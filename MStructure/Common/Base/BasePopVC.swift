//
//  BasePopupVC.swift
//  MUtils
//
//  Created by Mephrine on 2019/12/03.
//  Copyright © 2019 MUtils. All rights reserved.
//

import UIKit

/**
 # (C) BasePoppUpVC.swift
 - Author: Mephrine
 - Date: 19.12.03
 - Note: 모든 팝업 뷰컨트롤러가 상속받는 부모뷰
*/
class BasePopupVC: BaseVC {
    @IBOutlet weak var vDim: UIView!
    @IBOutlet weak var vContainer: UIView!
    
    private final let DIM_ALPHA: CGFloat = 0.3
    
    override func initView() {
        self.view.layoutIfNeeded()
    }
    
    /**
     # showAnim
     - Author: Mephrine
     - Date: 20.02.17
     - Parameters:
        - vc : 팝업을 노출할 뷰컨트롤러
        - parentAddView : 해당 뷰컨트롤러의 뷰를 적용할 부모 뷰컨트롤러의 뷰
        - completeion : 해당 화면 노출 애니메이션이 완료된 이후에 부모 뷰컨트롤러에서 처리할 클로저
     - Returns:
     - Note: 모든 팝업 뷰컨트롤러가 상속받는 부모뷰
    */
    func showAnim(vc: UIViewController? = UIApplication.shared.keyWindow?.visibleViewController, parentAddView: UIView?, _ completeion: @escaping ()->()) {
        guard let currentVC = vc else {
            completeion()
            return
        }
        
        var pView = parentAddView
       
        if pView == nil {
            pView = vc?.view
        }
        
        guard let parentView = pView else {
            completeion()
            return
        }
        
        currentVC.addChild(self)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        parentView.addSubview(self.view)
        self.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.vDim.alpha = 0.0
        self.vContainer.alpha = 0.0
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            if let _self = self {
                _self.vDim.alpha = _self.DIM_ALPHA
            }
        }) { (complete) in
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.vContainer.alpha = 1.0
            }) { (complete) in
                completeion()
            }
        }
    }
    
    /**
     # hideAnim
     - Author: Mephrine
     - Date: 20.02.17
     - Parameters:
     - Returns:
     - Note: 팝업 화면을 애니메이션을 넣어서 숨기는 함수
    */
    func hideAnim() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            if let _self = self {
                _self.vContainer.alpha = 0.0
            }
        }) { (complete) in
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.vDim.alpha = 0.0
            }) { [weak self] complete in
                if let _self = self {
                    _self.view.removeFromSuperview()
                    _self.removeFromParent()
                }
            }
        }
    }
    
    @IBAction func btnCancelPressed(_ sender: UIButton) {
        self.hideAnim()
    }
       
    @IBAction func btnCompletePressed(_ sender: UIButton) {
        self.hideAnim()
    }
}
