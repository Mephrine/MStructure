//
//  IntroVM.swift
//  MStructure
//
//  Created by Mephrine on 2019/12/04.
//  Copyright © 2019 MStructure. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxFlow
import RxSwift
import SwiftyUserDefaults
import WebKit
import MUtils

/**
 # IntroVM
 - Author: Mephrine
 - Date: 20.01.13
 - Note: IntroVC ViewModel
*/
class IntroVM: Reactor {
    var initialState: IntroVM.State = State()
    
    enum VersionStatus {
        case latest
        case old
        case error
    }
    
    enum ForcedUpdate {
        case closed
        case pass
        case forcedUpdate
        case keep
    }
    
    enum ExamineError: Error {
       case isJailbreak
    }

    
    typealias Services = HasUpdateService
    var services: Services
    
    init(withService service: AppServices) {
        self.services = service
    }
    
    /**
     # (E) Action
     - Author: Mephrine
     - Date: 20.01.13
     - Note: ReactorKit에서 ViewController에서 실행될 Action을 모아둔 enum
    */
    enum Action {
        case examineApp
    }
    
    /**
        # (E) Mutation
        - Author: Mephrine
        - Date: 20.01.13
        - Note: ReactorKit에서 Action이 들어오면 비즈니스 로직 처리 후 변경 값을 리턴하는 로직을 담당하는 Mutation함수에서 처리할 enum 모음
       */
    enum Mutation {
        case chkAppValid(Bool)
        case requestAppVersion(ForcedUpdate)
        case closedApp(String)
    }
    
    /**
        # (S) State
        - Author: Mephrine
        - Date: 20.01.13
        - Note: ReactorKit에서 상태값을 관리하는 구조체
       */
    struct State {
        var forcedUpdate: ForcedUpdate = .keep
        var endIntroView = false
        var completeExamine: Bool? = nil
        var closedMsg: String = ""
        
    }
    
    // MARK: Mutate
    /**
     # mutate
     - Author: Mephrine
     - Date: 20.01.13
     - Parameters:
        -action: 실행된 action
     - Returns: Observable<Mutation>
     - Note: Action이 들어오면 해당 부분을 타고, Service와의 Side Effect 처리를 함. (API 통신 등.) 그리고 Mutaion으로 반환
    */
    func mutate(action: IntroVM.Action) -> Observable<IntroVM.Mutation> {
        switch action {
        case .examineApp:
            let examineApp = self.examineApp()
                .map(Mutation.chkAppValid)
            
            let requestAppVersion = self.services.updateService.rx.appVersion()
                .asObservable()
            
            // 강제업데이트 버전이 0.0.0인 경우에는 iosRsn 팝업을 띄움.
            let closedApp = requestAppVersion
                .filter { $0.appVersion?.iosEnfrUpdt == "0.0.0" }
                .map { $0.appVersion?.iosRsn }
                .filterNil()
                .map(Mutation.closedApp)
            
            let updateApp = requestAppVersion.map{ self.validationUpdate($0.appVersion?.iosEnfrUpdt) }
                .catchErrorJustReturn(.keep)
                .map(Mutation.requestAppVersion)
            
            return .concat([examineApp, closedApp, updateApp])
        }
    }
    
    // MARK: Reduce
    /**
     # reduce
     - Author: Mephrine
     - Date: 20.01.13
     - Parameters:
         - state: 이전 state
         - mutation: 변경된 mutation
     - Returns: Bool
     - Note: 이전의 상태값과 Mutation을 이용해서 새로운 상태값을 반환
    */
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .chkAppValid(complete):
            newState.completeExamine = complete
        case let .closedApp(closedMsg):
            newState.closedMsg = closedMsg
        case let .requestAppVersion(isForcedUpdate):
            newState.forcedUpdate = isForcedUpdate
            break
        }
        
        return newState
    }
    
     /**
        # validationUpdate
         - Author: Mephrine
         - Date: 20.01.13
         - Parameters:
            - version: 서버에서 받아온 강제업데이트 적용 버전 정보
         - Returns: ForcedUpdate
         - Note: 강제업데이트 체크 함수
    */
    fileprivate func validationUpdate(_ version: String?) -> ForcedUpdate {
        guard let updateVersion = version else { return .pass }
        
        let currentVersion = Utils.version()
        let chkValidVersion = updateVersion.split(separator: ".")
        
        //일치하지 않으면 그냥 멍때리기.
        if chkValidVersion.count != 3 {
            return .keep
        }
        
        for numChk in chkValidVersion {
            guard !numChk.isEmpty && numChk.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
                else {
                    return .keep
            }
        }
        
        //앱 심사여부 UD에 저장.
        if self.compareVersion(latest: updateVersion, current: currentVersion) == .latest {
            // 정상진행
            return .pass
        } else {
            // 강제 업데이트
            return .forcedUpdate
        }
    }
    
    /**
        # compareVersion
         - Author: Mephrine
         - Date: 20.01.13
         - Parameters:
            - latest: 최신 버전
            - current: 현재 버전
         - Returns: VersionStatus
         - Note: 버전 비교 함수
    */
    fileprivate func compareVersion(latest: String, current: String) -> VersionStatus {
        let latestSplit = latest.components(separatedBy: ".")
        let currentSplit = current.components(separatedBy: ".")
        for (latest, current) in zip(latestSplit, currentSplit) {
            if let lastInt = Int(latest), let currentInt = Int(current) {
                if currentInt < lastInt {
                    return .old
                } else if currentInt > lastInt {
                    return .latest
                }
            } else {
                return .error
            }
        }
        return .latest
    }
    
    /**
     # examineApp
     - Author: Mephrine
     - Date: 20.01.13
     - Parameters:
     - Returns: Observable<Bool>
     - Note: 탈옥 체크 함수.
     */
    func examineApp() -> Observable<Bool> {
        return Observable<Bool>.create { observer -> Disposable in
            let jailbreak = Utils.checkJailBreak()
            
            if jailbreak {
                observer.onNext(false)
                observer.onError(ExamineError.isJailbreak)
                return Disposables.create()
            }
            
            observer.onNext(true)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
