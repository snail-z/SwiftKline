//
//  UTimeView.swift
//  swiftKline
//
//  Created by zhanghao on 2020/10/22.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import UIKit

public protocol UTimeViewExternalUse {
    /// 设置分时图样式
    var preference: UTimePreferences! { get set }
    /// 设置走势数据
    var dataList: [UTimeDataSource]? { get set }
    /// 设置数值参考系
    var frameReference: UTimeFrameReference? { get set }
    /// 绘制图表数据
    func drawChart()
    /// 清空图表数据
    func clearChart()
}

open class UTimeView: UTimeBase, UTimeViewExternalUse {
    
    /// 主图区横轴网格线
    private var majorXaxisLineLayer: UShapeLayer!
    /// 副图区横轴网格线
    private var minorXaxisLineLayer: UShapeLayer!
    /// 主图区价格参考线
    private var majorDashLayer: UShapeLayer!
    /// 日期时间线
    private var dateLineLayer: UShapeLayer!
    /// 时间线文本
    private var dateLineTextLayer: UTextLayer!
    /// 主图区x轴文本
    private var majorXaxisTextLayer: UTextLayer!
    /// 副图区x轴文本
    private var minorXaxisTextLayer: UTextLayer!
    /// 主图区数据文本
    private var majorBriefTextLayer: UTextLayer!
    /// 副图区数据文本
    private var minorBriefTextLayer: UTextLayer!
    /// 计算结果
    private var calculation: UTimeCalculation!
    /// 外观样式
    public var preference: UTimePreferences! = UTimePreferences()
    /// 走势列表
    public var dataList: [UTimeDataSource]?
    /// 数值参考系
    public var frameReference: UTimeFrameReference?
    
    override func defaultInitialization() {        
        majorXaxisLineLayer = UShapeLayer()
        chartContainerLayer.addSublayer(majorXaxisLineLayer)
        
        minorXaxisLineLayer = UShapeLayer()
        chartContainerLayer.addSublayer(minorXaxisLineLayer)
        
        majorDashLayer = UShapeLayer()
        chartContainerLayer.addSublayer(majorDashLayer)
        
        dateLineLayer = UShapeLayer()
        chartContainerLayer.addSublayer(dateLineLayer)
        
        dateLineTextLayer = UTextLayer()
        textContainerLayer.addSublayer(dateLineTextLayer)
        
        majorXaxisTextLayer = UTextLayer()
        textContainerLayer.addSublayer(majorXaxisTextLayer)
        
        minorXaxisTextLayer = UTextLayer()
        textContainerLayer.addSublayer(minorXaxisTextLayer)
        
        majorBriefTextLayer = UTextLayer()
        textContainerLayer.addSublayer(majorBriefTextLayer)
        
        minorBriefTextLayer = UTextLayer()
        textContainerLayer.addSublayer(minorBriefTextLayer)
    }
    
    override func sublayerInitialization() {
        majorXaxisLineLayer.fillColor = UIColor.clear.cgColor
        majorXaxisLineLayer.strokeColor = preference.gridLineColor?.cgColor
        majorXaxisLineLayer.lineWidth = preference.gridLineWidth
        
        minorXaxisLineLayer.fillColor = majorXaxisLineLayer.fillColor
        minorXaxisLineLayer.strokeColor = majorXaxisLineLayer.strokeColor
        minorXaxisLineLayer.lineWidth = majorXaxisLineLayer.lineWidth
        
        majorDashLayer.fillColor = UIColor.clear.cgColor
        majorDashLayer.strokeColor = preference.dashLineColor?.cgColor
        majorDashLayer.lineWidth = preference.dashLineWidth
        majorDashLayer.lineDashPattern = preference.dashLinePattern
        
        dateLineLayer.fillColor = majorXaxisLineLayer.fillColor
        dateLineLayer.strokeColor = majorXaxisLineLayer.strokeColor
        dateLineLayer.lineWidth = majorXaxisLineLayer.lineWidth
    }

    override func gestureInitialization() {
        
    }
    
    public func drawChart() {
        guard let list = dataList, !list.isEmpty else {
            return
        }
        
        calculation = UTimeCalculation(target: self)
        calculation.recalculate()
        
        print(calculation.pricePeakValue)
        
        updateChartLayout()
        
        drawMajorXlines()
        drawMinorXlines()
        drawDateLines()
        
        
//        updateLayout
        
//        majorXaxisLineLayer.path
        
//        floatedColor(by: 90, reference: 90)
    }
    
    /// 绘制主图区横轴线
    func drawMajorXlines() {
        let leftValues = calculation.pricePeakValue
            .takeXaxisLine(preference.majorNumberOfLines) { (_, doubleValue) -> String in
                return String(format: "%.*lf", preference.decimalKeepPlace, doubleValue)
        }
        
        let rightValues = calculation.changeRatePeakValue
            .takeXaxisLine(preference.majorNumberOfLines) { (_, doubleValue) -> String in
                return String(format: "%.*lf", 6, doubleValue)
        }
        
        // 横轴线间距
        let spacing = measurement.majorChartFrame.height / CGFloat(leftValues.count - 1)
        let originY = measurement.majorChartFrame.minY + preference.gridLineWidth/2
        
        // 计算参考线位置
        let distance = calculation.changeRatePeakValue.distance
        guard distance.isValid else { return }
        let percentage = calculation.changeRatePeakValue.max / distance
        let dashY = originY + measurement.majorChartFrame.height * percentage.cgFloat
        
        // 浮动颜色
        func floatedColor(by current: CGFloat) -> UIColor? {
            if current < dashY { return preference.riseColor
            } else if current > dashY { return preference.fallColor
            } else { return preference.plainTextColor }
        }
        
        // 绘制参考线
        let dash = UIBezierPath()
        let dasp = CGPoint(x: measurement.majorChartFrame.minX, y: dashY)
        dash.addLine(horizontal: dasp, length: measurement.majorChartFrame.width)
        majorDashLayer.path = dash.cgPath
        
        // 绘制横轴线和文本
        let path = UIBezierPath()
        var renders = [UTextRender]()
        for (index, text) in leftValues.enumerated() {
            let start = CGPoint(x: measurement.majorChartFrame.minX, y: originY + spacing * CGFloat(index))
            path.addLine(horizontal: start, length: measurement.majorChartFrame.width)
            
            var leftRender = UTextRender()
            leftRender.text = text
            leftRender.font = UIFont.systemFont(ofSize: 22)
            leftRender.color = floatedColor(by: start.y)
            leftRender.backgroundColor = .orange
            leftRender.position = start
            leftRender.positionOffset = CGPoint(x: 0, y: index > 0 ? 1 : 0)
            renders.append(leftRender)
            
            var rightRender = UTextRender()
            let doubleValue = rightValues[index].pk.toDouble()
            rightRender.text = doubleValue?.pk.stringValuePercent()
            rightRender.font = UIFont.systemFont(ofSize: 22)
            rightRender.color = floatedColor(by: start.y)
            rightRender.backgroundColor = .orange
            rightRender.position = CGPoint(x: start.x + measurement.majorChartFrame.width, y: start.y)
            rightRender.positionOffset = CGPoint(x: 1, y: index > 0 ? 1 : 0)
            renders.append(rightRender)
        }
        
        majorXaxisLineLayer.path = path.cgPath
        majorXaxisTextLayer.renders = renders
    }
    
    /// 绘制副图区横轴线
    func drawMinorXlines() {
        let leftValues = calculation.volumePeakValue
            .takeXaxisLine(preference.minorNumberOfLines) { (_, doubleValue) -> String in
                return doubleValue.pk.stringValueShortened(reserved: preference.decimalKeepPlace)
        }
        
        // 横轴线间距
        let spacing = measurement.minorChartFrame.height / CGFloat(leftValues.count - 1)
        let startY = measurement.minorChartFrame.minY + preference.gridLineWidth/2
        
        // 绘制横轴线
        let path = UIBezierPath()
        for index in 0..<leftValues.count {
            let start = CGPoint(x: measurement.minorChartFrame.minX, y: startY + spacing * CGFloat(index))
            path.addLine(horizontal: start, length: measurement.minorChartFrame.width)
        }
        minorXaxisLineLayer.path = path.cgPath
        
        // 绘制横轴线坐标文本
        var renders = [UTextRender]()
        var leftRender = UTextRender()
        leftRender.text = leftValues.first
        leftRender.font = preference.plainTextFont
        leftRender.color = preference.plainTextColor
        leftRender.backgroundColor = .orange
        leftRender.position = measurement.minorChartFrame.origin
        leftRender.positionOffset = .zero
        renders.append(leftRender)
        minorXaxisTextLayer.renders = renders
    }
    
    /// 绘制日期线
    func drawDateLines() {
        
    }
    
    
    private(set) var datesBarFrame = CGRect.zero
    private(set) var majorBriefFrame = CGRect.zero
    private(set) var minorBriefFrame = CGRect.zero
    private(set) var majorChartFrame = CGRect.zero
    private(set) var minorChartFrame = CGRect.zero

    private func updateChartLayout() {
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
        
        measurement.shapeWidth = preference.shapeWidth
        measurement.shapeSpacing = preference.shapeSpacing
        measurement.datesBarFrame = datesBarFrame
        measurement.majorBriefFrame = majorBriefFrame
        measurement.majorChartFrame = majorChartFrame
        measurement.minorBriefFrame = minorBriefFrame
        measurement.minorChartFrame = minorChartFrame
    }

    var measurement = UMeasurement()
    
    func drawGridLines() {
        
    }
    
    public func clearChart() {
//        majorXaxisLineLayer.path = UIBezierPath.init(rect: majorChartFrame).cgPath
//        majorXaxisLayer.fillColor = UIColor.orange.cgColor
//
//        minorXaxisLayer.path = UIBezierPath.init(rect: minorChartFrame).cgPath
//        minorXaxisLayer.fillColor = UIColor.orange.cgColor
        
        dateLineLayer.path = UIBezierPath.init(rect: datesBarFrame).cgPath
        dateLineLayer.fillColor = UIColor.blue.cgColor
        
//        majorBriefLabel.frame = majorBriefFrame
//        majorBriefLabel.backgroundColor = UIColor.red
//
//        minorBriefLabel.frame = minorBriefFrame
//        minorBriefLabel.backgroundColor = UIColor.green
    }
    
//    calculation.pricePeakValue
}

extension UTimeView {
    
    private func _pricePeakValue() -> UPeakValue {
        
        return UPeakValue(max: 27.5, min: 18.6)
    }
    
    private func _volumePeakValue() -> UPeakValue {
        
        return UPeakValue(max: 1938, min: 11)
    }
}


open class UTimeBase: UBaseView {
    
    private(set) var chartContainerLayer: UBaseLayer!
    private(set) var textContainerLayer: UBaseLayer!
    private(set) var containerView: UIView!
    
    override func initialization() {
        super.initialization()
        
        containerView = UIView()
        addSubview(containerView)
        
        chartContainerLayer = UBaseLayer()
        containerView.layer.addSublayer(chartContainerLayer)
        
        textContainerLayer = UBaseLayer()
        containerView.layer.addSublayer(textContainerLayer)
        
        defaultInitialization()
        sublayerInitialization()
        gestureInitialization()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        containerView.frame = bounds
        chartContainerLayer.sublayers?.forEach({ $0.frame = bounds })
        textContainerLayer.sublayers?.forEach({ $0.frame = bounds })
    }
    
    fileprivate func defaultInitialization() {}
    
    fileprivate func sublayerInitialization() {}
        
    fileprivate func gestureInitialization() {}
}
