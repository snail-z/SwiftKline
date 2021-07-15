//
//  NSObject+PKExtensions.swift
//  PKExtensions
//
//  Created by zhanghao on 2020/9/10.
//  Copyright © 2020 Pink Koala. All rights reserved.
//

import UIKit

open class PKObserverController: NSObject {
    
    public typealias ObserverBlock = ((_ sender: NSObject, _ change: [NSKeyValueChangeKey : Any]?) -> Void)
    
    private(set) var target: NSObject!
    private(set) var pathBlocks = [String: ObserverBlock]()
    
    init(target: NSObject) {
        super.init()
        self.target = target
    }
    
    init(target: NSObject, keyPath: String, options: NSKeyValueObservingOptions = .new, handler: @escaping ObserverBlock) {
        super.init()
        self.target = target
        addKeyPath(keyPath, options: options, handler: handler)
    }
    
    /// 添加单个KeyPath并处理回调
    public func addKeyPath(_ keyPath: String, options: NSKeyValueObservingOptions = .new, handler: @escaping ObserverBlock) {
        if !pathBlocks.keys.contains(keyPath) {
            target.addObserver(self, forKeyPath: keyPath, options: options, context: nil)
        }
        pathBlocks.updateValue(handler, forKey: keyPath)
    }

    /// 删除某个KeyPath
    public func removeKeyPath(_ keyPath: String) {
        if pathBlocks.keys.contains(keyPath) {
            target.removeObserver(target, forKeyPath: keyPath)
        }
    }

    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let value = object as? NSObject, let pathKey = keyPath else { return }
        let blocks = pathBlocks[pathKey]
        blocks?(value, change)
    }
    
    deinit {
        for pathKey in pathBlocks.keys {
            target.removeObserver(self, forKeyPath: pathKey)
        }
    }
}

// MARK: - private -
internal class _PKObserverWrapper: NSObject {
    
    private(set) var target: NSObject!
    private(set) var options: NSKeyValueObservingOptions!
    private(set) var pathBlocks = [String: [KVOBlock]]()
    
    internal typealias KVOBlock = ((_ sender: NSObject, _ change: [NSKeyValueChangeKey : Any]?) -> Void)
    
    init(target: NSObject, options: NSKeyValueObservingOptions = .new, keyPath: String, handler: @escaping KVOBlock) {
        super.init()
        self.target = target
        self.options = options
        pathBlocks.updateValue([handler], forKey: keyPath)
        
        for pathKey in pathBlocks.keys {
            target.addObserver(self, forKeyPath: pathKey, options: options, context: nil)
        }
    }
    
    init(wrapper: _PKObserverWrapper, ketPath: String, handler: @escaping KVOBlock) {
        super.init()
        self.target = wrapper.target
        self.options = wrapper.options
        
        pathBlocks.removeAll()
        for (pathKey, element) in wrapper.pathBlocks {
            pathBlocks.updateValue(element, forKey: pathKey)
        }
        
        if var blocks = pathBlocks[ketPath] {
            blocks.append(handler)
            pathBlocks.updateValue(blocks, forKey: ketPath)
        } else {
            pathBlocks.updateValue([handler], forKey: ketPath)
        }
        
        for pathKey in pathBlocks.keys {
            target.addObserver(self, forKeyPath: pathKey, options: options, context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let value = object as? NSObject, let pathKey = keyPath else { return }
        let blocks = pathBlocks[pathKey]
        blocks?.forEach({ $0(value, change) })
    }
    
    deinit {
        for pathKey in pathBlocks.keys {
            target.removeObserver(self, forKeyPath: pathKey)
        }
    }
}
