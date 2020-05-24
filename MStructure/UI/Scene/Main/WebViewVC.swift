//
//  WebViewVC.swift
//  MStructure
//
//  Created by Mephrine on 2019/12/04.
//  Copyright © 2019 MStructure. All rights reserved.
//

import ReactorKit
import Reusable
import RxCocoa
import RxOptional
import RxSwift
import RxWebKit
import Then
import UIKit
import WebKit
import MUtils

/**
 # (C) WebViewVC
 - Author: Mephrine
 - Date: 20.01.13
 - Note: 메인화면 ViewController
*/
class WebViewVC: BaseWebVC, StoryboardView, StoryboardBased {
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    // MARK: Bind
    /**
     # bind
     - Author: Mephrine
     - Date: 20.01.13
     - Parameters:
        - reactor: 사용될 ViewModel 주입
     - Returns:
     - Note: view가 모두 로드된 이후 (ViewDidLoad 및 storyboard instaniate) bind를 진행.
    */
    func bind(reactor: WebViewVM) {
        guard let webView = mWebView else {
            return
        }
        
        ////////////////// Action
        // 뷰 로드 시에, 웹뷰 실행. WEBVIEW_DOMAIN
        self.rx.viewWillAppear
            .take(1)
            .map { _ in Reactor.Action.loadWebView(WEB_INDEX) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        ////////////////// State
        reactor.state
            .map { $0.urlStr }
            .filterEmpty()
            .distinctUntilChanged()
            .observeOn(Schedulers.main)
            .subscribe(onNext:{ [weak self] in
                log.d("url : \($0)")
                self?.requestWebView($0)
            })
            .disposed(by: disposeBag)
        
        // 스크립트메시지가 들어오면 스크립트 실행.
        reactor.state.map{ $0.scriptMsg }
        .filterEmpty()
        .observeOn(Schedulers.main)
        .flatMap(webView.rx.evaluateJavaScript)
        .subscribe()
        .disposed(by: disposeBag)
        
        
        self.bindWebView()
    }
    
    /**
     # bindWebView
     - Author: Mephrine
     - Date: 20.01.13
     - Parameters:
     - Returns:
     - Note: 웹뷰 uidelegate 관련 바인딩 모음 함수
    */
    private func bindWebView() {
        guard let webView = mWebView else {
            return
        }
        
        // WebView delegate - Loading
        // 페이지 로딩 시작
        webView.rx
            .didStartProvisionalNavigation
            .subscribe(onNext: { _ in
                LoadingView.shared.show()
            })
            .disposed(by: disposeBag)
        
        // 페이지 로딩 완료
        webView.rx.didFinishNavigation
            .subscribe(onNext: { _ in
                LoadingView.shared.hide()
            })
            .disposed(by: disposeBag)
        
        // 페이지 로딩 실패
        webView.rx.didFailProvisionalNavigation
            .subscribe(onNext: { [weak self] webView, navigation, error in
                self?.chkURLError(error)
                }, onError: { [weak self] error in
                    self?.chkURLError(error)
            }).disposed(by: disposeBag)
        
        
        // WebView delegate - DeepLink
        webView.rx
            .decidePolicyNavigationAction
            .subscribe(onNext: { [weak self] webView, action, handler in
                guard let self = self else { return }
                if let url = action.request.url {
                    if self.policyAfterDeepLink(request: action.request) {
                        handler(.allow)
                        return
                    } else {
                        handler(.cancel)
                        return
                    }
                }
                handler(.allow)
            })
            .disposed(by: disposeBag)
        
        
        // Web <-> Native 간에 UserController 방식 이용 시에 사용.
//        webView.configuration.userContentController.rx
//            .scriptMessage(forName: "testFunc")
//            .debug()
//            .observeOn(Schedulers.main)
//            .bind { [weak self] scriptMessage in
//                guard let self = self else { return }
//
//                if !responseJson.isEmpty {
//                    Async.main {
//                        webView.evaluateJavaScript(responseJson) { result, error in
//                            log.e("script error : \(error.debugDescription)")
//                        }
//                    }
//                } else {
//                    if let message = scriptMessage.body as? String {
//                        self.steps.accept(AppStep.showAlertType1(vc: self, message: message))
//                    }
//                }
//        }.disposed(by: disposeBag)
    }
    
    /**
     # showAuthority
     - Author: Mephrine
     - Date: 20.01.13
     - Parameters:
     - Returns:
     - Note: 권한 팝업을 호출하는 함수
    */
    func showAuthority() {
        let authorityVC = AuthorityVC.instantiate(withViewModel: AuthorityVM(), storyBoardName: "Main")
        authorityVC.showAnim(vc: self, parentAddView: authorityVC.vContainer) {
            
        }
    }
}
