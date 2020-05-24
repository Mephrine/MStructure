//
//  Config.swift
//  MUtils
//
//  Created by Mephrine on 2020/01/14.
//  Copyright © 2020 KBIZ. All rights reserved.
//


import Foundation
import SwiftyJSON
import RxSwift

public protocol ALSwiftyJSONAble {
    init?(jsonData:JSON)
}

public protocol ModelType: ALSwiftyJSONAble {
    associatedtype Event
}

private var streams: [String: Any] = [:]

extension ModelType {
  public static var event: PublishSubject<Event> {
    let key = String(describing: self)
    if let stream = streams[key] as? PublishSubject<Event> {
      return stream
    }
    let stream = PublishSubject<Event>()
    streams[key] = stream
    return stream
  }
}


