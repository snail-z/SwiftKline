//
//  UTimeMeasurement.swift
//  swiftKline
//
//  Created by zhanghao on 2020/11/12.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

public struct UTimeMeasurement {
    
    /// 柱状图宽度
    public var shapeWidth: CGFloat!
    
    /// 柱状图间距
    public var shapeSpacing: CGFloat!
    
    /// 主图文本区
    public var majorBriefFrame = CGRect.zero
    
    /// 主图区域
    public var majorChartFrame = CGRect.zero
    
    /// 副图文本区
    public var minorBriefFrame = CGRect.zero

    /// 副图区域
    public var minorChartFrame = CGRect.zero
    
    /// 日期栏区域
    public var datesBarFrame = CGRect.zero
    
    /// 主图和副图合并区域
    public var unionChartFrame: CGRect {
        let x = min(majorChartFrame.minX, minorChartFrame.minX)
        let y = min(majorChartFrame.minY, minorChartFrame.minY)
        let width = max(majorChartFrame.width, minorChartFrame.width)
        let height = max(majorChartFrame.maxY - y, minorChartFrame.maxY - y)
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

public extension UTimeMeasurement {
    
    /// 将某个数值转为绘图区对应的位置
    typealias YaxisClosure = (_ doubleValue: Double) -> CGFloat
    
    /// 纵轴坐标位置转换 - yaxisFromValue
    /// - Parameters:
    ///   - peakValue: 极值
    ///   - rect: 绘图区域
    static func yaxisClosureMake(_ peakValue: UPeakValue, _ rect: CGRect) -> YaxisClosure {
        let dva = peakValue.max - peakValue.min
        guard dva > 0 else { return { _ in rect.minY } }
        
        return { value in
            let proportion = fabs(peakValue.max - value) / dva
            return rect.height * CGFloat(proportion) + rect.minY
        }
    }
    
    /// 将绘图区某个位置转为对应的数值
    static func yaxisToValue(_ peakValue: UPeakValue, _ rect: CGRect, yaxis: CGFloat) -> Double {
        let proportion = (yaxis - rect.minY) / rect.height
        let proportionValue = (peakValue.max - peakValue.min) * Double(proportion)
        return peakValue.max - proportionValue
    }
    
    
    /// 获取某个下标对应的横轴中心位置
    func xaixs(by index: Int) -> CGFloat {
        let centerX = (shapeWidth + shapeSpacing) * CGFloat(index) + shapeWidth * 0.5
        return centerX + majorChartFrame.minX
    }
    
    /// 获取某个下标对应的横轴起始位置
    func minxaixs(by index: Int) -> CGFloat {
        return xaixs(by: index) - shapeWidth * 0.5
    }
    
    
    
    
    /// 将横轴下标转为绘图区对应的位置
    typealias XaxisClosure = (_ index: Int) -> CGFloat
    
    /// 横轴坐标位置转换 - xaxisFromIndex
    /// - Parameters:
    ///   - peakValue: 极值
    ///   - frame: 绘图区域
    static func xaxisClosureMake(_ shapeWidth: CGFloat) {
        
    }
    
    func xaxisToIndex(_ shapeWidth: CGFloat, _ shapeSpacing: CGFloat, dataCount: Int, xaxis: CGFloat) -> Int {
        
        return 9
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func makeXaxisClosure() {
        let pe = UPeakValue.init(max: 190, min: 9)
        let rect = CGRect(x: 0, y: 0, width: 10, height: 1)
        let yaxisFromValue = UTimeMeasurement.yaxisClosureMake(pe, rect)
        let _ = yaxisFromValue(90)
        let _ = UTimeMeasurement.yaxisToValue(pe, rect, yaxis: 10)
    }
}


