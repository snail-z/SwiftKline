//
//  UBaseLayer.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/11/11.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

open class UBaseLayer: CALayer {

    /// 是否禁止隐式动画
    public var isDisableActions: Bool = false
    
    public override init(layer: Any) {
        super.init(layer: layer)
        initialization()
    }
    
    public override init() {
        super.init()
        initialization()
    }

    required public init?(coder: NSCoder) {
        super.init()
        initialization()
    }
    
    internal func initialization() {}
    
    open override func action(forKey event: String) -> CAAction? {
        guard isDisableActions else {
            return super.action(forKey: event)
        }
        return nil
    }
}
