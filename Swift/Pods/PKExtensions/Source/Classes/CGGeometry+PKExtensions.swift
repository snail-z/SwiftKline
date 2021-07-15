//
//  CGGeometry+PKExtensions.swift
//  PKExtensions
//
//  Created by zhanghao on 2020/2/24.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

import UIKit

public extension PKCGFloatExtensions {
    
    /// 将CGFloat转Int
    func toInt() -> Int { Int(base) }
    
    /// 将CGFloat转Double
    func toDouble() -> Double { Double(base) }
    
    /// 将CGFloat转String
    func toString() -> String { String(describing: base) }
    
    /// 返回CGFloat的中点
    func center() -> CGFloat { scaled(0.5) }
    
    /// 返回CGFloat的倍数
    func scaled(_ scale: CGFloat) -> CGFloat { base * scale }
    
    /// 将CGFloat转像素点
    func toPixel() -> CGFloat { scaled(UIScreen.main.scale) }
    
    /// 将像素点转换成CGFloat
    func fromPixel() -> CGFloat { base / UIScreen.main.scale }
    
    /// 将角度转弧度
    func degreesToRadians() -> CGFloat { (.pi * base) / 180.0 }
    
    /// 将弧度转角度
    func radiansToDegrees() -> CGFloat { (180.0 * base) / .pi }
    
    /// 像素取整类型
    enum FlatType { case ceiled, floored, rounded }
    
    /// 基于指定的倍数，对CGFloat进行像素取整(默认向上取整)
    func flatted(scale factor: CGFloat = UIScreen.main.scale, type: FlatType = .ceiled) -> CGFloat {
        let value = (base == .leastNonzeroMagnitude || base == .leastNormalMagnitude) ? 0 : base
        let scale = factor > 0 ? factor : UIScreen.main.scale
        switch type {
        case .ceiled:
            return ceil(value * scale) / scale
        case .floored:
            return floor(value * scale) / scale
        case .rounded:
            return round(value * scale) / scale
        }
    }
}

public extension PKCGPointExtensions {
    
    /// 获取圆上任意点坐标
    ///
    /// - Parameters:
    ///   - center: 圆心点坐标
    ///   - radius: 圆的半径
    ///   - radian: 该点所对应的弧度 (顺时针方向，水平第一象限开始)
    ///
    /// - Returns: 该点对应的坐标
    static func pointOnCircle(center: CGPoint, radius: CGFloat, radian: CGFloat) -> CGPoint {
        var result = CGPoint.zero
        let rad = radian + .pi / 2
        if rad < .pi / 2 {
            result.x = center.x + radius * sin(radian)
            result.y = center.y - radius * cos(radian)
        } else if rad < .pi {
            result.x = center.x + radius * sin(.pi - radian)
            result.y = center.y + radius * cos(.pi - radian)
        } else if rad < (.pi + .pi / 2) {
            result.x = center.x - radius * cos((.pi + .pi / 2) - radian)
            result.y = center.y + radius * sin((.pi + .pi / 2) - radian)
        } else {
            result.x = center.x - radius * sin(.pi * 2 - radian)
            result.y = center.y - radius * cos(.pi * 2 - radian)
        }
        return result
    }
    
    /// 返回两个点之间的距离
    static func distance(_ from: CGPoint, _ to: CGPoint) -> CGFloat {
        return sqrt(pow(to.x - from.x, 2) + pow(to.y - from.y, 2))
    }
    
    /// 返回两个点之间的中点
    static func center(_ p1: CGPoint, _ p2: CGPoint) -> CGPoint {
        let px = fmax(p1.x, p2.x) + fmin(p1.x, p2.x)
        let py = fmax(p1.y, p2.y) + fmin(p1.y, p2.y)
        return CGPoint(x: px * 0.5, y: py * 0.5)
    }

    /// 判断当前点是否在圆形内 (center: 圆心 radius: 半径)
    func within(center: CGPoint, radius: CGFloat) -> Bool {
        let dx = fabs(Double(base.x - center.x))
        let dy = fabs(Double(base.y - center.y))
        return hypot(dx, dy) <= Double(radius)
    }
    
    /// 将CGPoint放大指定的倍数
    func scaled(_ scale: CGFloat) -> CGPoint {
        return CGPoint(x: base.x * scale, y: base.y * scale)
    }
    
    /// 将CGPoint向上取整
    func ceiled() -> CGPoint {
        return CGPoint(x: ceil(base.x), y: ceil(base.y))
    }
    
    /// 将CGPoint向下取整
    func floored() -> CGPoint {
        return CGPoint(x: floor(base.x), y: floor(base.y))
    }
    
    /// 将CGPoint四舍五入
    func rounded() -> CGPoint {
        return CGPoint(x: round(base.x), y: round(base.y))
    }
}

public extension PKCGSizeExtensions {
    
    /// 返回最大的有限CGSize
    static var greatestFiniteMagnitude: CGSize {
        return CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
    }
    
    /// 将CGSize放大指定的倍数
    func scaled(_ scale: CGFloat) -> CGSize {
        return CGSize(width: base.width * scale, height: base.height * scale)
    }
    
    /// 将CGSize向上取整
    func ceiled() -> CGSize {
        return CGSize(width: ceil(base.width), height: ceil(base.height))
    }
    
    /// 将CGSize向下取整
    func floored() -> CGSize {
        return CGSize(width: floor(base.width), height: floor(base.height))
    }
    
    /// 将CGSize四舍五入
    func rounded() -> CGSize {
        return CGSize(width: round(base.width), height: round(base.height))
    }
    
    /// 判断CGSize是否存在infinite
    var isInfinite: Bool {
        return base.width.isInfinite || base.height.isInfinite
    }
    
    /// 判断CGSize是否存在NaN
    var isNaN: Bool {
        return base.width.isNaN || base.height.isNaN
    }
    
    /// 判断CGSize是否为空(宽或高为0)
    var isEmpty: Bool {
        return base.width <= 0 || base.height <= 0
    }
    
    /// 判断CGSize是否有效(不包含零值、不带无穷大的值、不带非法数字）
    var isValid: Bool {
        return !isEmpty && !isNaN && !isInfinite
    }
}

public extension PKCGRectExtensions {
    
    /// 将CGRect放大指定的倍数
    func scaled(_ scale: CGFloat) -> CGRect {
        return CGRect(x: base.origin.x * scale, y: base.origin.y * scale,
                      width: base.size.width * scale, height: base.size.height * scale)
    }
    
    /// 将CGRect向上取整
    func ceiled() -> CGRect {
        return CGRect(x: ceil(base.origin.x), y: ceil(base.origin.y),
                      width: ceil(base.size.width), height: ceil(base.size.height))
    }
    
    /// 将CGRect向下取整
    func floored() -> CGRect {
        return CGRect(x: floor(base.origin.x), y: floor(base.origin.y),
                      width: floor(base.size.width), height: floor(base.size.height))
    }
    
    /// 将CGRect四舍五入
    func rounded() -> CGRect {
        return CGRect(x: round(base.origin.x), y: round(base.origin.y),
                      width: round(base.size.width), height: round(base.size.height))
    }
}

public extension PKUIEdgeInsetsExtensions {
    
    /// 获取UIEdgeInsets在水平方向上的值
    var horizontal: CGFloat {
        return base.left + base.right
    }
    
    /// 获取UIEdgeInsets在垂直方向上的值
    var vertical: CGFloat {
        return base.top + base.bottom
    }
    
    /// 使用相同的值返回UIEdgeInsets
    static func make(same value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: value, left: value, bottom: value, right: value)
    }
    
    /// 设置top值返回UIEdgeInsets
    static func make(top: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
    }
    
    /// 设置left值返回UIEdgeInsets
    static func make(left: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: left, bottom: 0, right: 0)
    }
    
    /// 设置bottom值返回UIEdgeInsets
    static func make(bottom: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0)
    }
    
    /// 设置right值返回UIEdgeInsets
    static func make(right: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: right)
    }
}

public struct PKCGPointExtensions {
    fileprivate static var Base: CGPoint.Type { CGPoint.self }
    fileprivate var base: CGPoint
    fileprivate init(_ base: CGPoint) { self.base = base }
}

public extension CGPoint {
    var pk: PKCGPointExtensions { PKCGPointExtensions(self) }
    static var pk: PKCGPointExtensions.Type { PKCGPointExtensions.self }
}

public struct PKCGSizeExtensions {
    fileprivate static var Base: CGSize.Type { CGSize.self }
    fileprivate var base: CGSize
    fileprivate init(_ base: CGSize) { self.base = base }
}

public extension CGSize {
    var pk: PKCGSizeExtensions { PKCGSizeExtensions(self) }
    static var pk: PKCGSizeExtensions.Type { PKCGSizeExtensions.self }
}

public struct PKCGRectExtensions {
    fileprivate static var Base: CGRect.Type { CGRect.self }
    fileprivate var base: CGRect
    fileprivate init(_ base: CGRect) { self.base = base }
}

public extension CGRect {
    var pk: PKCGRectExtensions { PKCGRectExtensions(self) }
    static var pk: PKCGRectExtensions.Type { PKCGRectExtensions.self }
}

public struct PKCGFloatExtensions {
    fileprivate static var Base: CGFloat.Type { CGFloat.self }
    fileprivate var base: CGFloat
    fileprivate init(_ base: CGFloat) { self.base = base }
}

public extension CGFloat {
    var pk: PKCGFloatExtensions { PKCGFloatExtensions(self) }
    static var pk: PKCGFloatExtensions.Type { PKCGFloatExtensions.self }
}

public struct PKUIEdgeInsetsExtensions {
    fileprivate static var Base: UIEdgeInsets.Type { UIEdgeInsets.self }
    fileprivate var base: UIEdgeInsets
    fileprivate init(_ base: UIEdgeInsets) { self.base = base }
}

public extension UIEdgeInsets {
    var pk: PKUIEdgeInsetsExtensions { PKUIEdgeInsetsExtensions(self) }
    static var pk: PKUIEdgeInsetsExtensions.Type { PKUIEdgeInsetsExtensions.self }
}
