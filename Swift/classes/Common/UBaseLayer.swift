//
//  UBaseLayer.swift
//  swiftKline
//
//  Created by zhanghao on 2020/10/22.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import UIKit

open class UBaseLayer: CALayer {
    
    /// 是否禁止隐式动画
    public var isDisableActions: Bool = true
    
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

