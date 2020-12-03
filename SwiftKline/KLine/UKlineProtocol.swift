//
//  UKlineProtocol.swift
//  swiftKline_macOS
//
//  Created by zhanghao on 2020/12/1.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

/// K线走势数据源
public protocol UKlineDataSource {
    
    /// 开盘价
    var _openPrice: Double { get }

    /// 最高价
    var _highPrice: Double { get }
    
    /// 最低价
    var _lowPrice: Double { get }
    
    /// 收盘价
    var _closePrice: Double { get }
    
    /// 成交量
    var _volume: Double { get }
    
    /// 日期
    var _date: Date? { get }
    
    /// 日期文本
    var _dateText: String? { get }
    
    /// 均价
    var _averagePrice: Double { get }

    /// 成交额
    var _turnover: Double { get }
    
    /// 昨收价
    var _preClosePrice: Double { get }
}

public extension UKlineDataSource {
    
    /// 日期
    var _date: Date? { return nil }
    
    /// 日期文本
    var _dateText: String? { return nil }
    
    /// 均价
    var _averagePrice: Double { return 0 }

    /// 成交额
    var _turnover: Double { return 0 }
    
    /// 昨收价
    var _preClosePrice: Double { return 0 }
}
