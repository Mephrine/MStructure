//
//  WebViewVM.swift
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

/**
 # WebViewVM
 - Author: Mephrine
 - Date: 20.01.13
 - Note: MainVC ViewModel
*/
class WebViewVM: Reactor {
    var initialState = State()
    
    /**
     # (E) Action
     - Author: Mephrine
     - Date: 20.01.13
     - Note: ReactorKit에서 ViewController에서 실행될 Action을 모아둔 enum
    */
    enum Action {
        case loadWebView(String)
        case loadScript(String)
    }
    
    /**
     # (E) Mutation
     - Author: Mephrine
     - Date: 20.01.13
     - Note: ReactorKit에서 Action이 들어오면 비즈니스 로직 처리 후 변경 값을 리턴하는 로직을 담당하는 Mutation함수에서 처리할 enum 모음
    */
    enum Mutation {
        case loadWebView(String)
        case sendScriptMsg(String)
    }
    
    /**
     # (S) State
     - Author: Mephrine
     - Date: 20.01.13
     - Note: ReactorKit에서 상태값을 관리하는 구조체
    */
    struct State {
        var urlStr: String = ""
        var scriptMsg: String = ""
    }
    
    // 1. Action이 들어오면 해당 부분을 타고, Service와의 Side Effect 처리를 함. (API 통신 등.) 그리고 Mutaion으로 반환!
    // 전역 변수 관련된 처리위해 transform이동 시에는 해당 부분에서 전역 변수 구독하고 empty로 넘기기,
    /**
     # mutate
     - Author: Mephrine
     - Date: 20.01.13
     - Parameters:
        -action: 실행된 action
     - Returns: Observable<Mutation>
     - Note: Action이 들어오면 해당 부분을 타고, Service와의 Side Effect 처리를 함. (API 통신 등.) 그리고 Mutaion으로 반환
    */
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .loadWebView(urlStr):
            return Observable.of(Mutation.loadWebView(urlStr))
        case let .loadScript(script):
            return Observable.of(Mutation.sendScriptMsg(script))
        }
    }
    
    // 2. 각각의 스트림을 변형함. 다른 옵저버블 스트림을 변환, 결합 가능. (transform이 있으면 mutate -> transform -> mutate -> reduce)
        // 전역 변수를 mutate로 변환하고 기존 Mutation하고 merge.
//        func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
//            let stateMutation = self.services.userService.loginState
//                .flatMap { [weak self] in
//                    self?.mutate(loginState: $0) ?? .empty()
//                }
//            return Observable.of(mutation, stateMutation).merge()
//        }
    
    
    // 2. 이전의 상태값과 Mutation을 이용해서 새로운 상태값을 반환함.
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
        case let .loadWebView(urlStr):
            newState.urlStr = urlStr
            break
        case let .sendScriptMsg(scriptMsg):
            newState.scriptMsg = scriptMsg
            break
        }
        return newState
    }
}

