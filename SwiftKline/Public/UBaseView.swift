//
//  UBaseView.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/11/11.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

 open class UBaseView: NSView {
    
    open override var isFlipped: Bool {
        return true
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialization()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initialization()
    }
    
    public var baseLayer: UBaseLayer {
        get {
            return backedLayer
        }
    }
    
    private var backedLayer: UBaseLayer!
    
    internal func initialization() {
        backedLayer = UBaseLayer()
        layer = backedLayer
    }
    
    public var backgroundColor: NSColor? {
        didSet {
            wantsLayer = true
            layer?.backgroundColor = self.backgroundColor?.cgColor
        }
    }
}
