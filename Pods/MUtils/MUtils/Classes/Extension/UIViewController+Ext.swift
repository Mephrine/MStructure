//
//  UIViewController+Ext.swift
//  MUtils
//
//  Created by Mephrine on 2020/01/13.
//  Copyright © 2020 KBIZ. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    /**
     # instantiate
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
        - storyBoardName: Storyboard 명
     - Returns: Self
     - Note: 해당 Storyboard에서 현재 뷰컨트롤러를 생성
    */
    public func instantiate(storyBoardName: String) -> Self {
        let sb = UIStoryboard.init(name: storyBoardName, bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: String(describing: self)) as? Self {
            return viewController
        }
        return self
    }
    
    /**
     # isModal
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
     - Returns: Bool
     - Note: 현재 ViewController가 Modal형태로 띄워졌는지 확인
    */
    public func isModal() -> Bool {
    
         if self.presentingViewController != nil {
             return true
         }
         if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController {
             return true
         }
         if self.tabBarController?.presentingViewController is UITabBarController  {
             return true
         }
         
         return false
     }
}


