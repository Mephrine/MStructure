//
//  UserDefaults+Ext.swift
//  MStructure
//
//  Created by Mephrine on 2020/02/04.
//  Copyright © 2020 MUtils. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    //MARK: - 권한 체크
    static let UD_AUTH_CHECKED             = DefaultsKey<Bool?>("UD_AUTH_CHECKED")
    //MARK: - 간편 인증 타입
    static let UD_QUICK_AUTH_TYPE          = DefaultsKey<String?>("UD_QUICK_AUTH_TYPE")
}
