//
//  UTextRender.swift
//  swiftKline
//
//  Created by zhanghao on 2020/10/27.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import UIKit

public struct UTextRender {

    /// 文本内容 (String/NSAttributedString)
    public var text: Any?
    
    /// 文本颜色
    public var color: UIColor? = .black
    
    /// 文本字体
    public var font: UIFont? = .systemFont(ofSize: 12)
    
    /// 文本区域背景色
    public var backgroundColor: UIColor? = .clear
    
    /// 文本区域边框颜色
    public var borderColor: UIColor? = .clear
    
    /// 文本区域边框线宽
    public var borderWidth: CGFloat = 0
    
    /// 文本区域圆角
    public var cornerRadius: CGFloat = 0
    
    /// 文本边缘留白 (扩充文本区域)
    public var textEdgePadding: (horizontal: CGFloat, vertical: CGFloat) = (2, 2)
    
    /// 文本最大限制
    public var maxSize: CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
    
    /// 文本位置
    public var position: CGPoint = .zero

    /// 文本位置偏移 (单位坐标系，默认值{0,1}) 基于position偏移，同时控制显示位置。
    ///
    ///     {0.5, 0.5} 则表示文本区域的中心点与position重叠;
    ///     {0, 0} 则表示文本区域左上点与position重叠;
    ///     {1, 0} 则表示文本区域右上点与position重叠;
    ///     {0, 0} 左上, {0.5, 0.5} 中心, {1, 1} 右下
    ///
    ///     {0,   0}, {0.5,   0}, {1,   0},
    ///     {0, 0.5}, {0.5, 0.5}, {1, 0.5},
    ///     {0,   1}, {0.5,   1}, {1,   1}
    public var positionOffset: CGPoint = CGPoint(x: 0, y: 1)
}
