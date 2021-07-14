//
//  UIBezierPath+TQChart.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/17.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "UIBezierPath+TQStockChart.h"

@implementation UIBezierPath (TQStockChart)

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
    CGFloat maxX = rect.origin.x + rect.size.width;
    CGFloat maxY = rect.origin.y + rect.size.height;
    [self addLineToPoint:CGPointMake(maxX, rect.origin.y)];
    [self addLineToPoint:CGPointMake(maxX, maxY)];
    [self addLineToPoint:CGPointMake(rect.origin.x, maxY)];
    [self closePath];
}

- (void)addCandleShape:(CGCandleShape)shape {
    [self addRect:shape.rect];
    [self moveToPoint:shape.top];
    [self addLineToPoint:CGPointMake(shape.top.x, CGRectGetMinY(shape.rect))];
    [self moveToPoint:shape.bottom];
    [self addLineToPoint:CGPointMake(shape.bottom.x, shape.rect.origin.y + shape.rect.size.height)];
}

- (void)addTwigCandleShape:(CGCandleShape)shape {
    [self moveToPoint:shape.top];
    [self addLineToPoint:shape.bottom];
    CGFloat maxX = shape.rect.origin.x + shape.rect.size.width;
    CGFloat maxY = shape.rect.origin.y + shape.rect.size.height;
    [self moveToPoint:CGPointMake(shape.top.x, CGRectGetMinY(shape.rect))];
    [self addLineToPoint:CGPointMake(maxX, CGRectGetMinY(shape.rect))];
    [self moveToPoint:CGPointMake(shape.bottom.x, maxY)];
    [self addLineToPoint:CGPointMake(CGRectGetMinX(shape.rect), maxY)];
}

@end
