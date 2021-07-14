//
//  SwiftKline+Extensions.swift
//  swiftKline
//
//  Created by zhanghao on 2020/10/23.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import UIKit

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
    
    /// 将极值转为绘图区横坐标线
    func takeXaxisLine(_ n: Int) -> Array<Any> {
        return takeXaxisLine(n) { (_, value) -> String in String(format: "%.2f", value) }
    }
    
    /// 将极值转为绘图区横坐标线 (自定义内容)
    func takeXaxisLine(_ n: Int, _ closure: (_ index: Int, _ value: Double) -> String) -> [String] {
        let numberOfSegments = Swift.max(2, n) - 1
        let equalValue = fabs(max - min) / Double(numberOfSegments)
        var axisValues = [String]()
        for index in 0...numberOfSegments {
            let value = max - equalValue * Double(index)
            axisValues.append(closure(index, value))
        }
        return axisValues
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

public extension UIBezierPath {

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
        close()
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
    
    /// 查找数组内最大值和最小值
    func peakValue(_ closure: (_ sender: Self.Element) -> Double) -> UPeakValue {
        guard !isEmpty else { return .zero }
        var minValue = closure(self[0]), maxValue = closure(self[0])
        let lastIndex = count - 1
        for index in stride(from: 0, to: lastIndex, by: 2) {
            let one = closure(self[index]), two = closure(self[index + 1])
            let maxTemp = fmax(one, two), minTemp = fmax(one, two)
            if maxTemp > maxValue { maxValue = maxTemp }
            if minTemp < minValue { minValue = minTemp }
        }
        let lastValue = closure(self[lastIndex])
        if lastValue > maxValue { maxValue = lastValue }
        if lastValue < minValue { minValue = lastValue }
        return UPeakValue(max: maxValue, min: minValue)
    }
    
    /// 查找数组某范围内最大最小值
    func peakValue(at range: NSRange, _ closure: (_ sender: Self.Element) -> Double) -> UPeakValue {
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
        return filter({ !closure($0).isZero }) .peakValue(closure)
    }

    /// 查找数组某范围内最大最小值，忽略零值比较
    func ignoreZeroPeakValue(at range: NSRange, _ closure: (_ sender: Self.Element) -> Double) -> UPeakValue {
        let length = NSMaxRange(range)
        guard count < length else { return .zero }
        var value = Array()
        for index in range.location..<length {
            value.append(self[index])
        }
        return filter({ !closure($0).isZero }) .peakValue(closure)
    }
    
    /// 计算数组极值与参考值的最大跨度
    func spanValue(reference: Double, _ closure: (_ sender: Self.Element) -> Double) -> Double {
        let peakValue = self.peakValue(closure)
        guard peakValue.isValid else { return 0 }
        let value1 = fabs(peakValue.max - reference)
        let value2 = fabs(peakValue.min - reference)
        let maxValue = fmax(value1, value2)
        return fmax(maxValue, 0)
    }
}
