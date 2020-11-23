//
//  UTimeView.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/11/11.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

// MARK: - UTimeView

open class UTimeView: UTimeBase, UTimeViewInterface, NSGestureRecognizerDelegate {
    
    /// 主图区横轴网格线
    private var majorXaxisLineLayer: UShapeLayer!
    
    /// 副图区横轴网格线
    private var minorXaxisLineLayer: UShapeLayer!
    
    /// 主图区价格参考线
    private var majorDashLayer: UShapeLayer!
    
    /// 日期时间线
    private var dateLineLayer: UShapeLayer!

    /// 分时走势线
    private var trendLineLayer: UShapeLayer!
    
    /// 分时走势线填充
    private var trendFillLayer: UGradientLayer!
    
    /// 走势均线
    private var trendAverageLineLayer: UShapeLayer!
    
    /// 成交量柱状图涨
    private var VOLRiseLayer: UShapeLayer!
    
    /// 成交量柱状图跌
    private var VOLFallLayer: UShapeLayer!
    
    /// 成交量柱状图平
    private var VOLFlatLayer: UShapeLayer!
    
    /// 时间线文本
    private var dateLineTextLayer: UTextLayers!
    
    /// 主图区x轴文本
    private var majorXaxisTextLayer: UTextLayers!
    
    /// 副图区x轴文本
    private var minorXaxisTextLayer: UTextLayers!
    
    /// 主图区数据文本
    private var majorBriefTextLayer: UTextLayers!
    
    /// 副图区数据文本
    private var minorBriefTextLayer: UTextLayers!
    
    /// 鼠标跟踪线
    private var trackingLineLayer: UTrackingLineLayer!
    
    /// 数据跟踪提示框
    private var trackingTooltipLayer: UTrackingTooltipLayer!
    
    /// 计算结果
    private var calculated: UTimeCalculate!
    
    /// 外观样式
    public var preference: UTimePreferences! = UTimePreferences()
    
    /// 走势列表
    public var dataList: [UTimeDataSource]?
    
    /// 坐标参考系
    public var referenceSystem: UTimeReferenceSystem?
    
    /// 绘制区测量
    public private(set) var meas = UTimeMeasurement()
    
    override func defaultInitialization() {
        majorXaxisLineLayer = UShapeLayer()
        chartContainerLayer.addSublayer(majorXaxisLineLayer)
        
        minorXaxisLineLayer = UShapeLayer()
        chartContainerLayer.addSublayer(minorXaxisLineLayer)
        
        majorDashLayer = UShapeLayer()
        chartContainerLayer.addSublayer(majorDashLayer)
        
        dateLineLayer = UShapeLayer()
        chartContainerLayer.addSublayer(dateLineLayer)
        
        trendLineLayer = UShapeLayer()
        chartContainerLayer.addSublayer(trendLineLayer)
        
        trendFillLayer = UGradientLayer()
        chartContainerLayer.insertSublayer(trendFillLayer, at: 0)
        
        trendAverageLineLayer = UShapeLayer()
        chartContainerLayer.addSublayer(trendAverageLineLayer)
        
        VOLRiseLayer = UShapeLayer()
        chartContainerLayer.addSublayer(VOLRiseLayer)
        
        VOLFallLayer = UShapeLayer()
        chartContainerLayer.addSublayer(VOLFallLayer)
        
        VOLFlatLayer = UShapeLayer()
        chartContainerLayer.addSublayer(VOLFlatLayer)
        
        dateLineTextLayer = UTextLayers()
        textContainerLayer.addSublayer(dateLineTextLayer)
        
        majorXaxisTextLayer = UTextLayers()
        textContainerLayer.addSublayer(majorXaxisTextLayer)
        
        minorXaxisTextLayer = UTextLayers()
        textContainerLayer.addSublayer(minorXaxisTextLayer)
        
        majorBriefTextLayer = UTextLayers()
        textContainerLayer.addSublayer(majorBriefTextLayer)
        
        minorBriefTextLayer = UTextLayers()
        textContainerLayer.addSublayer(minorBriefTextLayer)
        
        trackingLineLayer = UTrackingLineLayer()
        chartContainerLayer.addSublayer(trackingLineLayer)
        
        trackingTooltipLayer = UTrackingTooltipLayer()
        chartContainerLayer.addSublayer(trackingTooltipLayer)
    }

    override func sublayerInitialization() {
        majorXaxisLineLayer.fillColor = NSColor.clear.cgColor
        majorXaxisLineLayer.strokeColor = preference.gridLineColor?.cgColor
        majorXaxisLineLayer.lineWidth = preference.gridLineWidth
        
        minorXaxisLineLayer.fillColor = majorXaxisLineLayer.fillColor
        minorXaxisLineLayer.strokeColor = majorXaxisLineLayer.strokeColor
        minorXaxisLineLayer.lineWidth = majorXaxisLineLayer.lineWidth
        
        majorDashLayer.fillColor = NSColor.clear.cgColor
        majorDashLayer.strokeColor = preference.dashLineColor?.cgColor
        majorDashLayer.lineWidth = preference.dashLineWidth
        majorDashLayer.lineDashPattern = preference.dashLinePattern
        
        dateLineLayer.fillColor = majorXaxisLineLayer.fillColor
        dateLineLayer.strokeColor = majorXaxisLineLayer.strokeColor
        dateLineLayer.lineWidth = majorXaxisLineLayer.lineWidth
        
        trendLineLayer.fillColor = NSColor.clear.cgColor
        trendLineLayer.strokeColor = preference.timeLineColor?.cgColor
        trendLineLayer.lineWidth = preference.timeLineWidth
        
        trendFillLayer.gradientClolors = preference.timeLineFillGradientClolors
        
        trendAverageLineLayer.fillColor = NSColor.clear.cgColor
        trendAverageLineLayer.strokeColor = preference.averageLineColor?.cgColor
        trendAverageLineLayer.lineWidth = preference.averageLineWidth
        
        VOLRiseLayer.fillColor = preference.riseColor?.cgColor
        VOLRiseLayer.strokeColor = preference.riseColor?.cgColor
        VOLRiseLayer.lineWidth = preference.strokeLineWidth
        
        VOLFallLayer.fillColor = preference.fallColor?.cgColor
        VOLFallLayer.strokeColor = preference.fallColor?.cgColor
        VOLFallLayer.lineWidth = preference.strokeLineWidth
        
        VOLFlatLayer.fillColor = preference.flatColor?.cgColor
        VOLFlatLayer.strokeColor = preference.flatColor?.cgColor
        VOLFlatLayer.lineWidth = preference.strokeLineWidth
        
        trackingLineLayer.lineColor = .orange
        trackingLineLayer.lineWidth = 5
    }
    
    override func gestureInitialization() {
//        NSGestureRecognizer
        
        let singleTap = NSClickGestureRecognizer.init(target: self, action: #selector(single(tap:)))
        singleTap.delegate = self
        if #available(OSX 10.12.2, *) {
            singleTap.numberOfTouchesRequired = 1
        } else {
            // Fallback on earlier versions
            singleTap.numberOfClicksRequired = 1
        }
        self.addGestureRecognizer(singleTap)
        
        let pan = NSPanGestureRecognizer.init(target: self, action: #selector(doublesdkja(tap:)))
//        doubleTap.delaysPrimaryMouseButtonEvents = true
//        doubleTap.delaysOtherMouseButtonEvents = true
//        doubleTap.delaysSecondaryMouseButtonEvents = true
        self.addGestureRecognizer(pan)
        
        
        
//        NSMagnificationGestureRecognizer
    }
    
    open override func mouseMoved(with event: NSEvent) {
        let p = event.locationInWindow
//        print("mouseMoved is: \(event.deltaY)")
        let vapp = convert(p, from: window!.contentView)
        
        let rectss = [meas.majorChartFrame, meas.minorChartFrame]
        trackingLineLayer.updateTracking(location: vapp, in: rectss)
        
        trackingTooltipLayer.frame = meas.unionChartFrame
        trackingTooltipLayer.setText(text: "sdf", for: .left)
        trackingTooltipLayer.trackRect = meas.unionChartFrame
        trackingTooltipLayer.updateTracking(location: vapp)
        
        let ns = NSTextField()
        ns.sizeToFit()
    }
    

    
    open override func mouseDragged(with event: NSEvent) {
        print("mouseDragged")
    }
    
    public func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: NSGestureRecognizer) -> Bool {
        return false
    }
    
    open override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
    
    @objc func single(tap: NSClickGestureRecognizer) {
        print("单击哈哈哈")
    }
    
    @objc func doublesdkja(tap: NSClickGestureRecognizer) {
        print("双击了哈哈哈")
    }
    

    public func drawChart() {
        guard let list = dataList, !list.isEmpty else {
            return
        }
        
        calculated = UTimeCalculate(target: self)
        calculated.recalculate()
        
        print(calculated.pricePeakValue)
        
        updateChartLayout()
        
//        clearChart()
        
        updateMajorXlines()
        updateMajorTrendChart()
        
        updateMinorCharts()
        
        
        
        let tracking = NSTrackingArea.init(rect: bounds, options: [.mouseMoved, .activeAlways, .inVisibleRect], owner: self, userInfo: nil)
        
        self.addTrackingArea(tracking)
    
    }

    open override func updateTrackingAreas() {
        print("updateTrackingAreas--")
    }
    
    public func clearChart() {
        backgroundColor = .lightGray
        
        print("majorBriefFrame is: \(meas.majorBriefFrame)")
        majorXaxisLineLayer.path = NSBezierPath(rect: meas.majorChartFrame).cgPath
        majorXaxisLineLayer.fillColor = NSColor.orange.cgColor
        
        minorXaxisLineLayer.path = NSBezierPath(rect: meas.minorChartFrame).cgPath
        minorXaxisLineLayer.fillColor = NSColor.orange.cgColor
                
        dateLineLayer.path = NSBezierPath.init(rect: meas.datesBarFrame).cgPath
        dateLineLayer.fillColor = NSColor.blue.cgColor
    }
    
    open override func layout() {
        super.layout()
        trackingTooltipLayer.frame = meas.unionChartFrame
//        majorBriefTextLayer.frame = measurement.majorBriefFrame
//        majorBriefTextLayer.backgroundColor = NSColor.yellow.cgColor
//
//        minorBriefTextLayer.frame = measurement.minorBriefFrame
//        minorBriefTextLayer.backgroundColor = NSColor.green.cgColor
    }
    
    private func updateMeasurement() {
        
    }
    
    
    private func updateChartLayout() {
        var datesBarFrame = CGRect.zero
        var majorChartFrame = CGRect.zero, majorBriefFrame = CGRect.zero
        var minorChartFrame = CGRect.zero, minorBriefFrame = CGRect.zero
        
        // .integral - 表示原点的值向下取整，表示大小的值向上取整，可以保证绘制范围平整地对齐到像素边界
        let rect = bounds.inset(by: preference.contentInsets).integral
        let majorChartHeight = fmin(rect.height * preference.majorChartRatio, rect.height)
        
        // 计算五个区域 (区分日期栏不同位置)
        switch preference.dateBarPosition {
        case .top:
            datesBarFrame.origin = rect.origin
            datesBarFrame.size = CGSize(width: rect.width, height: preference.dateBarHeight)
            
            majorBriefFrame.origin = CGPoint(x: rect.minX, y: datesBarFrame.maxY)
            majorBriefFrame.size = CGSize(width: rect.width, height: preference.majorBriefHeight)
            
            majorChartFrame.origin = CGPoint(x: rect.minX, y: majorBriefFrame.maxY)
            majorChartFrame.size = CGSize(width: rect.width, height: majorChartHeight)
            
            minorBriefFrame.origin = CGPoint(x: rect.minX, y: majorChartFrame.maxY)
            minorBriefFrame.size = CGSize(width: rect.width, height: preference.minorBriefHeight)
            
            minorChartFrame.origin = CGPoint(x: rect.minX, y: minorBriefFrame.maxY)
            minorChartFrame.size = CGSize(width: rect.width, height: rect.maxY - minorBriefFrame.maxY)
        case .middle:
            majorBriefFrame.origin = rect.origin
            majorBriefFrame.size = CGSize(width: rect.width, height: preference.majorBriefHeight)
            
            majorChartFrame.origin = CGPoint(x: rect.minX, y: majorBriefFrame.maxY)
            majorChartFrame.size = CGSize(width: rect.width, height: majorChartHeight)
            
            datesBarFrame.origin = CGPoint(x: rect.minX, y: majorChartFrame.maxY)
            datesBarFrame.size = CGSize(width: rect.width, height: preference.dateBarHeight)
            
            minorBriefFrame.origin = CGPoint(x: rect.minX, y: datesBarFrame.maxY)
            minorBriefFrame.size = CGSize(width: rect.width, height: preference.minorBriefHeight)
            
            minorChartFrame.origin = CGPoint(x: rect.minX, y: minorBriefFrame.maxY)
            minorChartFrame.size = CGSize(width: rect.width, height: rect.maxY - minorBriefFrame.maxY)
        case .bottom:
            majorBriefFrame.origin = rect.origin
            majorBriefFrame.size = CGSize(width: rect.width, height: preference.majorBriefHeight)
            
            majorChartFrame.origin = CGPoint(x: rect.minX, y: majorBriefFrame.maxY)
            majorChartFrame.size = CGSize(width: rect.width, height: majorChartHeight)
            
            minorBriefFrame.origin = CGPoint(x: rect.minX, y: majorChartFrame.maxY)
            minorBriefFrame.size = CGSize(width: rect.width, height: preference.minorBriefHeight)
            
            minorChartFrame.origin = CGPoint(x: rect.minX, y: minorBriefFrame.maxY)
            let minorChartHeight = rect.maxY - minorBriefFrame.maxY - preference.dateBarHeight
            minorChartFrame.size = CGSize(width: rect.width, height: minorChartHeight)
            
            datesBarFrame.origin = CGPoint(x: rect.minX, y: minorChartFrame.maxY)
            datesBarFrame.size = CGSize(width: rect.width, height: preference.dateBarHeight)
        }

        /// 计算条形图宽度或间距
        if preference.shapeSpacing > 0 {
            var allSpacing = CGFloat(preference.maximumEntries - 1) * preference.shapeSpacing
            allSpacing = fmin(allSpacing, majorChartFrame.width)
            preference.shapeWidth = (majorChartFrame.width - allSpacing) / CGFloat(preference.maximumEntries)
        } else {
            var allWidth = CGFloat(preference.maximumEntries) * preference.shapeWidth
            allWidth = fmin(allWidth, majorChartFrame.width)
            preference.shapeSpacing = (majorChartFrame.width - allWidth) / CGFloat(preference.maximumEntries - 1)
        }
        
        meas.shapeWidth = preference.shapeWidth
        meas.shapeSpacing = preference.shapeSpacing
        meas.datesBarFrame = datesBarFrame
        meas.majorBriefFrame = majorBriefFrame
        meas.majorChartFrame = majorChartFrame
        meas.minorBriefFrame = minorBriefFrame
        meas.minorChartFrame = minorChartFrame
    }
    
    
    /// 绘制主图区横轴线
    private func updateMajorXlines() {
        let leftValues = calculated.pricePeakValue
            .takeXaxisLine(preference.majorNumberOfLines) { (_, doubleValue) -> String in
                return String(format: "%.*lf", preference.decimalKeepPlace, doubleValue)
        }
        
        let rightValues = calculated.changeRatePeakValue
            .takeXaxisLine(preference.majorNumberOfLines) { (_, doubleValue) -> String in
                return String(format: "%.*lf", 6, doubleValue)
        }
        
        // 横轴线间距
        let spacing = meas.majorChartFrame.height / CGFloat(leftValues.count - 1)
        let originY = meas.majorChartFrame.minY + preference.gridLineWidth/2
        
        // 计算参考线位置
        let distance = calculated.changeRatePeakValue.distance
        guard distance.isValid else { return }
        let percentage = calculated.changeRatePeakValue.max / distance
        let dashY = originY + meas.majorChartFrame.height * percentage.cgFloat
        
        // 浮动颜色
        func floatedColor(by current: CGFloat) -> NSColor? {
            if current < dashY {
                return preference.riseColor
            } else if current > dashY {
                return preference.fallColor
            } else {
                return preference.plainTextColor
            }
        }
        
        // 绘制参考线
        let dash = NSBezierPath()
        let dasp = CGPoint(x: meas.majorChartFrame.minX, y: dashY)
        dash.addLine(horizontal: dasp, length: meas.majorChartFrame.width)
        majorDashLayer.path = dash.cgPath
        
        // 绘制横轴线和文本
        let path = NSBezierPath()
        var renders = [UTextRender]()
        for (index, text) in leftValues.enumerated() {
            let start = CGPoint(x: meas.majorChartFrame.minX, y: originY + spacing * CGFloat(index))
            path.addLine(horizontal: start, length: meas.majorChartFrame.width)
            
            var leftRender = UTextRender()
            leftRender.text = text
            leftRender.font = NSFont.systemFont(ofSize: 22)
            leftRender.color = floatedColor(by: start.y)
//            leftRender.backgroundColor = .orange
            leftRender.position = start
            leftRender.positionOffset = CGPoint(x: 0, y: index > 0 ? 1 : 0)
            renders.append(leftRender)
            
            var rightRender = UTextRender()
            let s = rightValues[index]
            let doubleValue = Double(s)
            rightRender.text = "\(doubleValue)"
            rightRender.font = NSFont.systemFont(ofSize: 22)
            rightRender.color = floatedColor(by: start.y)
//            rightRender.backgroundColor = .orange
            rightRender.position = CGPoint(x: start.x + meas.majorChartFrame.width, y: start.y)
            rightRender.positionOffset = CGPoint(x: 1, y: index > 0 ? 1 : 0)
            renders.append(rightRender)
        }
        
        majorXaxisLineLayer.path = path.cgPath
        majorXaxisTextLayer.renders = renders
        
//
//        let tefe = NSTextField.init(string: "2880.33")
//        tefe.backgroundColor = .white
//        tefe.textColor = .black
//        tefe.isBezeled = false
//        tefe.font = NSFont.systemFont(ofSize: 22)
//        tefe.frame = CGRect(x: 9, y: 150, width: 100, height: 50)
//        addSubview(tefe)
    }
    
    func updateMajorTrendChart() {
        let yaxis = yaxisMake(calculated.pricePeakValue, meas.majorChartFrame)
        let firstObj = dataList!.first!
        var priceY = yaxis(calculated.pricePeakValue.limited(calculated.referenceValue))
        let averageY = yaxis(calculated.pricePeakValue.limited(firstObj._averagePrice))

        let fromPath = CGMutablePath()
        let path1 = CGMutablePath()
        let path2 = CGMutablePath()
        /// 路径动画：fromPath必须和toPath绘线点一致，动画才能平滑显示
        fromPath.move(to: CGPoint(x: meas.majorChartFrame.minX, y: priceY))
        path1.move(to: CGPoint(x: meas.majorChartFrame.minX, y: priceY))
        path2.move(to: CGPoint(x: meas.majorChartFrame.minX, y: averageY))
    
        for (index, element) in dataList!.enumerated() {
            let centerX = meas.xaixs(by: index)
            let latestValue = calculated.pricePeakValue.limited(element._latestPrice)
            let averageValue = calculated.pricePeakValue.limited(element._averagePrice)
            let latestY = yaxis(latestValue)
            if index < 2 {
                priceY = latestY
            }
            let averageY = yaxis(averageValue)
            path1.addLine(to: CGPoint(x: centerX, y: latestY))
            fromPath.addLine(to: CGPoint(x: centerX, y: meas.majorChartFrame.maxY))
            path2.addLine(to: CGPoint(x: centerX, y: averageY))
        }
        
        trendLineLayer.path = path1
        trendAverageLineLayer.path = path2
        
        let endX = meas.xaixs(by: dataList!.count - 1)
        /// 绘制走势渐变填充
        let fillPath = CGMutablePath.init()
        fillPath.addPath(path1)
        fillPath.addLine(to: CGPoint(x: endX, y: meas.majorChartFrame.maxY))
        fillPath.addLine(to: CGPoint(x: meas.majorChartFrame.minX, y: meas.majorChartFrame.maxY))
        fillPath.closeSubpath()
        
        /// 绘制走势渐变填充
        let fromPath22 = CGMutablePath.init()
        fromPath22.addPath(fromPath)
        fromPath22.addLine(to: CGPoint(x: endX, y: meas.majorChartFrame.maxY))
        fromPath22.addLine(to: CGPoint(x: meas.majorChartFrame.minX, y: meas.majorChartFrame.maxY))
        fromPath22.closeSubpath()
        
        let testL = CAShapeLayer()
        testL.strokeColor = NSColor.blue.cgColor
        testL.fillColor = NSColor.clear.cgColor
        testL.lineWidth = 5
        testL.path = fillPath
        chartContainerLayer.addSublayer(testL)
        
        
        
//        return
        trendFillLayer.isDisablePathActions = false
        let colors = NSColor.init(red: 62/255.0, green: 141/255.0, blue: 247/255.0, alpha: 1)
        trendFillLayer.gradientClolors = [colors.withAlphaComponent(0.3), colors.withAlphaComponent(0.1)]
        trendFillLayer.gradientDirection = .topToBottom
        
//        UToolTipView
//        UCrosslineView
        
//        let fromPath = CGMutablePath.init()
//        fromPath.move(to: CGPoint(x: meas.majorChartFrame.minX, y: priceY))
//        fromPath.addLine(to: CGPoint(x: meas.majorChartFrame.minX, y: priceY))
//        fromPath.addLine(to: CGPoint(x: meas.majorChartFrame.minX, y: priceY))
//        fromPath.addLine(to: CGPoint(x: meas.majorChartFrame.minX, y: meas.majorChartFrame.maxY))
//        fromPath.addLine(to: CGPoint(x: meas.majorChartFrame.minX, y: meas.majorChartFrame.maxY))
//        fromPath.closeSubpath()
//        fillPath.addLine(to: CGPoint(x: 15, y: priceY))
//        fromPath.addLine(to: CGPoint(x: 50, y: meas.majorChartFrame.maxY))
//        fromPath.addLine(to: CGPoint(x: meas.majorChartFrame.minX, y: meas.majorChartFrame.maxY))
//        fromPath.closeSubpath()
        
//        trendFillLayer._oldPath = fromPath
        trendFillLayer.gradientPath = fromPath22
        
        let toPath = CGMutablePath.init()
        toPath.move(to: CGPoint(x: meas.majorChartFrame.minX, y: priceY))
        toPath.addLine(to: CGPoint(x: 100, y: priceY+20))
        toPath.addLine(to: CGPoint(x: 200, y: priceY-50))
        toPath.addLine(to: CGPoint(x: 200, y: meas.majorChartFrame.maxY))
        toPath.addLine(to: CGPoint(x: meas.majorChartFrame.minX, y: meas.majorChartFrame.maxY))
        toPath.closeSubpath()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.trendFillLayer.gradientPath = fillPath
        })
    }
    
    func updateMinorCharts() {
        let yaxis = yaxisMake(calculated.volumePeakValue, meas.minorChartFrame)
        var referenceValue = calculated.referenceValue
        
        let risePath = CGMutablePath()
        let fallPath = CGMutablePath()
        let flatPath = CGMutablePath()
        
        for (index, element) in dataList!.enumerated() {
            let x = meas.minxaixs(by: index)
            let y = yaxis(element._volume)
            let r = CGRect(x: x, y: y,
                           width: meas.shapeWidth,
                           height: meas.minorChartFrame.maxY - y)
            
//            if index > 0 {
//                referenceValue = dataList![index - 1]._latestPrice
//            }
            
            if element._latestPrice > referenceValue {
                risePath.addRect(r)
            } else if element._averagePrice < referenceValue {
                fallPath.addRect(r)
            } else {
                flatPath.addRect(r)
            }
        }
        
        VOLRiseLayer.path = risePath
        VOLFallLayer.path = fallPath
        VOLFlatLayer.path = flatPath
    }
}


// MARK: - UTimeBase

open class UTimeBase: UBaseView {
    
    private(set) var chartContainerLayer: UBaseLayer!
    private(set) var textContainerLayer: UBaseLayer!
    private(set) var containerView: UBaseView!
    
    override func initialization() {
        super.initialization()
        
        containerView = UBaseView()
        addSubview(containerView)
        
        chartContainerLayer = UBaseLayer()
        containerView.layer?.addSublayer(chartContainerLayer)
        
        textContainerLayer = UBaseLayer()
        containerView.layer?.addSublayer(textContainerLayer)
        
        defaultInitialization()
        sublayerInitialization()
        gestureInitialization()
    }
    
    open override func layout() {
        super.layout()
        containerView.frame = bounds
        chartContainerLayer.sublayers?.forEach({ $0.frame = bounds })
        textContainerLayer.sublayers?.forEach({ $0.frame = bounds })
    }

    fileprivate func defaultInitialization() {}

    fileprivate func sublayerInitialization() {}

    fileprivate func gestureInitialization() {}
}












//open class UTimeLayer: UBaseLayer {
//
//    /// 主图区横轴网格线
//    private var majorXaxisLineLayer: CAShapeLayer!
//    /// 主图区x轴文本
//    private var majorXaxisTextLayer: UTextLayer!
//
//    override func initialization() {
//        super.initialization()
//
//        majorXaxisLineLayer = CAShapeLayer.init()
//        majorXaxisLineLayer.fillColor = NSUIColor.cyan.cgColor
//        majorXaxisLineLayer.strokeColor = NSUIColor.red.cgColor
//        majorXaxisLineLayer.lineWidth = 2
//        addSublayer(majorXaxisLineLayer)
//
//
//        let path = CGMutablePath.init()
//        path.move(to: CGPoint(x: 10, y: 100))
//        path.addLine(to: CGPoint(x: 100, y: 10))
//        path.addLine(to: CGPoint(x: 200, y: 150))
//        path.closeSubpath()
//
//        majorXaxisLineLayer.path = path
//
//        majorXaxisTextLayer = UTextLayer()
//        addSublayer(majorXaxisTextLayer)
//    }
//
//
//    open override func layoutSublayers() {
//        super.layoutSublayers()
//        majorXaxisTextLayer.frame = bounds
//    }
//
//    public func drawChart() {
//
//        let leftValues = ["256.9", "25.990万元", "AOP指标"]
//        var renders = [UTextRender]()
//        for (index, text) in leftValues.enumerated() {
//            let start = CGPoint(x: 10, y: 20 + 100 * CGFloat(index))
//
//            var leftRender = UTextRender()
//            leftRender.text = text
//            leftRender.font = NSFont.systemFont(ofSize: 22)
//            leftRender.color = .yellow
//            leftRender.backgroundColor = .orange
//            leftRender.position = start
//            leftRender.positionOffset = CGPoint(x: 0, y: index > 0 ? 1 : 0)
//            renders.append(leftRender)
//        }
//
//        majorXaxisTextLayer.renders = renders
//    }
//}
//
