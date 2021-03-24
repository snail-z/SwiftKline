//
//  UBaseView.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/11/11.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

class TJHhaha {
    
}

class TJHhaha1: NSObject {
    
}

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
    
    static func hahah(name: TJHhaha1) {
    }
    
    static func hahah(name: TJHhaha) {
    }
    
    static func hahah(type: Any) {
        
    }
    
    func hahah(type: Double) {
        
    }
    
    func hahah(type: String) {
        
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
