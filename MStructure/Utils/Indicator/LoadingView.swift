//
//  LoadingView.swift
//  MStructure
//
//  Created by Mephrine on 2020/01/16.
//  Copyright © 2020 MUtils. All rights reserved.
//

import UIKit
import SnapKit
import MUtils

/**
    # (C) LoadingView
    - Author: Mephrine
    - Date: 19.12.03
    - Note: 로딩 화면 뷰
   */
class LoadingView: UIView {
    
    // 컴포넌트
    static let shared = LoadingView()
    private var isLoading: Bool = false
    
    /**
     # show
     - Author: Mephrine
     - Date: 19.12.03
     - Parameters:
     - Returns:
     - Note: 로딩뷰 보이기
    */
    open func show(){
        if isLoading {
            return
        }
        self.isLoading = true

        let ivLoadingView = UIImageView.init(frame: CGRect.zero)
        ivLoadingView.tag = 999

        ivLoadingView.backgroundColor = .clear
        ivLoadingView.animationImages = LoadingView.shared.animArray()   // 애니메이션 이미지
        ivLoadingView.animationDuration = 1.5
        ivLoadingView.animationRepeatCount = 0    // 0일 경우 무한반복

        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor(hex: 0x000000, alpha: 0.5)
        
        Async.main {
            if let window = UIApplication.shared.keyWindow {
                ivLoadingView.center = window.center
                self.addSubview(ivLoadingView)
                window.addSubview(self)
                
                ivLoadingView.snp.makeConstraints {
                    $0.center.equalTo(window)
                }

                ivLoadingView.startAnimating()
            }
        }
    }

    /**
     # hide
     - Author: Mephrine
     - Date: 19.12.03
     - Parameters:
     - Returns:
     - Note: 로딩뷰 숨기기
    */
    open func hide(){
        if !isLoading {
            return
        }
        self.isLoading = false
        Async.main {
            if let ivLoadingView = self.viewWithTag(999) as? UIImageView {
                ivLoadingView.stopAnimating()
                ivLoadingView.removeFromSuperview()
                
                self.removeFromSuperview()
                
            }
        }
    }
    
    /**
     # animArray
     - Author: Mephrine
     - Date: 19.12.03
     - Parameters:
     - Returns: [UIImage]
     - Note: 로딩뷰로 보여질 UIImage 배열 반환
    */
    func animArray() -> [UIImage] {
        var animArray: [UIImage] = []
        for i in 0 ..< 16 {
            if let img = UIImage(named: "KBIZloading_\(i)") {
                animArray.append(img)
            }
        }
        
        return animArray
    }
}

