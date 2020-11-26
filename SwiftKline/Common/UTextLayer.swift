//
//  UTextLayer.swift
//  swiftKline
//
//  Created by zhanghao on 2020/10/23.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

public struct UTextRender {

    /// 文本内容 (String/NSAttributedString)
    public var text: Any?
    
    /// 文本颜色
    public var color: NSColor? = .black
    
    /// 文本字体
    public var font: NSFont? = .systemFont(ofSize: 12)
    
    /// 文本区域背景色
    public var backgroundColor: NSColor? = .clear
    
    /// 文本区域边框颜色
    public var borderColor: NSColor? = .clear
    
    /// 文本区域边框线宽
    public var borderWidth: CGFloat = 0
    
    /// 文本区域圆角
    public var cornerRadius: CGFloat = 0
    
    /// 文本边缘留白 (扩充文本区域)
    public var textEdgePadding: (horizontal: CGFloat, vertical: CGFloat) = (2, 2)
    
    /// 文本最大限制
    public var maxSize: CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
    
    /// 文本位置
    public var position: CGPoint = .zero

    /// 文本位置偏移量(单位坐标系)，基于position偏移，可与position同时控制显示位置
    public var positionOffset: CGPoint = .positionOffsetLeftTop
}

open class UTextLayers: UBaseLayer {
    
    /// 绘制数组内容
    public var renders: [UTextRender]? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 绘制某个内容
    public func update(render: UTextRender) {
        renders = [render]
    }
    
    override func initialization() {
        super.initialization()
        isGeometryFlipped = true
        contentsScale = NSScreen.scale
    }
    
    override public func draw(in ctx: CGContext) {
        guard let res = renders, !res.isEmpty else { return }
        ctx.clear(bounds)
        
        func limit( _ a: CGFloat) -> CGFloat { return min(1, max(0, a)) }
        
        for re in res {
            guard let attrib = makeAttrib(with: re) else { continue }
        
            let maxs = CGSize(width: min(re.maxSize.width, bounds.width), height: min(re.maxSize.height, bounds.height))
            var size = attrib.boundingRect(with: maxs, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).size
            size = CGSize(width: ceil(size.width), height: ceil(size.height))
            
            let scale = CGPoint(x: limit(re.positionOffset.x), y: limit(re.positionOffset.y))
            let origin = CGPoint(x: re.position.x - size.width * scale.x, y: re.position.y - size.height * scale.y)
            
            var fills = size, fillo = origin
            fills.width += re.textEdgePadding.horizontal
            fills.height += re.textEdgePadding.vertical
            fillo.x -= re.textEdgePadding.horizontal * 0.5
            fillo.y -= re.textEdgePadding.vertical * 0.55 // 字体渲染偏上，为了视觉上更加居中，把0.5改为0.55
        
            let fillR = CGRect(x: fillo.x, y: bounds.height - fillo.y - fills.height, width: fills.width, height: fills.height)
            
            let fillPath = CGMutablePath()
            fillPath.addRoundedRect(in: fillR, cornerWidth: re.cornerRadius, cornerHeight: re.cornerRadius)
            ctx.setFillColor((re.backgroundColor ?? .clear).cgColor)
            ctx.setStrokeColor((re.borderColor ?? .clear).cgColor)
            ctx.setLineWidth(re.borderWidth)
            ctx.setLineCap(.square)
            ctx.setLineJoin(.miter)
            ctx.addPath(fillPath)
            ctx.drawPath(using: .fillStroke)
            
            let path = CGMutablePath()
            path.addRect(CGRect(x: origin.x, y: bounds.height - origin.y - size.height, width: size.width, height:size.height))
            let framesetter = CTFramesetterCreateWithAttributedString(attrib)
            let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrib.length), path, nil)
            CTFrameDraw(frame, ctx)
        }
    }
    
    private func makeAttrib(with render: UTextRender) -> NSAttributedString? {
        if render.text is NSAttributedString {
            return (render.text as! NSAttributedString)
        }
        
        if render.text is String {
            let text = render.text as! String
            let attrib = NSMutableAttributedString(string: text)
            attrib.addAttribute(.font, value: render.font ?? .systemFont(ofSize: 12), range: NSMakeRange(0, text.count))
            attrib.addAttribute(.foregroundColor, value: render.color ?? .black, range: NSMakeRange(0, text.count))
            return attrib
        }
        
        return nil
    }
}

open class UTextLayer: UBaseLayer {
    
    /// 设置文本
    public var text: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 设置属性文本
    public var attributedText: NSAttributedString? {
        didSet {
            setNeedsDisplay()
        }
    }
       
    /// 文本字体
    public var font: NSFont? = .systemFont(ofSize: 12) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 文本颜色
    public var textColor: NSColor? = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 对齐类型
    public enum TextAlignment {
        case left, right, top, bottom, center, adaptive
    }
    
    /// 文本对齐方式 (设置为.adaptive将自适应文本)
    public var textAlignment: TextAlignment = .center {
        didSet {
            setNeedsDisplay()
        }
    }

    /// 文本边缘留白 (自适应时四周均有效，其他情况就近边缘设置)
    public var contentEdgeInsets: NSEdgeInsets = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func initialization() {
        super.initialization()
        contentsScale = NSScreen.scale
    }
    
    open override func draw(in ctx: CGContext) {
        guard let attrib = makeAttributed() else { return }
        ctx.clear(bounds)
        ctx.textMatrix = .identity
        ctx.translateBy(x: 0, y: bounds.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        
        let size = intrinsicSize
        var rect = CGRect(origin: .zero, size: size)
        switch textAlignment {
        case .left:
            rect.origin.x = contentEdgeInsets.left
            rect.origin.y = (bounds.height - size.height) / 2
        case .right:
            rect.origin.x = bounds.width - size.width - contentEdgeInsets.right
            rect.origin.y = (bounds.height - size.height) / 2
        case .top:
            rect.origin.x = (bounds.width - size.width) / 2
            rect.origin.y = bounds.height - size.height - contentEdgeInsets.top
        case .bottom:
            rect.origin.y = contentEdgeInsets.bottom
            rect.origin.x = (bounds.width - size.width) / 2
        case .center:
            rect.origin.x = (bounds.width - size.width) / 2
            rect.origin.y = (bounds.height - size.height) / 2
        case .adaptive:
            rect.origin.x = contentEdgeInsets.left
            rect.origin.y = contentEdgeInsets.bottom
        }
        
        let path = CGMutablePath()
        path.addRect(rect)
        let framesetter = CTFramesetterCreateWithAttributedString(attrib)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrib.length), path, nil)
        CTFrameDraw(frame, ctx)
    }
    
    private func makeAttributed() -> NSAttributedString? {
        if let _ = attributedText {
            return attributedText
        } else {
            guard let value = text else { return nil }
            
            let attrib = NSMutableAttributedString(string: value)
            attrib.addAttribute(.font, value: font ?? .systemFont(ofSize: 12), range: NSMakeRange(0, value.count))
            attrib.addAttribute(.foregroundColor, value: textColor ?? .black, range: NSMakeRange(0, value.count))
            return attrib
        }
    }
    
    /// 文本内容实际尺寸
    public var intrinsicSize: CGSize {
        guard let attrib = makeAttributed() else {
            return .zero
        }
        let maxs = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        let size = attrib.boundingRect(with: maxs, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).size
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }
    
    /// 实际布局尺寸
    public var layoutSize: CGSize {
        guard textAlignment == .adaptive else {
            return bounds.size
        }
        var size = intrinsicSize
        size.width += contentEdgeInsets.horizontal
        size.height += contentEdgeInsets.vertical
        return size
    }
    
    /// 调整位置
    public func needsAdjust(position: CGPoint, offset: CGPoint = .positionOffsetCenter) {
        let size = layoutSize
        let scale = CGPoint(x: min(1, max(0, offset.x)), y: min(1, max(0, offset.y)))
        let origin = CGPoint(x: position.x - size.width * scale.x, y: position.y - size.height * scale.y)
        frame = CGRect(origin: origin, size: size)
    }
}

/// 文本位置偏移量(单位坐标系)，基于position偏移，用于控制显示位置
/// {0,   0}, {0.5,   0}, {1,   0},
/// {0, 0.5}, {0.5, 0.5}, {1, 0.5},
/// {0,   1}, {0.5,   1}, {1,   1}
/// {0.5, 0.5} 则表示文本区域的中心点与position重叠;
/// {0, 0} 则表示文本区域左上点与position重叠;
/// {1, 0} 则表示文本区域右上点与position重叠;
/// {0, 0} 左上, {0.5, 0.5} 中心, {1, 1} 右下...
public extension CGPoint {
    
    static let positionOffsetLeftTop = CGPoint(x: 0, y: 0)
    
    static let positionOffsetRightTop = CGPoint(x: 1, y: 0)
    
    static let positionOffsetLeftBottom = CGPoint(x: 0, y: 1)
    
    static let positionOffsetRightBottom = CGPoint(x: 1, y: 1)

    static let positionOffsetCenter = CGPoint(x: 0.5, y: 0.5)
    
    static let positionOffsetCenterTop = CGPoint(x: 0.5, y: 0)
    
    static let positionOffsetCenterLeft = CGPoint(x: 0, y: 0.5)
    
    static let positionOffsetCenterBottom = CGPoint(x: 0.5, y: 1)
    
    static let positionOffsetCenterRight = CGPoint(x: 1, y: 0.5)
}
