//
//  SubWebViewVM.swift
//  MStructure
//
//  Created by Mephrine on 2020/01/15.
//  Copyright © 2020 MUtils. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxFlow
import RxSwift

/**
 # SubWebViewVM
 - Author: Mephrine
 - Date: 20.01.13
 - Note: SubWebViewVC ViewModel
*/
class SubWebViewVM: Reactor {
    var initialState = State()
    
    /**
     # (E) Action
     - Author: Mephrine
     - Date: 20.01.13
     - Note: ReactorKit에서 ViewController에서 실행될 Action을 모아둔 enum
    */
    enum Action {
        case loadWebView
        case returnCertAuth(String)
    }
    
    /**
     # (E) Mutation
     - Author: Mephrine
     - Date: 20.01.13
     - Note: ReactorKit에서 Action이 들어오면 비즈니스 로직 처리 후 변경 값을 리턴하는 로직을 담당하는 Mutation함수에서 처리할 enum 모음
    */
    enum Mutation {
        case loadWebView(String)
        case convertCertToScriptMsg(String)
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
    
    init(urlString: String = "") {
        self.initialState = State(urlStr: urlString)
    }
    
    // 1. Action이 들어오면 해당 부분을 타고, Service와의 Side Effect 처리를 함. (API 통신 등.) 그리고 Mutaion으로 반환.
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
        case .loadWebView:
            return Observable.of(Mutation.loadWebView(currentState.urlStr))
        case let .returnCertAuth(scriptMsg):
            return Observable.just(scriptMsg)
                .map{ Mutation.convertCertToScriptMsg($0) }
        }
    }
    
    
    // 2. 이전의 상태값과 Mutation을 이용해서 새로운 상태값을 반환.
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
            
        case let .convertCertToScriptMsg(scriptMsg):
            newState.scriptMsg = scriptMsg
        }
        return newState
    }
    
    
    // 3. 각각의 스트림을 변형함. 다른 옵저버블 스트림을 변환, 결합 가능.
    //    func transform(mutation: Observable<SubWebViewVM.Mutation>) -> Observable<SubWebViewVM.Mutation> {
    //
    //    }
    
    //    private func mutate(taskEvent: TaskEvent) -> Observable<Mutation> {
    //        let state = self.currentState
    //    }
}

