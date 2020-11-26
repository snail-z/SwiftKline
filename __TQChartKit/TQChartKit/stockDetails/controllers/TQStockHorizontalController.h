//
//  TQStockHorizontalController.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/17.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQStockBaseHorizontalController.h"
#import "TQStockChartProtocol.h"

@interface TQStockHorizontalController : TQStockBaseHorizontalController

@property (nonatomic, strong) NSArray<id<TQTimeChartProtocol>> *dataArray;

@end
