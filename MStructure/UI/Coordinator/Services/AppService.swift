//
//  AppService.swift
//  MStructure
//
//  Created by Mephrine on 2019/12/04.
//  Copyright © 2019 MStructure. All rights reserved.
//

import Foundation

/**
 # (S) AppServices
 - Author: Mephrine
 - Date: 19.12.03
 - Note: 앱에서 사용될 서비스를 관리하는 구조체
*/
struct AppServices: HasUpdateService, HasTestService {
    let updateService: UpdateService
    let testService: TestService
}
