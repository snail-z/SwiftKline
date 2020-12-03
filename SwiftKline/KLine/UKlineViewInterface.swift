//
//  UKlineViewInterface.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/12/1.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

public protocol UKlineViewInterface {
    
    /// 设置K线图样式
    var preference: UKlinePreferences! { get set }
    
    /// 设置走势数据
    var dataList: [UKlineDataSource]! { get set }
    
    /// 绘制图表数据
    func drawChart()
    
    /// 清空图表数据
    func clearChart()
}
