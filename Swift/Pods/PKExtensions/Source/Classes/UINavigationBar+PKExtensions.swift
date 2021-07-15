//
//  UINavigationBar+PKExtensions.swift
//  PKExtensions
//
//  Created by zhanghao on 2020/6/21.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

import UIKit

public extension PKViewExtensions where Base: UINavigationBar {

    /// 设置导航栏标题字体和颜色
    func setTitleFont(_ font: UIFont, color: UIColor = .black) {
        var attrs = [NSAttributedString.Key: Any]()
        attrs[.font] = font
        attrs[.foregroundColor] = color
        base.titleTextAttributes = attrs
    }

    /// 设置导航栏背景和文本颜色
    func setColors(background: UIColor, text: UIColor) {
        base.isTranslucent = false
        base.backgroundColor = background
        base.barTintColor = background
        base.setBackgroundImage(UIImage(), for: .default)
        base.tintColor = text
        base.titleTextAttributes = [.foregroundColor: text]
    }

    /// 设置tintColor使导航栏透明
    func makeTransparent(withTint tint: UIColor = .white) {
        base.isTranslucent = true
        base.backgroundColor = .clear
        base.barTintColor = .clear
        base.setBackgroundImage(UIImage(), for: .default)
        base.tintColor = tint
        base.titleTextAttributes = [.foregroundColor: tint]
        base.shadowImage = UIImage()
    }
}
