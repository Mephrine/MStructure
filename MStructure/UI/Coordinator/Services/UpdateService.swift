//
//  AuthService.swift
//  MStructure
//
//  Created by Mephrine on 2019/12/05.
//  Copyright © 2019 MStructure. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

/**
 # (P) HasUpdateService
 - Author: Mephrine
 - Date: 19.12.05
 - Note: 앱 업데이트 관련 서비스 프로토콜을 사용하기 위한 변수를 선언한 프로토콜
*/
protocol HasUpdateService {
    var updateService: UpdateService { get }
}

/**
 # (C) UpdateService
 - Author: Mephrine
 - Date: 19.12.05
 - Note: 업데이트API 관련 서비스 클래스.
*/
class UpdateService {
    private let networking = MNetworking()
    // 1번만 실행.
    private let updateSubject = ReplaySubject<AppVersion?>.create(bufferSize: 1)
    
    /**
     # appVersion
     - Author: Mephrine
     - Date: 20.02.17
     - Parameters:
     - Returns: Single<AppVersion>
     - Note: 네트워크 통신을 통해 앱 버전 정보를 받아옴.
    */
    fileprivate func appVersion() -> Single<AppVersion> {
        return networking.request(.AppVersion)
            .map(to: AppVersion.self)
    }
    
}

extension UpdateService: ReactiveCompatible {}

extension Reactive where Base: UpdateService {
    /**
     # appVersion
     - Author: Mephrine
     - Date: 20.02.17
     - Parameters:
     - Returns: Observable<AppVersion>
     - Note: 앱 버전 정보를 rx로 접근 가능하도록 확장한 함수.
    */
    func appVersion() -> Observable<AppVersion> {
        return base.appVersion().asObservable()
    }
}



