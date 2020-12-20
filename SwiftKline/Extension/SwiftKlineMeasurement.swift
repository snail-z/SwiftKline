//
//  SwiftKlineMeasurement.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/12/17.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

public protocol UMeasurementProtocol {
    
    /// 单条柱状图宽度
    var shapeWidth: CGFloat { get set }

    /// 柱状图间距
    var shapeSpacing: CGFloat { get set }
        
    /// 主图文本区
    var majorBriefFrame: CGRect { get set }
        
    /// 主图区域
    var majorChartFrame: CGRect { get set }
        
    /// 副图文本区
    var minorBriefFrames: [CGRect] { get set }

    /// 副图区域
    var minorChartFrames: [CGRect] { get set }
        
    /// 日期栏区域
    var dateBarFrame: CGRect { get set }
        
    /// 主图和副图合并区域
    var unionChartFrame: CGRect { get }
    
    /// 获取某个下标对应的横轴中心位置
    func midxaixs(by index: Int) -> CGFloat
    
    /// 获取某个下标对应的横轴起始位置
    func minxaixs(by index: Int) -> CGFloat
}

public extension UMeasurementProtocol {
    
    /// 主图和副图合并区域
    var unionChartFrame: CGRect {
        return .zero
    }
    
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



/// 绘图基础数据
public struct UMeasurement {
    
    /// 单柱状图宽度
    var shapeWidth: CGFloat
     
    /// 柱状图间距
    var shapeSpacing: CGFloat
    
    /// 绘图区域
    var drawnRect: CGRect
}

public extension UMeasurement {
    
    /// 将数值转为对应的坐标位置
    func yaxisFromValue(by peakValue: UPeakValue, value: Double) -> CGFloat {
        let dvalue = peakValue.max - peakValue.min
        let proportion = fabs(peakValue.max - value) / dvalue
        return drawnRect.height * CGFloat(proportion) + drawnRect.minY
    }
    
    /// 将坐标位置转为对应的数值
    func yaxisToValue(by peakValue: UPeakValue, yaxis: CGFloat) -> Double {
        let proportion = (yaxis - drawnRect.minY) / drawnRect.height
        let proportionValue = (peakValue.max - peakValue.min) * Double(proportion)
        return peakValue.max - proportionValue
    }
    
    /// 获取某个下标对应的横轴中心位置
    func midxaixs(by index: Int) -> CGFloat {
        let centerX = (shapeWidth + shapeSpacing) * CGFloat(index) + shapeWidth * 0.5
        return centerX + drawnRect.minX
    }
    
    /// 获取某个下标对应的横轴起始位置
    func minxaixs(by index: Int) -> CGFloat {
        return midxaixs(by: index) - shapeWidth * 0.5
    }
    
    /// 计算某点位置所对应的下标
    func xaxisToIndex(by count: Int, xaxis: CGFloat) -> Int {
        let shapeOne = shapeSpacing + shapeWidth
        var index = Int(xaxis / shapeOne)
        let baseline = CGFloat(index) * shapeOne + shapeOne - shapeSpacing / 2
        if xaxis > baseline { index += 1 }
        index = max(0, index)
        index = min(count - 1, index)
        return index
    }
}
