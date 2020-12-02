//
//  UKlineView.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/12/1.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

open class UKlineView: UKlineBase {

    func hau() {
        
    }
}

// MARK: - UKlineBase

open class UKlineBase: UBaseView {
    
    private(set) var chartContainerLayer: UBaseLayer!
    private(set) var textContainerLayer: UBaseLayer!
    private(set) var containerView: UBaseView!
    private(set) var scrollView: NSScrollView!
    
    override func initialization() {
        super.initialization()
        scrollView = NSScrollView()
        scrollView.scrollerStyle = .overlay
        scrollView.hasVerticalRuler = true
        scrollView.hasHorizontalRuler = true
        scrollView.scrollerKnobStyle = .dark
        scrollView.horizontalScrollElasticity = .automatic
        scrollView.verticalScrollElasticity = .automatic
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
