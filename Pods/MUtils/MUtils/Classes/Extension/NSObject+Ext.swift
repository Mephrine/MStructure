//
//  NSObjectExtension.swift
//  JHAlarm
//
//  Created by 김제현 on 12/08/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import UIKit

extension NSObject {
    public var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!;
    }
    
    /**
        # viewController
        - Author: Mephrine
        - Date: 20.02.07
        - Parameters:
           - fromStoryboard: Storyboard 명
           - identifier: Storyboard내 ViewController id
        - Returns: UIViewController?
        - Note: Storyboard의 ViewController를 생성하여 반환
       */
    public func viewController(fromStoryboard storyboard: String, identifier: String) -> UIViewController? {
        let bundle = Bundle(for: self.classForCoder)
        
        let sb = UIStoryboard(name: storyboard, bundle: bundle)
        
        return sb.instantiateViewController(withIdentifier: identifier)
    }
}

