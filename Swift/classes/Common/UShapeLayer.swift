//
//  UShapeLayer.swift
//  swiftKline
//
//  Created by zhanghao on 2020/10/23.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import UIKit

open class UShapeLayer: CAShapeLayer {
    
    /// 是否禁止隐式动画
    public var isDisableActions: Bool = true
    
    /// 设置路径变化动画
    public func pathActions(duration: TimeInterval) {
        guard let oldValue = oldPath, let toValue = path else {
            return
        }

        let anim = CABasicAnimation(keyPath: "path")
        anim.fromValue = oldValue
        anim.toValue = toValue
        anim.duration = duration
        anim.isRemovedOnCompletion = true
        add(anim, forKey: nil)
    }
    
    private var oldPath: CGPath?
    
    open override var path: CGPath? {
        didSet {
            oldPath = oldValue
        }
    }
    
    open override func action(forKey event: String) -> CAAction? {
        guard isDisableActions else {
            return super.action(forKey: event)
        }
        return nil
    }
}
