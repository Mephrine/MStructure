//
//  IntroVC.swift
//  MStructure
//
//  Created by Mephrine on 2019/12/04.
//  Copyright © 2019 MStructure. All rights reserved.
//

import Foundation
import ReactorKit
import Reusable
import RxViewController
import UIKit
import MUtils

/**
 # (C) IntroVC
 - Author: Mephrine
 - Date: 20.01.13
 - Note: 인트로화면 ViewController
*/
class IntroVC: BaseVC, StoryboardView, StoryboardBased {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    /**
     # initView
     - Author: Mephrine
     - Date: 20.01.13
     - Parameters:
     - Returns:
     - Note: BaseVC에서 상속받은 viewDidLoad 이후 실행되는 함수
    */
    override func initView() {
    }
    
    /**
     # bind
     - Author: Mephrine
     - Date: 20.01.13
     - Parameters:
        - reactor: 사용될 ViewModel 주입
     - Returns:
     - Note: view가 모두 로드된 이후 (ViewDidLoad 및 storyboard instaniate) bind를 진행.
    */
    func bind(reactor: IntroVM) {
        // Action
        self.rx.viewDidAppear
            .take(1)
            .map { _ in Reactor.Action.examineApp }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map{ $0.completeExamine }
            .filterNil()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if !$0 {
                    CommonAlert.showAlertType1(vc: self, message: STR_JAILBREAK, completeTitle: STR_OK, {
                        Utils.cexit()
                    })
                }
                }).disposed(by: disposeBag)
        
        reactor.state.map { $0.forcedUpdate }
            .do(onNext: {
                if ($0 == .forcedUpdate) {
                    self.showForcedUpdateAlert()
                }
            })
            .filter{$0 == .pass}
            .delay(.milliseconds(1000), scheduler: Schedulers.io)
            .subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
                self.moveMain()
            }).disposed(by: disposeBag)
        
        reactor.state.map { $0.closedMsg }
        .filterEmpty()
        .distinctUntilChanged()
        .subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.showClosedAppAlert($0)
        }).disposed(by: disposeBag)
    }
    
    /**
     # showForcedUpdateAlert
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
     - Returns:
     - Note: 강제 업데이트 진행 알럿 노출.
    */
    func showForcedUpdateAlert() {
        CommonAlert.showAlertType2(vc: self, message: STR_FORCE_UPDATE, cancelTitle: STR_CANCEL, completeTitle: STR_OK, {
            self.moveMain()
        }) {
            if let appStoreUrl = URL(string: APPSTORE_LINK) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appStoreUrl, options: [:]) { _ in
                        Utils.cexit()
                    }

                } else {
                    UIApplication.shared.openURL(appStoreUrl)
                    Utils.cexit()
                }
            }
        }
    }
    
    /**
     # showClosedAppAlert
     - Author: Mephrine
     - Date: 20.04.20
     - Parameters:
     - Returns:
     - Note: 오픈 전에 진입을 금지하는 알럿 노출.
    */
    func showClosedAppAlert(_ msg: String) {
        CommonAlert.showAlertType1(vc: self, message: msg, completeTitle: STR_OK, {
            Utils.cexit()
        })
    }
    
    // MARK: Navigation
     /**
     # moveMain
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
     - Returns:
     - Note: 메인 화면으로 이동.
    */
    func moveMain() {
        self.steps.accept(AppStep.goMain)
    }
}
