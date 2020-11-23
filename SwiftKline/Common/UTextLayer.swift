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

    /// 文本位置偏移 (单位坐标系，默认值{0,1}) 基于position偏移，同时控制显示位置。
    ///
    ///     {0.5, 0.5} 则表示文本区域的中心点与position重叠;
    ///     {0, 0} 则表示文本区域左上点与position重叠;
    ///     {1, 0} 则表示文本区域右上点与position重叠;
    ///     {0, 0} 左上, {0.5, 0.5} 中心, {1, 1} 右下
    ///
    ///     {0,   0}, {0.5,   0}, {1,   0},
    ///     {0, 0.5}, {0.5, 0.5}, {1, 0.5},
    ///     {0,   1}, {0.5,   1}, {1,   1}
    public var positionOffset: CGPoint = CGPoint(x: 0, y: 1)
}

open class UTextLayers: UBaseLayer {

    override func initialization() {
        super.initialization()
        contentsScale = NSScreen.scale
    }
    
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
    
    override public func draw(in ctx: CGContext) {
        guard let res = renders, !res.isEmpty else { return }
        ctx.clear(bounds)
        ctx.textMatrix = .identity
        ctx.translateBy(x: 0, y: bounds.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
            
        func ratable( _ a: CGFloat) -> CGFloat { return min(1, max(0, a)) }
        
        for re in res {
            guard let attrib = makeAttrib(with: re) else { continue }
        
            let maxs = CGSize(width: min(re.maxSize.width, bounds.width), height: min(re.maxSize.height, bounds.height))
            var size = attrib.boundingRect(with: maxs, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).size
            size = CGSize(width: ceil(size.width), height: ceil(size.height))
            
            let scale = CGPoint(x: ratable(re.positionOffset.x), y: ratable(re.positionOffset.y))
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
    
    /// 设置文本 (String/NSAttributedString)
    public var text: Any?
       
    /// 文本字体
    public var font: NSFont? = .systemFont(ofSize: 12)
    
    /// 文本颜色
    public var textColor: NSColor? = .black
    
    /// 对齐类型
    public enum TextAlignment {
        case left, right, top, bottom, center
    }
    
    /// 文本对齐方式
    public var textAlignment: TextAlignment = .center
    
    override func initialization() {
        super.initialization()
    }
    
    func df() {
        
//        guard let res = renders, !res.isEmpty else { return }
        
        let maxs = CGSize(width: min(100, bounds.width), height: min(200, bounds.height))
        let attrib = NSMutableAttributedString.init(string: "")
        var size = attrib.boundingRect(with: maxs, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil).size
    }
}
