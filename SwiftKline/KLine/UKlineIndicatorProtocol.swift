//
//  UKlineIndicatorProtocol.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/12/17.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

protocol UKlineIndicatorProtocol {
    
    /// 当前范围内绘制图表
    func drawChart(in range: NSRange)
    
    /// 返回当前范围内的极值，用于自定义主图区域的最大最小值
    func calculatePeakValue(by peakValue: UPeakValue, for range: NSRange)
 
    
    
}

protocol UIndicatorMajorProtocol {
    
    /// 当前范围内绘制图表
    func majorDrawChart(in range: NSRange)
    
    /// 返回当前范围内的极值 (根据蜡烛图极值对比当前指标极值，返回最终的最大最小值)
    func majorCalculatePeakValue(in range: NSRange, by peakValue: UPeakValue) -> UPeakValue
}


protocol UIndicatorMinorProtocol {
    
    /// 返回当前范围内的极值
    func minorCalculatePeakValue(in range: NSRange) -> UPeakValue
    
    /// 绘制横轴线和坐标值
    func minorDrawXaxis(by peakValue: UPeakValue)
    
    /// 当前范围内绘制图表
    func minorDrawChart(in range: NSRange)
}


