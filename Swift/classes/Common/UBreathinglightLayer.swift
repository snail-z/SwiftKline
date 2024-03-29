//
//  UBreathinglightLayer.swift
//  swiftKline
//
//  Created by zhanghao on 2020/10/22.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import UIKit

class UBreathinglightLayer: UBaseLayer {

    private var activeLayer: CAShapeLayer!
    private var inactiveLayer: CAShapeLayer!
    
    override func initialization() {
        inactiveLayer = CAShapeLayer()
        addSublayer(inactiveLayer)
        
        activeLayer = CAShapeLayer()
        addSublayer(activeLayer)
    }
    
    func startAnimating() {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        let path = UIBezierPath(arcCenter: .zero, radius: 10, startAngle: 0, endAngle: .pi*2, clockwise: true)
        activeLayer.path = path.cgPath
        activeLayer.position = center
        
        activeLayer.fillColor = UIColor.pk.random().cgColor
        activeLayer.lineWidth = 0
        
        activeLayer.add(flashingAnimation(), forKey: nil)
    }
    
    func stopAnimating() {
        
    }
    
    private func flashingAnimation() -> CAAnimationGroup {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [0.25, 1, 0.25, 0.25]
        animation.keyTimes = [0, 0.5, 0.8, 1]
        
        let animation2 = CAKeyframeAnimation(keyPath: "opacity")
        animation2.values = [0.25, 1, 0.25]
        animation2.keyTimes = [0, 0.75, 1]
        
        let group = CAAnimationGroup()
        group.duration = 3
        group.repeatCount = .greatestFiniteMagnitude
        group.fillMode = .forwards
        group.animations = [animation, animation2]
        // 该属性默认为true，由于程序进入后台后，动画会被认为是完成状态导致动画被删除
        group.isRemovedOnCompletion = false
        return group
    }
    
    /*
     open func startAnimating()

     open func stopAnimating()

     open var isAnimating: Bool { get }
     */
}
