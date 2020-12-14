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
    public private(set) var shapeWidth: CGFloat = 0
    
    /// 蜡烛图描边宽度
    public var strokeWidth: CGFloat = 0
    
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
    
    /// 计算并验证蜡烛图宽度是否可绘制，若不可绘制该方法则会更新蜡烛图的间距和宽度
    public mutating func adjustSpacingToMakeLegalWidth(by count: Int) {
        shapeWidth = loopWidth(numbersOfKlines: count)
    }
    
    public var descriptions: String {
        return "shapeWidth = \(shapeWidth), strokeWidth = \(strokeWidth), shapeSpacing = \(shapeSpacing), majorBriefFrame = \(majorBriefFrame), majorChartFrame = \(majorChartFrame)"
    }
}

private extension UKlineMeasurement {
    
    private mutating func loopWidth(numbersOfKlines: Int) -> CGFloat {
        // 计算出单个K线的宽度
        let totalSpacing = CGFloat(numbersOfKlines - 1) * shapeSpacing
        let totalWidth = majorChartFrame.width - totalSpacing
        let oneWidth = totalWidth / CGFloat(numbersOfKlines)
        
        // 蜡烛图最小宽度
        let minWidth = strokeWidth * 2
        
        // 判断宽度是否能有效绘制
        guard oneWidth < minWidth else {
            return oneWidth
        }
        
        // 若实际小于最小宽度，则间距调整为原来的75%，再重新计算宽度
        shapeSpacing *= 0.75
        
        return loopWidth(numbersOfKlines: numbersOfKlines)
    }
}

public extension UKlineMeasurement {
    
    /// 获取某个下标对应的横轴中心位置
    func midxaixs(by index: Int) -> CGFloat {
        let centerX = (shapeWidth + shapeSpacing) * CGFloat(index) + shapeWidth * 0.5
        return centerX + majorChartFrame.minX
    }
    
    /// 获取某个下标对应的横轴起始位置
    func minxaixs(by index: Int) -> CGFloat {
        return midxaixs(by: index) - shapeWidth * 0.5
    }
}
