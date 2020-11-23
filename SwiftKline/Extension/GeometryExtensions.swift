//
//  GeometryExtensions.swift
//  swiftKline
//
//  Created by zhanghao on 2020/11/11.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

/// 极大极小值
public struct UPeakValue {
    public var max: Double
    public var min: Double
}

/// K线图形状
public struct UCandleShape {
    public var top: CGPoint
    public var rect: CGRect
    public var bottom: CGPoint
}

/// 将某个数值转为绘图区对应的位置
public typealias yaxisFrom = (_ doubleValue: Double) -> CGFloat

/// 纵轴坐标位置转换
/// - Parameters:
///   - peakValue: 极值
///   - rect: 绘图区域
public func yaxisMake(_ peakValue: UPeakValue, _ rect: CGRect) -> yaxisFrom {
    let dva = peakValue.max - peakValue.min
    guard dva > 0 else { return { _ in rect.minY } }
    
    return { value in
        let proportion = fabs(peakValue.max - value) / dva
        return rect.height * CGFloat(proportion) + rect.minY
    }
}

/// 将绘图区某个位置转为对应的数值
public func yaxisToValue(_ peakValue: UPeakValue, _ rect: CGRect, yaxis: CGFloat) -> Double {
    let proportion = (yaxis - rect.minY) / rect.height
    let proportionValue = (peakValue.max - peakValue.min) * Double(proportion)
    return peakValue.max - proportionValue
}
