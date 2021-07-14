//
//  UBaseItem.swift
//  swiftKline
//
//  Created by zhanghao on 2020/11/4.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import HandyJSON

public class UBaseItem: HandyJSON {

    required public init() {}
    
    /// 子类重写实现自定义解析规则
    public func mapping(mapper: HelpingMapper) {}
}

