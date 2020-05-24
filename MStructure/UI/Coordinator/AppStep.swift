//
//  AppStep.swift
//  MStructure
//
//  Created by Mephrine on 2019/12/03.
//  Copyright © 2019 MStructure. All rights reserved.
//

import ReactorKit
import RxFlow

/**
 # AppStep
 - Author: Mephrine
 - Date: 19.12.03
 - Parameters:
 - Returns:
 - Note: 앱 네비게이션 이동 관련 모음 enum.
*/
enum AppStep: Step {
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: 인트로
    // 인트로화면 진입
    case initApp
    
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: 메인
    // 메인 웹뷰페이지로 이동.
    case goMain
    
    // 하위 뎁스 웹뷰 띄우기.
    case goRequestPushSubWebView(url: String)
    case goPushSubWebView(_ subWebViewVC: SubWebViewVC)
    
//    case goRequestSubRootWebView(_ subWebViewVC: SubWebViewVC)
    
    case backSubWebViewVC
        
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: 메인내 웹뷰 관련 네비게이션 상태.
    
    // SafariViewController 띄우기
    case showSFVC(url: URL)
    
    ////////////////////////////////////////////////////////////////////////////////
    // MARK: 뒤로가기 - Pop 공통(뒤로가기 시, 별도 처리 없는 경우)
    case goBack
    
    case goBackRootView
    
    ////////////////////////////////////////////////////////////////////////////////
}
