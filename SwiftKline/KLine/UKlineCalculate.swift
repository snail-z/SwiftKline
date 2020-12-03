//
//  UKlineCalculate.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/12/1.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

internal class UKlineCalculate {
    
    /// 需要绘制的数据范围
    func rangeOfDrawn() -> NSRange {
        
        // 获取滚动视图的水平偏移量
        let offsetX = target.scrollView.contentView.bounds.origin.x - target.scrollView.frame.origin.x
        
        // 蜡烛图的单个宽度和间距
        let oneWidth = target.meas.shapeWidth + target.meas.shapeSpacing
        
        // 当前滚动位置对应的数据量下标
        var index = Int(round(offsetX / oneWidth))
        
        // 可视范围内需要绘制的蜡烛图数量
        var length = target.preference.numberOfKlines
        
        // 为使滚动效果更加平滑，可视范围两端分别多画出一条K线
        index -= 1; length += 2
        
        // 将下标控制在数据量之内，防止越界
        index = min(target.dataList.count, max(0, index))
        
        // 获取对应的数据范围
        var range = NSRange(location: index, length: length)
        
        // 如果范围超过实际数据量，则取有效数据长度
        if NSMaxRange(range) > target.dataList.count {
            range.length = target.dataList.count - range.location
        }
        
        return range
    }

    /// 需要计算的数据范围
    func rangeOfCalculated() -> NSRange {
        
        // 获取滚动视图的水平偏移量
        let offsetX = target.scrollView.contentView.bounds.origin.x - target.scrollView.frame.origin.x
        
        // 蜡烛图的单个宽度和间距
        let oneWidth = target.meas.shapeWidth + target.meas.shapeSpacing
        
        // 当前滚动位置对应的数据量下标 (可以画出多少根K线)
        var index = Int(round(offsetX / oneWidth))
        
        
        return NSRange.init(location: 0, length: 0)
    }
    
    internal init(target: UKlineView) {
        self.target = target
    }
    
    internal private(set) weak var target: UKlineView!
}
