//
//  UKlineCalculate.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/12/1.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

internal class UKlineCalculate {
    
    /// 重新计算
    internal func recalculate() {
        guard let _ = target.dataList else { return }
        let range = NSRange(location: 0, length: 60)
        let _  = peakIndexValue(at: range, broken: false)
    }
    
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

    /// 需要计算的数据范围 (真实的可视范围)
    func rangeOfCalculated() -> NSRange {
        
        // 获取滚动视图的水平偏移量
        let offsetX = target.scrollView.contentView.bounds.origin.x - target.scrollView.frame.origin.x
        
        // 蜡烛图的单个宽度和间距
        let oneWidth = target.meas.shapeWidth + target.meas.shapeSpacing
        
        // 当前滚动位置对应的数据量下标 (可以画出多少根K线)
        var index = Int(round(offsetX / oneWidth))
        
        // 将下标控制在数据量之内，防止越界
        index = min(target.dataList.count, max(0, index))
        
        // 获取对应的数据范围
        var range = NSRange(location: index, length: target.preference.numberOfKlines)
        
        // 如果范围超过实际数据量，则取有效数据长度
        if NSMaxRange(range) > target.dataList.count {
            range.length = target.dataList.count - range.location
        }
        
        // 如果滚动视图拖动到边界以外，则取有效边界内数据
        if target.scrollView.contentView.documentVisibleRect.origin.x < 0,
            target.scrollView.contentView.documentRect.width > target.meas.majorChartFrame.width {
            let visibleX = abs(target.scrollView.contentView.documentVisibleRect.origin.x)
            range.length -= Int(round(visibleX / oneWidth))
        }

        return range
    }
    
    /// 指定范围内的极值及对应的下标
    func peakIndexValue(at range: NSRange, broken: Bool = false) -> UPeakIndexValue {
        guard !broken else {
            // 折线状态直接使用收盘价来计算极值
            return target.dataList.peakIndexValue(at: range, by: { $0._closePrice })
        }
        
        // 正常状态下，最大值按最高价计算，最小值按最低价计算
        var maxTuple = UIndexValue(index: 0, value: -.greatestFiniteMagnitude)
        var minTuple = UIndexValue(index: 0, value: .greatestFiniteMagnitude)
        target.dataList.forEach(at:range) { (index, element) in
            if element._highPrice > maxTuple.value {
                maxTuple = UIndexValue(index: index, value: element._highPrice)
            }
            if element._lowPrice < minTuple.value {
                minTuple = UIndexValue(index: index, value: element._lowPrice)
            }
        }
        return UPeakIndexValue(max: maxTuple, min: minTuple)
    }
    
    /// 根据峰值点边缘间距扩大极值
    func enlargedPeakValue(_ peakValue: UPeakValue) -> UPeakValue {
        let factor = peakValue.distance.cgFloat / target.meas.majorChartFrame.height
        let padding = (target.preference.peakTaggedEdgePadding * factor).double;
        return UPeakValue(max: peakValue.max + padding, min: peakValue.min - padding)
    }
    
    internal init(target: UKlineView) {
        self.target = target
    }
    
    internal private(set) weak var target: UKlineView!
}
