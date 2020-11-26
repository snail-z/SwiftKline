//
//  UIBezierPath+TQChart.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/17.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "UIBezierPath+TQChart.h"

@implementation UIBezierPath (TQChart)

- (void)addLine:(CGPoint)start end:(CGPoint)end {
    [self moveToPoint:start];
    [self addLineToPoint:end];
}

- (void)addHorizontalLine:(CGPoint)start len:(CGFloat)len {
    [self moveToPoint:start];
    [self addLineToPoint:CGPointMake(start.x + len, start.y)];
}

- (void)addVerticalLine:(CGPoint)start len:(CGFloat)len {
    [self moveToPoint:start];
    [self addLineToPoint:CGPointMake(start.x, start.y + len)];
}

- (void)addRect:(CGRect)rect {
    [self moveToPoint:rect.origin];
    [self addLineToPoint:CGPointMake(CGRectGetMaxX(rect), rect.origin.y)];
    [self addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
    [self addLineToPoint:CGPointMake(rect.origin.x, CGRectGetMaxY(rect))];
    [self closePath];
}

- (void)addCandleShape:(CGCandleShape)shape {
    [self addRect:shape.rect];
    [self moveToPoint:shape.top];
    [self addLineToPoint:CGPointMake(shape.top.x, CGRectGetMinY(shape.rect))];
    [self moveToPoint:shape.bottom];
    [self addLineToPoint:CGPointMake(shape.bottom.x, CGRectGetMaxY(shape.rect))];
}

- (void)addTwigCandleShape:(CGCandleShape)shape {
    [self moveToPoint:shape.top];
    [self addLineToPoint:shape.bottom];
    [self moveToPoint:CGPointMake(shape.top.x, CGRectGetMinY(shape.rect))];
    [self addLineToPoint:CGPointMake(CGRectGetMaxX(shape.rect), CGRectGetMinY(shape.rect))];
    [self moveToPoint:CGPointMake(shape.bottom.x, CGRectGetMaxY(shape.rect))];
    [self addLineToPoint:CGPointMake(CGRectGetMinX(shape.rect), CGRectGetMaxY(shape.rect))];
}

@end
