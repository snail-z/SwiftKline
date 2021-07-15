//
//  UIWindow+PKExtensions.swift
//  PKExtensions
//
//  Created by zhanghao on 2020/6/19.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

import UIKit

public extension PKViewExtensions where Base: UIWindow {
    
    /// 切换当前的根视图控制器
    ///
    /// - Parameters:
    ///   - viewController: 新的视图控制器
    ///   - animated: 视图控制器更改动画
    ///   - duration: 动画持续时间
    ///   - options: 动画选项
    ///   - completion: 切换完成后回调
    func switchRootViewController(to viewController: UIViewController,
                                  animated: Bool = true,
                                  duration: TimeInterval = 0.5,
                                  options: UIView.AnimationOptions = .transitionFlipFromRight,
                                  _ completion: (() -> Void)? = nil) {
    
        guard animated else {
            base.rootViewController = viewController
            completion?()
            return
        }

        UIView.transition(with: base, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.base.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }, completion: { _ in
            completion?()
        })
    }
}
