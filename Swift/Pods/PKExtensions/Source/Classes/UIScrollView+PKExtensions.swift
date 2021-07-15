//
//  UIScrollView+PKExtensions.swift
//  PKExtensions
//
//  Created by corgi on 2020/6/21.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

import UIKit

public extension PKViewExtensions where Base: UIScrollView {

    /// 获取整个滚动视图快照 (UIScrollView滚动内容区)
    func snapshot() -> UIImage? {
        // Original Source: https://gist.github.com/thestoics/1204051
        UIGraphicsBeginImageContextWithOptions(base.contentSize, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        let previousFrame = base.frame
        base.frame = CGRect(origin: base.frame.origin, size: base.contentSize)
        base.layer.render(in: context)
        base.frame = previousFrame
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

public extension PKViewExtensions where Base: UIScrollView {
    
    /// 吃掉滚动视图自动调整的Insets
    func eatAutomaticallyAdjustsInsets() {
        if #available(iOS 11.0, *) {
            base.contentInsetAdjustmentBehavior = .never
        } else {
            base.pk.dependViewController()?.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    /// 视图的四周边界
    var boundaries: UIEdgeInsets {
        let top = 0 - base.contentInset.top
        let left = 0 - base.contentInset.left
        let bottom = base.contentSize.height - base.bounds.size.height + base.contentInset.bottom
        let right = base.contentSize.width - base.bounds.size.width + base.contentInset.right
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    /// 边界类型(上左下右)
    enum BoundariesType {
        case top, left, bottom, right
    }
    
    /// 使视图滚动到指定边界
    func scroll(to type: BoundariesType, animated: Bool = true) {
        var offset = base.contentOffset
        switch type {
        case .top: offset.y = boundaries.top
        case .left: offset.x = boundaries.left
        case .bottom: offset.y = boundaries.bottom
        case .right: offset.x = boundaries.right
        }
        base.setContentOffset(offset, animated: animated)
    }
}
