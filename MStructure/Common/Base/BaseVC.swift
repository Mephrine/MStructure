//
//  BaseVC.swift
//  MStructure
//
//  Created by Mephrine on 2019/12/03.
//  Copyright © 2019 MStructure. All rights reserved.
//

import ReactorKit
import Reusable
import RxCocoa
import RxFlow
import RxSwift
import UIKit
import MUtils

/**
 # (C) BaseVC.swift
 - Author: Mephrine
 - Date: 19.12.03
 - Parameters:
 - Returns:
 - Note: 모든 뷰컨트롤러가 상속받는 최상위 부모뷰.
*/
class BaseVC: UIViewController, Stepper {
    //MARK: - 변수
    // PopGesture 플래그 변수
    var isViewControllerPopGesture = true
    var isWebPopGesture = true
    
    //제스쳐 관련 플래그 변수
    private var isPopGesture = true
    private var isPopSwipe = false
    
    
    lazy private(set) var classNm: String = {
      return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()
    
    private var scrollViewOriginalContentInsetAdjustmentBehaviorRawValue: Int?
    
    var disposeBag = DisposeBag()
    
    //MARK: - 스테이터스바 관련.
    // 스테이터스 바 숨김 여부
    var statusBarShouldBeHidden = false
    
    var steps = PublishRelay<Step>()
    
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 자동으로 스크롤뷰 인셋 조정하는 코드 막기
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Check Network State
        if(!UtilNetwork.shared.checkConnection(STR_NETWORK_ERROR)) {
//            MToast.makeText(STR_NETWORK_ERROR)
        }
        
        self.initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        // Enable swipe back when no navigation bar
        self.setInteractivePopGesture(isViewControllerPopGesture)
        
        // fix iOS 11 scroll view bug
        if #available(iOS 11, *) {
          if let scrollView = self.view.subviews.first as? UIScrollView {
            self.scrollViewOriginalContentInsetAdjustmentBehaviorRawValue =
              scrollView.contentInsetAdjustmentBehavior.rawValue
            scrollView.contentInsetAdjustmentBehavior = .never
          }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // fix iOS 11 scroll view bug
        if #available(iOS 11, *) {
          if let scrollView = self.view.subviews.first as? UIScrollView,
            let rawValue = self.scrollViewOriginalContentInsetAdjustmentBehaviorRawValue,
            let behavior = UIScrollView.ContentInsetAdjustmentBehavior(rawValue: rawValue) {
            scrollView.contentInsetAdjustmentBehavior = behavior
          }
        }
        
        self.resetView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isPopSwipe {
            if isPopGesture {
                popGesture()
            }
            isPopSwipe = false
        }
    }
    
    // MARK: Override 용도
    /**
     # initView
     - Author: Mephrine
     - Date: 20.02.10
     - Parameters:
     - Returns:
     - Note: viewDidLoad에서 실행할 내용 정의하는 Override용 함수
    */
    func initView() {
        
    }
    
    /**
     # resetView
     - Author: Mephrine
     - Date: 20.02.10
     - Parameters:
     - Returns:
     - Note: viewWillAppear에서 실행할 내용 정의하는 Override용 함수
    */
    func resetView() {
        
    }
    
    /**
     # popGesture
     - Author: Mephrine
     - Date: 20.02.10
     - Parameters:
     - Returns:
     - Note: ViewController에서 PopGesture시에 실행할 내용 정의하는 Override용 함수
    */
    func popGesture() {
        
    }
    
    // MARK: SafeArea
    /**
     # safeAreaTopAnchor
     - Author: Mephrine
     - Date: 20.02.10
     - Parameters:
     - Returns: CGFloat
     - Note: 현재 디바이스의 safeAreaTop pixel값을 리턴하는 함수
    */
    var safeAreaTopAnchor: CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            var topPadding = window?.safeAreaInsets.top
            
            if topPadding == 0 {
                topPadding = self.topLayoutGuide.length
                if topPadding == 0 {
                    topPadding = UIApplication.shared.statusBarFrame.size.height
                }
            }
            
            return topPadding ?? Utils.STATUS_HEIGHT
        } else {
            return Utils.STATUS_HEIGHT
        }
    }
    
    /**
     # safeAreaBottomAnchor
     - Author: Mephrine
     - Date: 20.02.10
     - Parameters:
     - Returns: CGFloat
     - Note: 현재 디바이스의 safeAreaBottom pixel값을 리턴하는 함수
    */
    var safeAreaBottomAnchor: CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom
            return bottomPadding!
        } else {
            return bottomLayoutGuide.length
        }
    }
     
    // MARK: StatusBar 애니메이션
    /**
     # hideStatusAnim
     - Author: Mephrine
     - Date: 20.02.10
     - Parameters:
     - Returns:
     - Note: 상태바를 숨기는 애니메이션을 수행하는 함수
    */
    func hideStatusAnim() {
        self.statusBarShouldBeHidden = true
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    /**
     # showStatusAnim
     - Author: Mephrine
     - Date: 20.02.10
     - Parameters:
     - Returns:
     - Note: 상태바를 보이는 애니메이션을 수행하는 함수
    */
    func showStatusAnim() {
        self.statusBarShouldBeHidden = false
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    /**
     # setInteractivePopGesture
     - Author: Mephrine
     - Date: 20.02.10
     - Parameters:
        - isRegi: PopGesture 적용 여부 Bool
     - Returns:
     - Note: ViewController PopGesture를 적용/해제하는 함수
    */
    func setInteractivePopGesture(_ isRegi:Bool = true) {
        if isRegi {
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self as UIGestureRecognizerDelegate
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            isPopGesture = true
        } else {
            self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            isPopGesture = false
        }
    }
}

//MARK: -  UIGestureRecognizerDelegate. ViewController PopGesture 사용 / 해제를 위한 delegate 함수를 처리
extension BaseVC: UIGestureRecognizerDelegate {
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        switch gestureRecognizer.state {
        case .possible:
            log.d("gestureRecognizer.state : possible")
            isPopSwipe = true
            break
        case .began:
            log.d("gestureRecognizer.state : began")
            isPopSwipe = true
            break
        case .changed:
            log.d("gestureRecognizer.state : changed")
            isPopSwipe = true
            break
        default:
            log.d("gestureRecognizer.state : default")
            isPopSwipe = false
            break
        }
        return true
    }
}

// ViewModel과 같이 사용하는 용도.
//MARK: -  Storyboard & ViewModel로 ViewController 생성하는 용도.
extension View where Self: StoryboardBased & UIViewController {
    static func instantiate<ViewModelType> (withViewModel viewModel: ViewModelType) -> Self where ViewModelType == Self.Reactor {
        let viewController = Self.instantiate()
        viewController.reactor = viewModel
        return viewController
    }
    
    static func instantiate<ViewModelType> (withViewModel viewModel: ViewModelType, storyBoardName: String) -> Self where ViewModelType == Self.Reactor {
        let sb = UIStoryboard.init(name: storyBoardName, bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: String(describing: self)) as? Self {
            viewController.reactor = viewModel
            return viewController
        }
        return Self.instantiate(withViewModel: viewModel)
    }
}
