//
//  CGGeometry+Extensions.swift
//  swiftKline
//
//  Created by zhanghao on 2020/10/23.
//  Copyright © 2020 zhanghao. All rights reserved.
//

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

/// 图表绘制标准
//UGraphsStandard
public struct UChartStandard {
    public var shapeWidth: CGFloat
    public var shapeSpacing: CGFloat
    public var chartRect: CGRect
}
