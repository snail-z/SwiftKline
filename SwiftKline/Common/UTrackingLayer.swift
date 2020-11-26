//
//  UTrackingLineLayer.swift
//  swiftKline
//
//  Created by zhanghao on 2020/11/16.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

open class UTrackingLineLayer: UBaseLayer {
    
    /// 绘制区域
    public var drawableRects: [CGRect] = [.zero]

    /// 绘线颜色
    public var lineColor: NSColor? {
        didSet {
            crossLineLayer.strokeColor = lineColor?.cgColor
        }
    }
    
    /// 绘线宽度
    public var lineWidth: CGFloat = 0 {
        didSet {
            crossLineLayer.lineWidth = lineWidth
        }
    }
    
    /// 绘虚线的实线部分和间隔长度
    public var lineDashPattern: [NSNumber]? {
        didSet {
            crossLineLayer.lineDashPattern = lineDashPattern
        }
    }
    
    private var crossLineLayer: UShapeLayer!
    
    override func initialization() {
        super.initialization()
        crossLineLayer = UShapeLayer()
        crossLineLayer.fillColor = NSColor.clear.cgColor
        addSublayer(crossLineLayer)
    }
    
    /// 在指定范围内更新跟踪位置 (使用预先设置的trackRects)
    public func updateTracking(location point: CGPoint) {
        updateTracking(location: point, in: drawableRects)
    }
    
    /// 在指定多个范围内更新跟踪位置 (实时入参rects)
    public func updateTracking(location point: CGPoint, in rects: [CGRect]) {
        guard let res = rects.filter({ $0.contains(point) }).first else {
            return
        }
        
        /// 按最小y值的rect排序
        let sortRects = rects.sorted(by: { $0.minY < $1.minY })
        
        /// 绘制纵线 (仅纵线贯穿)
        let path = CGMutablePath()
        for rs in sortRects {
            path.move(to: CGPoint(x: point.x, y: rs.minY))
            path.addLine(to: CGPoint(x: point.x, y: rs.maxY))
        }
        
        /// 在包含该点的区域绘制横线
        path.move(to: CGPoint(x: res.minX, y: point.y))
        path.addLine(to: CGPoint(x: res.maxX, y: point.y))
        
        crossLineLayer.path = path
    }
    
    /// 在指定范围内更新跟踪位置
    public func updateTracking(location point: CGPoint, in rect: CGRect) {
        updateTracking(location: point, in: [rect])
    }
    
    /// 在当前视图区更新跟踪位置
    public func updateTrackingInBounds(location point: CGPoint) {
        updateTracking(location: point, in: bounds)
    }
}


open class UTrackingWidgetLayer: UBaseLayer {
    
    /// 绘制区边界
    public var boundsRect: CGRect = .zero
    
    /// 坐标轴挂件
    public enum Widget {
        case top(_ value: String)
        case left(_ value: String)
        case bottom(_ value: String)
        case right(_ value: String)
    }

    /// 更新坐标提示窗
    public func updateTracking(location point: CGPoint, widgets: [Widget]) {
        for element in widgets {
            switch element {
            case .left(let value):
                leftTextLayer.text = value
                let y = limitY(by: leftTextLayer.layoutSize.height, location: point)
                let position = CGPoint(x: boundsRect.minX, y: y)
                leftTextLayer.needsAdjust(position: position, offset: .positionOffsetCenterRight)
                
            case .right(let value):
                rightTextLayer.text = value
                let y = limitY(by: rightTextLayer.layoutSize.height, location: point)
                let position = CGPoint(x: boundsRect.maxX, y: y)
                rightTextLayer.needsAdjust(position: position, offset: .positionOffsetCenterLeft)
                
            case .bottom(let value):
                bottomTextLayer.text = value
                let x = limitX(by: bottomTextLayer.layoutSize.width, location: point)
                let position = CGPoint(x: x, y: boundsRect.maxY)
                bottomTextLayer.needsAdjust(position: position, offset: .positionOffsetCenterTop)
                
            case .top(let value):
                topTextLayer.text = value
                let x = limitX(by: topTextLayer.layoutSize.width, location: point)
                let position = CGPoint(x: x, y: boundsRect.minY)
                topTextLayer.needsAdjust(position: position, offset: .positionOffsetCenterBottom)
            }
        }
    }
    
    private func limitX(by width: CGFloat, location: CGPoint) -> CGFloat {
        if location.x - width / 2 < boundsRect.minX {
            return width / 2 + boundsRect.minX
        } else if location.x + width / 2 > boundsRect.maxX {
            return boundsRect.maxX - width / 2
        } else {
            return location.x
        }
    }

    private func limitY(by height: CGFloat, location: CGPoint) -> CGFloat {
        if location.y - height / 2 < boundsRect.minY {
            return height / 2 + boundsRect.minY
        } else if location.y + height / 2 > boundsRect.maxY {
            return boundsRect.maxY - height / 2
        } else {
            return location.y
        }
    }
    
    private lazy var topTextLayer: UTextLayer = {
        let textLayer = makeTextLayer()
        textLayer.textAlignment = .adaptive
        textLayer.contentEdgeInsets = .init(top: 2, left: 5, bottom: 2, right: 5)
        return textLayer
    }()
    
    private lazy var leftTextLayer: UTextLayer = {
        let textLayer = makeTextLayer()
        textLayer.textAlignment = .right
        textLayer.contentEdgeInsets = .right(5)
        textLayer.frame = CGRect(x: 0, y: 0, width: 50, height: 18)
        return textLayer
    }()
    
    private lazy var bottomTextLayer: UTextLayer = {
        let textLayer = makeTextLayer()
        textLayer.textAlignment = .adaptive
        textLayer.contentEdgeInsets = .init(top: 2, left: 5, bottom: 2, right: 5)
        return textLayer
    }()
    
    private lazy var rightTextLayer: UTextLayer = {
        let textLayer = makeTextLayer()
        textLayer.textAlignment = .left
        textLayer.contentEdgeInsets = .left(5)
        textLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 18)
        return textLayer
    }()
    
    private func makeTextLayer() -> UTextLayer {
        let textLayer = UTextLayer()
        textLayer.isDisableActions = true
        textLayer.font = .systemFont(ofSize: 10)
        textLayer.textColor = .white
        textLayer.backgroundColor = NSColor.gray.cgColor
        addSublayer(textLayer)
        return textLayer
    }
}


public struct UTrackingTooltipItem {
    
    /// 属性文本(居左)
    public var leftText: NSAttributedString!
    
    /// 属性文本(居右)
    public var rightText: NSAttributedString!
    
    /// 便利构造
    static func make(left: NSAttributedString, right: NSAttributedString) -> Self {
        var item = UTrackingTooltipItem()
        item.leftText = left
        item.rightText = right
        return item
    }
}

class UTrackingLineCanvas {
    
}

open class UTrackingTooltipCanvas {
    
    func draw(in ctx: CGContext) {
        
    }
    
}

open class UTrackingTooltipLayer: UBaseLayer {
    
    /// 每个条目高度
    public var itemHeight: CGFloat = 15
    
    /// 每个条目间距
    public var itemSpacing: CGFloat = 8
    
    /// 数据条目数量
    public var itemCount: Int = 0
    
    /// 内容边缘留白
    public var contentEdgeInsets: NSEdgeInsets = .init(top: 10, left: 10, bottom: 20, right: 20)
    
    /// 更新数据条目
    public var items: [UTrackingTooltipItem]? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func initialization() {
        super.initialization()
        contentsScale = NSScreen.scale
        isGeometryFlipped = true
    }
    
    public func sizeToFit(width: CGFloat) {
        var height = contentEdgeInsets.vertical
        height += CGFloat(itemCount) * itemHeight
        height += CGFloat(itemCount - 1) * itemSpacing
        frame = CGRect(origin: frame.origin, size: CGSize(width: width, height: height))
    }
    
    open override func draw(in ctx: CGContext) {
        guard let elements = items else { return }
        ctx.clear(bounds)
        
//        let insetRect = bounds.inset(by: contentEdgeInsets.swapVertical)
//        let fillPath = CGMutablePath()
//        fillPath.addRect(insetRect)
//        ctx.setFillColor(NSColor.orange.cgColor)
//        ctx.addPath(fillPath)
//        ctx.drawPath(using: .fill)
        
        var index = elements.count - 1
        
        for item in elements {
            let y = contentEdgeInsets.bottom + (itemHeight + itemSpacing) * CGFloat(index)
            let rect = CGRect(x: contentEdgeInsets.left, y: y, width: bounds.width - contentEdgeInsets.horizontal, height: itemHeight)
            
            let path = CGMutablePath()
            path.addRect(rect)
            
            let framesetterLeft = CTFramesetterCreateWithAttributedString(item.leftText)
            let frameLeft = CTFramesetterCreateFrame(framesetterLeft, CFRangeMake(0, item.leftText.length), path, nil)
            CTFrameDraw(frameLeft, ctx)
            
            let framesetterRight = CTFramesetterCreateWithAttributedString(item.rightText)
            let frameRight = CTFramesetterCreateFrame(framesetterRight, CFRangeMake(0, item.rightText.length), path, nil)
            CTFrameDraw(frameRight, ctx)
            
            index-=1
        }
    }
}
