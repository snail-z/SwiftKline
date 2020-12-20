//
//  UTimeMeasurement.swift
//  swiftKline
//
//  Created by zhanghao on 2020/11/12.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Foundation

public struct UTimeMeasurement: UMeasurementProtocol {
    
    /// 柱状图宽度
    public var shapeWidth: CGFloat = 0
    
    /// 柱状图间距
    public var shapeSpacing: CGFloat = 0
    
    /// 主图文本区
    public var majorBriefFrame: CGRect = .zero
    
    /// 主图图表区
    public var majorChartFrame: CGRect = .zero
    
    /// 副图文本区
    public var minorBriefFrames: [CGRect] = [.zero]
    
    /// 副图图表区
    public var minorChartFrames: [CGRect] = [.zero]
    
    /// 日期栏区域
    public var dateBarFrame: CGRect = .zero
}

public extension UTimeMeasurement {
    
    /// 副图文本区
    var minorBriefFrame: CGRect {
        return minorBriefFrames.first!
    }
    
    /// 副图图表区
    var minorChartFrame: CGRect {
        return minorChartFrames.first!
    }
}
