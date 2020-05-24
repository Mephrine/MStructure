//
//  Utils.swift
//  MUtils
//
//  Created by Mephrine on 2019/12/03.
//  Copyright © 2019 MUtils. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit


/**
 # (C) Utils
 - Author: Mephrine
 - Date: 19.12.03
 - Note: 공통적으로 사용하는 UI 관련 변수 및 함수 모음.
*/
public let IS_SIMUL = TARGET_IPHONE_SIMULATOR

public class Utils {
    public static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    public static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    public static let STATUS_HEIGHT = UIApplication.shared.statusBarFrame.size.height
    
    /**
        # version
         - Author: Mephrine
         - Date: 20.01.13
         - Parameters:
         - Returns: String
         - Note: 현재 번들 버전 반환
    */
    public static func version() -> String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    /**
        # findView
         - Author: Mephrine
         - Date: 20.01.13
         - Parameters:
            - superView: 찾는 뷰의 부모뷰
            - findView: 찾는 뷰
            - type: 찾는 뷰의 타입
         - Returns: Bool
         - Note: 부모 뷰에 특정 뷰가 존재하는지 찾는 함수
    */
    public static func findView<V>(superView: UIView, findView: UIView, type: V) -> Bool {
        for subView in superView.subviews {
            if subView is V {
                return true
            }
        }
        return false
    }
    
    /**
     # createURLString
         - Author: Mephrine
         - Date: 20.01.13
         - Parameters:
             - urlStr: 호출할 url
             - parameters: 적용할 Parameters
         - Returns: String
         - Note: url에 Dictionary 파라미터를 적용하는 등 변경을 위해 사용하는 함수
     */
    public static func createURLString (_ urlStr:String, _ parameters: [String:Any]? = nil) -> String {
        if let params = parameters {
            let paramStr = params.toQueryString()
            return "\(urlStr)&\(paramStr)"
        }else{
            return urlStr
        }
    }
    
    /**
    # castOrThrow
        - Author: Mephrine
        - Date: 20.01.13
        - Parameters:
            - resultType: 변환할 타입
            - object: 적용할 오브젝트
        - throws: 캐스팅 변환 시 에러가 발생
        - Returns: T
        - Note: 오브젝트를 특정 타입으로 변환하는 함수
    */
    public static func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
        guard let returnValue = object as? T else {
            throw RxCocoaError.castingError(object: object, targetType: resultType)
        }
        return returnValue
    }    
    
    /**
    # checkJailBreak
        - Author: Mephrine
        - Date: 20.01.13
        - Parameters:
        - Returns: Bool
        - Note: 탈옥 체크를 하는 함수. true -> 탈옥
    */
    public static func checkJailBreak() -> Bool {
        if IS_SIMUL != 1
        {
            // Check 1 : existence of files that are common for jailbroken devices
            if FileManager.default.fileExists(atPath: "/Applications/Cydia.app")
                || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib")
                || FileManager.default.fileExists(atPath: "/bin/bash")
                || FileManager.default.fileExists(atPath: "/usr/sbin/sshd")
                || FileManager.default.fileExists(atPath: "/Applications/RockApp.app")
                || FileManager.default.fileExists(atPath: "/Applications/Icy.app")
                || FileManager.default.fileExists(atPath: "/usr/libexec/sftp-server")
                || FileManager.default.fileExists(atPath: "/Applications/WinterBoard.app")
                || FileManager.default.fileExists(atPath: "/Applications/SBSettings.app")
                || FileManager.default.fileExists(atPath: "/Applications/MxTube.app")
                || FileManager.default.fileExists(atPath: "/Applications/IntelliScreen.app")
                || FileManager.default.fileExists(atPath: "/private/var/lib/apt")
                || FileManager.default.fileExists(atPath: "/Applications/blackra1n.app")
                || FileManager.default.fileExists(atPath: "/private/var/stash")
                || FileManager.default.fileExists(atPath: "/private/var/mobile/Library/SBSettings/Themes")
                || FileManager.default.fileExists(atPath: "/System/Library/LaunchDaemons/com.ikey.bbot.plist")
                || FileManager.default.fileExists(atPath: "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist")
                || FileManager.default.fileExists(atPath: "/private/var/tmp/cydia.log")
                || FileManager.default.fileExists(atPath: "/private/var/lib/cydia")
                || FileManager.default.fileExists(atPath: "/etc/apt")
                || FileManager.default.fileExists(atPath: "/private/var/lib/apt/")
                || UIApplication.shared.canOpenURL(URL(string:"cydia://package/com.example.package")!)
            {
                    return true
            }
            // Check 2 : Reading and writing in system directories (sandbox violation)
            let stringToWrite = "Jailbreak Test"
            do
            {
                try stringToWrite.write(toFile:"/private/JailbreakTest.txt", atomically:true, encoding:String.Encoding.utf8)
                //Device is jailbroken
                return true
            }catch
            {
                return false
            }
        }else
        {
            return false
        }
    }
    
    /**
       # cexit
           - Author: Mephrine
           - Date: 20.01.13
           - Parameters:
           - Returns:
           - Note: 앱 강제종료 함수
       */
    public static func cexit() {
        NotificationCenter.default.post(name: NSNotification.Name("UIApplicationWillTerminateNotification"), object: nil)
        exit(0)
    }
    
    /**
     # openExternalLink
     - Author: shan
     - Date: 20.03.17
     - Parameters:
        - urlStr : String 타입 링크
        - handler : Completion Handler
     - Returns:
     - Note: 외부 브라우저/ 외부 링크 실행.
     */
    public static func openExternalLink(urlStr: String, _ handler:(() -> Void)? = nil) {
        guard let url = URL(string: urlStr) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:]) { (result) in
                handler?()
            }
            
        } else {
            UIApplication.shared.openURL(url)
            handler?()
        }
    }
    
    /**
     # openTelNumber
     - Author: shan
     - Date: 20.03.17
     - Parameters:
        - urlStr : String 타입 전화번호
     - Returns:
     - Note: 전화걸기 알럿 노출 및 전화걸기 Action.
     */
    public static func openTelNumber(vc: UIViewController, urlStr: String, _ cancelTitle: String = "취소", _ completeTitle: String = "통화" ) {
        if #available(iOS 11.0, *) {
            self.openExternalLink(urlStr: urlStr)
        } else {
            if #available(iOS 10.0, *) {
                if let phoneNumber = urlStr.split(":").last {
                    CommonAlert.showAlertType2(vc: vc, message: phoneNumber, cancelTitle: cancelTitle, completeTitle: completeTitle, nil) {
                        self.openExternalLink(urlStr: urlStr)
                    }
                }
            } else {
                self.openExternalLink(urlStr: urlStr)
            }
        }
    }
    
}
