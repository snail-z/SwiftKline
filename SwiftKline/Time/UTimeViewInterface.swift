//
//  UTimeViewInterface.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/11/12.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

public protocol UTimeViewInterface {
    
    /// 设置分时图样式
    var preference: UTimePreferences! { get set }
    
    /// 设置走势数据
    var dataList: [UTimeDataSource]? { get set }
    
    /// 设置坐标参考系
    var referenceSystem: UTimeReferenceSystem? { get set }
    
    /// 绘制图表数据
    func drawChart()
    
    /// 清空图表数据
    func clearChart()
}
