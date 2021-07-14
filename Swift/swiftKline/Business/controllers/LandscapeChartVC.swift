//
//  LandscapeChartVC.swift
//  swiftKline
//
//  Created by zhanghao on 2021/7/13.
//  Copyright © 2021 zhanghao. All rights reserved.
//

import UIKit

class LandscapeChartVC: BaseLandscapeChartVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        let v = UIView()
        v.backgroundColor = .orange
        view.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(50)
            make.width.height.equalTo(200)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
