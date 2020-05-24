//
//  Color+DarkMode.swift
//  CWUtils
//
//  Created by iamchiwon on 2019/12/10.
//

import UIKit


/**
 # isDarkMode
 - Author: Mephrine
 - Date: 19.12.03
 - Parameters:
 - Returns: Bool
 - Note: 다크모드가 적용되어있는지 확인하는 함수.
*/
public func isDarkMode() -> Bool {
    if #available(iOS 13.0, *) {
        return UIScreen.main.traitCollection.userInterfaceStyle == .dark
    } else {
        return false
    }
}

extension UIColor {
    /**
     # darkableColor
     - Author: Mephrine
     - Date: 19.12.03
     - Parameters:
        - color: 일반 모드 적용할 컬러
        - darkmode: 다크 모드 적용할 컬러
     - Returns: UIColor
     - Note: 다크모드 여부에 따라 적용할 컬러를 리턴하는 함수.
    */
    public static func darkableColor(_ color: UIColor, darkmode: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                traits.userInterfaceStyle == .dark ? darkmode : color
            }
        } else {
            return color
        }
    }
}

extension UIImage {
    /**
     # darkableImage
     - Author: Mephrine
     - Date: 19.12.03
     - Parameters:
        - color: 일반 모드 적용할 이미지
        - darkmode: 다크 모드 적용할 이미지
     - Returns: UIImage
     - Note: 다크모드 여부에 따라 적용할 이미지를 리턴하는 함수.
    */
    public static func darkableImage(_ image: UIImage, darkmode: UIImage) -> UIImage {
        if #available(iOS 13.0, *) {
            image.imageAsset?.register(darkmode, with: UITraitCollection(userInterfaceStyle: .dark))
            return image
        } else {
            return image
        }
    }
}

extension UITraitCollection {
    /**
     # darkableImage
     - Author: Mephrine
     - Date: 19.12.03
     - Parameters:
        - makeImage: receiver에 의해 시스템 darkmode가 변경이 된 경우 처리할 클로저
     - Returns: UIImage
     - Note: 시스템 다크모드가 변경된 경우 처리할 클로저를 명시한 함수.
    */
    func darkenized<T>(_ makeImage: @autoclosure () -> T) -> T {
        var image = makeImage()
        if #available(iOS 13.0, *) {
            performAsCurrent {
                image = makeImage()
            }
        }
        return image
    }
}
