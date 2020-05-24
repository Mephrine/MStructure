//
//  CGRect+Ext.swift
//  JHAlarm
//
//  Created by 김제현 on 09/09/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import CoreGraphics

extension CGRect {
    public var x: CGFloat { return self.origin.x }
    public var y: CGFloat { return self.origin.y }
    public var centerX: CGFloat { return self.midX }
    public var centerY: CGFloat { return self.midY }
    public var center: CGPoint { return CGPoint(x: self.midX, y: self.midY) }
}
