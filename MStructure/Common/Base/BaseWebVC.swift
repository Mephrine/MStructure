//
//  BaseWebVC.swift
//  MStructure
//
//  Created by Mephrine on 2020/01/16.
//  Copyright © 2020 MUtils. All rights reserved.
//

import ReactorKit
import Reusable
import RxCocoa
import RxSwift
import SafariServices
import SwiftyUserDefaults
import Then
import UIKit
import WebKit
import MUtils

/**
 # (C) BaseWebVC.swift
 - Author: Mephrine
 - Date: 20.01.16
 - Parameters:
 - Returns:
 - Note: 모든 웹뷰 뷰컨트롤러가 상속받는 부모뷰
*/
typealias OldClosureType =  @convention(c) (Any, Selector, UnsafeRawPointer, Bool, Bool, Any?) -> Void
typealias NewClosureType =  @convention(c) (Any, Selector, UnsafeRawPointer, Bool, Bool, Bool, Any?) -> Void

class BaseWebVC: BaseVC {
    @IBOutlet weak var vContainer: UIView!
    
    var isModal = false                 // 모달 여부.
    var strCurUrl = ""                  // 현재 URL
    
    var isWebBouncing = false           // 웹뷰 바운싱
    
    var requestIndexPage = false
    
    // 웹뷰 설정
    var config: WKWebViewConfiguration?
    internal var mWebView: WKWebView?
    private var subWebView: WKWebView?
    
    weak var documentPicker: UIDocumentPickerViewController?
    
    override func viewDidLoad() {
        initWebView()
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 영상 관련 노티 등록
        NotificationCenter.default.addObserver(self, selector: #selector(videoExitFullScreen(_:)), name: UIWindow.didBecomeHiddenNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LoadingView.shared.hide()
        
        // 영상 관련 노티 제거
        NotificationCenter.default.removeObserver(self, name: UIWindow.didBecomeHiddenNotification, object: nil)
    }
    
    /**
     # initWebView
     - Author: Mephrine
     - Date: 20.02.10
     - Parameters:
     - Returns:
     - Note: webView 생성 및 config등 적용하는 함수
    */
    func initWebView() {
        // WKWebview Delegate 초기화
        
        /// WKWebview Config 초기화
        if mWebView == nil {
            if let config = self.config {
                self.mWebView = WKWebView(frame: CGRect.zero, configuration: config)
            } else {
                let config = WKWebViewConfiguration()
                config.processPool = WKCookieStorage.shared.sharedProcessPool
                config.preferences.javaScriptEnabled = true
                config.preferences.javaScriptCanOpenWindowsAutomatically = true
                config.selectionGranularity = .character
                // 미디어 관련
                config.allowsInlineMediaPlayback = true
                config.allowsPictureInPictureMediaPlayback = true
                config.selectionGranularity = .character
                
                
                //190107 jhkim. 자동재생 관련해서 추가.
                if #available(iOS 10.0, *) {
                    config.requiresUserActionForMediaPlayback = false
                    config.mediaTypesRequiringUserActionForPlayback = []
                }
                
//                let controller = WKUserContentController()
                
                //            if let cookies = HTTPCookieStorage.shared.cookies {
                //                let script = WKCookieStorage.shared.getJSCookiesString(for: cookies)
                //                let cookieScript = WKUserScript(source: script, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
                //                controller.addUserScript(cookieScript)
                //            }
                
                //TODO: Mephrine. UserAgent 및 callbackhandler 추가 시,
                //                        let controller = WKUserContentController()
                // VestPIN 핸들러.
                //            controller.add(self, name: "iosLion")
                
//                config.userContentController = controller
                config.applicationNameForUserAgent = (config.applicationNameForUserAgent ?? "") + WEB_USER_AGENT
                
                
                self.config = config
                self.mWebView = WKWebView(frame: CGRect.zero, configuration: config)
                
            }
        }
        
        guard let webView = mWebView else {
            return
        }
        
        webView.backgroundColor = .white
        webView.scrollView.backgroundColor = .white
        
        webView.scrollView.bounces = isWebBouncing
        
        // Rx로 변경하기 위해서 주석.
        webView.uiDelegate = self
        //                self.webView.navigationDelegate = self.delegate
        
        webView.allowsBackForwardNavigationGestures = self.isWebPopGesture
        
        // 드래그로 키패드 내리기.
        webView.scrollView.keyboardDismissMode = .onDrag
        
        webView.keyboardDisplayRequiresUserAction = false
        
        vContainer.addSubview(webView)
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    deinit {
        LoadingView.shared.hide()
        mWebView?.stopLoading()
        mWebView?.loadHTMLString("", baseURL: nil)
        mWebView?.configuration.userContentController = WKUserContentController()
        mWebView?.uiDelegate = nil
        mWebView?.navigationDelegate = nil
        mWebView?.removeFromSuperview()
        mWebView = nil
    }
    
    
    /**
     # requestWebView
     - Author: Mephrine
     - Date: 20.01.16
     - Parameters:
        - urlString : 호출할 URL String형
        - parameters : 파라미터
     - Returns:
     - Note: 웹뷰 URL 호출 시 사용되는 함수.
    */
    func requestWebView(_ urlString:String, _ parameters: [String:Any]? = nil) {
        guard let webView = mWebView else {
            return
        }
        
        let urlStr = Utils.createURLString(urlString, parameters)
        
        if let value = URL(string:urlStr) {
            //            var request = URLRequest(url: value, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)
            var request = URLRequest(url: value)
            // 공통 헤더값추가
            // TODO: -mephrine 헤더쪽 필드 및 http 방식 설정해야함.
//                                    request.httpMethod = "POST"
//                                    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            // 헤더 설정
            //            request.setValue(test값, forHTTPHeaderField: "test")
            let cookies = HTTPCookieStorage.shared.cookies ?? []
            log.d("HTTPCookieStorage cookie : \(cookies)")
            
            if cookies.count == 0 {
                log.d("setCookie Zero")
                WKCookieStorage.shared.addAllCookies {
                    Async.main {
                        webView.load(request)
                    }
                }
            }else{
                WKCookieStorage.shared.setCookies(cookies: cookies) {
                    log.d("setCookie success")
                    Async.main {
                        webView.load(request)
                    }
                }
            }
        }
    }
    
    /**
     # reloadWebView
     - Author: Mephrine
     - Date: 20.02.17
     - Parameters
     - Returns:
     - Note: 마지막에 로드된 URL로 리로드
    */
    func reloadWebView() {
        self.requestWebView(strCurUrl)
    }
    
    
    /**
     # isURLError
     - Author: Mephrine
     - Date: 20.02.10
     - Parameters:
        - error : 발생한 URL 에러
     - Returns:
     - Note: URL 에러 처리가 필요한 에러가 맞는지 확인하는 함수.
    */
    private func isURLError(error: Error) -> Bool {
        let nsError = error as NSError
        if nsError.code == -1022 {
            log.e("Error Code -1022 :: \(NSURLErrorAppTransportSecurityRequiresSecureConnection)")
            return true
        } else if nsError.code == 102 {
            // 스키마가 들어오는 경우 해당 부분이 실행됨.
            return false
        }  else if let urlError = error as? URLError {
            switch urlError.code {
            case .cancelled:
                return false
            case .notConnectedToInternet:
                log.e("Error Code notConnectedToInternet :::: \(urlError.code)")
                return true
            case .cannotFindHost:
                log.e("Error Code cannotFindHost :::: \(urlError.code)")
                return true
            case .resourceUnavailable:
                log.e("Error Code resourceUnavailable")
                return true
            case .timedOut:
                log.e("Error Code timedOut")
                return true
            default:
                return true
            }
        }
        return true
    }
    
    /**
     # chkURLError
     - Author: Mephrine
     - Date: 20.02.10
     - Parameters:
        - error : 발생한 URL 에러
     - Returns:
     - Note: URL Error 발생 시 사용자에게 보여줄 내용을 정리한 함수.
    */
    func chkURLError(_ error: Error) {
        if isURLError(error: error) {
            LoadingView.shared.hide()
            self.onErrorCoverView()
            self.showErrorConfirm()
        }
    }
    
    /**
     # dismiss
     - Author: Mephrine
     - Date: 20.02.10
     - Parameters:
     - Returns:
     - Note: WebView내에서 UIDocumentPickerViewController 오픈 시, dismiss 관련 버그로 인해서 추가.
    */
    override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        if self.presentedViewController == nil && self.documentPicker != nil {
            self.documentPicker = nil
        } else {
            super.dismiss(animated: flag, completion: completion);
        }
    }
    
    /**
     # present
     - Author: Mephrine
     - Date: 20.02.17
     - Parameters:
        - urlString : 호출할 URL String형
        - parameters : 파라미터
     - Returns:
     - Note: 웹뷰 URL 호출 시 사용되는 함수.
    */
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if viewControllerToPresent is UIDocumentPickerViewController {
            self.documentPicker = viewControllerToPresent as? UIDocumentPickerViewController
        }
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    /**
     # callJavaScriptFunc
     - Author: Mephrine
     - Date: 20.03.17
     - Parameters:
        - funcStr : JavaScript String
        - completion : 스크립트 실행 후 CompletionHandler
     - Returns:
     - Note: 스크립트 실행 함수.
     */
    func callJavaScriptFunc(_ funcStr: String, completion: ((Any?, Error?) -> Void)? = nil) {
        guard let webView = mWebView else {
            return
        }
        webView.evaluateJavaScript(funcStr, completionHandler: completion)
    }
    
    /**
     # onErrorCoverView
     - Author: Mephrine
     - Date: 20.03.17
     - Parameters:
     - Returns:
     - Note: 웹뷰내 에러가 발생한 경우, 웹뷰 내용을 숨기기 위해서 흰색 뷰를 덮어 씌움.
     */
    func onErrorCoverView() {
        guard let webView = mWebView else {
            return
        }
        // 기존에 해당 뷰가 존재하는지 체크.
        let existView: UIView? = self.view.viewWithTag(999)
        if existView != nil {
            return
        }
       
        let coverView = UIView().then{
            $0.backgroundColor = UIColor(hex:0xffffff)
            $0.tag = 999
        }
        self.view.addSubview(coverView)
        
        coverView.snp.makeConstraints {
            $0.edges.equalTo(webView.snp.edges)
        }
    }
    
    /**
     # onErrorCoverRemoveView
     - Author: Mephrine
     - Date: 20.03.17
     - Parameters:
     - Returns:
     - Note: 웹뷰내 에러가 발생한 경우, 웹뷰 내용을 숨기기 위해서 덮은 흰색 뷰를 제거.
     */
    func onErrorCoverRemoveView() {
        guard let webView = mWebView else {
            return
        }
        // 기존에 해당 뷰가 존재하는지 체크.
        if let existView: UIView? = self.view.viewWithTag(999) {
            existView?.removeFromSuperview()
        }
    }
    
    /**
     # showErrorConfirm
     - Author: Mephrine
     - Date: 20.03.17
     - Parameters:
     - Returns:
     - Note: 웹뷰 오류 리로드 알럿 띄우기.
     */
    func showErrorConfirm() {
        CommonAlert.showAlertType2(vc: self, message: STR_WEBVIEW_ERROR_RELOAD, cancelTitle: STR_CANCEL, completeTitle: STR_OK, { [weak self] in
            self?.onErrorCoverRemoveView()
        }, { [weak self] in
            self?.onErrorCoverRemoveView()
            self?.reloadWebView()
        })
    }

    /**
        # deallocSubWebView
        - Author: Mephrine
        - Date: 20.03.17
        - Parameters:
        - Returns:
        - Note: window.open으로 생성한 subWebView 메모리 할당 해제하는 함수.
    */
    func deallocSubWebView() {
        LoadingView.shared.hide()

        subWebView?.stopLoading()
        subWebView?.loadHTMLString("", baseURL: nil)
        subWebView?.configuration.userContentController = WKUserContentController()
        subWebView?.uiDelegate = nil
        subWebView?.navigationDelegate = nil
        subWebView?.removeFromSuperview()
        subWebView = nil
    }
    
    /**
        # popGesture
        - Author: Mephrine
        - Date: 20.03.17
        - Parameters:
        - Returns:
        - Note: 딥링크를 통해 웹에서 PopGesture 적용 / 해지하는 함수
    */
    func popGesture(_ apply: Bool) {
        self.isWebPopGesture = apply
        self.setInteractivePopGesture(apply)
        mWebView?.allowsBackForwardNavigationGestures = apply
    }
    
}

// MARK: Deep Link 관련
extension BaseWebVC {
    /**
     # policyAfterDeepLink
     - Author: Mephrine
     - Date: 20.02.17
     - Parameters:
        - request : 호출할 리퀘스트
     - Returns: Bool, true: allow | false: cancel
     - Note: 딥링크 스키마 및 파일 다운로드 등 url 예외 처리.
     */
    func policyAfterDeepLink(request: URLRequest) -> Bool {
        guard let webView = mWebView else {
            return false
        }
        
        // 전달된 URL
        guard let url = request.url else { return false }
        let strUrl    = url.absoluteString
        let strScheme = url.scheme ?? ""
        
        log.i("Deep Link strUrl = \(strUrl)")
        
        if url.scheme == "http" || url.scheme == "https" {
            if strUrl.contains("/download") || strUrl.contains("/file/") {
                if strUrl.contains(".jpg") || strUrl.contains(".png") || strUrl.contains(".jpeg") || strUrl.contains(".gif") {
                    return true
                } else if strUrl.contains(".hwp") {
                    Utils.openExternalLink(urlStr: url.absoluteString)
                } else {
                    self.steps.accept(AppStep.showSFVC(url: url))
                    return false
                }
            }else if let domainHost = URL(string: WEB_DOMAIN)?.host {
                if strUrl.hasSuffix("#") {
                    return false
                }else if url.host == "kapi.kakao.com" {
                    
                }else if url.host == "itunes.apple.com" || url.host == "phobos.apple.com" {
                    Utils.openExternalLink(urlStr: url.absoluteString)
                }else if url.host?.hasPrefix("sso") ?? false {
                    
                }else if url.host == "www.youtube.com"{
                    if url.path.hasPrefix("/embed/") {
                        // 유투브 동영상을 iframe으로 embed 시키면 팝업웹뷰로 걸러지는거 방지
                    }
                }
            }
            
            strCurUrl = strUrl
            
            return true
        } else if strUrl == "about:blank" {
            return false
        } else if strUrl.starts(with: "file://") {
            return false
        } else if strUrl.starts(with: "tel:") {
            Utils.openTelNumber(vc: self, urlStr: strUrl)
            return false
        } else if strUrl.starts(with: "sms:") || strUrl.starts(with: "mailto:") {
            Utils.openExternalLink(urlStr: strUrl)
            return false
        }
        
        // CustomURI - DeepLinking 관련 처리
        if strScheme == WEB_DEEP_LINK_SCHEME {
            guard let strHost = url.host else {
                return false
            }
            
            return false
        }else{
            // 외부 앱 호출
            Utils.openExternalLink(urlStr: url.absoluteString)
            return false
        }
    }
}


extension BaseWebVC: WKUIDelegate {
    /**
     # webView
     - Author: Mephrine
     - Date: 20.02.17
     - Parameters:
        - webView : 웹뷰
        - runJavaScriptAlertPanelWithMessage : 알럿에 노출될 메시지
        - initiatedByFrame : 해당 뷰 프레임
        - completionHandler : 확인 버튼 누를 시 실행될 핸들러
     - Returns: WKWebView
     - Note: 웹에서 alert 호출 시 실행되는 함수.
     */
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        log.d("runJavaScriptAlertPanelWithMessage 실행")
        if let host = webView.url?.host {
            CommonAlert.showAlertType1(vc: self, message: message, completionHandler)
        } else {
            completionHandler()
        }
        
    }
    
    /**
     # webView
     - Author: Mephrine
     - Date: 20.02.17
     - Parameters:
        - webView : 웹뷰
        - runJavaScriptConfirmPanelWithMessage : confirm창에 노출될 메시지
        - initiatedByFrame : 해당 뷰 프레임
        - completionHandler : 확인 / 취소 버튼 누를 시 실행될 핸들러
     - Returns: WKWebView
     - Note: 웹에서 confirm 호출 시 실행되는 함수.
     */
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        log.d("runJavaScriptConfirmPanelWithMessage 실행")
        if let host = webView.url?.host {
            CommonAlert.showJSConfirm(vc: self, message: message, completionHandler)
        } else {
            completionHandler(true)
        }
    }
    
    /**
     # webView
     - Author: Mephrine
     - Date: 20.02.17
     - Parameters:
        - webView : 새 창 웹뷰
        - createWebViewWith : 웹뷰 설정
        - for : 웹뷰 action
        - windowFeatures : 새 창의 window 특성
     - Returns: WKWebView
     - Note: 웹에서 window.open등 새 창을 열면 실행되는 함수.
     */
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        // window.open 등의 새창을 실행하는 스크립트가 실행되면 해당 부분을 탐.
        // webView를 리턴하면 해당 함수 내부에서 post등의 관련 데이터를 전달하는 것으로 보임. 그래서 request url 로그를 찍으면 nil로 들어옴.
        if navigationAction.targetFrame == nil {
            if let subWebViewVC = UIStoryboard.init(name: "Web", bundle: nil).instantiateViewController(withIdentifier: "SubWebViewVC") as? SubWebViewVC {
                configuration.userContentController = WKUserContentController()
                subWebView = WKWebView(frame: CGRect.zero, configuration: configuration)
                subWebViewVC.mWebView = subWebView
                self.steps.accept(AppStep.goPushSubWebView(subWebViewVC))
                return subWebView
            }
        }
        return WKWebView(frame: view.bounds, configuration: configuration)
    }
    
    /**
     # webView
     - Author: Mephrine
     - Date: 20.02.17
     - Parameters:
        - webView : 새 창 웹뷰
        - shouldPreviewElement : 프리뷰 내용
     - Returns: WKWebView
     - Note: 웹 프리뷰 설정.
     */
    @available(iOS 10.0, *)
    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        return false
    }
    
    /**
     # webViewDidClose
     - Author: Mephrine
     - Date: 20.02.17
     - Parameters:
        - webView : 새 창이 닫힐 때의 웹뷰
     - Returns: WKWebView
     - Note: window.close로 새 창이 닫히는 스크립트 실행 시 호출되는 함수.
     */
    /** @abstract Notifies your app that the DOM window object's close() method completed successfully.
     @param webView The web view invoking the delegate method.
     @discussion Your app should remove the web view from the view hierarchy and update
     the UI as needed, such as by closing the containing browser tab or window.
     */
    @available(iOS 9.0, *)
    func webViewDidClose(_ webView: WKWebView) {
//        if self.isModal {
//            if webView.canGoBack {
//                self.steps.accept(AppStep.backSubWebViewVC)
//            } else {
//                self.steps.accept(AppStep.backSubRootWebView)
//            }
//        } else {
            self.steps.accept(AppStep.backSubWebViewVC)
//        }
        self.deallocSubWebView()
    }
    
    /**
     # videoExitFullScreen
     - Author: Mephrine
     - Date: 20.03.17
     - Parameters:
        - noti : didBecomeHiddenNotification
     - Returns:
     - Note: 동영상 종료 후 화면 회전.
     */
    @objc func videoExitFullScreen(_ noti: Notification) {
        Async.main(after: 0.3) {
            UIDevice.current.setValue(UIInterfaceOrientation.unknown.rawValue, forKey: "orientation")
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            
            self.showStatusAnim()
        }
    }
    
}

extension WKWebView{
   
    var keyboardDisplayRequiresUserAction: Bool? {
        get {
            return self.keyboardDisplayRequiresUserAction
        }
        set {
            self.setKeyboardRequiresUserInteraction(newValue ?? true)
        }
    }

    /**
    # setKeyboardRequiresUserInteraction
    - Author: Mephrine
    - Date: 20.04.07
    - Parameters:
        - value: keyboardDisplayRequiresUserAction 사용여부 Bool
    - Returns:
    - Note: keyboardDisplayRequiresUserAction을 WKWebView에서 사용하기 위한 방법.
    */
    func setKeyboardRequiresUserInteraction( _ value: Bool) {
        guard let WKContentView: AnyClass = NSClassFromString("WKContentView") else {
            print("keyboardDisplayRequiresUserAction extension: Cannot find the WKContentView class")
            return
        }
        // For iOS 10, *
        let sel_10: Selector = sel_getUid("_startAssistingNode:userIsInteracting:blurPreviousNode:userObject:")
        // For iOS 11.3, *
        let sel_11_3: Selector = sel_getUid("_startAssistingNode:userIsInteracting:blurPreviousNode:changingActivityState:userObject:")
        // For iOS 12.2, *
        let sel_12_2: Selector = sel_getUid("_elementDidFocus:userIsInteracting:blurPreviousNode:changingActivityState:userObject:")
        // For iOS 13.0, *
        let sel_13_0: Selector = sel_getUid("_elementDidFocus:userIsInteracting:blurPreviousNode:activityStateChanges:userObject:")

        if let method = class_getInstanceMethod(WKContentView, sel_10) {
            let originalImp: IMP = method_getImplementation(method)
            let original: OldClosureType = unsafeBitCast(originalImp, to: OldClosureType.self)
            let block : @convention(block) (Any, UnsafeRawPointer, Bool, Bool, Any?) -> Void = { (me, arg0, arg1, arg2, arg3) in
                original(me, sel_10, arg0, !value, arg2, arg3)
            }
            let imp: IMP = imp_implementationWithBlock(block)
            method_setImplementation(method, imp)
        }

        if let method = class_getInstanceMethod(WKContentView, sel_11_3) {
            let originalImp: IMP = method_getImplementation(method)
            let original: NewClosureType = unsafeBitCast(originalImp, to: NewClosureType.self)
            let block : @convention(block) (Any, UnsafeRawPointer, Bool, Bool, Bool, Any?) -> Void = { (me, arg0, arg1, arg2, arg3, arg4) in
                original(me, sel_11_3, arg0, !value, arg2, arg3, arg4)
            }
            let imp: IMP = imp_implementationWithBlock(block)
            method_setImplementation(method, imp)
        }

        if let method = class_getInstanceMethod(WKContentView, sel_12_2) {
            let originalImp: IMP = method_getImplementation(method)
            let original: NewClosureType = unsafeBitCast(originalImp, to: NewClosureType.self)
            let block : @convention(block) (Any, UnsafeRawPointer, Bool, Bool, Bool, Any?) -> Void = { (me, arg0, arg1, arg2, arg3, arg4) in
                original(me, sel_12_2, arg0, !value, arg2, arg3, arg4)
            }
            let imp: IMP = imp_implementationWithBlock(block)
            method_setImplementation(method, imp)
        }

        if let method = class_getInstanceMethod(WKContentView, sel_13_0) {
            let originalImp: IMP = method_getImplementation(method)
            let original: NewClosureType = unsafeBitCast(originalImp, to: NewClosureType.self)
            let block : @convention(block) (Any, UnsafeRawPointer, Bool, Bool, Bool, Any?) -> Void = { (me, arg0, arg1, arg2, arg3, arg4) in
                original(me, sel_13_0, arg0, !value, arg2, arg3, arg4)
            }
            let imp: IMP = imp_implementationWithBlock(block)
            method_setImplementation(method, imp)
        }
    }
}
