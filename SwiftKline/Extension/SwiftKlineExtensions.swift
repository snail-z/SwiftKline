//
//  SwiftKlineExtensions.swift
//  swiftKline
//
//  Created by zhanghao on 2020/11/11.
//  Copyright © 2020 zhanghao. All rights reserved.
//


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

public extension NSScreen {
    
    var unitsPerInch: CGSize {
        let millimetersPerInch:CGFloat = 25.4
        let screenDescription = deviceDescription
        if let displayUnitSize = (screenDescription[NSDeviceDescriptionKey.size] as? NSValue)?.sizeValue,
            let screenNumber = (screenDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber)?.uint32Value {
            let displayPhysicalSize = CGDisplayScreenSize(screenNumber)
            return CGSize(width: millimetersPerInch * displayUnitSize.width / displayPhysicalSize.width,
                          height: millimetersPerInch * displayUnitSize.height / displayPhysicalSize.height)
        } else {
            return CGSize(width: 72.0, height: 72.0) // this is the same as what CoreGraphics assumes if no EDID data is available from the display device — https://developer.apple.com/documentation/coregraphics/1456599-cgdisplayscreensize?language=objc
        }
    }
//
//    let desc = NSScreen.main!.deviceDescription
//    let size = desc[NSDeviceDescriptionKey(rawValue: "NSDeviceSize")]
//    let number = desc[NSDeviceDescriptionKey(rawValue: "NSScreenNumber")]
//    if let screen = NSScreen.main {
//        print("main screen units per inch \(screen.unitsPerInch)")
//    }
}

public extension NSScreen {
    
    /// 获取当前屏幕的单位像素值
    static var scale: CGFloat {
        /// 如何获取像 iOS 中的 UIScreen.main.scale 值??
        return 2 // NSScreen.main?.backingScaleFactor
    }
}

public extension NSEdgeInsets {
    
    /// 返回零值的NSEdgeInsets
    static var zero: NSEdgeInsets {
        return NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    /// 设置top值返回NSEdgeInsets
    static func top(_ value: CGFloat) -> NSEdgeInsets {
        return NSEdgeInsets(top: value, left: 0, bottom: 0, right: 0)
    }
    
    /// 设置left值返回NSEdgeInsets
    static func left(_ value: CGFloat) -> NSEdgeInsets {
        return NSEdgeInsets(top: 0, left: value, bottom: 0, right: 0)
    }
    
    /// 设置bottom值返回NSEdgeInsets
    static func bottom(_ value: CGFloat) -> NSEdgeInsets {
        return NSEdgeInsets(top: 0, left: 0, bottom: value, right: 0)
    }
    
    /// 设置right值返回NSEdgeInsets
    static func right(_ value: CGFloat) -> NSEdgeInsets {
        return NSEdgeInsets(top: 0, left: 0, bottom: 0, right: value)
    }
    
    /// 获取NSEdgeInsets在水平方向上的值
    var horizontal: CGFloat {
        return left + right
    }
    
    /// 获取NSEdgeInsets在垂直方向上的值
    var vertical: CGFloat {
        return top + bottom
    }
}

public extension NSRect {

    func inset(by inset: NSEdgeInsets) -> Self {
        return NSRect(x: inset.left,
                      y: inset.top,
                      width: width - inset.horizontal,
                      height: height - inset.vertical)
    }
}

#if os(iOS) || os(tvOS)
import UIKit

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
#endif

#if os(OSX)
import Cocoa

public extension NSBezierPath {
 
    /// 将NSBezierPath转为CGPath
    var cgPath: CGPath {
        let path = CGMutablePath()
        let points = UnsafeMutablePointer<NSPoint>.allocate(capacity: 3)
        let elementCount = self.elementCount
        
        if elementCount > 0 {
            var didClosePath = true
            
            for index in 0..<elementCount {
                let pathType = self.element(at: index, associatedPoints: points)
                
                switch pathType {
                case .moveTo:
                    path.move(to: CGPoint(x: points[0].x, y: points[0].y))
                case .lineTo:
                    path.addLine(to: CGPoint(x: points[0].x, y: points[0].y))
                    didClosePath = false
                case .curveTo:
                    let origin = CGPoint(x: points[0].x, y: points[0].y)
                    let control1 = CGPoint(x: points[1].x, y: points[1].y)
                    let control2 = CGPoint(x: points[2].x, y: points[2].y)
                    path.addCurve(to: origin, control1: control1, control2: control2)
                    didClosePath = false
                case .closePath:
                    path.closeSubpath()
                    didClosePath = true
                @unknown default: break
                }
            }
            
            if !didClosePath { path.closeSubpath() }
        }
        
        points.deallocate()
        return path
    }
    
    /// 绘制两点间连线
    func addLine(_ start: CGPoint, end: CGPoint) {
        move(to: start)
        line(to: end)
    }
    
    /// 绘制横线
    func addLine(horizontal start: CGPoint, length: CGFloat) {
        move(to: start)
        line(to: CGPoint(x: start.x + length, y: start.y))
    }
    
    /// 绘制竖线
    func addLine(vertical start: CGPoint, length: CGFloat) {
        move(to: start)
        line(to: CGPoint(x: start.x, y: start.y + length))
    }
    
    /// 绘制矩形框
    func addRect(_ rect: CGRect) {
        move(to: rect.origin)
        line(to: CGPoint(x: rect.minX + rect.width, y: rect.minY))
        line(to: CGPoint(x: rect.minX + rect.width, y: rect.minY + rect.height))
        line(to: CGPoint(x: rect.minX, y: rect.minY + rect.height))
        close()
    }
    
    /// 绘制蜡烛线
    func addCandle(_ shape: UCandleShape) {
        addRect(shape.rect)
        move(to: shape.top)
        line(to: CGPoint(x: shape.top.x, y: shape.rect.minY))
        move(to: shape.bottom)
        line(to: CGPoint(x: shape.bottom.x, y: shape.rect.minY + shape.rect.height))
    }
    
    /// 绘制蜡烛线(树枝形态)
    func addForkCandle(_ shape: UCandleShape) {
        move(to: shape.top)
        line(to: shape.bottom)
        move(to: CGPoint(x: shape.top.x, y: shape.rect.minY))
        line(to: CGPoint(x: shape.rect.minX + shape.rect.width, y: shape.rect.minY))
        move(to: CGPoint(x: shape.bottom.x, y: shape.rect.minY + shape.rect.height))
        line(to: CGPoint(x: shape.rect.minX, y: shape.rect.minY + shape.rect.height))
    }
}

#endif

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
    func takeXaxisLine(_ n: Int) -> [String] {
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
        return value.filter({ !closure($0).isZero }) .peakValue(closure)
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
