//
//  NetworkResponse.swift
//  MStructure
//
//  Created by Mephrine on 2020/02/18.
//  Copyright © 2020 MUtils. All rights reserved.
//

import RxSwift
import SwiftyJSON
import MUtils

/**
 # (C) NetworkResponse.swift
 - Author: Mephrine
 - Date: 20.02.18
 - Note: API Response 중에서 공통으로 받는 필드를 모아둔 클래스.
*/
class NetworkResponse: ModelType {
    enum Event {
    }
    
    var resultCode: String?
    var resultMessage: String?
    
    required init(jsonData: JSON) {
        resultCode = jsonData["resultCode"].string
        resultMessage = jsonData["resultMessage"].string
        
        //e.g.) self.albumTracks = jsonData["albumTracks"].to(type: ItemIdModel.self) as? [ItemIdModel] ?? []
    }
}


