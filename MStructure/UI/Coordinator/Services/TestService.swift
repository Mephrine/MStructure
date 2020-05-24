//
//  TestService.swift
//  MUtils
//
//  Created by Mephrine on 2020/02/18.
//  Copyright © 2020 MUtils. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

/**
 # (P) HasUpdateService
 - Author: Mephrine
 - Date: 19.12.05
 - Note: 인증서 관련 서비스 프로토콜을 사용하기 위한 변수를 선언한 프로토콜
*/
protocol HasTestService {
    var testService: TestService { get }
}

/**
 # (E) MResults
 - Author: Mephrine
 - Date: 20.02.18
 - Parameters:
 - Returns:
    - FAIL : 처리 실패
    - SUCCESS : 처리 성공
 - Note: xx 결과.
*/
enum MResults {
    case SUCCESS
    case FAIL
}

/**
 # (E) CertError
 - Author: Mephrine
 - Date: 20.02.18
 - Parameters:
 - Returns:
    - NONE : 에러 없음
    - FAIL_READ : 읽기 실패
    - FAIL_AUTH : 인증 실패
    - FAIL_MISMATCH_IDN : 주민등록번호 불일치
    - FAIL_NETWORK : 기타 오류
 - Note: xx 관련 에러.
*/
enum MError: Error {
    case NONE
    case FAIL_READ
    case FAIL_AUTH
    case FAIL_MISMATCH_IDN
    case FAIL_NETWORK
    
    func errorMessage() -> String {
        switch self {
        default:
            return ""
        }
    }
    
    func isAlert() -> Bool {
        switch self {
        case .FAIL_READ, .FAIL_AUTH, .FAIL_NETWORK:
            return true
        default:
            return false
        }
    }
}

//typealias resultAuth = (Object?, MError)
typealias result = (MResults, String)
typealias resultAny = (MResults, Any)


/*
  ----
  ***
*/
/**
    # (C) TestService
    - Author: Mephrine
    - Date: 20.02.17
    - Note: 공인인증서 관련 서비스 클래스.
*/
class TestService {
    private let networking = MNetworking()
    
    /**
     # auth
     - Author: Mephrine
     - Date: 20.03.09
     - Parameters:
        - pwd : 입력한 비밀번호
     - Returns: Observable<MResults>
     - Note: 웹에 전달할 공인인증서 인증 정보를 획득 및 전달.
    */
    fileprivate func auth(_ pwd: String) -> Observable<MResults> {
        return Observable<MResults>.create { observer -> Disposable in
           
            observer.onNext(MResults.SUCCESS)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

extension TestService: ReactiveCompatible {}

extension Reactive where Base: TestService {
//    func test(pwd: String) -> Observable<MResults> {
//        return base.serverAuth()
//            .asObservable()
//            .flatMapLatest{ self.base.auth(pwd) }
//            .catchError { error -> Observable<(CertificateAuth?, MError)> in
//                if let cError = error as? MError {
//                    let resultError: resultCertAuth = (nil, cError)
//                    return Observable.just(resultError)
//                }
//
//                let resultError: resultCertAuth = (nil, MError.FAIL_NETWORK)
//                return Observable.just(resultError)
//        }
//    }
}

