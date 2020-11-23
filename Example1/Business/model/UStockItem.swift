//
//  UStockItem.swift
//  swiftKline
//
//  Created by zhanghao on 2020/11/4.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import Cocoa

// MARK: 股票信息
public class UStockItem: UBaseItem {
    
    /// 最高价
    public var high_price: String = ""
    /// 最低价
    public var low_price: String = ""
    /// 市场
    public var market: String = ""
    /// 股票代码
    public var stock_code: String = ""
    /// 股票名称
    public var stock_name: String = ""
    /// 昨收
    public var pre_close_price: String = ""
    /// 分时数据
    public var times: [UTimeItem] = []
}

// MARK: 分时线信息
public class UTimeItem: UBaseItem {

    /// 日期
    public var date: String = ""
    /// 昨收
    public var pre_close_price: Double = 0
    /// 均价
    public var avg_price: Double = 0
    /// 当前价
    public var price: Double = 0
    /// 成交量
    public var volume: Double = 0
    /// 成交额
    public var amount: Double = 0
    /// 大盘价
    public var lead_price: Double = 0
    /// 大盘是否上涨
    public var lead_upward: Bool = false
    /// 大盘成交量
    public var lead_volume: Double = 0
}

extension UTimeItem: UTimeDataSource {
    
    public var _latestPrice: Double {
        return price
    }
    
    public var _averagePrice: Double {
        return avg_price
    }
    
    public var _volume: Double {
        return volume
    }
    
    public var _date: Date {
        return Date()
    }
}

// MARK: K线信息
public class UKLineItem: UBaseItem {
    
}
