//
//  UIScrollView+PKExtensions.swift
//  PKExtensions
//
//  Created by corgi on 2020/6/21.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

#if os(iOS) || os(tvOS)

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
    
    /// 消除滚动视图自动调整的Insets
    func eliminateAutomaticallyAdjustsInsets() {
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

public extension PKViewExtensions where Base: UIScrollView {
    
    /// 设置滚动视图顶部背景色
    func insetTopBackgroundColor(_ color: UIColor?, offset: CGFloat = 0) {
        removeTopBackground()
        let view = base.pk_topBackground
        if view.superview == nil {
            base.addSubview(view)
            view.pk.makeConstraints { (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.width.equalTo(self.base.pk.width)
                make.bottom.equalTo(self.base.pk.top).offset(offset)
                make.height.equalTo(1000)
            }
        }
        view.backgroundColor = color
    }
    
    /// 删除滚动视图顶部背景色
    func removeTopBackground() {
        base.pk_removeTopBackground()
    }
}
 
private extension UIScrollView {
    
    var pk_topBackground: UIView {
        let aView: UIView
        if let existing = objc_getAssociatedObject(self, &UIScrollViewAssociatedTopBackgroundKey) as? UIView {
            aView = existing
        } else {
            aView = UIView()
            objc_setAssociatedObject(self, &UIScrollViewAssociatedTopBackgroundKey, aView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return aView
    }
    
    func pk_removeTopBackground() {
        if let existing = objc_getAssociatedObject(self, &UIScrollViewAssociatedTopBackgroundKey) as? UIView {
            existing.removeFromSuperview()
            objc_setAssociatedObject(self, &UIScrollViewAssociatedTopBackgroundKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

private var UIScrollViewAssociatedTopBackgroundKey: Void?

#endif
