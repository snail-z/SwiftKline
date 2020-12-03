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
    
    public func drawChart() {
        guard let values = dataList, !values.isEmpty else {
            return
        }
        updateCWidth()
    }
    
    public func clearChart() {
        
    }
    
    /// 绘制区测量
    public private(set) var meas = UKlineMeasurement()
    
    /// 计算滚动范围
    func updateCWidth() {
        let value = scrollView.contentSize
        print("value is: \(value)")
        
        let shapeWidth: CGFloat = 10
        let shapeGap: CGFloat = 2
        
        let contentWidth = (shapeWidth + shapeGap) * CGFloat(dataList.count) - shapeGap
        scrollView.documentSize = CGSize(width: contentWidth, height: scrollView.frame.height)
        print("scrollView documentSize is: \(scrollView.documentSize)")
        
        scrollView.contentView.postsBoundsChangedNotifications = true
        NotificationCenter.default.addObserver(self, selector: #selector(boundsChange), name: NSView.boundsDidChangeNotification, object: scrollView.contentView)
        
//        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func boundsChange(noti: Notification) {
        
        let _contentViewOffset = scrollView.contentView.bounds.origin
        print("_contentViewOffset is: \(_contentViewOffset)")
        
//        //Set the scroll offset from the retrieved point:
//        NSPoint scrollPoint = [scrollView.contentView convertPoint:_contentViewOffset toView:scrollView.documentView];
//        [scrollView.documentView scrollPoint:scrollPoint];
        
        if let cliV = noti.object as? NSClipView {
            print("boundsChange==> \(cliV.documentVisibleRect)")
            
        }
    }
    
    
    func shapeWidthLoop(_ numbers: Int) {
        
    }
}

extension UKlineView {
    
}

// MARK: - UKlineBase

open class UBaseScrollView: NSScrollView {
    
    /// 是否隐藏所有滚动条，默认true
    public var hideScrollers: Bool = true {
        didSet {
            scrollersHidden(hideScrollers)
        }
    }
    
    /// 是否允许滚动，默认false
    public var isScrollEnabled: Bool = false
    
    /// 设置视图滚动范围
    public var documentSize: CGSize {
        get {
            return backedView.bounds.size
        } set {
            backedView.frame = CGRect(origin: .zero, size: newValue)
        }
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialization()
    }
    
    public required init?(coder: NSCoder) {
        super.init(frame: .zero)
        initialization()
    }
    
    private var backedView: UBaseView!
    
    internal func initialization() {
        hideScrollers = true
        backedView = UBaseView()
        backedView.frame = bounds
        backedView.backgroundColor = .yellow
        documentView = backedView
    }
    
    private func scrollersHidden(_ hidden: Bool) {
        hasHorizontalScroller = !hidden
        hasVerticalScroller = !hidden
    }
    
    open override func scrollWheel(with event: NSEvent) {
        if isScrollEnabled {
            super.scrollWheel(with: event)
        } else {
            nextResponder?.scrollWheel(with: event)
        }
    }
}

open class UKlineBase: UBaseView {
    
    private(set) var chartContainerLayer: UBaseLayer!
    private(set) var textContainerLayer: UBaseLayer!
    private(set) var containerView: UBaseView!
    private(set) var scrollView: UBaseScrollView!
    
    final override func initialization() {
        super.initialization()
        scrollView = UBaseScrollView()
        scrollView.contentInsets = .zero
        scrollView.horizontalScrollElasticity = .automatic
        scrollView.verticalScrollElasticity = .automatic
        scrollView.isScrollEnabled = true
        scrollView.documentSize = CGSize(width: 1000, height: 2000)
//        scrollView.frame = CGRect(x: 100, y: 100, width: 500, height: 300)
        
        scrollView.hideScrollers = false
        scrollView.scrollerStyle = .legacy
        scrollView.scrollerKnobStyle = .dark
        addSubview(scrollView)
        
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
    
    open override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        scrollView.frame = CGRect(x: 100, y: 100, width: 500, height: 300)
    }
    
    open override func resize(withOldSuperviewSize oldSize: NSSize) {
        super.resize(withOldSuperviewSize: oldSize)
        scrollView.frame = CGRect(x: 100, y: 100, width: 500, height: 300)
    }
    
    open override func layout() {
        super.layout()
        scrollView.frame = CGRect(x: 100, y: 100, width: 500, height: 300)
        containerView.frame = bounds
        chartContainerLayer.sublayers?.forEach({ $0.frame = bounds })
        textContainerLayer.sublayers?.forEach({ $0.frame = bounds })
    }

    fileprivate func defaultInitialization() {}

    fileprivate func sublayerInitialization() {}

    fileprivate func gestureInitialization() {}
}
