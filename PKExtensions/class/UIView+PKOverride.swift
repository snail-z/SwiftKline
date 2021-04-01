//
//  UIKit+PKOverride.swift
//  UIKit+PKOverride
//
//  Created by zhanghao on 2020/2/27.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit

// MARK: - PKUIButton

/**
*  提供以下功能：
*  1. 支持设置图片相对于 titleLabel 的位置 (imagePosition)
*  2. 支持设置图片和 titleLabel 之间的间距 (imageAndTitleSpacing)
*  3. 支持自定义图片尺寸大小 (imageSpecifiedSize)
*  4. 支持图片和 titleLabel 同时居中对齐或边缘对齐
*  5. 支持图片和 titleLabel 各自对齐到两端 (.eachEnd)
*  6. 支持调整内容边距 (contentEdgeInsets) 注：不支持titleEdgeInsets/imageEdgeInsets
*  7. 支持调整 cornerRadius 始终保持为高度的 1/2 (adjustsRoundedCornersAutomatically)
*  8. 支持 Auto Layout 以上设置可根据内容自适应
*  9. 支持点击时扩增响应范围 (touchResponseInsets)
*/
public extension UIControl.ContentHorizontalAlignment {
    
    /// 图片标题分别对齐到左右两端
    /// Usage: button.contentHorizontalAlignment = .eachEnd
    static var eachEnd: UIControl.ContentHorizontalAlignment {
        return .fill
    }
}

public extension UIControl.ContentVerticalAlignment {
    
    /// 图片标题分别对齐到顶部和底部
    /// Usage: button.contentVerticalAlignment = .eachEnd
    static var eachEnd: UIControl.ContentVerticalAlignment {
        return .fill
    }
}

open class PKUIButton: UIButton {
    
    /// 图片与文字布局位置
    public enum ImagePosition: Int {
        /// 图片在上，文字在下
        case top
        /// 图片在左，文字在右
        case left
        /// 图片在下，文字在上
        case bottom
        /// 图片在右，文字在左
        case right
    }
    
    /// 设置按图标和文字的相对位置，默认为ImagePosition.left
    public var imagePosition: ImagePosition = .left {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// 设置图标和文字之间的间隔，默认为10 (与两端对齐样式冲突时优先级低)
    public var imageAndTitleSpacing: CGFloat = 10 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// 设置图标大小为指定尺寸，默认为zero使用图片自身尺寸
    public var imageSpecifiedSize: CGSize = .zero {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// 是否自动调整 `cornerRadius` 使其始终保持为高度的 1/2
    public var adjustsRoundedCornersAutomatically: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// 设置按钮点击时扩增的响应区域，默认UIEdgeInsetsZero
    public var touchResponseInsets:UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
        }
    }
    
    open override func sizeToFit() {
        super.sizeToFit()
        frame.size = sizeThatFits(CGSize.pk.greatestFiniteMagnitude)
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        let _size = intrinsicContentSize
        return CGSize(width: min(_size.width, size.width), height: min(_size.height, size.height))
    }
    
    open override var intrinsicContentSize: CGSize {
        guard isImageValid() || isTitleValid() else { return .zero}
        
        let titleSize = getValidTitleSize()
        let imageSize = getValidImageSize()
        let spacing = getValidSpacing()
        
        var contentSize: CGSize
        switch imagePosition {
        case .top, .bottom:
            let height = titleSize.height + imageSize.height + spacing
            let width = max(titleSize.width, imageSize.width)
            contentSize = CGSize(width: width, height: height)
        case .left, .right:
            let width = titleSize.width + imageSize.width + spacing
            let height = max(titleSize.height, imageSize.height)
            contentSize = CGSize(width: width, height: height)
        }
        contentSize.height += contentEdgeInsets.pk.vertical
        contentSize.width += contentEdgeInsets.pk.horizontal
        return contentSize
    }
    
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        guard adjustsRoundedCornersAutomatically else {
            return
        }
        layer.cornerRadius = bounds.height / 2
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()

        guard !bounds.isEmpty else { return }
        
        guard isImageValid() || isTitleValid() else { return }
        
        var titleSize = getValidTitleSize()
        let imageSize = getValidImageSize()
        let spacing = getValidSpacing()
        let inset = contentEdgeInsets
        
        switch imagePosition {
        case .top:
            var contentHeight = imageSize.height + titleSize.height + spacing
            if contentHeight > bounds.height {
                titleSize.height = bounds.height - imageSize.height - spacing
                contentHeight = bounds.height
            }
            let padding = verticalTop(contentHeight)
            let imageX = (bounds.width - inset.pk.horizontal - imageSize.width) / 2 + inset.left
            let titleX = (bounds.width - inset.pk.horizontal - titleSize.width) / 2 + inset.left
            imageView!.frame = CGRect(x: imageX, y: padding, size: imageSize)
            let titleY = anotherTop(titleSize.height, originY: imageView!.frame.maxY + spacing)
            titleLabel!.frame = CGRect(x: titleX, y: titleY, size: titleSize)
        case .left:
            let edgePadding = contentEdgeInsets.left + contentEdgeInsets.right
            var contentWidth = titleSize.width + imageSize.width + spacing
            if contentWidth > (bounds.width - edgePadding) {
                titleSize.width = bounds.width - imageSize.width - spacing - edgePadding
                contentWidth = bounds.width - edgePadding
            }
            let padding = horizontalLeft(contentWidth)
            let imageY = (bounds.height - inset.pk.vertical - imageSize.height) / 2 + inset.top
            let titleY = (bounds.height - inset.pk.vertical - titleSize.height) / 2 + inset.top
            imageView!.frame = CGRect(x: padding , y: imageY, size: imageSize)
            let titleX = anotherLeft(titleSize.width, originX: imageView!.frame.maxX + spacing)
            titleLabel!.frame = CGRect(x: titleX, y: titleY, size: titleSize)
        case .bottom:
            var contentHeight = imageSize.height + titleSize.height + spacing
            if contentHeight > bounds.height {
                titleSize.height = bounds.height - imageSize.height - spacing
                contentHeight = bounds.height
            }
            let padding = verticalTop(contentHeight)
            let imageX = (bounds.width - inset.pk.horizontal - imageSize.width) / 2 + inset.left
            let titleX = (bounds.width - inset.pk.horizontal - titleSize.width) / 2 + inset.left
            titleLabel!.frame = CGRect(x: titleX, y: padding, size: titleSize)
            let imageY = anotherTop(imageSize.height, originY: titleLabel!.frame.maxY + spacing)
            imageView!.frame = CGRect(x: imageX, y: imageY, size: imageSize)
        case .right:
            let edgePadding = contentEdgeInsets.left + contentEdgeInsets.right
            var contentWidth = titleSize.width + imageSize.width + spacing
            if contentWidth > (bounds.width - edgePadding) {
                titleSize.width = bounds.width - imageSize.width - spacing - edgePadding
                contentWidth = bounds.width - edgePadding
            }
            let padding = horizontalLeft(contentWidth)
            let imageY = (bounds.height - inset.pk.vertical - imageSize.height) / 2 + inset.top
            let titleY = (bounds.height - inset.pk.vertical - titleSize.height) / 2 + inset.top
            titleLabel!.frame = CGRect(x: padding, y: titleY, size: titleSize)
            let imageX = anotherLeft(imageSize.width, originX: titleLabel!.frame.maxX + spacing)
            imageView!.frame = CGRect(x: imageX, y: imageY, size: imageSize)
        }
    }
    
    private func horizontalLeft(_ width: CGFloat) -> CGFloat {
        switch contentHorizontalAlignment {
        case .left:
            return contentEdgeInsets.left
        case .right:
            return bounds.width - contentEdgeInsets.right - width
        case .eachEnd:
            return contentEdgeInsets.left
        default: /// Other types regarded as .center
            return (bounds.width - contentEdgeInsets.pk.horizontal - width) / 2 + contentEdgeInsets.left
        }
    }
    
    private func anotherLeft(_ width: CGFloat, originX: CGFloat) -> CGFloat {
        switch contentHorizontalAlignment {
        case .eachEnd:
            return bounds.width - width - contentEdgeInsets.right
        default:
            return originX
        }
    }
    
    private func verticalTop(_ height: CGFloat) -> CGFloat {
        switch contentVerticalAlignment {
        case .top:
            return contentEdgeInsets.top
        case .bottom:
            return bounds.height - contentEdgeInsets.bottom - height
        case .eachEnd:
            return contentEdgeInsets.top
        default: /// Other types regarded as .center
            return (bounds.height - contentEdgeInsets.pk.vertical - height) / 2 + contentEdgeInsets.top
        }
    }
    
    private func anotherTop(_ height: CGFloat, originY: CGFloat) -> CGFloat {
        switch contentVerticalAlignment {
        case .eachEnd:
            return bounds.height - height - contentEdgeInsets.bottom
        default:
            return originY
        }
    }
    
    private func getValidTitleSize() -> CGSize {
        guard isTitleValid() else { return .zero }
        return titleLabel!.intrinsicContentSize
    }
    
    private func getValidImageSize() -> CGSize {
        guard isImageValid() else { return .zero }
        return imageSpecifiedSize.pk.isValid ? imageSpecifiedSize : currentImage!.size
    }
    
    private func getValidSpacing() -> CGFloat {
        guard isImageValid(), isTitleValid() else { return .zero }
        return imageAndTitleSpacing
    }
    
    private func isImageValid() -> Bool { currentImage != nil }
    
    private func isTitleValid() -> Bool { (currentTitle != nil || currentAttributedTitle != nil) }
    
    private func getResponseRect() -> CGRect {
        guard touchResponseInsets != UIEdgeInsets.zero else {
            return bounds
        }
        return CGRect(x: bounds.minX - touchResponseInsets.left,
                      y: bounds.minY - touchResponseInsets.top,
                      width: bounds.width + touchResponseInsets.left + touchResponseInsets.right,
                      height: bounds.height + touchResponseInsets.top + touchResponseInsets.bottom)
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = getResponseRect()
        if(rect.equalTo(bounds)) {
            return super.point(inside: point, with: event)
        }
        return rect.contains(point)
    }
}

private extension CGRect {
    init(x: CGFloat, y: CGFloat, size: CGSize) {
        self.init(x: x, y: y, width: size.width, height: size.height)
    }
}


// MARK: - PKUITextField

/**
*  提供以下功能：
*  1. 支持调整左视图边缘留白 (leftViewPadding)
*  2. 支持调整右视图边缘留白 (rightViewPadding)
*  3. 支持调整清除按钮边缘留白 (clearButtonPadding)
*  4. 支持输入框文本边缘留白 (textEdgeInsets)
*  5. 增加键盘删除按钮的响应事件 - PKUITextField.deleteBackward
*/
open class PKUITextField: UITextField {
    
    /// 左视图边缘留白
    public var leftViewPadding: CGFloat = 0
    
    /// 右视图边缘留白
    public var rightViewPadding: CGFloat = 0
    
    /// 清除按钮边缘留白
    public var clearButtonPadding: CGFloat = 0
    
    /// 文本边缘留白
    public var textEdgeInsets: UIEdgeInsets = .zero
    
    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var leftRect = super.leftViewRect(forBounds: bounds)
        leftRect.origin.x += leftViewPadding
        return leftRect
    }
    
    open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rightRect = super.rightViewRect(forBounds: bounds)
        rightRect.origin.x -= rightViewPadding
        return rightRect
    }
    
    open override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var clearRect = super.clearButtonRect(forBounds: bounds)
        clearRect.origin.x = bounds.size.width - clearRect.size.width - clearButtonPadding
        return clearRect
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return _inputRect(forBounds: bounds, modes: [.always])
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return _inputRect(forBounds: bounds, modes: [.always, .whileEditing])
    }
    
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        guard isEditing else {
            return textRect(forBounds: bounds)
        }
        return editingRect(forBounds: bounds)
    }
    
    private func _inputRect(forBounds bounds: CGRect, modes: [ViewMode]) -> CGRect {
        var insets = textEdgeInsets
        
        if let _ = leftView, modes.contains(leftViewMode) {
            insets.left += leftViewRect(forBounds: bounds).maxX
        }
        
        if let _ = rightView, modes.contains(rightViewMode) {
            insets.right += (bounds.width - rightViewRect(forBounds: bounds).minX)
        } else {
            if modes.contains(clearButtonMode) {
                insets.right += (bounds.width - clearButtonRect(forBounds: bounds).minX)
            }
        }
        
        return bounds.inset(by: insets)
    }

    open override func deleteBackward() {
        super.deleteBackward()
        sendActions(for: PKUITextField.deleteBackward)
    }
    
    /// 键盘删除按钮的响应事件
    ///
    ///     Usage: textField.addTarget(self, action: #selector(textFieldDeleteBackward(_:)), for: PKUITextField.deleteBackward)
    public static var deleteBackward: UIControl.Event {
        return UIControl.Event(rawValue: 2020)
    }
}


// MARK: - PKUITextView

/**
*  提供以下功能：
*  1. 支持设置占位文本 (placeholder)
*  2. 支持设置占位文本颜色 (placeholderColor)
*  3. 支持设置占位文本内边距 (placeholderInsets)
*  4. 支持设置文本框是否需要自适应内容高度 (adjustsToFitContentHeightAutomatically)
*  5. 输入框 contentSize 改变回调 - didContentSizeChanged(oldSize, newSize)
*  6. 输入框变化增加删除事件 - deleteBackward
*/
open class PKUITextView: UITextView, UITextViewDelegate {
    
    /// 设置占位文本
    public var placeholder: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 设置占位文本颜色
    public var placeholderColor: UIColor? = .gray {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 调整占位文本内边距
    public var placeholderInset: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 是否自适应内容高度，默认false (需要固定水平约束)
    public var adjustsToFitContentHeightAutomatically = false
    
    /// 自适应内容尺寸限制的最大行数，默认0无限制
    public var automaticallyMaxNumberOfLines: NSInteger = 0 {
        didSet {
            guard oldValue != automaticallyMaxNumberOfLines else {
                return
            }
            let oldSize = bounds.size
            invalidateIntrinsicContentSize()
            didContentSizeChanged?(oldSize, getIntrinsicContentSize())
        }
    }
    
    /// 输入框 contentSize 改变回调
    public var didContentSizeChanged: ((_ oldSize: CGSize, _ newSize: CGSize) -> Void)? = nil
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        layoutManager.allowsNonContiguousLayout = false
        bindNotifications()
    }
    
    public required init?(coder: NSCoder) { super.init(coder: coder) }
    
    public override func draw(_ rect: CGRect) {
        guard !hasText else { return }
        guard let textValue = placeholder else { return }
        let fontValue = font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        let colorValue = placeholderColor ?? UIColor.gray
        let attributedText = NSMutableAttributedString(string: textValue)
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.addAttribute(.font, value: fontValue, range: range)
        attributedText.addAttribute(.foregroundColor, value: colorValue, range: range)
        let rect = CGRect(x: placeholderInset.left + 8, // 优化占位文本偏移问题
                          y: placeholderInset.top,
                          width: bounds.width - placeholderInset.left - placeholderInset.right,
                          height: bounds.height - placeholderInset.top - placeholderInset.bottom)
        attributedText.draw(in: rect)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    public override var font: UIFont? {
        get {
            return super.font
        } set {
            super.font = newValue
            setNeedsDisplay()
        }
    }
    
    public override var attributedText: NSAttributedString! {
        get {
            return super.attributedText
        } set {
            setNeedsDisplay()
        }
    }
    
    public override var text: String! {
        get {
            return super.text
        } set {
            setNeedsDisplay()
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        return getIntrinsicContentSize()
    }
    
    private func heightForNumberOfLines(_ lines: NSInteger) -> CGFloat {
        return ceil((font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)).lineHeight * CGFloat(lines) + textContainerInset.top + textContainerInset.bottom)
    }
    
    private func getIntrinsicContentSize() -> CGSize {
        var size = self.contentSize
        size.height = max(heightForNumberOfLines(1), size.height)
        if automaticallyMaxNumberOfLines > 0 {
            size.height = min(heightForNumberOfLines(automaticallyMaxNumberOfLines), size.height)
        }
        return size;
    }
    
    private func bindNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextView.textDidChangeNotification, object: nil)
        addObserver(self, forKeyPath: "contentSize", options: [.old, .new], context: nil)
    }
    
    private func unbindNotifications() {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
        removeObserver(self, forKeyPath: "contentSize")
    }
    
    @objc private func textDidChange(_ notif: Notification) {
        setNeedsDisplay()
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            guard adjustsToFitContentHeightAutomatically else { return }
            if let oldSize = change?[.oldKey] as? CGSize,
               let newSize = change?[.newKey] as? CGSize,
                !oldSize.equalTo(newSize), newSize.width > 0, newSize.height > 0 {
                invalidateIntrinsicContentSize()
                didContentSizeChanged?(oldSize, getIntrinsicContentSize())
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        unbindNotifications()
    }
    
    public override func deleteBackward() {
        super.deleteBackward()
        delegate?.textViewDidChange?(self)
    }
}


// MARK: - PKUILabel

/// 提供调整UILabel文本内边距功能
open class PKUILabel: UILabel {
    
    /// 设置文本内边距
    public var textInsets: UIEdgeInsets = .zero
    
    open override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insets = textInsets
        var rect = super.textRect(forBounds: bounds.inset(by: insets), limitedToNumberOfLines: numberOfLines)
        rect.origin.x -= insets.left
        rect.origin.y -= insets.top
        rect.size.width += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }
}

#endif
