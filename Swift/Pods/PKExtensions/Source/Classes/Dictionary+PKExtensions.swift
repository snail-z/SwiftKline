//
//  Dictionary+PKExtensions.swift
//  PKExtensions
//
//  Created by zhanghao on 2020/6/19.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

import UIKit

public extension PKDictionaryExtensions {
    
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
