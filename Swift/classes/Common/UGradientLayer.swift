//
//  UGradientLayer.swift
//  swiftKline
//
//  Created by zhanghao on 2020/10/22.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import UIKit

open class UGradientLayer: UBaseLayer {
    
    /// 是否禁止路径动画
    public var isDisablePathActions: Bool = false

    /// 渐变色路径
    public var gradientPath: CGPath? {
        didSet {
            updatePath(gradientPath)
        }
    }
    
    /// 渐变色数组
    public var gradientClolors: [UIColor?]? {
        didSet {
            updatePath(gradientPath)
        }
    }
    
    /// 线性渐变方向
    public enum GradientDirection {
        /// 从左到右渐变
        case leftToRight
        /// 从右到左渐变
        case rightToLeft
        /// 从上到下渐变
        case topToBottom
        /// 从下到上渐变
        case bottomToTop
        /// 从左上到右下渐变
        case leftTopToRightBottom
        /// 从左下到右上渐变
        case leftBottomToRightTop
        /// 从右上到左下渐变
        case rightTopToLeftBottom
        /// 从右下到左上渐变
        case rightBottomToLeftTop
    }
    
    /// 线性渐变方向
    public var gradientDirection: GradientDirection = .topToBottom {
        didSet {
            setLinear(direction: gradientDirection)
        }
    }
    
    private var backgroundLayer: CALayer!
    private var maskLayer: UShapeLayer!
    private var gradientLayer: CAGradientLayer!
    
    override func initialization() {
        backgroundLayer = CALayer()
        addSublayer(backgroundLayer)
        
        gradientLayer = CAGradientLayer()
        setLinear(direction: gradientDirection)
        backgroundLayer.addSublayer(gradientLayer)
        
        maskLayer = UShapeLayer()
        maskLayer.fillColor = UIColor.white.cgColor
        maskLayer.strokeColor = UIColor.clear.cgColor
        maskLayer.lineWidth = 0
    }
    
    open override func layoutSublayers() {
        super.layoutSublayers()
        backgroundLayer.frame = bounds
        gradientLayer.frame = bounds
    }
    
    private func updatePath(_ path: CGPath?) {
        guard
            let path = gradientPath,
            let colors = gradientClolors, !colors.isEmpty else {
            clear()
            return
        }
        
        if colors.count > 1 {
            backgroundLayer.mask = maskLayer
            gradientLayer.colors = colors.map({ $0?.cgColor ?? UIColor.black.cgColor })
            maskLayer.path = path
            guard !isDisablePathActions else { return }
            maskLayer.pathActions(duration: 0.25)
        } else {
            backgroundLayer.mask = maskLayer
            gradientLayer.backgroundColor = colors.last!?.cgColor
            maskLayer.path = path
        }
    }
    
    private func clear() {
        maskLayer.path = nil
        gradientLayer.colors = nil
        gradientLayer.backgroundColor = nil
    }
    
    private func setLinear(direction: GradientDirection) {
        switch direction {
        case .leftToRight:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        case .rightToLeft:
            gradientLayer.startPoint = CGPoint(x: 1, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        case .leftTopToRightBottom:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        case .leftBottomToRightTop:
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        case .rightTopToLeftBottom:
            gradientLayer.startPoint = CGPoint(x: 1, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        case .rightBottomToLeftTop:
            gradientLayer.startPoint = CGPoint(x: 1, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        }
    }
}
