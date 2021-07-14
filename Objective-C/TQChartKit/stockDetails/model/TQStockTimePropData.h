//
//  TQStockTimePropData.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/23.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TQStockChartProtocol.h"

@interface TQStockTimePropData : NSObject <TQTimeChartCoordsProtocol>

@property (nonatomic, strong) NSArray<id<TQTimeChartProtocol>> *dataArray;

- (void)defaultStyle;
- (void)fiveDayStyle;

@end
