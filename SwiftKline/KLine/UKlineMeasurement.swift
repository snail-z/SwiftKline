//
//  UKlineMeasurement.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/12/3.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

public struct UKlineMeasurement {
    
    /// 蜡烛图宽度
    public var shapeWidth: CGFloat = 0
    
    /// 蜡烛图间距
    public var shapeSpacing: CGFloat = 0
    
    /// 主图文本区
    public var majorBriefFrame: CGRect = .zero
    
    /// 主图区域
    public var majorChartFrame: CGRect = .zero
    
    /// 副图文本区
    public var minorBriefFrames: [CGRect] = []

    /// 副图区域
    public var minorChartFrames: [CGRect] = []
    
    /// 日期栏区域
    public var datesBarFrame: CGRect = .zero
    
    /// 主图和副图合并区域
    public var unionChartFrame: CGRect {
//        let x = min(majorChartFrame.minX, minorChartFrame.minX)
//        let y = min(majorChartFrame.minY, minorChartFrame.minY)
//        let width = max(majorChartFrame.width, minorChartFrame.width)
//        let height = max(majorChartFrame.maxY - y, minorChartFrame.maxY - y)
//        return CGRect(x: x, y: y, width: width, height: height)
        return .zero
    }
}
