//
//  Networking.swift
//  MStructure
//
//  Created by Mephrine on 2019/12/05.
//  Copyright © 2019 MStructure. All rights reserved.
//

import Moya
import RxSwift
import MUtils

enum ResultNetwork: Int {
    case success = 0
    case nullObject = -1
    case notValidity = -2
    case notRequired = -3
    case systemError = -99
}

//typealias completeNetwork = (ResultNetwork, Response)
typealias MNetworking = Networking<CallAPI>


/**
 # (C) Networking
 - Author: Mephrine
 - Date: 20.02.18
 - Note: Moya Provider를 커스터마이징한 CustomProvider를 이용해 request 통신을 담당하는 클래스
 */
final class Networking<Target: TargetType>: CustomProvider<Target> {
    
    /**
        # request
            - Author: Mephrine
            - Date: 20.02.17
            - parameters:
                - target : Call API에 정의한 enum 케이스 중에서 현재 요청할 API
            - returns: Single<Response>
            - Note: Moya request를 커스텀하여 결과값 로그 및 네트워크 상태 코드가 정상인 경우만 필터해서 받는 Single 생성.
    */
    func request(_ target: Target) -> Single<Response> {
        let requestString = "\(target.method.rawValue) \(target.path)"
        return self.rx.request(target)
            .filterSuccessfulStatusCodes()
            .do(
                onSuccess: { value in
                    let message = "SUCCESS: \(requestString) (\(value.statusCode))"
                    log.d(message)
            },
                onError: { error in
                    if let response = (error as? MoyaError)?.response {
                        if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
                            let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(jsonObject)"
                            log.e(message)
                        } else if let rawString = String(data: response.data, encoding: .utf8) {
                            let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
                            log.e(message)
                        } else {
                            let message = "FAILURE: \(requestString) (\(response.statusCode))"
                            log.e(message)
                        }
                    } else {
                        let message = "FAILURE: \(requestString)\n\(error)"
                        log.e(message)
                    }
            }
                ,
                onSubscribed: {
                    let message = "REQUEST: \(requestString)"
                    log.d(message)
            }
        )
//            .map {
//            completeNetwork()
//        }
    }
}
