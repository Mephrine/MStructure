//
//  NotificationManager+Rx.swift
//  MUtils
//
//  Created by Mephrine on 2019/12/03.
//  Copyright © 2019 MUtils. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/**
 # (E) NotificationManager
 - Author: Mephrine
 - Date: 20.02.07
 - Note: Notification 전체를 다루는 Manager Enum
*/
enum NotificationManager: String{
    case reloadColor
    
    public var name: Notification.Name {
        return Notification.Name(rawValue)
    }
}

extension NotificationManager {
    /**
     # post
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
        - object: 대상 object
        - userInfo: 전달할 userInfo 데이터
     - Returns:
     - Note: Notification을 보내는 함수
    */
    public func post(object: AnyObject? = nil, userInfo: [NSObject: AnyObject]? = nil) {
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }
    
    /**
     # (S) Reactive
     - Author: Mephrine
     - Date: 20.02.07
     - Note: NotificationManager에 rx를 적용하기 위한 구조체
    */
    struct Reactive {
        fileprivate let base: NotificationManager
        
        init (_ base: NotificationManager) {
            self.base = base
        }
    }
    
    public var rx: Reactive {
        return Reactive(self)
    }
}

extension NotificationManager.Reactive {
    public var post: Observable<Notification> {
        return NotificationCenter.default.rx.notification(base.name)
    }
}

