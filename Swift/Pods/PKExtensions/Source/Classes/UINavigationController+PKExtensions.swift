//
//  UINavigationController+PKExtensions.swift
//  PKExtensions
//
//  Created by zhanghao on 2020/7/30.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

import UIKit

public extension PKViewControllerExtensions where Base: UINavigationController {

    /// 为导航控制器pop动画增加完成回调
    func popViewController(animated: Bool = true, _ completion: (() -> Void)? = nil) {
        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        base.popViewController(animated: animated)
        CATransaction.commit()
    }

    /// 为导航控制器push动画增加完成回调
    func pushViewController(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        base.pushViewController(viewController, animated: true)
        CATransaction.commit()
    }

    /// 设置当前控制器导航栏为透明
    func makeTransparent(withTint tint: UIColor = .white) {
        base.navigationBar.setBackgroundImage(UIImage(), for: .default)
        base.navigationBar.shadowImage = UIImage()
        base.navigationBar.isTranslucent = true
        base.navigationBar.tintColor = tint
        base.navigationBar.titleTextAttributes = [.foregroundColor: tint]
    }
}
