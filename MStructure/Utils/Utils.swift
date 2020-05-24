//
//  Utils.swift
//  MStructure
//
//  Created by Mephrine on 2019/12/03.
//  Copyright © 2019 MStructure. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit
import MUtils

/**
 # (C) Utils
 - Author: Mephrine
 - Date: 19.12.03
 - Note: 공통적으로 사용하는 UI 관련 변수 및 함수 모음.
*/

extension Utils {
    /**
        # (E) FONT_TYPE
         - Author: Mephrine
         - Date: 20.01.13
         - Note: 사용하는 폰트를 모아둔 enum
    */
    enum FONT_TYPE: String {
        case Medium = "NotoSansKR-Medium"
        case Regular = "NotoSansKR-Regular"
    }
    
    /**
    # Font
        - Author: Mephrine
        - Date: 20.01.13
        - Parameters:
            - type: 적용할 폰트 타입
            - size: 폰트 사이즈
        - Returns:
        - Note: 적용할 폰트 타입을 받아서 UIFont로 전환해주는 함수.
    */
    static func Font(_ type: FONT_TYPE, size: CGFloat) -> UIFont {
        return UIFont(name: type.rawValue, size: size)!
    }
    
    /**
     # removeKeyChain
     - Author: Mephrine
     - Date: 20.01.13
     - Parameters:
     - Returns:
     - Note: 처음 진행 시, 관련 키체인을 모두 제거
    */
    static func removeKeyChain()  {
        let secItemClasses =  [
            kSecClassGenericPassword,
            kSecClassInternetPassword,
            kSecClassCertificate,
            kSecClassKey,
            kSecClassIdentity,
        ]
        for itemClass in secItemClasses {
            let spec: NSDictionary = [kSecClass: itemClass]
            SecItemDelete(spec)
        }
    }
}
