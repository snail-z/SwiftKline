//
//  SwiftKlineExtensions.swift
//  swiftKline
//
//  Created by zhanghao on 2020/11/11.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGMutablePath {
    
    /// 绘制两点间连线
    func addLine(_ start: CGPoint, end: CGPoint) {
        move(to: start)
        addLine(to: end)
    }
    
    /// 绘制横线
    func addLine(horizontal start: CGPoint, length: CGFloat) {
        move(to: start)
        addLine(to: CGPoint(x: start.x + length, y: start.y))
    }
    
    /// 绘制竖线
    func addLine(vertical start: CGPoint, length: CGFloat) {
        move(to: start)
        addLine(to: CGPoint(x: start.x, y: start.y + length))
    }
    
    /// 绘制矩形框
    func addRect(_ rect: CGRect) {
        move(to: rect.origin)
        addLine(to: CGPoint(x: rect.minX + rect.width, y: rect.minY))
        addLine(to: CGPoint(x: rect.minX + rect.width, y: rect.minY + rect.height))
        addLine(to: CGPoint(x: rect.minX, y: rect.minY + rect.height))
        closeSubpath()
    }
    
    /// 绘制蜡烛线
    func addCandle(_ shape: UCandleShape) {
        addRect(shape.rect)
        move(to: shape.top)
        addLine(to: CGPoint(x: shape.top.x, y: shape.rect.minY))
        move(to: shape.bottom)
        addLine(to: CGPoint(x: shape.bottom.x, y: shape.rect.minY + shape.rect.height))
    }
    
    /// 绘制蜡烛线(树枝形态)
    func addForkCandle(_ shape: UCandleShape) {
        move(to: shape.top)
        addLine(to: shape.bottom)
        move(to: CGPoint(x: shape.top.x, y: shape.rect.minY))
        addLine(to: CGPoint(x: shape.rect.minX + shape.rect.width, y: shape.rect.minY))
        move(to: CGPoint(x: shape.bottom.x, y: shape.rect.minY + shape.rect.height))
        addLine(to: CGPoint(x: shape.rect.minX, y: shape.rect.minY + shape.rect.height))
    }
}

public extension UIndexValue {
    
    /// 获取为零的带索引值
    static var zero: UIndexValue {
        return UIndexValue(index: 0, value: 0)
    }
    
    /// 判断带索引值是否有效(不包含零值、不带无穷大的值、不带非法数字）
    var isValid: Bool {
        return !value.isZero && !value.isNaN && !value.isInfinite
    }
}

public extension UPeakIndexValue {
    
    /// 获取为零的带索引的极值
    static var zero: UPeakIndexValue {
        return UPeakIndexValue(max: .zero, min: .zero)
    }
    
    /// 判断带索引的极值中是否有效(不包含零值、不带无穷大的值、不带非法数字）
    var isValid: Bool {
        return UPeakValue(max: max.value, min: min.value).isValid
    }
    
    /// 不包含索引的最大最小值
    var pureValue: UPeakValue {
        return UPeakValue(max: max.value, min: min.value)
    }
}

public extension UPeakValue {
    
    /// 获取为零的极值
    static var zero: UPeakValue {
        return UPeakValue(max: 0, min: 0)
    }
    
    /// 判断极值中是否有效(不包含零值、不带无穷大的值、不带非法数字）
    var isValid: Bool {
        let isZero = max.isZero || min.isZero
        let isNaN = max.isNaN || min.isNaN
        let isInfinite = max.isInfinite || min.isInfinite
        return !isZero && !isNaN && !isInfinite
    }
    
    /// 获取极值两点距离
    var distance: Double {
        return abs(max - min)
    }
    
    /// 获取极值两点中间值
    var median: Double {
        return max - (max - min) * 0.5
    }
    
    /// 返回最大最小值相同的极值
    static func same(_ value: Double) -> UPeakValue {
        return UPeakValue(max: value, min: value)
    }
    
    /// 判断两个极值是否相同
    func isEqual(to other: UPeakValue) -> Bool {
        return max == other.max && min == other.min
    }
    
    /// 将某浮点数限制在极值之间
    func limited(_ value: Double) -> Double {
        return Swift.min(max, Swift.max(min, value))
    }
    
    /// 判断极值是否包含某个浮点数
    func isContains(_ value: Double) -> Bool {
        return !(value > max || value < min)
    }
}

public extension UPeakValue {
    
    /// 将极值等分段对应到绘图区横坐标
    func fragments(by lines: Int) -> [String] {
        return fragments(by: lines, { (_, value) -> String in String(format: "%.2f", value) })
    }
    
    /// 将极值转为绘图区横坐标线 (自定义内容)
    func fragments(by lines: Int, _ closure: (_ index: Int, _ value: Double) -> String) -> [String] {
        let fragments = Swift.max(2, lines) - 1
        let equalValue = fabs(max - min) / Double(fragments)
        var axisValues = [String]()
        for index in 0...fragments {
            let value = max - equalValue * Double(index)
            axisValues.append(closure(index, value))
        }
        return axisValues
    }
}

public extension NSUIEdgeInsets {
    
    /// 返回零值的NSEdgeInsets
    static var zero: NSUIEdgeInsets {
        return NSUIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    /// 设置top值返回NSEdgeInsets
    static func top(_ value: CGFloat) -> NSUIEdgeInsets {
        return NSUIEdgeInsets(top: value, left: 0, bottom: 0, right: 0)
    }
    
    /// 设置left值返回NSEdgeInsets
    static func left(_ value: CGFloat) -> NSUIEdgeInsets {
        return NSUIEdgeInsets(top: 0, left: value, bottom: 0, right: 0)
    }
    
    /// 设置bottom值返回NSEdgeInsets
    static func bottom(_ value: CGFloat) -> NSUIEdgeInsets {
        return NSUIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)
    }
    
    /// 设置right值返回NSEdgeInsets
    static func right(_ value: CGFloat) -> NSUIEdgeInsets {
        return NSUIEdgeInsets(top: 0, left: 0, bottom: 0, right: value)
    }
    
    /// 获取NSEdgeInsets在水平方向上的值
    var horizontal: CGFloat {
        return left + right
    }
    
    /// 获取NSEdgeInsets在垂直方向上的值
    var vertical: CGFloat {
        return top + bottom
    }
    
    /// 调换top和bottom
    var swapVertical: NSUIEdgeInsets {
        return NSUIEdgeInsets(top: bottom, left: left, bottom: top, right: right)
    }
}

public extension Double {
    
    /// 判断Double是否有效(不包含零值、不带无穷大的值、不带非法数字）
    var isValid: Bool {
        return !isZero && !isInfinite && !isNaN
    }
    
    /// 转为CGFloat
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
}

public extension CGFloat {
    
    /// 转为Double
    var double: Double {
        return Double(self)
    }
}

#if os(OSX)

import Cocoa

public extension CGRect {

    func inset(by inset: NSEdgeInsets) -> Self {
        return NSRect(x: inset.left,
                      y: inset.top,
                      width: width - inset.horizontal,
                      height: height - inset.vertical)
    }
}

public extension NSScreen {
    
    /// 获取当前屏幕的单位像素值
    static var scale: CGFloat {
        /// 如何获取像 iOS 中的 UIScreen.main.scale 值??
        return 2 // NSScreen.main?.backingScaleFactor
    }
}

#endif

public extension Array {
    
    /// 获取数组索引对应的元素，若索引越界则返回nil
    func element(at index: Index) -> Self.Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    /// 获取某范围内首元素
    func firstElement(at range: NSRange) -> Self.Element? {
        guard range.location < count else {
            return nil
        }
        return self[range.location]
    }
    
    /// 获取某范围内末尾元素
    func lastElement(at range: NSRange)  -> Self.Element? {
        let endIndex = NSMaxRange(range) - 1
        guard endIndex < count else {
            return nil
        }
        return self[endIndex]
    }

    /// 遍历数组某范围内元素
    func forEach(at range:NSRange, _ body: (Self.Element) -> Void) {
        let length = NSMaxRange(range)
        guard count < length else { return }
        for index in range.location..<length {
            body(self[index])
        }
    }
    
    /// 遍历数组某范围内元素及下标
    func forEach(at range:NSRange, _ body: (Int, Self.Element) -> Void) {
        let length = NSMaxRange(range)
        guard length <= count else { return }
        for index in range.location..<length {
            body(index, self[index])
        }
    }
        
    /// 查找数组内最大值和最小值及其对应的下标
    func peakIndexValue(by closure: (_ sender: Self.Element) -> Double) -> UPeakIndexValue {
        return peakIndexValue(at: NSRange(location: 0, length: count), by: closure)
    }
    
    /// 查找数组某范围内最大值和最小值及其对应的下标
    func peakIndexValue(at range: NSRange, by closure: (_ sender: Self.Element) -> Double) -> UPeakIndexValue {
        guard !isEmpty else { return .zero }
        
        let lastIndex = NSMaxRange(range) - 1
        guard lastIndex < count else { return .zero }
        
        var maxTuple = UIndexValue(index: range.location, value: closure(self[range.location]))
        var minTuple = UIndexValue(index: range.location, value: closure(self[range.location]))
        let lastTuple = UIndexValue(index: lastIndex, value: closure(self[lastIndex]))
        
        for index in stride(from: range.location, to: lastTuple.index, by: 2) {
            let one = UIndexValue(index: index, value: closure(self[index]))
            let two = UIndexValue(index: index + 1, value: closure(self[index + 1]))
            let maxTemp = one.value > two.value ? one : two
            let minTemp = one.value < two.value ? one : two
            if maxTemp.value > maxTuple.value { maxTuple = maxTemp }
            if minTemp.value < minTuple.value { minTuple = minTemp }
        }
        if lastTuple.value > maxTuple.value { maxTuple = lastTuple }
        if lastTuple.value < minTuple.value { minTuple = lastTuple }
        return UPeakIndexValue(max: maxTuple, min: minTuple)
    }
    
    /// 查找数组内最大值和最小值
    func peakValue(by closure: (_ sender: Self.Element) -> Double) -> UPeakValue {
        return peakValue(at: NSRange(location: 0, length: count), by: closure)
    }
    
    /// 查找数组某范围内最大最小值
    func peakValue(at range: NSRange, by closure: (_ sender: Self.Element) -> Double) -> UPeakValue {
        guard !isEmpty else { return .zero }
        var peakValue = UPeakValue.same(closure(self[range.location]))
        let lastIndex = NSMaxRange(range) - 1
        for index in stride(from: range.location, to: lastIndex, by: 2) {
            let one = closure(self[index]), two = closure(self[index + 1])
            let maxTemp = fmax(one, two), minTemp = fmin(one, two)
            if maxTemp > peakValue.max { peakValue.max = maxTemp }
            if minTemp < peakValue.min { peakValue.min = minTemp }
        }
        let lastValue = closure(self[lastIndex])
        if lastValue > peakValue.max { peakValue.max = lastValue }
        if lastValue < peakValue.min { peakValue.min = lastValue }
        return peakValue
    }
    
    /// 查找数组内最大值和最小值，忽略零值比较
    func ignoreZeroPeakValue(_ closure: (_ sender: Self.Element) -> Double) -> UPeakValue {
        return filter({ !closure($0).isZero }) .peakValue(by: closure)
    }

    /// 查找数组某范围内最大最小值，忽略零值比较
    func ignoreZeroPeakValue(at range: NSRange, _ closure: (_ sender: Self.Element) -> Double) -> UPeakValue {
        let length = NSMaxRange(range)
        guard count < length else { return .zero }
        var value = Array()
        for index in range.location..<length {
            value.append(self[index])
        }
        return value.filter({ !closure($0).isZero }) .peakValue(by: closure)
    }
    
    /// 计算数组极值与参考值的最大跨度
    func spanValue(reference: Double, _ closure: (_ sender: Self.Element) -> Double) -> Double {
        let peakValue = self.peakValue(by: closure)
        guard peakValue.isValid else { return 0 }
        let value1 = fabs(peakValue.max - reference)
        let value2 = fabs(peakValue.min - reference)
        let maxValue = fmax(value1, value2)
        return fmax(maxValue, 0)
    }
}

public extension Date {
    
    /// 将Date转为分钟数，如 9:30 => 570
    func minuteUnit() -> Int {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        calendar.locale = .current
        let allComps = calendar.dateComponents([Calendar.Component.hour, .minute] , from: self)
        guard
            let hour = allComps.hour,
            let minute = allComps.minute else {
            return 0
        }
        return hour * 60 + minute
    }
    
    /// 将分钟数转为Date(HH:mm格式)，如 570 => 9:30
    static func minuteDate(from minuteUnit: Int) -> Date? {
        let dateString = minuteString(from: minuteUnit)
        return Date.pk.date(fromString: dateString, format: "HH:mm")
    }
    
    /// 将分钟数转为分钟字符串
    static func minuteString(from minuteUnit: Int) -> String {
        let hour = String(format: "%.2ld", minuteUnit / 60)
        let mins = String(format: "%.2ld", minuteUnit % 60)
        return hour + ":" + mins
    }
    
    /// 返回某个时间段的分钟数集
    /// 分时与分钟数对照：
    /// 09:30 <=> 570
    /// 10:00 <=> 600
    /// 10:30 <=> 630
    /// 11:00 <=> 660
    /// 11:30 <=> 690
    /// 13:00 <=> 780
    /// 14:00 <=> 840
    /// 14:30 <=> 870
    /// 15:00 <=> 900
    /// 15:05 <=> 905
    /// 15:30 <=> 930
    /// 16:00 <=> 960
    /// 例如返回9点30到11点间的分钟数 `minuteUnitRanges(570...660)`
    static func minuteUnitRanges(_ ranges: ClosedRange<Int>...) -> [Int] {
        var values = [Int]()
        for range in ranges {
            values.append(contentsOf: range.map({  $0 }))
        }
        return values
    }
}

extension NSScrollView {
    
    /// 使视图滚动到顶部边界
    public func scrollToTop() {
        if let documentView = self.documentView {
            if documentView.isFlipped {
                documentView.scroll(.zero)
            } else {
                let maxHeight = max(bounds.height, documentView.bounds.height)
                documentView.scroll(NSPoint(x: 0, y: maxHeight))
            }
        }
    }
}

public extension CGRect {
    
    /// 通过origin、width、height初始化CGRect
    init(origin: CGPoint, width: CGFloat, height: CGFloat) {
        self.init(origin: origin, size: CGSize(width: width, height: height))
    }

    init(origin: CGPoint, width: Double, height: Double) {
        self.init(origin: origin, size: CGSize(width: width, height: height))
    }

    init(origin: CGPoint, width: Int, height: Int) {
        self.init(origin: origin, size: CGSize(width: width, height: height))
    }
}
