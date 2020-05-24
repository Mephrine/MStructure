//
//  SubWebViewVC.swift
//  MStructure
//
//  Created by Mephrine on 2020/01/15.
//  Copyright © 2020 MUtils. All rights reserved.
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
 # (C) SubWebViewVC
 - Author: Mephrine
 - Date: 20.01.13
 - Note: 서브웹뷰 화면 ViewController
*/
class SubWebViewVC: BaseWebVC, StoryboardView, StoryboardBased {
    
    override func popGesture() {
        LoadingView.shared.hide()
        self.callJavaScriptFunc(#"self.close()"#)
        
        mWebView?.stopLoading()
        mWebView?.loadHTMLString("", baseURL: nil)
        mWebView?.configuration.userContentController = WKUserContentController()
        mWebView?.uiDelegate = nil
        mWebView?.navigationDelegate = nil
        mWebView?.removeAllSubviews()
        mWebView?.removeFromSuperview()
        mWebView = nil
        
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
    func bind(reactor: SubWebViewVM) {
        guard let webView = mWebView else {
            return
        }
        
        ////////////////// Action
        // 뷰 로드 시에, 웹뷰 실행. WEBVIEW_DOMAIN
        //        self.rx.viewWillAppear
        //            .take(1)
        //            .map { _ in Reactor.Action.loadWebView }
        //            .bind(to: reactor.action)
        //            .disposed(by: disposeBag)
        
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
            .debug()
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
        
    }
    
    
    // 인증서 화면에서 받아온 정보를 넘기는 액션 실행.
    func returnCertAuthInfo(_ scriptMsg: String) {
        self.reactor?.action.onNext(.returnCertAuth(scriptMsg))
    }
    
}
