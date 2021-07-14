//
//  BaseLandscapeChartVC.swift
//  swiftKline
//
//  Created by zhanghao on 2021/7/13.
//  Copyright © 2021 zhanghao. All rights reserved.
//

import UIKit

class BaseLandscapeChartVC: UIViewController {

    public private(set) var containerView: UIView!
    public private(set) var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        containerView = UIView()
        view.addSubview(containerView)
        
        closeButton = UIButton.init(type: .custom)
        closeButton.titleLabel?.font = .systemFont(ofSize: 32)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.setTitle("×", for: .normal)
        view.addSubview(closeButton)
        
        closeButton.pk.addAction(for: .touchUpInside) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override var shouldAutorotate: Bool {
        true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .landscapeRight
    }
    
    deinit {
        print("BaseLandscapeChartVC is deinit✈️✈️")
    }
}
