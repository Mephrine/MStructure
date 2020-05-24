//
//  CommonAlert.swift
//  JHAlarm
//
//  Created by 김제현 on 09/09/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import UIKit

open class CommonAlert {
    
    /**
     # showAlertType1
     - Author: Mephrine
     - Date: 19.12.03
     - Parameters:
        - vc: 알럿을 띄울 뷰컨트롤러
        - title: 알럿 타이틀명
        - message: 알럿 메시지
        - completeTitle: 버튼명
        - completeHandler: 버튼 클릭 시, 실행될 클로저
     - Returns:
     - Note: 버튼이 1개인 기본 알럿을 띄우는 함수
    */
    public static func showAlertType1(vc:UIViewController, title:String = "", message:String = "", completeTitle:String = "확인", _ completeHandler:(() -> Void)? = nil){
        Async.main {
            let alert = UIAlertController(title: title, message: message, preferredStyle:UIAlertController.Style.alert)
            let action1 = UIAlertAction(title:completeTitle, style: .default) { action in
                completeHandler?()
            }
            alert.addAction(action1)
            
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    /**
        # showAlertType2
        - Author: Mephrine
        - Date: 19.12.03
        - Parameters:
           - vc: 알럿을 띄울 뷰컨트롤러
           - title: 알럿 타이틀명
           - message: 알럿 메시지
           - cancelTitle: 취소 버튼명
           - completeTitle: 확인 버튼명
           - cancelHandler: 취소 버튼 클릭 시, 실행될 클로저
           - completeHandler: 확인 버튼 클릭 시, 실행될 클로저
        - Returns:
        - Note: 버튼이 2개인 기본 알럿을 띄우는 함수
       */
    public static func showAlertType2(vc:UIViewController, title:String = "", message:String = "", cancelTitle:String = "취소", completeTitle:String = "확인",  _ cancelHandler:(() -> Void)? = nil, _ completeHandler:(() -> Void)? = nil){
        Async.main {
            let alert = UIAlertController(title: title, message: message, preferredStyle:UIAlertController.Style.alert)
            let action1 = UIAlertAction(title:cancelTitle, style: .cancel) { action in
                cancelHandler?()
            }
            let action2 = UIAlertAction(title:completeTitle, style: .default) { action in
                completeHandler?()
            }
            alert.addAction(action1)
            alert.addAction(action2)
            
            vc.present(alert, animated: true, completion: nil)
        }
    }

    /**
     # showJSConfirm
     - Author: Mephrine
     - Date: 19.12.03
     - Parameters:
        - vc: 알럿을 띄울 뷰컨트롤러
        - title: 알럿 타이틀명
        - message: 알럿 메시지
        - cancelTitle: 취소 버튼명
        - completeTitle: 확인 버튼명
        - cancelHandler: 취소 버튼 클릭 시, 실행될 클로저
        - completeHandler: 확인 버튼 클릭 시, 실행될 클로저
     - Returns:
     - Note: 버튼이 2개인 기본 알럿을 띄우는 함수 - JS에서 confirm 실행된 경우
    */
    public static func showJSConfirm(vc:UIViewController, title:String = "", message:String = "", cancelTitle:String = "취소", completeTitle:String = "확인",  _ completeHandler:((Bool) -> Void)? = nil){
        Async.main {
            let alert = UIAlertController(title: title, message: message, preferredStyle:UIAlertController.Style.alert)
            let action1 = UIAlertAction(title:cancelTitle, style: .cancel) { action in
                completeHandler?(false)
            }
            let action2 = UIAlertAction(title:completeTitle, style: .default) { action in
                completeHandler?(true)
            }
            alert.addAction(action1)
            alert.addAction(action2)
            
            vc.present(alert, animated: true, completion: nil)
        }
    }
}
