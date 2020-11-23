//
//  UTrackingLineLayer.swift
//  swiftKline
//
//  Created by zhanghao on 2020/11/16.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

open class UTrackingTooltipLayer: UBaseLayer {

    /// 内容的可视区域
    public var trackRect: CGRect = .zero
    
    /// 坐标轴方向
    public enum TrackDirection {
        case top, left, bottom, right
    }
    
    /// 设置坐标轴文本
    public func setText(text: String, for direction: TrackDirection) {
        directionTexts.updateValue(text, forKey: direction)
    }
        
    private var directionTextLayer: UTextLayers!
    let xtextlayer = UTextLayer()
    
    override func initialization() {
        directionTextLayer = UTextLayers()
        addSublayer(directionTextLayer)
        
        
        addSublayer(xtextlayer)
    }
    
    /// 更新提示框
    public func updateTracking(location point: CGPoint) {
        guard trackRect.contains(point) else {
            return
        }
        
        var renders = [UTextRender]()
        
//        if let value = directionTexts[.top] {
//            var render = UTextRender()
//            render.text = value
//            render.color = .black
//            render.backgroundColor = .red
//            render.position = CGPoint(x: point.x, y: trackRect.minY)
//            renders.append(render)
//        }
//
//        if let value = directionTexts[.left] {
            var render = UTextRender()
            render.text = "skfj是劳动法"
            render.color = .black
            render.backgroundColor = .red
            render.position = CGPoint(x: 100, y: 100)
            renders.append(render)
//        }
//        ULabelLayer
        
//        UNSLabelsLayer
        
        xtextlayer.backgroundColor = NSColor.purple.cgColor
//        xtextlayer.string = "山东矿机"
//        xtextlayer.font = NSFont.systemFont(ofSize: 12)
        xtextlayer.frame = CGRect(x: 200, y: 200, width: 100, height: 50)
        xtextlayer.position = CGPoint(x: point.x, y: trackRect.minY)
        directionTextLayer.frame = bounds
        directionTextLayer.renders = renders
    }
    
    private lazy var directionTexts: [TrackDirection: String] = {
        return [TrackDirection: String]()
    }()
}

open class UTrackingLineLayer: UBaseLayer {
    
    /// 绘线的可视区域
    public var trackRects: [CGRect] = [.zero]

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
        updateTracking(location: point, in: trackRects)
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
