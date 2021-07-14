//
//  UBaseView.swift
//  swiftKline
//
//  Created by zhanghao on 2020/10/23.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import UIKit

open class UBaseView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required public init?(coder: NSCoder) {
        super.init(frame: .zero)
        initialization()
    }
    
    internal func initialization() {}
}
