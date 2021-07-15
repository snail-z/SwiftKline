//
//  DispatchQueue.swift
//  PKExtensions
//
//  Created by corgi on 2020/7/2.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

import UIKit

public extension PKDispatchQueueExtensions {

    /// 判断当前队列是否为主队列
    static var isMainQueue: Bool {
        enum Static {
            static var key: DispatchSpecificKey<Void> = {
                let key = DispatchSpecificKey<Void>()
                DispatchQueue.main.setSpecific(key: key, value: ())
                return key
            }()
        }
        return DispatchQueue.getSpecific(key: Static.key) != nil
    }

    /// 判断当前队列是否为指定队列
    static func isCurrent(_ queue: DispatchQueue) -> Bool {
        let key = DispatchSpecificKey<Void>()

        queue.setSpecific(key: key, value: ())
        defer { queue.setSpecific(key: key, value: nil) }

        return DispatchQueue.getSpecific(key: key) != nil
    }
    
    /// 延迟指定时间后执行闭包任务
    static func asyncAfter(delay seconds: Double, execute work: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: work)
    }
    
    /// 在主线程中执行闭包任务
    static func executeInMainThread(_ work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.sync(execute: work)
        }
    }
}

public struct PKDispatchQueueExtensions {
    fileprivate static var Base: DispatchQueue.Type { DispatchQueue.self }
    fileprivate var base: DispatchQueue
    fileprivate init(_ base: DispatchQueue) { self.base = base }
}

public extension DispatchQueue {
    var pk: PKDispatchQueueExtensions { PKDispatchQueueExtensions(self) }
    static var pk: PKDispatchQueueExtensions.Type { PKDispatchQueueExtensions.self }
}
