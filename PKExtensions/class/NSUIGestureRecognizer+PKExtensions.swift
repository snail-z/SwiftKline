//
//  NSUIGestureRecognizer+PKExtensions.swift
//  PKExtensions
//
//  Created by zhanghao on 2020/2/24.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

import Foundation

public extension PKGestureRecognizerExtensions where Base: NSUIGestureRecognizer {
    
    /// 初始化手势识别器并添加闭包事件
    static func addGestureHandler(_ handler: @escaping (_ sender: Base) -> Void) -> Base {
        let owner = Base()
        owner.pk_addGesture(handler: { handler($0 as! Base) })
        return owner
    }
    
    /// 为手势识别器并添加闭包事件
    func addGestureHandler(_ handler: @escaping (_ sender: Base) -> Void) {
        base.pk_addGesture(handler: { handler($0 as! Base) })
    }
    
    /// 移除所有手势识别器闭包事件
    func removeGestureHandlers() {
        base.pk_removeGestureHandlers()
    }
}

private var UIGestureRecognizerAssociatedWrappersKey: Void?

private extension NSUIGestureRecognizer {
    var pk_wrappers: [_PKGestureRecognizerWrapper<NSUIGestureRecognizer>]? {
        get {
            return objc_getAssociatedObject(self, &UIGestureRecognizerAssociatedWrappersKey) as? [_PKGestureRecognizerWrapper]
        } set {
            objc_setAssociatedObject(self, &UIGestureRecognizerAssociatedWrappersKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    #if os(iOS) || os(tvOS)
    
    func pk_addGesture(handler: @escaping (_ sender: NSUIGestureRecognizer) -> Void) {
        if pk_wrappers == nil { pk_wrappers = Array() }
        let target = _PKGestureRecognizerWrapper(handler: handler)
        pk_wrappers?.append(target)
        self.addTarget(target, action: target.method)
    }
    
    func pk_removeGestureHandlers() {
        if var events = pk_wrappers, !events.isEmpty {
            for target in events {
                self.removeTarget(target, action: target.method)
            }
            events.removeAll()
            pk_wrappers = nil
        }
    }
    
    #endif
    
    #if os(OSX)
    
    func pk_addGesture(handler: @escaping (_ sender: NSUIGestureRecognizer) -> Void) {
        if pk_wrappers == nil { pk_wrappers = Array() }
        let target = _PKGestureRecognizerWrapper(handler: handler)
        pk_wrappers?.append(target)
        self.target = target
        self.action = target.method
    }
    
    func pk_removeGestureHandlers() {
        if var events = pk_wrappers, !events.isEmpty {
            self.target = nil
            self.action = nil
            events.removeAll()
            pk_wrappers = nil
        }
    }
    
    #endif
}

private class _PKGestureRecognizerWrapper<T> {
    var block: ((_ sender: T) -> Void)?
    let method = #selector(invoke(_:))
    
    init(handler: @escaping (_ sender: T) -> Void) {
        block = handler
    }
    
    @objc func invoke(_ sender: NSUIGestureRecognizer)  {
        block?(sender as! T)
    }
}

public struct PKGestureRecognizerExtensions<Base> {
    fileprivate var base: Base
    fileprivate init(_ base: Base) { self.base = base }
}

public protocol PKGestureRecognizerExtensionsCompatible {}

public extension PKGestureRecognizerExtensionsCompatible {
    static var pk: PKGestureRecognizerExtensions<Self>.Type { PKGestureRecognizerExtensions<Self>.self }
    var pk: PKGestureRecognizerExtensions<Self> { get{ PKGestureRecognizerExtensions(self) } set{} }
}

extension NSUIGestureRecognizer: PKGestureRecognizerExtensionsCompatible {}
