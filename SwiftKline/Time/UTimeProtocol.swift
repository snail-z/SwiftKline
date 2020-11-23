//
//  UTimeProtocol.swift
//  swiftKline
//
//  Created by zhanghao on 2020/10/23.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

/// 走势数据源
public protocol UTimeDataSource {
    
    /// 最新价
    var _latestPrice: Double { get }

    /// 均价
    var _averagePrice: Double { get }
    
    /// 成交量
    var _volume: Double { get }
    
    /// 日期
    var _date: Date { get }
    
    /// 大盘红绿柱
    var _leadRgbVolume: Double { get }
    
    /// 大盘红绿柱方向 (上涨返回YES，下跌返回NO)
    var _isLeadRgbUpward: Bool { get }
}

public extension UTimeDataSource {

    /// 返回此值用于绘制大盘红绿柱，默认为0
    var _leadRgbVolume: Double {
        return 0
    }
    
    /// 返回此值用于确定大盘红绿柱方向
    var _isLeadRgbUpward: Bool {
        return false
    }
}

/// 坐标参考系
public protocol UTimeReferenceSystem {}

public extension UTimeReferenceSystem {
    
    /// 价格最大值
    var _maxPrice: Double? { return nil }
    
    /// 价格最小值
    var _minPrice: Double? { return nil }
    
    /// 最大涨幅值
    var _maxChangeRate: Double? { return nil }
    
    /// 最小涨幅值
    var _minChangeRate: Double? { return nil }
    
    /// 最大成交量
    var _maxVolume: Double? { return nil }
    
    /// 最小成交量
    var _minVolume: Double? { return nil }
    
    /// 参考价(昨收价)
    var _referenceValue: Double? { return nil }
}
