//
//  UKlineView.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/12/1.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

open class UKlineView: UKlineBase, UKlineViewInterface {
    
    public var preference: UKlinePreferences!
    
    public var dataList: [UKlineDataSource]!
    
    var calculate: UKlineCalculate!
    
    override func defaultInitialization() {
        calculate = UKlineCalculate.init(target: self)
        
//        scrollView.contentView.postsBoundsChangedNotifications = true
//        NotificationCenter.default.addObserver(self, selector: #selector(boundsChange), name: NSView.boundsDidChangeNotification, object: scrollView.contentView)
    }
    
    public func drawChart() {
        guard let values = dataList, !values.isEmpty else {
            return
        }
        
        updateChartLayout()
        
        calculate.recalculate()
    }
    
    
    var riseKlineLayer: UShapeLayer!
    var fallKlineLayer: UShapeLayer!
    var flatKlineLayer: UShapeLayer!
    
    var aixsXTextLayer: UTextLayer!
    var progressLayer: UShapeLayer!
    
    override func sublayerInitialization() {
        riseKlineLayer = UShapeLayer()
        chartContainerLayer.addSublayer(riseKlineLayer)
        
        fallKlineLayer = UShapeLayer()
        chartContainerLayer.addSublayer(fallKlineLayer)
        
        flatKlineLayer = UShapeLayer()
        chartContainerLayer.addSublayer(flatKlineLayer)
    }
    
    private func updateChartLayout() {
        var datesBarFrame = CGRect.zero
        var majorChartFrame = CGRect.zero, majorBriefFrame = CGRect.zero
        var minorChartFrame = CGRect.zero, minorBriefFrame = CGRect.zero
        
        // .integral - 表示原点的值向下取整，表示大小的值向上取整，可以保证绘制范围平整地对齐到像素边界
        let rect = bounds.inset(by: preference.contentEdgeInsets).integral
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
        
        
//        /// 计算条形图宽度或间距
//        if preference.shapeSpacing > 0 {
//            var allSpacing = CGFloat(preference.maximumNumberOfEntries - 1) * preference.shapeSpacing
//            allSpacing = fmin(allSpacing, majorChartFrame.width)
//            preference.shapeWidth = (majorChartFrame.width - allSpacing) / CGFloat(preference.maximumNumberOfEntries)
//        } else {
//            var allWidth = CGFloat(preference.maximumNumberOfEntries) * preference.shapeWidth
//            allWidth = fmin(allWidth, majorChartFrame.width)
//            preference.shapeSpacing = (majorChartFrame.width - allWidth) / CGFloat(preference.maximumNumberOfEntries - 1)
//        }
//
        
        
        meas.shapeSpacing = preference.shapeSpacing
        meas.strokeWidth = preference.shapeStrokeWidth
        meas.datesBarFrame = datesBarFrame
        meas.majorBriefFrame = majorBriefFrame
        meas.majorChartFrame = majorChartFrame
//        meas.minorBriefFrame = minorBriefFrame
//        meas.minorChartFrame = minorChartFrame
        
        let testlyaer = CAShapeLayer()
        testlyaer.fillColor = NSColor.gray.cgColor
        let pss = CGMutablePath()
        pss.addRect(majorChartFrame)
        testlyaer.path = pss
        chartContainerLayer.insertSublayer(testlyaer, below: riseKlineLayer)
        
        updateCWidth()
    }
    
    public func clearChart() {
        
    }
    
    /// 绘制区测量
    public private(set) var meas = UKlineMeasurement()
    
    /// 计算滚动范围
    func updateCWidth() {
        riseKlineLayer.fillColor = NSColor.red.cgColor
        riseKlineLayer.strokeColor = NSColor.red.cgColor
        riseKlineLayer.lineWidth = preference.shapeStrokeWidth
        
        fallKlineLayer.fillColor = NSColor.green.cgColor
        fallKlineLayer.strokeColor = NSColor.green.cgColor
        fallKlineLayer.lineWidth = preference.shapeStrokeWidth
        
        flatKlineLayer.fillColor = NSColor.gray.cgColor
        flatKlineLayer.strokeColor = NSColor.gray.cgColor
        flatKlineLayer.lineWidth = preference.shapeStrokeWidth
        
        
//        let testpath = CGMutablePath()
//        testpath.addRect(meas.majorChartFrame)
//        riseKlineLayer.path = testpath
//        return
        
        let value = scrollView.contentSize
        print("value is: \(value)")
        
        meas.adjustSpacingToMakeLegalWidth(by: preference.numberOfKlines)
        
        let shapeWidth = meas.shapeWidth
        
        print("shapeWidth is: \(shapeWidth)")
        print("self.description is: \(meas.descriptions)")
        
        
        let contentWidth = (shapeWidth + meas.shapeSpacing) * CGFloat(dataList.count) - meas.shapeSpacing
        scrollView.documentSize = CGSize(width: contentWidth, height: scrollView.frame.height)
        print("scrollView documentSize is: \(scrollView.documentSize)")
        
        print("scrollView contentView is: \(scrollView.contentView)")
        print("scrollView documentSize is: \(scrollView.documentView)")

        
        
//        NotificationCenter.default.removeObserver(self)
        
        
       
        
        
        let drawRange = calculate.rangeOfDrawn()
        let visualRange = calculate.rangeOfCalculated()
        
        // 主图区域极值
        let peakIndexValue = calculate.peakIndexValue(at: visualRange)
        
        // 整合叠加指标的极值
        
        // 判断极值的有效性
        if !peakIndexValue.isValid {
            print("peakIndexValue 无效!!")
        }
        
        print("drawRange is: \(drawRange)")
        print("visualRange is: \(visualRange)")
        print("peakIndexValue is: \(peakIndexValue)")
        
        let enlargedValue = calculate.enlargedPeakValue(peakIndexValue.pureValue)
        print("enlargedValue is: \(enlargedValue)")
        
        let risePath = CGMutablePath()
        let fallPath = CGMutablePath()
        let flatPath = CGMutablePath()
        
        
        let yaxis = yaxisMake(enlargedValue, meas.majorChartFrame)
        
        dataList.forEach(at: drawRange) { (index, element) in
            let highY = yaxis(element._highPrice)
            let lowY = yaxis(element._lowPrice)
            let openY = yaxis(element._openPrice)
            let closeY = yaxis(element._closePrice)
            let centerX = meas.midxaixs(by: index)
            
            let klineWidth = meas.shapeWidth - meas.strokeWidth
            let originX = centerX - meas.shapeWidth * 0.5
            let originY = min(openY, closeY)
            let klineHeight = abs(openY - closeY)
            
            let top = CGPoint(x: centerX, y: highY)
            let bottom = CGPoint(x: centerX, y: lowY)
            let rect = CGRect(x: originX, y: originY, width: klineWidth, height: klineHeight)
            
            let shape = UCandleShape(top: top, rect: rect, bottom: bottom)
            
            if element._openPrice < element._closePrice {
                risePath.addCandle(shape)
            } else if element._openPrice > element._closePrice {
                fallPath.addCandle(shape)
            } else {
                flatPath.addCandle(shape)
            }
        }
        
        riseKlineLayer.path = risePath
        fallKlineLayer.path = fallPath
        flatKlineLayer.path = flatPath
        
        
//        aixsXTextLayer = UTextLayer()
//        aixsXTextLayer.text = "呼呼呼哈哈"
//        aixsXTextLayer.textColor = .red
//        aixsXTextLayer.font = .systemFont(ofSize: 20)
//        textContainerLayer.addSublayer(aixsXTextLayer)
//
        
        
//        progressLayer = UShapeLayer()
//        progressLayer.fillColor = NSColor.red.cgColor
//        progressLayer.strokeColor = NSColor.white.cgColor
//        progressLayer.lineWidth = 5
//        chartContainerLayer.addSublayer(progressLayer)
//
//        progressLayer.frame = CGRect(x: 50, y: 100, width: 200, height: 100)
//        progressLayer.backgroundColor = NSColor.darkGray.cgColor
//        let pasth = CGMutablePath()
//        let rect = CGRect(x: 10, y: 10, width: 150, height: 50)
//        pasth.addRoundedRect(in: rect, cornerWidth: 10, cornerHeight: 10)
//        progressLayer.lineCap = .round
//        progressLayer.path = pasth
//
//        let maskLayer = CAShapeLayer()
//        maskLayer.fillColor = NSColor.white.cgColor
//        maskLayer.strokeColor = NSColor.white.cgColor
//        maskLayer.lineWidth = 5
//
//        let pasth2 = CGMutablePath()
//        pasth2.addRoundedRect(in: rect, cornerWidth: 10, cornerHeight: 10)
//        maskLayer.path = pasth2
//        progressLayer.mask = maskLayer


//        let prLayer = UProgress2Layer()
//        prLayer.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
//        prLayer.backgroundColor = NSColor.brown.cgColor
//        prLayer.trackColor = NSColor.red
//        prLayer.cornerRadius = 10
//
//        chartContainerLayer.addSublayer(prLayer)
//        prLayer.setProgress(1, animated: true)
    }
    
    @objc func boundsChange(noti: Notification) {
        
        let _contentViewOffset = scrollView.contentView.bounds.origin
        print("_contentViewOffset is: \(_contentViewOffset)")
        
//        //Set the scroll offset from the retrieved point:
//        NSPoint scrollPoint = [scrollView.contentView convertPoint:_contentViewOffset toView:scrollView.documentView];
//        [scrollView.documentView scrollPoint:scrollPoint];
        
        if let cliV = noti.object as? NSClipView {
            print("boundsChange==> \(cliV.documentVisibleRect)")
            print("boundsChange==> \(cliV.bounds)")
        }
        
//        let clidp = scrollView.contentView.documentRect
//        print("clidp is: \(clidp)")
//
//        let docum = scrollView.documentView!
//        print("docum is: \(docum.bounds)")
        drawChart()
    }
    
    
    func shapeWidthLoop(_ numbers: Int) {
        
    }
}

// MARK: - UKlineBase

open class UKlineBase: UBaseView, UBaseScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UBaseScrollView) {
        print("收到了副科级第三方老师打开")
    }

    private(set) var gridContainerLayer: UBaseLayer!
    private(set) var chartContainerLayer: UBaseLayer!
    private(set) var textContainerLayer: UBaseLayer!
    private(set) var containerView: UBaseView!
    
    private(set) var scrollView: UBaseScrollView!
    
    final override func initialization() {
        super.initialization()
        containerView = UBaseView()
        addSubview(containerView)
        
        scrollView = UBaseScrollView()
        scrollView.delegate = self
        scrollView.contentInsets = .zero
        scrollView.horizontalScrollElasticity = .none
        scrollView.scrollerStyle = .legacy
        scrollView.scrollerKnobStyle = .dark
        scrollView.hasHorizontalScroller = true
        scrollView.isScrollEnabled = true
        scrollView.documentSize = CGSize(width: 2000, height: 2000)
        containerView.addSubview(scrollView)
        
        chartContainerLayer = UBaseLayer()
        scrollView.documentView?.layer?.addSublayer(chartContainerLayer)
        
        textContainerLayer = UBaseLayer()
        scrollView.documentView?.layer?.addSublayer(textContainerLayer)
        
        defaultInitialization()
        sublayerInitialization()
        gestureInitialization()
    }
    
    open override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        scrollView.contentView.frame = bounds
        scrollView.frame = bounds
        
        scrollView.contentView.frame = bounds
        scrollView.frame = bounds
        
        containerView.frame = bounds
//        chartContainerLayer.sublayers?.forEach({ $0.frame = bounds })
//        textContainerLayer.sublayers?.forEach({ $0.frame = bounds })
    }
    
    open override func resize(withOldSuperviewSize oldSize: NSSize) {
        super.resize(withOldSuperviewSize: oldSize)
        scrollView.contentView.frame = bounds
        scrollView.frame = bounds
        
        scrollView.contentView.frame = bounds
        scrollView.frame = bounds
        
        containerView.frame = bounds
//        chartContainerLayer.sublayers?.forEach({ $0.frame = bounds })
//        textContainerLayer.sublayers?.forEach({ $0.frame = bounds })
    }
    
    open override func layout() {
        super.layout()
        scrollView.contentView.frame = bounds
        scrollView.frame = bounds
        
        containerView.frame = bounds
//        chartContainerLayer.sublayers?.forEach({ $0.frame = bounds })
//        textContainerLayer.sublayers?.forEach({ $0.frame = bounds })
    }

    fileprivate func defaultInitialization() {}

    fileprivate func sublayerInitialization() {}

    fileprivate func gestureInitialization() {}
}
