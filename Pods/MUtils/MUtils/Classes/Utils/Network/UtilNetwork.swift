//
//  UtilNetwork.swift
//  MUtils
//
//  Created by Mephrine on 2020/02/07.
//  Copyright © 2018년 김제현. All rights reserved.
//

import Foundation
import Reachability
/**
 # (C) UtilNetwork
 - Author: Mephrine
 - Date: 19.12.03
 - Note: reachability를 이용해 네트워크 연결 관련하여 판단하는 클래스
*/
public class UtilNetwork: NSObject {
    public static let shared = UtilNetwork()
    private var optReachability: Reachability?
    
    override init() {
        do {
            try optReachability = Reachability()
        } catch {
            log.e("Reachable init error")
        }
    }
    
    /**
     # initNetwork
     - Author: Mephrine
     - Date: 19.12.03
     - Parameters:
     - Returns:
     - Note: reachability 실행하는 함수.
    */
    public func initNetwork() {
        guard let reachability = optReachability else { return }
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                log.d("Reachable via WiFi")
            } else {
                log.d("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            log.d("Not reachable")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            log.e("Unable to start notifier")
        }
    }
    
    /**
     # checkConnection
     - Author: Mephrine
     - Date: 19.12.03
     - Parameters:
     - Returns: Bool
     - Note: celluar / wifi가 연결되었는지 판단하는 함수.
    */
    public func checkConnection(_ errorMsg: String) -> Bool {
        guard let reachability = optReachability else { return false }
        var success = false
        
        switch reachability.connection {
        case .cellular:
            success = true
            break
        case .wifi:
            success = true
            break
        case .none:
            break
        case .unavailable:
            break
        }

        if !success {
            MToast.makeText(errorMsg)
        }
        
        return success
    }
}

