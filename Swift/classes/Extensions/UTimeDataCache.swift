
//
//  UTimeDataCache.swift
//  swiftKline
//
//  Created by zhanghao on 2020/10/23.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import UIKit

public struct UMeasurement {
    
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
}

public extension UMeasurement {
    
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
//        let pe = UPeakValue.init(max: 190, min: 9)
//        let rect = CGRect(x: 0, y: 0, width: 10, height: 1)
//        let yaxisFromValue = UMeasurement.yaxisClosureMake(pe, rect)
//        let d = yaxisFromValue(90)
//        let value = UMeasurement.yaxisToValue(pe, rect, yaxis: 10)
    }
}

struct UKineMeasurements {
    
    /// 柱状图宽度
    public var shapeWidth: CGFloat!
    
    /// 柱状图间距
    public var shapeSpacing: CGFloat!
    
    /// 主图文本区
    private(set) var majorBriefFrame = CGRect.zero
    
    /// 主图区域
    private(set) var majorChartFrame = CGRect.zero
    
    /// 副图1文本区
    private(set) var minor1BriefFrame = CGRect.zero

    /// 副图1区域
    private(set) var minor1ChartFrame = CGRect.zero
    
    /// 日期栏区域
    private(set) var datesBarFrame = CGRect.zero
}
