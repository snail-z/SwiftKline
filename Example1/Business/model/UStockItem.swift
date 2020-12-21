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
    
    /// 换手
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
    
    /// 日期
    public var date: String = ""
    
    /// 收盘价
    public var close_price: Double = 0
    
    /// 最高价
    public var high_price: Double = 0
    
    /// 最低价
    public var low_price: Double = 0
    
    /// 开盘价
    public var open_price: Double = 0
    
    /// 涨跌
    public var price_change : Double = 0
    
    /// 涨跌幅
    public var price_change_rate: Double = 0
    
    /// 换手率
    public var turnover: Double = 0
    
    /// 换手率
    public var turnover_rate: Double = 0
    
    /// 振幅
    public var amplitude: Double = 0
    
    /// 成交量
    public var volume: Double = 0
    
    /// MA5
    public var avg_price_5: Double = 0
    
    /// MA10
    public var avg_price_10: Double = 0
    
    /// MA20
    public var avg_price_20: Double = 0
}

extension UKLineItem: UKlineDataSource {
    
    public var _openPrice: Double {
        return open_price
    }
    
    public var _highPrice: Double {
        return high_price
    }
    
    public var _lowPrice: Double {
        return low_price
    }
    
    public var _closePrice: Double {
        return close_price
    }
    
    public var _volume: Double {
        return volume
    }
    
    public var _date: Date! {
        let mdate = Date.pk.date(fromString: date, format:.yMdHms)
        return mdate
    }
    
    public var _dateText: String? {
        return date
    }
}
