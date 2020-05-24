//
//  UIView+Ext.swift
//  MFramework
//
//  Created by Mephrine on 2019/12/24.
//  Copyright © 2019 MFramework. All rights reserved.
//

import UIKit

extension UIView
{
    /**
        # fadeTransition
        - Author: Mephrine
        - Date: 20.02.07
        - Parameters:
            - duration: 애니메이션 적용 시간
        - Returns:
        - Note: fade 애니메이션 효과 적용
       */
    public func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
    
    /**
     # removeAllSubviews
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
     - Returns:
     - Note: 모든 서브뷰 제거
    */
    public func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
    /**
     # removeAllConstraints
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
     - Returns:
     - Note: 뷰의 모든 Constraints 제거
    */
    public func removeAllConstraints() {
        self.removeConstraints(self.constraints)
        for view in self.subviews {
            view.removeAllConstraints()
        }
    }
    
    /**
     # parentViewController
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
     - Returns:
     - Note: 현재 뷰를 소유한 ViewController 반환
    */
    public func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while true {
            guard let nextResponder = parentResponder?.next else { return nil }
            if let vc = nextResponder as? UIViewController {
                return vc
            }
            parentResponder = nextResponder
        }
    }
    
    /**
        # addDashedBorder
        - Author: Mephrine
        - Date: 20.02.07
        - Parameters:
            - s: dash 길이
            - e: dash 갭
            - lineWidth: 라인 너비
        - Returns:
        - Note: 해당 뷰에 DashPattern Line의 Border 적용
       */
    public func addDashedBorder(s: NSNumber, e: NSNumber, lineWidth: CGFloat) {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [s,e]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 0).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    /**
     # addBorderUtility
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
        - x: 적용 시작할 x축
        - y: 적용 시작할 y축
        - width: x축에서 적용할 너비
        - height: y축에서 적용할 높이
        - color: 적용 색상 값
     - Returns:
     - Note: 해당 뷰에 border 적용
    */
    public  func addBorderUtility(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(border)
    }
    
    /**
     # addBorderTop
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
        - size: 적용할 높이값
        - color: 적용 색상 값
     - Returns:
     - Note: 해당 뷰의 Top부분 border 적용
    */
    public func addBorderTop(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: frame.width, height: size, color: color)
    }
    
    /**
     # addBorderBottom
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
         - size: 적용할 높이값
         - color: 적용 색상 값
     - Returns:
     - Note: 해당 뷰의 Bottom부분 border 적용
    */
    public func addBorderBottom(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: frame.height - size, width: frame.width, height: size, color: color)
    }
    
    /**
     # addBorderBottom
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
         - size: 적용할 높이값
         - color: 적용 색상 값
     - Returns:
     - Note: 해당 뷰의 Left부분 border 적용
    */
    public func addBorderLeft(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: size, height: frame.height, color: color)
    }
    
    /**
     # addBorderBottom
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
         - size: 적용할 높이값
         - color: 적용 색상 값
     - Returns:
     - Note: 해당 뷰의 Right부분 border 적용
    */
    public func addBorderRight(size: CGFloat, color: UIColor) {
        addBorderUtility(x: frame.width - size, y: 0, width: size, height: frame.height, color: color)
    }
}


@IBDesignable
public extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue!.cgColor
        }
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }
    
    @IBInspectable
    var masksToBounds: Bool {
        set {
            layer.masksToBounds = newValue
        }
        get {
            return layer.masksToBounds
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        set {
            layer.shadowOffset = newValue
        }
        get {
            return layer.shadowOffset
        }
    }
}

extension UIView {
    public var centerX: CGFloat { return self.center.x }
    public var centerY: CGFloat { return self.center.y }
}

extension UIView {
    /**
     # viewWithIdentifier
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
         - identifier: 뷰의 identifier
     - Returns: UIView?
     - Note: 현재 뷰 안에서 identifier값으로 뷰를 찾아서 반환
    */
    public func viewWithIdentifier(_ identifier: String) -> UIView? {
        if identifier == accessibilityIdentifier { return self }
        for v in subviews {
            let sub = v.viewWithIdentifier(identifier)
            if sub != nil { return sub }
        }
        return nil
    }
    
    /**
     # constraintWithIdentifier
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
         - identifier: 뷰의 identifier
     - Returns: NSLayoutConstraint?
     - Note: 현재 뷰의 적용된 constraint를 identifier값으로 찾아서 반환
    */
    public func constraintWithIdentifier(_ identifier: String) -> NSLayoutConstraint? {
        var searchView: UIView? = self
        while searchView != nil {
            for constraint in searchView!.constraints as [NSLayoutConstraint] {
                if constraint.identifier == identifier {
                    return constraint
                }
            }
            searchView = searchView!.superview
        }
        return nil
    }
        
    /**
     # imageView
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
         - tag: 뷰의 tag
     - Returns: UIImageView?
     - Note: 뷰의 tag값으로 UIImageView를 반환
    */
    public func imageView(_ tag: Int) -> UIImageView? {
        return viewWithTag(tag) as? UIImageView
    }
    
    /**
     # label
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
         - tag: 뷰의 tag
     - Returns: UILabel?
     - Note: 뷰의 tag값으로 UILabel을 반환
    */
    public func label(_ tag: Int) -> UILabel? {
        return viewWithTag(tag) as? UILabel
    }
    
    /**
     # button
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
         - tag: 뷰의 tag
     - Returns: UIButton?
     - Note: 뷰의 tag값으로 UIButton을 반환
    */
    public func button(_ tag: Int) -> UIButton? {
        return viewWithTag(tag) as? UIButton
    }
    
    /**
     # textfield
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
         - tag: 뷰의 tag
     - Returns: UITextField?
     - Note: 뷰의 tag값으로 UITextField를 반환
    */
    public func textfield(_ tag: Int) -> UITextField? {
        return viewWithTag(tag) as? UITextField
    }
    
    public var isShown: Bool {
        get {
            return !isHidden
        }
        set {
            isHidden = !newValue
        }
    }
}

