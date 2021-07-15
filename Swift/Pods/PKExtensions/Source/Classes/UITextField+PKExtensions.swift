//
//  UITextField+PKExtensions.swift
//  PKExtensions
//
//  Created by zhanghao on 2020/7/13.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

import UIKit

public extension PKViewExtensions where Base: UITextField {

    /// UITextField文本类型 (邮件地址/密码/通用文本)
    enum TextType {
        case emailAddress, password, generic
    }
    
    /// 设置文本类型
    var textType: TextType {
        get {
            if base.keyboardType == .emailAddress {
                return .emailAddress
            } else if base.isSecureTextEntry {
                return .password
            }
            return .generic
        }
        set {
            switch newValue {
            case .emailAddress:
                base.keyboardType = .emailAddress
                base.autocorrectionType = .no
                base.autocapitalizationType = .none
                base.isSecureTextEntry = false
                base.placeholder = "Email Address"

            case .password:
                base.keyboardType = .asciiCapable
                base.autocorrectionType = .no
                base.autocapitalizationType = .none
                base.isSecureTextEntry = true
                base.placeholder = "Password"

            case .generic:
                base.isSecureTextEntry = false
            }
        }
    }

    /// 检查文本框是否为空
    var isEmpty: Bool {
        return base.text?.isEmpty == true
    }
    
    /// 返回无空格换行符的文本
    var trimmedText: String? {
        return base.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// 清除文本框
    func clear() {
        base.text = ""
        base.attributedText = NSAttributedString(string: "")
    }
    
    /// 设置占位符文本及颜色
    func setPlaceholder(_ string: String?, color: UIColor? = nil) {
        guard let holder = string, !holder.isEmpty else { return }
        let foregroundColor = color ?? UIColor.gray.withAlphaComponent(0.7)
        base.attributedPlaceholder = NSAttributedString(string: string!, attributes: [.foregroundColor: foregroundColor])
    }
}
