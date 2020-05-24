//
//  AppVersion.swift
//  MUtils
//
//  Created by Mephrine on 2020/02/11.
//  Copyright © 2020 MUtils. All rights reserved.
//

import Foundation
import SwiftyJSON
import MUtils

/**
 # (C) AppVersion
 - Author: Mephrine
 - Date: 19.12.03
 - Note: 앱 버전 정보 API Response 모델 클래스
*/
class AppVersion: NetworkResponse {
    var appVersion: AppVersionInfo?
    
    required init(jsonData: JSON) {
        super.init(jsonData: jsonData)
        appVersion = jsonData["appVersion"].to(type: AppVersionInfo.self) as! AppVersionInfo
        //e.g.) self.albumTracks = jsonData["albumTracks"].to(type: ItemIdModel.self) as? [ItemIdModel] ?? []
    }
    
    /**
     # (C) AppVersion
     - Author: Mephrine
     - Date: 19.12.03
     - Note: 앱 버전 정보 API Response JSON 오브젝트 클래스
    */
    internal class AppVersionInfo: ALSwiftyJSONAble {
        enum Event {
            
        }
        
        var iosFnl: String?             // 최신버전
        var iosEnfrUpdt: String?        // 강제업데이트 버전
        var iosRsn: String?                // 사유
        
        required init(jsonData: JSON) {
            iosFnl = jsonData["iosFnl"].string
            iosEnfrUpdt = jsonData["iosEnfrUpdt"].string
            iosRsn = jsonData["iosRsn"].string
        }
        
    }
}

