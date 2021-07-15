//
//  UIViewControllerExtensions.swift
//  PKExtensions
//
//  Created by zhanghao on 2020/2/26.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

import UIKit

public extension PKViewControllerExtensions where Base: UIViewController {
    
    /// 返回当前实例的类名称
    var className: String {
        return String(describing: type(of: base))
    }

    /// 返回当前类名称
    static var className: String {
        return String(describing: Base.self)
    }
    
    /// 检查ViewController是否在屏幕上显示
    var isVisible: Bool {
        // http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
        return base.isViewLoaded && base.view.window != nil
    }
    
    /// 添加子控制器及视图
    func addChildViewController(_ child: UIViewController, toContainerView containerView: UIView) {
        base.addChild(child)
        containerView.addSubview(child.view)
        child.didMove(toParent: base)
    }

    /// 移除子控制器及视图
    func removeViewAndControllerFromParentViewController() {
        guard base.parent != nil else { return }
        base.willMove(toParent: nil)
        base.removeFromParent()
        base.view.removeFromSuperview()
    }
    
    /// 添加背景图
    func addBackgroundImage(_ named: String) {
        return addBackgroundImage(UIImage(named: named))
    }
    
    /// 添加背景图
    func addBackgroundImage(_ image: UIImage?) {
        guard let img = image else { return }
        let imageView = UIImageView(frame: base.view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.image = img
        imageView.clipsToBounds = true
        base.view.addSubview(imageView)
        base.view.sendSubviewToBack(imageView)
    }
}

public struct PKViewControllerExtensions<Base> {
    var base: Base
    fileprivate init(_ base: Base) { self.base = base }
}

public protocol PKViewControllerExtensionsCompatible {}

public extension PKViewControllerExtensionsCompatible {
    static var pk: PKViewControllerExtensions<Self>.Type { PKViewControllerExtensions<Self>.self }
    var pk: PKViewControllerExtensions<Self> { get{ PKViewControllerExtensions(self) } set{} }
}

extension UIViewController: PKViewControllerExtensionsCompatible {}
