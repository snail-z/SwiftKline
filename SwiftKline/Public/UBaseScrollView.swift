//
//  UBaseScrollView.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/12/14.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

public protocol UBaseScrollViewDelegate: NSObjectProtocol {
    
    /// 视图正在滚动中回调事件
    func scrollViewDidScroll(_ scrollView: UBaseScrollView)
}

public extension UBaseScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UBaseScrollView) {}
}

open class UBaseScrollView: NSScrollView {
    
    /// 滚动视图代理对象
    public weak var delegate : UBaseScrollViewDelegate?
    
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
        contentView = UBaseClipView()
        
        backedView = UBaseView()
        backedView.frame = bounds
        backedView.backgroundColor = .yellow
        documentView = backedView
        
        addObserver()
    }
    
    open override func scrollWheel(with event: NSEvent) {
        if isScrollEnabled {
            return super.scrollWheel(with: event)
        } else {
            nextResponder?.scrollWheel(with: event)
        }
    }
    
    private func addObserver() {
        contentView.postsBoundsChangedNotifications = true
        NotificationCenter.default.addObserver(self, selector: #selector(scrollViewDidScroll(_:)), name: NSView.boundsDidChangeNotification, object: contentView)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        removeObserver()
    }
    
    @objc private func scrollViewDidScroll(_ notification: Notification) {
        delegate?.scrollViewDidScroll(self)
    }
}

class UBaseClipView: NSClipView {
    
    override func constrainBoundsRect(_ proposedBounds: NSRect) -> NSRect {
        guard let scrollView = superview as? UBaseScrollView else {
            return super.constrainBoundsRect(proposedBounds)
        }
        
        if scrollView.isScrollEnabled {
            return super.constrainBoundsRect(proposedBounds)
        }
        
        return documentVisibleRect
    }
}
