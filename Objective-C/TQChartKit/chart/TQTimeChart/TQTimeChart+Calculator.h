//
//  TQKTimeChart+Calculator.h
//  CoreGraphics_demo
//
//  Created by zhanghao on 2018/7/8.
//  Copyright © 2018年 snail-z. All rights reserved.
//

#import "TQTimeChart.h"
#import "TQStockChartUtilities.h"

@interface TQTimeChart (Calculator)

@property (nonatomic, assign, readonly) CGPeakValue timePeakValue;
@property (nonatomic, assign, readonly) CGPeakValue changeRatioPeakValue;

- (CGFloat)getCenterXWithIndex:(NSInteger)index;
- (CGFloat)getOriginXWithIndex:(NSInteger)index;

- (CGFloat)mapRefValueWithPointY:(CGFloat)py peak:(CGPeakValue)peak inRect:(CGRect)rect;
- (NSInteger)mapIndexWithPointX:(CGFloat)pointX;

@end
