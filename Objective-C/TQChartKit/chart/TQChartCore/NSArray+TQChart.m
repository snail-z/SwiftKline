
//
//  NSArray+TQChart.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/17.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "NSArray+TQChart.h"

@implementation NSArray (TQChart)

- (NSArray<id> *)tq_toCGColors {
    if (![self isKindOfClass:[NSArray<UIColor *> class]]) {
        return nil;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (UIColor *obj in self) {
        [array addObject:(__bridge id)obj.CGColor];
    }
    return array;
}

@end
