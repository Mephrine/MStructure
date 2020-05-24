//
//  UIView+Rx.swift
//  MFramework
//
//  Created by Mephrine on 2019/12/24.
//  Copyright © 2019 MFramework. All rights reserved.
//

import UIKit
import RxSwift

extension UIView {
   /**
       # addTapGestureRecognizer
       - Author: Mephrine
       - Date: 20.02.07
       - Parameters:
          - numberOfTapsRequired: retry 시 대기할 interval 시간 배열
       - Returns: Observable<UITapGestureRecognizer>
       - Note: 탭 제스처 추가하는 Observable를 리턴하는 함수
      */
    public func addTapGestureRecognizer(_ numberOfTapsRequired: Int = 1) -> Observable<UITapGestureRecognizer> {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = numberOfTapsRequired
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
        return tapGesture.rx.event.asDriver().asObservable()
    }
    
    /**
     # addSwipeGestureRecognizer
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
     - Returns: Observable<UISwipeGestureRecognizer>
     - Note: Swipe 제스처 추가하는 Observable를 리턴하는 함수
    */
    public func addSwipeGestureRecognizer() -> Observable<UISwipeGestureRecognizer> {
        let swipeGesture = UISwipeGestureRecognizer()
        isUserInteractionEnabled = true
        addGestureRecognizer(swipeGesture)
        return swipeGesture.rx.event.asDriver().asObservable()
    }
}
