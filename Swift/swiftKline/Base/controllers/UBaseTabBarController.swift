//
//  UBaseTabBarController.swift
//  swiftKline
//
//  Created by zhanghao on 2020/10/30.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import UIKit

class UBaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addClass(ULeftViewController(), title: "首页", imgName: "th_tabbar_home", selectedImgName: "th_tabbar_home_sel")
        addClass(URightViewController(), title: "设置", imgName: "th_tabbar_travel", selectedImgName: "th_tabbar_travel_sel")
    }
    
    func addClass(_ classVC: UIViewController, title: String, imgName: String, selectedImgName: String) {
        let navc = UBaseNavigationController(rootViewController: classVC)
        classVC.navigationItem.title = title
        navc.tabBarItem.title = title
        classVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
        classVC.tabBarItem.imageInsets = UIEdgeInsets(top: -4, left: 0, bottom: 0, right: 0)
        let image = UIImage.init(named: imgName)
        navc.tabBarItem.image = image?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let selectImage = UIImage.init(named: imgName)
        navc.tabBarItem.selectedImage = selectImage?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        tabBar.isTranslucent = false
        addChild(navc)
    }
}
