//
//  UITextView+PKExtensions.swift
//  PKExtensions
//
//  Created by zhanghao on 2020/7/22.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

import UIKit

public extension PKViewExtensions where Base: UITextView {
 
    /// 清除文本框
    func clear() {
        base.text = ""
        base.attributedText = NSAttributedString(string: "")
    }
    
    /// 检查文本框是否为空
    var isEmpty: Bool {
        return base.text?.isEmpty == true
    }
    
    /// 返回无空格换行符的文本
    var trimmedText: String? {
        return base.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// 滚动到文本视图的底部
    func scrollToBottom() {
        let range = NSMakeRange((base.text as NSString).length - 1, 1)
        base.scrollRangeToVisible(range)
    }

    /// 滚动到文本视图的顶部
    func scrollToTop() {
        let range = NSMakeRange(0, 1)
        base.scrollRangeToVisible(range)
    }

    /// 去除内容多余边距
    func invalidateContentMargins() {
        base.contentInset = .zero
        base.scrollIndicatorInsets = .zero
        base.contentOffset = .zero
        base.textContainerInset = .zero
        base.textContainer.lineFragmentPadding = 0
    }
}
