//
//  GeometryExtensions.swift
//  swiftKline
//
//  Created by zhanghao on 2020/11/11.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Foundation

/// 极大极小值
public struct UPeakValue {
    
    public var max: Double
    
    public var min: Double
}

/// 索引及对应的值
public struct UIndexValue {
    
    public var index: Int
    
    public var value: Double
}

/// 极大极小值及对应的索引 (带索引的极值)
public struct UPeakIndexValue {
    
    public var max: UIndexValue
    
    public var min: UIndexValue
}

/// K线图形状
public struct UCandleShape {
    
    public var top: CGPoint
    
    public var rect: CGRect
    
    public var bottom: CGPoint
}
