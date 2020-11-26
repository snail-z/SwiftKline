//
//  Dictionary+PKExtensions.swift
//  PKExtensions
//
//  Created by zhanghao on 2020/6/19.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

import Foundation

public extension PKDictionaryExtensions {
    
    /// 检查字典中是否存在对应的Key
    func hasKey(_ key: Key) -> Bool {
        return base.index(forKey: key) != nil
    }
    
    /// 获取字典中的一个随机元素
    func randomValue() -> Value? {
        return Array(base.values).randomElement()
    }
    
    /// 将字典转JSONData
    func jsonData(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(base) else {
            return nil
        }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        return try? JSONSerialization.data(withJSONObject: base, options: options)
    }
    
    /// 将字典转JSON字符串
    func jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(base) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: base, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}

public struct PKDictionaryExtensions<Key, Value> where Key : Hashable {
    fileprivate static var Base: Dictionary<Key, Value>.Type { Dictionary<Key, Value>.self }
    fileprivate var base: Dictionary<Key, Value>
    fileprivate init(_ base: Dictionary<Key, Value>) { self.base = base }
}

public extension Dictionary {
    var pk: PKDictionaryExtensions<Key, Value> { PKDictionaryExtensions(self) }
    static var pk: PKDictionaryExtensions<Key, Value>.Type { PKDictionaryExtensions<Key, Value>.self }
}
