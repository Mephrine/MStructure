//
//  WKCookieStorage.swift
//  WKWebViewCookieSync
//
//  Created by SakuiYoshimitsu on 2017/09/06.
//  Copyright © 2017年 ysakui. All rights reserved.
//

import UIKit
import WebKit
import MUtils
/**
 # WKCookieStorage
 - Author: Mephrine
 - Date: 20.02.07
 - Parameters:
 - Returns:
 - Note: WKWebView 쿠키 관리는 iOS 10을 포함하고 있으므로, iOS 11이상부터 사용 가능한 WKWebSiteDataStore 사용 대신에 스크립트 방식으로 쿠키 관리.
 쿠키 공용 사용을 위해서 해당 클래스는 싱글턴 방식으로 사용해야하며, WKProcessPool 공유를 위해 웹뷰의 config에 해당 Pool 설정 필요.
*/

final class WKCookieStorage: NSObject {
    static let shared = WKCookieStorage()
    
    var sharedProcessPool: WKProcessPool = WKProcessPool()
    fileprivate var webView: WKWebView?
    
    private let htmlTemplate = "<DOCTYPE html><html><body></body></html>"
    var dummyBaseURL = URL(string: WEB_DOMAIN)
    fileprivate let getCookiesStringHandler = "getCookiesStringHandler"
    fileprivate let setCookieHandler = "setCookieHandler"
    
    fileprivate var getCookiesCompletion: ((_ cookiesString: String?) -> Void)?
    fileprivate var setCookieCompletion: (() -> Void)?
    
    deinit {
        self.webView?.stopLoading()
        self.webView?.removeFromSuperview()
        self.webView = nil
    }
    
    /**
     # deleteAllCookies
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
        - completion : 반환 클로저
     - Returns:
     - Note: 스크립트를 통해 불러온 모든 쿠키 제거 및 HTTPCookieStorage에 저장된 쿠키, Cache 제거
    */
    func deleteAllCookies(completion: @escaping () -> Void) {
        var msg = ""
        self.cookiesString { (cookieStr) in
            if let cookies = cookieStr?.components(separatedBy: ";") {
                for i in 0 ..< cookies.count {
                    let cookie = cookies[i]
                    let eqPos  = cookie.components(separatedBy: "=")
                    let name   = eqPos.first ?? ""
                    
                    msg = name + "=;expires=Thu, 01 Jan 1970 00:00:00 GMT";
                    if i != cookies.count - 1 {
                        msg += ";"
                    }
                }
                self.setCookieCompletion = completion
                let javaScriptString = "webkit.messageHandlers.\(self.setCookieHandler).postMessage(\(msg))"
                self.loadHTMLString(javaScriptString: javaScriptString, messageHandler: self.setCookieHandler)
            }
        }
        
        clearCookies()
    }
    
    /**
     # addAllCookies
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
        - completion : 반환 클로저
     - Returns:
     - Note: 스크립트를 통해 불러온 모든 쿠키 더하기
    */
    func addAllCookies(completion: @escaping () -> Void) {
        var msg = ""
        self.cookiesString { (cookieStr) in
            if let cookies = cookieStr?.components(separatedBy: ";") {
                for i in 0 ..< cookies.count {
                    let cookie = cookies[i]
                    msg += cookie
                }
                
                self.setCookieCompletion = completion
                let javaScriptString = "webkit.messageHandlers.\(self.setCookieHandler).postMessage(document.cookie='\(msg)')"
                self.loadHTMLString(javaScriptString: javaScriptString, messageHandler: self.setCookieHandler)
            }
        }
    }
    
    /**
     # clearCookies
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
     - Returns:
     - Note: HTTPCookieStorage에 저장된 쿠키 및 Cache 제거
    */
    func clearCookies() {
        if let cookies = HTTPCookieStorage.shared.cookies {
            URLCache.shared.removeAllCachedResponses()
            URLCache.shared.diskCapacity = 0
            URLCache.shared.memoryCapacity = 0
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    
    /**
     # cookiesString
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
        - completion : 반환 클로저
     - Returns:
     - Note: 자바스크립트 document.cookie로 쿠키 데이터를 string형으로 반환하여 클로저에 전달
    */
    func cookiesString(completion: @escaping (_ cookiesString: String?) -> Void) {
        self.getCookiesCompletion = completion
        
        let javaScriptString = "webkit.messageHandlers.\(self.getCookiesStringHandler).postMessage(document.cookie)"
        
        loadHTMLString(javaScriptString: javaScriptString, messageHandler: self.getCookiesStringHandler)
    }
    
    /**
        # setCookie
        - Author: Mephrine
        - Date: 20.02.07
        - Parameters:
           - name : 쿠키명
           - value : 쿠키에 저장할 값
           - completion : 반환 클로저
        - Returns:
        - Note: 저장할 단일 쿠키를 자바스크립트로 실행 후 결과값을 반환하는 함수
       */
    func setCookie(name: String, value: String, completion: @escaping () -> Void) {
        self.setCookieCompletion = completion

        let javaScriptString = "webkit.messageHandlers.\(self.setCookieHandler).postMessage(document.cookie='\(name)=\(value)')"

        loadHTMLString(javaScriptString: javaScriptString, messageHandler: self.setCookieHandler)
    }
    
    
    /**
     # setCookies
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
        - cookies : 저장할 쿠키 옵셔널 배열
        - completion : 반환 클로저
     - Returns:
     - Note: 자바스크립트 document.cookie로 쿠키 데이터를 string형으로 반환하여 클로저에 전달
    */
    func setCookies(cookies:[HTTPCookie]?, completion: @escaping () -> Void) {
        var percentEncoding = CharacterSet.alphanumerics // 영문자 제외 인코딩
        percentEncoding.insert(charactersIn: "-_.!~") // 비예약 문자 제외
        
        var msg = ""
        if let cookies = cookies {
            for (index,cookie) in cookies.enumerated() {
                
                
                if let enValue = cookie.value.addingPercentEncoding(withAllowedCharacters: percentEncoding){
                    msg += "\(cookie.name)=\(enValue)"
                }
                if index != cookies.count - 1 {
                    msg += ";"
                }
            }
            self.setCookieCompletion = completion
            let javaScriptString = "webkit.messageHandlers.\(self.setCookieHandler).postMessage(document.cookie='\(msg)')"
            self.loadHTMLString(javaScriptString: javaScriptString, messageHandler: self.setCookieHandler)
        }
    }
    
    /**
     # loadHTMLString
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
        - javaScriptString : 실행할 자바스크립트
        - messageHandler : userContnetController에서 확인할 메시지 명칭
     - Returns:
     - Note: 쿠키 관련 스크립트를 실행하는 용도의 보이지 않는 웹뷰를 생성하여 스크립트 실행
    */
    private func loadHTMLString(javaScriptString: String, messageHandler: String) {
        let userScript = WKUserScript(
            source: javaScriptString,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
        
        let controller = WKUserContentController()
        controller.addUserScript(userScript)
        controller.add(self, name: messageHandler)
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = controller
        configuration.processPool = self.sharedProcessPool
        configuration.preferences.javaScriptEnabled = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        self.webView?.stopLoading()
        self.webView?.removeFromSuperview()
        self.webView = nil
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        self.webView = webView
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            appDelegate.navigationVC?.viewControllers.last?.view?.addSubview(webView)
            appDelegate.window?.addSubview(webView)
            webView.loadHTMLString(htmlTemplate, baseURL: dummyBaseURL)
        }
    }
    
    /**
     # strJSCookies
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
        - for : 저장할 쿠키 옵셔널 배열
     - Returns: String
     - Note: 쿠키를 자바스크립트 String형으로 변경하여 반환
    */
    func strJSCookies(for cookies: [HTTPCookie]) -> String {
        var result = ""
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
        
        log.d("cookies : \(cookies)")
        if cookies.count > 0 {
            for cookie in cookies {
                result += "document.cookie='\(cookie.name)=\(cookie.value); domain=\(cookie.domain); path=\(cookie.path); "
                if let date = cookie.expiresDate {
                    result += "expires=\(dateFormatter.string(from:date)); "
                }
                if (cookie.isSecure) {
                    result += "secure; "
                }
                result += "'; "
            }
        }
        return result
    }
}

extension WKCookieStorage: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.webView?.stopLoading()
        self.webView?.removeFromSuperview()
        self.webView = nil
        
        switch message.name {
        case self.getCookiesStringHandler:
            if let cookiesString = message.body as? String {
                self.getCookiesCompletion?(cookiesString)
            } else {
                self.getCookiesCompletion?(nil)
            }
            
        case self.setCookieHandler:
            self.setCookieCompletion?()
            
        default:
            break
        }
    }
}

