//
//  UKlinePreferences.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/12/1.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

public struct UKlinePreferences {

    /// K线周期
    public enum KlinePeriod {
        
        /// 日K，周K，月K，季K，年K
        case day, week, month, quarter, year
        
        /// 1分钟K，5分钟K，15分钟K，...
        case min1, min5, min15, min30, min60, min120
    }
    
    /// K线周期，默认日K
    public var period: KlinePeriod = .day
    
    /// K线数量，可视范围内K线显示数量 (缩放时数量会动态改变，可以记录该值保存缩放状态)
    public var numberOfKlines: Int = 70
    
    /// K线数量，可视范围内显示的最多数量
    public var maxNumberOfKlines: Int = 120
    
    /// K线数量，可视范围内显示的最少数量
    public var minNumberOfKlines: Int = 20
    
    /// 绘制区边缘留白
    public var contentEdgeInsets: NSEdgeInsets = .zero
    
    /// K线图延伸线宽度
    public var shapeStrokeWidth: CGFloat = 1

    /// K线图初始间距 (随着K线数量改变该间距也会自动调整)
    public var shapeSpacing: CGFloat = 2
    
    /// 当缩放超出显示数量时，是否将K线图绘制成折线走势
    public var isPinchBrokenEnabled: Bool = true
    
    /// K线图进入折线状态后，是否清除其它指标
    public var isPinchBrokenLineCleared: Bool = true
    
    /// K线图进入折线状态后，可以继续缩放的数量
    public var numberOfPinchBroken: Int = 50
    
    /// K线图缩放成折线后的宽度
    public var pinchBrokenLineWidth: CGFloat = 0
    
    /// K线图缩放成折线后的颜色
    public var pinchBrokenLineColor: NSColor? = .orange
    
    /// 涨K是否实心绘制，默认false
    public var shouldRiseSolid: Bool = false
    
    /// 跌K是否实心绘制，默认true
    public var shouldFallSolid: Bool = true
    
    /// 平K是否实心绘制，默认true
    public var shouldFlatSolid: Bool = true
    
    /// 涨K颜色
    public var riseColor: NSColor? = .red
    
    /// 跌K颜色
    public var fallColor: NSColor? = .green
    
    /// 平K颜色
    public var flatColor: NSColor? = .gray

    /// 设置图表中的数值精度，默认保留两位小数
    public var decimalKeepPlace: Int = 2
    
    /// 峰值点边缘留白
    public var peakTaggedEdgePadding: CGFloat = 10
    
    var majorChartRatio: CGFloat = 0.6
    
    
    /// 日期栏显示位置
    public enum DatePosition {
        case top, middle, bottom
    }
    /// 日期栏位置
    public var dateBarPosition: DatePosition = .bottom
    
    /// 主图高度 (高度和占比设置其一即可)
    public var majorChartHeight: CGFloat = 0
    
    /// 主图区数据文本高度
    public var majorBriefHeight: CGFloat = 20
    
    /// 副图区数据文本高度
    public var minorBriefHeight: CGFloat = 20
    
    /// 日期栏分隔区域高度
    public var dateBarHeight: CGFloat = 20
    
}
