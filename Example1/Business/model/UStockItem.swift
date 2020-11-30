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
    public var total_volume: Double = 0
    /// 涨跌
    public var price_change : Double = 0
    /// 涨跌幅
    public var price_change_rate: Double = 0
    /// 转手率
    public var turnover: Double = 0
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
        // 2017-06-26 11:03:00
        let rdate = Date.pk.date(fromString: date, format: .yMdHms)!
        return rdate
    }
}

// MARK: K线信息
public class UKLineItem: UBaseItem {
    
}
