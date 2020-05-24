//
//  MainFlow.swift
//  MStructure
//
//  Created by Mephrine on 2020/01/13.
//  Copyright © 2020 KBIZ. All rights reserved.
//

import Foundation
import RxCocoa
import RxFlow
import RxSwift
import UIKit
import SafariServices
import MUtils

/**
 # (C) MainFlow
 - Author: Mephrine
 - Date: 20.01.13
 - Note: 메인화면 네비게이션 관리 Flow.
*/
class MainFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController: BaseNavigationController = {
        let viewController = BaseNavigationController()
        viewController.setNavigationBarHidden(true, animated: false)
        return viewController
    }()
    
    private let service: AppServices
    
    init(service: AppServices) {
        self.service = service
    }
    
    deinit {
        log.d("deinit MainFlow")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .goMain:
            return naviToMain()
        case .goPushSubWebView(let subWebViewVC):
            return naviToSubWebView(subWebViewVC)
        case .goRequestPushSubWebView(let url):
            return naviToSubWebView(urlStr: url)
        case .backSubWebViewVC:
            return naviToGoBackSubWebView()
//        case .goRequestSubRootWebView(let subWebViewVC):
//            return naviToSubRootWebView(subWebViewVC)
        case .showSFVC(let url):
            return showSFVC(url: url)
        case .goBack:
            return naviToGoBack()
        default:
            return .none
        }
    }
    
    // 메인화면 띄우기.
    private func naviToMain() -> FlowContributors {
        let mainVC = MainVC.instantiate(withViewModel: MainVM(), storyBoardName: "Main")
        self.rootViewController.setViewControllers([mainVC], animated: false)
        
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: mainVC, withNextStepper: mainVC))
    }
    
    // 서브웹뷰 이동.
    private func naviToSubWebView(urlStr: String) -> FlowContributors {
        let subWebViewVC = SubWebViewVC.instantiate(withViewModel: SubWebViewVM.init(urlString: urlStr), storyBoardName: "Web")
        self.rootViewController.pushViewController(subWebViewVC, animated: ANIMATION_PUSH_TRANSITION)

        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: subWebViewVC, withNextStepper: subWebViewVC))
    }
    
    private func naviToSubWebView(_ subWebViewVC: SubWebViewVC) -> FlowContributors {
        subWebViewVC.reactor = SubWebViewVM.init()
        self.rootViewController.pushViewController(subWebViewVC, animated: ANIMATION_PUSH_TRANSITION)
        
        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: subWebViewVC, withNextStepper: subWebViewVC))
    }
    
    // 서브웹뷰 종료.
    private func naviToGoBackSubWebView() -> FlowContributors {
        self.rootViewController.popViewController(animated: ANIMATION_PUSH_TRANSITION)
        return .none
    }
    
    // 서브웹뷰 새로운 루트뷰로 이동하기.
//    private func naviToSubRootWebView(urlStr: String) -> FlowContributors {
//        let subWebFlow = SubWebFlow(service: self.service)
//        Flows.whenReady(flow1: subWebFlow) { [unowned self] root in
//            Async.main {
//                root.modalPresentationStyle = .fullScreen
//                self.rootViewController.present(root, animated: ANIMATION_ROOT_TRANSITION)
//            }
//        }
//        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: subWebFlow, withNextStepper: OneStepper(withSingleStep: AppStep.initSubRootWebView(urlStr: urlStr))))
//    }
//
//    // 서브웹뷰 새로운 루트뷰로 이동하기.
//    private func naviToSubRootWebView(_ subWebViewVC: SubWebViewVC) -> FlowContributors {
//        let subWebFlow = SubWebFlow(service: self.service)
//        Flows.whenReady(flow1: subWebFlow) { [unowned self] root in
//            Async.main {
//                root.modalPresentationStyle = .fullScreen
//                self.rootViewController.present(root, animated: ANIMATION_ROOT_TRANSITION)
//            }
//        }
//        return .one(flowContributor: FlowContributor.contribute(withNextPresentable: subWebFlow, withNextStepper: OneStepper(withSingleStep: AppStep.initRequestSubRootWebView(subWebViewVC))))
//    }
    
    /**
     # showSFVC
     - Author: Mephrine
     - Date: 20.03.17
     - Parameters:
        - url : URL 타입 링크
     - Returns: FlowContributors
     - Note: SafariVC로 링크 실행.
     */
    private func showSFVC(url: URL) -> FlowContributors {
        let currentVC = self.rootViewController.visibleViewController
        let sfVC = SFSafariViewController(url: url)
        currentVC?.present(sfVC, animated: true, completion: nil)
        
        return .none
    }
    
    /**
     # naviToGoBack
     - Author: Mephrine
     - Date: 20.03.17
     - Parameters:
        - Returns: FlowContributors
     - Note: 뒤로가기 공통.
     */
    private func naviToGoBack() -> FlowContributors {
        self.rootViewController.popViewController(animated: ANIMATION_PUSH_TRANSITION)
        return .none
    }
    
}
