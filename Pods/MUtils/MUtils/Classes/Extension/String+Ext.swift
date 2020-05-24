//
//  String+Ext.swift
//  MFramework
//
//  Created by Mephrine on 2019/12/24.
//  Copyright © 2019 MFramework. All rights reserved.
//

import Foundation

extension String {
    /**
     # encodeUrl
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
     - Returns: String
     - Note: url 인코딩 적용
    */
    public func encodeUrl() -> String {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    
    /**
     # decodeUrl
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
     - Returns: String
     - Note: url 디코딩 적용
    */
    public func decodeUrl() -> String {
        return self.removingPercentEncoding!
    }
    
    /**
     # replace
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
        - target: 변경할 대상 String
        - withString: 교체할 String
     - Returns: String
     - Note: target을 withString 값으로 변경
    */
    public func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString)
    }
    
    // MARK: - sub string
    public subscript (range: Range<Int>) -> String {
        get {
            var lower = range.lowerBound
            var upper = range.upperBound
            
            guard self.count > 0 else {
                return ""
            }
            
            if lower < 0 {
                lower = 0
            }
            
            if upper >= self.count {
                upper = self.count
            }
            
            let start = self.index(self.startIndex, offsetBy: lower)
            let end = self.index(self.startIndex, offsetBy: upper)
            let value = Range<String.Index>(uncheckedBounds: (lower: start, upper: end))
            return String(self[value])
        }
    }
    
    public subscript (range: ClosedRange<Int>) -> String {
        get {
            var lower = range.lowerBound
            var upper = range.upperBound
            
            guard self.count > 0 else {
                return ""
            }
            
            if lower < 0 {
                lower = 0
            }
            
            if upper >= self.count {
                upper = self.count - 1
            }
            
            let start = self.index(self.startIndex, offsetBy: lower)
            let end = self.index(self.startIndex, offsetBy: upper)
            let value = ClosedRange<String.Index>(uncheckedBounds: (lower: start, upper: end))
            return String(self[value])
        }
    }
    
    public subscript (range: PartialRangeThrough<Int>) -> String {
        get {
            guard self.count > 0 else {
                return ""
            }
            
            var upper = range.upperBound
            
            if upper >= self.count {
                upper = self.count - 1
            }
            
            let end = self.index(self.startIndex, offsetBy: upper)
            let value = PartialRangeThrough<String.Index>(end)
            return String(self[value])
        }
    }
    
    public subscript (range: PartialRangeUpTo<Int>) -> String {
        get {
            guard self.count > 0 else {
                return ""
            }
            
            var upper = range.upperBound
            
            if upper >= self.count {
                upper = self.count
            }
            
            let end = self.index(self.startIndex, offsetBy: upper)
            let value = PartialRangeUpTo<String.Index>(end)
            return String(self[value])
        }
    }
    
    public subscript (range: PartialRangeFrom<Int>) -> String {
        get {
            guard self.count > 0 else {
                return ""
            }
            var lower = range.lowerBound
            
            if lower < 0 {
                lower = 0
            }
            
            let start = self.index(self.startIndex, offsetBy: lower)
            let value = PartialRangeFrom<String.Index>(start)
            return String(self[value])
        }
    }
    
    public subscript(_ range: PartialRangeUpTo<Int>) -> Substring {
        return prefix(range.upperBound)
    }
    
    public subscript(_ range: PartialRangeThrough<Int>) -> Substring {
        return prefix(range.upperBound+1)
    }
    
    public subscript(_ range: PartialRangeFrom<Int>) -> Substring {
        return suffix(max(0,count-range.lowerBound))
    }
    
    public func toInt32() -> Int32 {
        guard let n = NumberFormatter().number(from: self) else {
            return 0
        }
        return Int32(truncating: n)
    }
    
    /**
     # toDateFormat
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
        - from: 현재 날짜 포맷
        - to: 변경할 날짜 포맷
     - Returns: String
     - Note: 날짜 포맷형식으로 변경
    */
    public func toDateFormat(from: String = "yyyy-MM-dd HH:mm:ss", to: String = "yyyy-MM-dd") -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.timeZone = TimeZone(identifier: "UTC")!
        dateFormatterGet.dateFormat = from

        if let date = dateFormatterGet.date(from: self) {
            return date.formatted(to)
        } else {
            print("There was an error decoding the string")
        }
        return self
    }
    
    /**
     # split
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
        - separator: 구분자
     - Returns: Array<String>
     - Note: 구분자로 split
    */
    public func split(_ separator: String) -> Array<String>{
        let arrayString = self.components(separatedBy: separator)
        let arrayResult = NSMutableArray()
        
        for string in arrayString {
            arrayResult.add(string)
        }
        
        return arrayResult as! Array<String>
    }
   
    /**
     # filterOnlyNumber
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
     - Returns: String
     - Note: 숫자만 필터해서 반환
    */
    public func filterOnlyNumber() -> String {
        return self.filter { $0.isNumber }
    }
}

//StringExtension.swift
protocol StringOptionalProtocol {}
extension String: StringOptionalProtocol {}

extension Optional where Wrapped: StringOptionalProtocol {
    // nil 또는 빈값의 경우 true 리턴
    var isEmpty: Bool {
        if let str = self as? String {
            return str.isEmpty //랩핌을 했기 때문에 빈값으로 처리
        }
        return true // 랩핑을 실패하면 nil로 처리
    }
    
    // nil 또는 빈값의 경우 false리턴
    var isNotEmpty: Bool {
        guard let str = self as? String else {
            return false // 랩핑에 실패하였기 때문에 nil 처리
        }
        return !str.isEmpty // 랩핑에 성공했기 때문에 빈값이 아닌지 체크
    }
}

extension Substring {
    public var string: String { return String(self) }
}


extension StringProtocol where Self: RangeReplaceableCollection {
    public var removingAllWhitespacesAndNewlines: Self {
        return filter { !$0.isNewline && !$0.isWhitespace }
    }
    
    /**
     # removeAllWhitespacesAndNewlines
     - Author: Mephrine
     - Date: 20.02.07
     - Parameters:
     - Returns:
     - Note: whitespace, enter 제거
    */
    public mutating func removeAllWhitespacesAndNewlines() {
        removeAll { $0.isNewline || $0.isWhitespace }
    }
}
