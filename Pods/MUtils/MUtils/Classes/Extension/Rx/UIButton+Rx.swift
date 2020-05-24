//
//  UIButton+Rx.swift
//  MFramework
//
//  Created by Mephrine on 2019/12/24.
//  Copyright © 2019 MFramework. All rights reserved.
//

import UIKit
import RxSwift

extension UIButton {
    /**
     # tapThrottle
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
        - milliseconds: 이벤트를 수용할 시간
     - Returns: Observable<UIButton>
     - Note: 버튼 클릭 시 지정한 milliseconds 시간 내에 들어온 이벤트 중 가장 끝 이벤트만 실행
    */
    public func tapThrottle(_ milliseconds: Int = 300) -> Observable<UIButton> {
        return rx.tap.asDriver()
            .throttle(.milliseconds(milliseconds), latest: false)
            .map{ self }
            .asObservable()
    }
    
    /**
     # tapThrottle
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
        - milliseconds: 이벤트를 수용할 시간
     - Returns: Observable<Void>
     - Note: 버튼 클릭 시 지정한 milliseconds 시간 내에 들어온 이벤트 중 가장 끝 이벤트만 실행
    */
    public func tapThrottleVoid(_ milliseconds: Int = 300) -> Observable<Void> {
        return rx.tap.asDriver()
            .throttle(.milliseconds(milliseconds), latest: false)
            .asObservable()
    }
}
