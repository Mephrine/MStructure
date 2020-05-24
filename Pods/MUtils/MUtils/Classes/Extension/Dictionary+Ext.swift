//
//  Array+Equtable.swift
//  d.code
//
//  Created by iamchiwon on 2017. 12. 26..
//  Copyright © 2017년 n.code. All rights reserved.
//

import Foundation

extension Dictionary {
    /**
     # decode<T>
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
     - Returns: T?
     - Note: Decodable 타입을 원하는 타입으로 변경
    */
    public func decode<T>() -> T? where T: Decodable {
        do {
            return try JSONDecoder().decode(T.self, from: self.json().data(using: .utf8)!)
        } catch let e {
            print(e.localizedDescription)
            return nil
        }
    }
    
    /**
     # json
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
     - Returns: String
     - Note: json String 형으로 변환하여 반환
    */
    public func json() -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            if let json = String(data: data, encoding: .utf8) {
                return json
            }
            return "{}"
        } catch let e {
            print(e.localizedDescription)
            return "{}"
        }
    }
    
    /**
     # toQueryString
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
        - isEncode: 인코딩 여부
     - Returns: String
     - Note: Query 형식의 String으로 반환
    */
    public func toQueryString(isEncode:Bool = true) -> String {
        var paramData = ""
        for key in self.keys {
            if let value = self[key] as? String {
                
                if isEncode {
                    // 퍼센트 인코딩
                    var percentEncoding = CharacterSet.alphanumerics // 영문자 제외 인코딩
                    percentEncoding.insert(charactersIn: "+-_.!") // 비예약 문자 제외
                    
                    if let enValue = value.addingPercentEncoding(withAllowedCharacters: percentEncoding){
                        paramData.append("\(key)=\(enValue)"+"&")
                    }
                }else{
                    paramData.append("\(key)=\(value)"+"&")
                }
            }
        }
        
        if paramData.hasSuffix("&") {
            let startIndex = paramData.startIndex
            let endIndex = paramData.index(paramData.endIndex, offsetBy: -1)
            paramData = String(paramData[startIndex..<endIndex])
        }
        
        return paramData
    }
}
