//
//  NSArray+TQChart.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/17.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSArray (TQChart)

/** 将UIColor数组转成CGColor数组 */
- (nullable NSArray<id> *)tq_toCGColors;

@end
