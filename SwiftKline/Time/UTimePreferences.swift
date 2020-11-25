//
//  UTimePreferences.swift
//  swiftKline
//
//  Created by zhanghao on 2020/10/23.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

open class UTimePreferences {

    /// 分时图走势类别
    public enum TrendCategory: Int {
        /// 单日分时走势
        case oneday = 1
        /// 五日分时走势
        case fiveDays = 5
    }

    /// 走势类别
    public var trendCategory: TrendCategory = .oneday
    
    /// 最大数据量(默认242条)
    public var maximumEntries: Int = 242

    /// 设置图表中的数值精度，默认保留两位小数
    public var decimalKeepPlace: Int = 2
    
    /// 默认幅度，当没有数据、昨收为0或者极值相等时，涨跌幅为+-defaultChange
    public var defaultChange: Double = 0.06
    
    /// 绘制区边缘留白
    public var contentInsets = NSEdgeInsets(top: 20, left: 50, bottom: 20, right: 100)
    
    /// 网格线颜色
    public var gridLineColor: NSColor? = .red
    
    /// 网格线宽度
    public var gridLineWidth: CGFloat = 2
    
    /// 主图网格横向分割线数 (majorNumberOfLines >= 2)
    public var majorNumberOfLines: Int = 3
    
    /// 副图网格横向分割线数 (minorNumberOfLines >= 2)
    public var minorNumberOfLines: Int = 2
    
    /// 价格参考线宽度
    public var dashLineWidth: CGFloat = 1 / NSScreen.scale
    
    /// 参考线颜色
    public var dashLineColor: NSColor? = .blue
    
    /// 参考线长度和间隔 (默认[6, 5]，即长度为6，间隔为5)
    public var dashLinePattern: [NSNumber]? = [6, 5]
    
    /// 成交量柱状图间距 (设置shapeSpacing则推算shapeWidth)
    public var shapeSpacing: CGFloat = 0
    
    /// 成交量量柱状图宽度 (shapeSpacing与shapeWidth设置其一)
    public var shapeWidth: CGFloat = 0
    
    /// 成交量柱状图颜色-涨
    public var riseColor: NSColor? = .red
    
    /// 成交量柱状图颜色-跌
    public var fallColor: NSColor? = .green
    
    /// 成交量柱状图颜色-平
    public var flatColor: NSColor? = .darkGray
    
    /// 成交量柱状图描边线宽
    public var strokeLineWidth: CGFloat = 0
    
    /// 图表部分文本颜色
    public var plainTextColor: NSColor? = .black
    
    /// 图表部分文本字体
    public var plainTextFont: NSFont? = NSFont.systemFont(ofSize: 12)
    
    /// 分时线线宽
    public var timeLineWidth: CGFloat = 1 / NSScreen.scale
    
    /// 分时线颜色
    public var timeLineColor: NSColor? = .purple
    
    /// 分时线填充渐变色
    public var timeLineFillGradientClolors: [NSColor?]? = [.blue, .orange]
    
    /// 分时均线宽 (设置为0则隐藏)
    public var averageLineWidth: CGFloat = 1 / NSScreen.scale
    
    /// 分时均线颜色
    public var averageLineColor: NSColor? = .red
    
    /// 持仓线线宽 (设置为0则隐藏)
    public var positionLineWidth: CGFloat = 1 / NSScreen.scale
    
    /// 持仓线颜色
    public var positionLineColor: NSColor? = .brown
    
    /// 日期栏显示位置
    public enum DatePosition {
        case top, middle, bottom
    }
    /// 日期栏位置
    public var dateBarPosition: DatePosition = .bottom
    
    /// 日期栏分隔区域高度
    public var dateBarHeight: CGFloat = 20
    
    /// 格式化日期
    public var dateFormatter: String = "HH:mm"
    
    /// 十字线格式化日期
    public var crossDateFormatter: String = "HH:mm"
    
    /// 长按是否显示十字线
    public var showCrossLineOnLongPress: Bool = true
    
    /// 十字线是否约束在当前价格点位置
    public var isCrossLineConstrained: Bool = true
    
    /// 十字线在多少秒后隐藏
    public var crossLineHiddenDuration: TimeInterval = 2.0
    
    /// 十字线颜色
    public var crossLineColor: NSColor? = .red
    
    /// 十字线宽度
    public var crossLineWidth: CGFloat = 1 / NSScreen.scale
    
    /// 十字线文本颜色
    public var crossLineTextColor: NSColor? = .red
    
    /// 十字线文本背景色
    public var crossLineBackgroundColor: NSColor? = .blue
    
    /// 十字交叉点半径 (默认为0，不显示)
    public var crossLineDotRadius: CGFloat = 0
    
    /// 十字交叉点颜色
    public var crossLineDotColor: NSColor? = .red
    
    /// 是否显示呼吸灯
    public var showBreathinglight: Bool = true
    
    /// 休市点分钟集 (可用于设置休市前的点不闪动呼吸灯)
    public var closedpointsMinutes: [Int] = []
    
    /// 主图高度占比
    public var majorChartRatio: CGFloat = 0.6
    
    /// 主图高度 (高度和占比设置其一即可)
    public var majorChartHeight: CGFloat = 0
    
    /// 主图区数据文本高度
    public var majorBriefHeight: CGFloat = 20
    
    /// 副图区数据文本高度
    public var minorBriefHeight: CGFloat = 20
}
