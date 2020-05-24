//
//  Date+Ext.swift
//  MUtils
//
//  Created by Mephrine on 2020/02/21.
//  Copyright © 2020 MUtils. All rights reserved.
//

import Foundation
extension Date {
    /**
     # formatted
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
        - format: 변형할 DateFormat
     - Returns: String
     - Note: DateFormat으로 변형한 String 반환
    */
    public func formatted(_ format: String) -> String {
        let df = DateFormatter()
        df.dateFormat = format
        df.timeZone = TimeZone(identifier: "UTC")!
        
        return df.string(from: self)
    }
    
    /**
     # currentTimeInMilli
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
     - Returns: Int
     - Note: 현재 날짜의 밀리초
    */
    public static func currentTimeInMilli() -> Int {
        return Date().timeInMilli()
    }
    
    /**
     # timeInMilli
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
     - Returns: Int
     - Note: timeIntervalSince1970의 밀리초 반환
    */
    public func timeInMilli() -> Int {
        return Int(self.timeIntervalSince1970 / 1000.0)
    }
    
    /**
     # dateCompare
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
        - fromDate: 비교 대상 Date
     - Returns: String
     - Note: 두 날짜간 비교해서 과거/현재/미래 체크
    */
    public func dateCompare(fromDate:Date) -> String {
        var strDateMessage:String = ""
        let result:ComparisonResult = self.compare(fromDate)
        switch result {
        case .orderedAscending:
            strDateMessage = "Future"
            break
        case .orderedDescending:
            strDateMessage = "Past"
            break
        case .orderedSame:
            strDateMessage = "Same"
            break
        default:
            strDateMessage = "Error"
            break
        }
        return strDateMessage
    }
      
    /**
        # dateCompare
        - Author: Mephrine
        - Date: 20.02.07
        - Parameters:
           - startDate: 시작일
           - endDate: 종료일
        - Returns: Int
        - Note: 3개의 날짜 비교. 내가 원하는 시간이 해당 기간에 포함되는지 확인. 1 -> 기간 포함 / 2 -> 날짜 지남. / 3-> 날짜가 시작되지 않음.
       */
    public func dateCompare(startDate: Date, endDate: Date) -> Int {
        let compare = dateCompare(fromDate: startDate)
        let compare2 = dateCompare(fromDate: endDate)
        
        if compare == "Past" {
            if compare2 == "Future" {
                // 두 날짜 사이에 포함.
                return 1
            }
            else{
                // endDate을 벗어남.
                return 2
            }
        }
            
        else if compare == "Same" {
            //  현재
            return 1
        } else {
            // startDate 이전.
            return 3
        }
    }
    
    /**
     # dateCompare
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
        - sessionTime: 만료 시간
     - Returns: Bool
     - Note: 현재 로컬 시간 - self 시간이 만료 시간을 지났는지 확인
    */
    public func overIntervalCurrentTime(_ sessionTime: Double) -> Bool {
        let currentDate = Date()  //현재 로컬 시간

        // currentDate - localDate
        // self -> 이전 시간의 시점.
        let diffTime = round(currentDate.timeIntervalSince(self))
        
        if diffTime > sessionTime {
            return false
        }
        
        return true
    }
}
