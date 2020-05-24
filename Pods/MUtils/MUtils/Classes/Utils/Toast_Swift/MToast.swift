//
//  MToast.swift
//  MUtils
//
//  Created by Mephrine on 2020/02/07.
//  Copyright © 2020 MUtils. All rights reserved.
//

import Foundation
import Toast_Swift

/**
 # MToast.swift
 - Author: Mephrine
 - Date: 19.12.03
 - Note: 커스텀 토스트.
*/
public class MToast: NSObject {
    
    static var completion: ((_ didTap: Bool) -> Void)?
    
    /**
     # makeText
     - Author: Mephrine
     - Date: 19.12.03
     - Parameters:
        - text: 토스트 메시지
     - Returns:
     - Note: 토스트 메시지를 띄움
    */
    public static func makeText(_ text: String) {
        guard let window = UIApplication.shared.keyWindow else { return }
//        guard let topController = window.visibleViewController else { return }
        Async.main {
//            log.d("rootViewController : \(topController)")
//            if let window = topController.view.window {
                window.makeToast(text)
//            }
        }
    }
    
    /**
     # makeText
     - Author: Mephrine
     - Date: 19.12.03
     - Parameters:
        - text: 토스트 메시지
        - completion: 토스트를 탭하는 경우 실행할 클로저
     - Returns:
     - Note: 토스트 메시지를 띄우며, 탭 시 실행할 클로저를 설정할 수 있음.
    */
    public static func makeText(_ text: String, completion: ((_ didTap: Bool) -> Void)?) {
        guard let window = UIApplication.shared.keyWindow else { return }
//        guard let topController = window.visibleViewController else { return }
        
        MToast.completion = completion
        
        Async.main {
            // create a new style
            var style = ToastStyle()
            style.messageColor = .black
            
            window.makeToast(text, duration: 2.0, position: .center, title: nil, image: nil, style: style, completion: { (didTap) in
                completion!(didTap)
            })
        }
    }
}
