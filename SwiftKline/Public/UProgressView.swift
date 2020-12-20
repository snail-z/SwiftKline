//
//  UProgressLayer.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/12/15.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

open class UProgressLayer: CALayer {
    
    enum Style {
        case bar, loop
    }

    /// 进度颜色
    public var trackColor: NSColor? = .black {
        didSet {
            activeLayer.backgroundColor = trackColor?.cgColor
        }
    }
    
    private var activeLayer: CALayer!

    override init() {
        super.init()
        initialization()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initialization()
    }

    private func initialization() {
        masksToBounds = true
        
        activeLayer = CALayer()
        activeLayer.anchorPoint = .zero
        activeLayer.backgroundColor = NSColor.purple.cgColor
        addSublayer(activeLayer)
    }
    
    /// 设置进度
    open func setProgress(_ progress: Float, animated: Bool = false) {
        let moveWidth = CGFloat(min(max(0, progress), 1)) * bounds.width
        let finalRect = CGRect(origin: .zero, size: CGSize(width: moveWidth, height: bounds.height))
        activeLayer.frame = finalRect
        
        guard animated else { return }
        
        let basic = CABasicAnimation(keyPath: "bounds")
        basic.fromValue = CGRect(origin: .zero, size: CGSize(width: 0, height: bounds.height))
        basic.toValue = finalRect
        basic.duration = 0.25
        basic.fillMode = .forwards
        basic.isRemovedOnCompletion = false
        self.activeLayer.add(basic, forKey: nil)
    }
}


open class UProgress2Layer: CALayer {

    /// 进度颜色
    public var trackColor: NSColor? = .black {
        didSet {
            activeLayer.backgroundColor = trackColor?.cgColor
        }
    }
    
    private var activeLayer: CAShapeLayer!
    private var inactiveLayer: CAShapeLayer!
    private var backLayer: CALayer!
    
    override init() {
        super.init()
        initialization()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initialization()
    }

    private func initialization() {
        inactiveLayer = CAShapeLayer()
        addSublayer(inactiveLayer)
        
        backLayer = CALayer()
        addSublayer(backLayer)
        
        activeLayer = CAShapeLayer()
        addSublayer(activeLayer)
        
        isGeometryFlipped = true
    }
    
    /// 设置进度
    open func setProgress(_ progress: Float, animated: Bool = false) {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let path = CGMutablePath()
        
        let dks: CGFloat = 90
        let sdk: CGFloat = -270
        
        
        path.addArc(center: center, radius: 50, startAngle: dks.pk.degreesToRadians(), endAngle: sdk.pk.degreesToRadians(), clockwise: true)
        
        activeLayer.fillColor = NSColor.clear.cgColor
        activeLayer.path = path
        activeLayer.strokeColor = trackColor?.cgColor
        activeLayer.lineWidth = 20
        
        inactiveLayer.fillColor = NSColor.clear.cgColor
        let path2 = CGMutablePath()
        path2.addArc(center: center, radius: 50, startAngle: 0, endAngle: .pi*2, clockwise: true)
        inactiveLayer.path = path2
        inactiveLayer.strokeColor = trackColor?.cgColor
        inactiveLayer.lineWidth = 20
        
        backLayer.frame = bounds
        backLayer.backgroundColor = NSColor.green.cgColor
        
        backLayer.mask = activeLayer
        
        
        
        let endValue = min(max(0, CGFloat(progress)), 1)
        
        activeLayer.strokeStart = 0
        activeLayer.strokeEnd = endValue
        
        guard animated else { return }
    
        let basic = CABasicAnimation(keyPath: "strokeEnd")
        basic.fromValue = 0
        basic.toValue = endValue
        basic.duration = 1.25
        basic.fillMode = .forwards
        basic.isRemovedOnCompletion = false
        self.activeLayer.add(basic, forKey: nil)
    }
}
