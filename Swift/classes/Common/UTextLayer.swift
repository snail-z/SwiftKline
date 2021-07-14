//
//  UTextLayer.swift
//  swiftKline
//
//  Created by zhanghao on 2020/10/23.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import UIKit

open class UTextLayer: UBaseLayer {

    override func initialization() {
        super.initialization()
        contentsScale = UIScreen.main.scale
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
        
            let fillPath = UIBezierPath(roundedRect: CGRect(x: fillo.x, y: bounds.height - fillo.y - fills.height, width: fills.width, height: fills.height), cornerRadius: re.cornerRadius).cgPath
            ctx.setFillColor((re.backgroundColor ?? .clear).cgColor)
            ctx.setStrokeColor((re.borderColor ?? .clear).cgColor)
            ctx.setLineWidth(re.borderWidth)
            ctx.setLineCap(.square)
            ctx.setLineJoin(.miter)
            ctx.addPath(fillPath)
            ctx.drawPath(using: .fillStroke)
            
            let path = UIBezierPath(rect: CGRect(x: origin.x, y: bounds.height - origin.y - size.height, width: size.width, height:size.height)).cgPath
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
