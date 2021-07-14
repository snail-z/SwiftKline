
//
//  UBaseNavigationController.swift
//  swiftKline
//
//  Created by zhanghao on 2020/10/30.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import UIKit

class UBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(nil, for: .default)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if !self.viewControllers.isEmpty {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}
