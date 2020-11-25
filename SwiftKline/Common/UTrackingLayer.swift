//
//  UTrackingLineLayer.swift
//  swiftKline
//
//  Created by zhanghao on 2020/11/16.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

open class UTrackingAixsLayerUTrackingTooltipLayer: UBaseLayer {
    
}

open class UTrackingWidgetLayer: UBaseLayer {
    
    /// 绘制区边界
    public var boundsRect: CGRect = .zero
    
    /// 坐标轴挂件
    public enum WidgetType {
        case top(_ value: String)
        case left(_ value: String)
        case bottom(_ value: String)
        case right(_ value: String)
    }
    
    /// 更新坐标提示窗
    public func updateTracking(location point: CGPoint, widget content: [WidgetType]) {
        for element in content {
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
