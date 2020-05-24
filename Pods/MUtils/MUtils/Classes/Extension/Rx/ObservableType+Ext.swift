//
//  RxSwift+RetryInterval.swift
//  CWUtils
//
//  Created by iamchiwon on 16/04/2019.
//

import Foundation
import RxSwift
import RxSwiftExt

extension ObservableType {
    /**
     # retryInterval
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
        - intervals: retry 시 대기할 interval 시간 배열
        - when: retry를 진행할 에러 코드를 체크하는 클로저
     - Returns: Observable<Self.Element>
     - Note: 특정 에러코드인 경우에 retry를 시키기 위한 함수. when에서 true에 해당되는 에러코드인 경우, intervals의 초만큼 retry. (504에러 시 1,2,4초 마다 retry)
             iamchiwon 님께서 만드신 것 사용.
    */
    // e.g. .retryInterval([1, 2, 4]) { ($0 as NSError).code == 504 }
    public func retryInterval(_ intervals: [RxTimeInterval], when f: @escaping (Error) -> Bool) -> Observable<Self.Element> {
        return retryWhen { error -> Observable<Int> in
            error.flatMap { e -> Observable<Void> in
                guard f(e) else { return .error(e) }
                return .just(())
                }
                .zip(with: Observable<RxTimeInterval>.from(intervals)) { $1 }
                .flatMap { Observable<Int>.timer($0, scheduler: Schedulers.background) }
        }
    }
}
