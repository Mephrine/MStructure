//
//  BaseNavigationController.swift
//  MStructure
//
//  Created by Mephrine on 2020/02/10.
//  Copyright © 2020 MUtils. All rights reserved.
//

import Foundation
import MUtils

/**
 # (C) BaseNavigationController.swift
 - Author: Mephrine
 - Date: 19.12.03
 - Parameters:
 - Returns:
 - Note: 네비게이션 컨트롤러에서 공통적으로 사용될 함수가 재정의된 네비게이션 컨트롤러 클래스.
*/
class BaseNavigationController: UINavigationController {
    private weak var lastPresentedController : UIViewController?
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   /**
    # dismiss
    - Author: Mephrine
    - Date: 20.02.10
    - Parameters:
       - animated : Transition 애니메이션 사용 여부
       - completion : 네비게이션이 dismiss 된 이후의 callback 처리를 위한 클로저
    - Returns:
    - Note: iOS 10까지 발생하는 WebView내에서 UIDocumentMenuViewController / UIImagePickerController 오픈 시, dismiss 관련 버그로 인해서 추가.
   */
    override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        if presentedViewController != nil && lastPresentedController != presentedViewController  {
            lastPresentedController = presentedViewController;
            presentedViewController?.dismiss(animated: flag, completion: {
                completion?();
                self.lastPresentedController = nil;
            });

        } else if lastPresentedController == nil {
            guard let topVC = self.topViewController else { return }
            if !(topVC is WebViewVC) && !(topVC is SubWebViewVC) {
                super.dismiss(animated: flag, completion: completion)
            }
        }
        
    }
}
