//
//  Config.swift
//  MStructure
//
//  Created by Mephrine on 2020/01/14.
//  Copyright © 2020 KBIZ. All rights reserved.
//

/**
 # Config.swift
 - Author: Mephrine
 - Date: 19.12.03
 - Note: 개발/운영 서버 URL 및 솔루션 키값 등 환경 설정 관련 모음.
*/

public let IS_DEBUG                                 = false

//MARK: SCHEME
public let WEB_DEEP_LINK_SCHEME                     = "SchemeValue"

// 앱 심사용으로 iOS만 해당 값을 줌. iOS_Review
public let WEB_USER_AGENT                           = "iOS MStructre"

//MARK: WEBVIEW URL
public let WEB_DOMAIN                               = API_DOMAIN
public let WEB_INDEX                                = "\(WEB_DOMAIN)/index.do"

//MARK: FORCE UPDATE
public let APPSTORE_LINK                            = "itms-apps://itunes.apple.com/app/id~~~~"

//MARK: API - Path는 CallAPI에 정의되어 있음.
public let API_DOMAIN                               = IS_DEBUG ? "https://test.co.kr" : "https://dtest.co.kr"

//MARK: ANIMATION
public let ANIMATION_PUSH_TRANSITION = true
public let ANIMATION_ROOT_TRANSITION = false
public let ANIMATION_PRESENT_TRANSITION = true
