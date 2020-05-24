//
//  UITextField+Ext.swift
//  MUtils
//
//  Created by Mephrine on 2020/02/26.
//  Copyright © 2020 MUtils. All rights reserved.
//

import UIKit

extension UITextField {
    /**
     # inputPadding
     - Author: shan
     - Date: 20.04.09
     - Parameters:
        - spacing : 패딩값
     - Returns:
     - Note: textfield에 (좌 우) 동일한 패딩값 삽입.
     #필요시 좌, 우 분리해서 사용.
     */
    public func inputPadding(spacing: CGFloat) {
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: spacing, height: self.frame.height))
        leftView.backgroundColor = self.backgroundColor
        self.leftView = leftView
        self.leftViewMode = .always
        
        let rightView = UIView(frame: CGRect(x: self.frame.width - (spacing + 18), y: 0.0, width: (spacing + 18), height: self.frame.height))
        rightView.backgroundColor = self.backgroundColor
        self.rightView = rightView
        self.rightViewMode = .always
    }
}
