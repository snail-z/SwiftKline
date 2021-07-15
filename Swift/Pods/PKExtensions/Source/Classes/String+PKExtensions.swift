//
//  String+PKExtensions.swift
//  PKExtensions
//
//  Created by zhanghao on 2020/2/24.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

import UIKit

public extension PKStringExtensions {
    
    /// 将String转为Int
    func toInt() -> Int? { Int(base) }
    
    /// 将String转为Double
    func toDouble() -> Double? { Double(base) }
    
    /// 将String转CGFloat
    func toCGFloat() -> CGFloat? {
        guard let doubleValue = Double(base) else { return nil }
        return CGFloat(doubleValue)
    }
    
    /// 将String转NSString
    func toNSString() -> NSString {
        return NSString(string: base)
    }
    
    /// 获取字符串尺寸
    func boundingSize(with size: CGSize,
                      font: UIFont!,
                      lineBreakMode: NSLineBreakMode? = nil) -> CGSize {
        var attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize) ]
        if lineBreakMode != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = lineBreakMode!
            attributes.updateValue(paragraphStyle, forKey: NSAttributedString.Key.paragraphStyle)
        }
        let _size = NSString(string: base).boundingRect(with: size,
                                                        options: .usesLineFragmentOrigin,
                                                        attributes: attributes,
                                                        context: nil)
        return CGSize(width: ceil(_size.width), height: ceil(_size.height))
    }
    
    /// 获取字符串宽度 (约束高度)
    func boundingWidth(with height: CGFloat,
                       font: UIFont!,
                       lineBreakMode: NSLineBreakMode? = nil) -> CGFloat {
        let size = CGSize(width: .greatestFiniteMagnitude, height: height)
        return boundingSize(with: size, font: font, lineBreakMode: lineBreakMode).width
    }
    
    /// 获取字符串高度 (约束宽度)
    func boundingHeight(with width: CGFloat,
                        font: UIFont!,
                        lineBreakMode: NSLineBreakMode? = nil) -> CGFloat {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        return boundingSize(with: size, font: font, lineBreakMode: lineBreakMode).height
    }
}

public extension PKStringExtensions {
    
    /// 检查字符串是否为空或只包含空白和换行字符
    var isBlank: Bool {
        let trimmed = base.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty
    }
    
    /// 返回base64编码的字符串
    var base64Encoded: String? {
        // https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
        let plainData = base.data(using: .utf8)
        return plainData?.base64EncodedString()
    }
    
    /// 返回字符串中出现指定字符的第一个索引
    func index(of char: Character) -> Int? {
        for (index, c) in base.enumerated() where c == char {
            return index
        }
        return nil
    }
    
    /// 字符串查找子串返回NSRange
    func nsRange(of subString: String?) -> NSRange {
        guard let subValue = subString else { return NSRange(location: 0, length: 0) }
        guard let range = base.range(of: subValue) else {
            return NSRange(location: 0, length: 0)
        }
        return NSRange(range, in: base)
    }
    
    /// 字符串提取子串 (从某个位置起到某个位置结束)
    ///
    ///     "Hello World".pk.slicing(from: 6, length: 5) -> "World"
    func substring(from index: Int, length: Int) -> String? {
        guard length >= 0, index >= 0, index < base.count  else { return nil }
        guard index.advanced(by: length) <= base.count else {
            return base[safe: index..<base.count]
        }
        guard length > 0 else { return "" }
        return base[safe: index..<index.advanced(by: length)]
    }
    
    /// 字符串提取子串 (从起始处到某个位置结束)
    func substring(to index: Int) -> String? {
        return substring(from: 0, length: index)
    }
    
    /// 字符串提取子串 (从某个位置起直到末尾结束)
    func substring(from index: Int) -> String? {
        return substring(from: index, length: base.count)
    }
    
    /// 删除首字符并返回新字符串
    func deleteFirstCharacter() -> String? {
        return substring(from: 1)
    }
    
    /// 删除末尾字符并返回新字符串
    func deleteLastCharacter() -> String? {
        return substring(to: base.count - 1)
    }
}

public extension PKStringExtensions {
    
    /// 检查是否包含指定字符串 (默认会区分大小写)
    func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return base.range(of: string, options: .caseInsensitive) != nil
        }
        return base.range(of: string) != nil
    }
    
    /// 将数字金额字符串转成大写(人民币朗读形式)
    func rmbCapitalized() -> String {
        guard let number = Double(base) else { return "" }
        return number.pk.stringRmbCapitalized()
    }
    
    /// 检查字符串中是否包含Emoji
    func containsEmoji() -> Bool {
        for i in 0..<base.count {
            let c: unichar = (base as NSString).character(at: i)
            if (0xD800 <= c && c <= 0xDBFF) || (0xDC00 <= c && c <= 0xDFFF) {
                return true
            }
        }
        return false
    }
    
    /// 转为驼峰式字符串
    ///
    ///     "sOme vAriable naMe".pk.camelCased() -> "someVariableName"
    func camelCased() -> String {
        let source = base.lowercased()
        let first = source[..<source.index(after: source.startIndex)]
        if source.contains(" ") {
            let connected = source.capitalized.replacingOccurrences(of: " ", with: "")
            let camel = connected.replacingOccurrences(of: "\n", with: "")
            let rest = String(camel.dropFirst())
            return first + rest
        }
        let rest = String(source.dropFirst())
        return first + rest
    }
    
    /// 返回给定长度的随机字符串
    ///
    ///     String.pk.random(ofLength: 18) -> "u7MMZYvGo9obcOcPj8"
    static func random(ofLength length: Int) -> String {
        guard length > 0 else { return "" }
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 1...length {
            randomString.append(base.randomElement()!)
        }
        return randomString
    }
}

public extension PKStringExtensions {
    
    /// 检查字符串是否是有效的URL
    var isValidURL: Bool {
        return URL(string: base) != nil
    }
    
    /// 检查字符串是否是有效的https URL
    var isValidHttpsURL: Bool {
        guard let url = URL(string: base) else { return false }
        return url.scheme == "https"
    }
    
    /// 检查字符串是否是有效的文件URL
    var isValidFileURL: Bool {
        return URL(string: base)?.isFileURL ?? false
    }
    
    /// 检查字符串是否是有效的邮件格式
    var isValidEmail: Bool {
        // http://emailregex.com/
        let regex = "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return base.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    /// 检查字符串是否是手机号 (仅中国手机号所有号段)
    var isValidMobileNumber: Bool {
        let string = base.trimmingCharacters(in: .whitespacesAndNewlines)
        guard string.count == 11 else { return false }
        let regex = "^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$"
        return string.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    /// 检查字符串是否是身份证号
    var isValidIDCardNumber: Bool {
        let regex = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        return base.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    /// 验证字符串是否为纯数字
    var validateAllDigits: Bool {
        let regex = "(^[0-9]*$)"
        return base.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    /// 验证字符串是否为纯汉字
    var validateChineseCharacters: Bool {
        let regex = "(^[\\u4e00-\\u9fa5]+$)"
        return base.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

public extension String {
    
    /// 获取指定范围内字符串
    subscript<R>(safe range: R) -> String? where R: RangeExpression, R.Bound == Int {
        let range = range.relative(to: Int.min..<Int.max)
        guard range.lowerBound >= 0,
            let lowerIndex = index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex),
            let upperIndex = index(startIndex, offsetBy: range.upperBound, limitedBy: endIndex) else {
                return nil
        }
        return String(self[lowerIndex..<upperIndex])
    }
}

public struct PKStringExtensions {
    fileprivate static var Base: String.Type { String.self }
    fileprivate var base: String
    fileprivate init(_ base: String) { self.base = base }
}

public extension String {
    var pk: PKStringExtensions { PKStringExtensions(self) }
    static var pk: PKStringExtensions.Type { PKStringExtensions.self }
}
