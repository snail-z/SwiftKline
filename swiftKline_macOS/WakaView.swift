//
//  WakaView.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/11/6.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

class WakaView: NSView {

    var backgroundColor: NSColor? {
        didSet {
            layer?.backgroundColor = self.backgroundColor?.cgColor
        }
    }
    
    override var isFlipped: Bool {
        return true
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
