//
//  UIBezierPath+PKStockChart.m
//  PKChartKit
//
//  Created by zhanghao on 2017/11/28.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import "UIBezierPath+PKStockChart.h"

@implementation UIBezierPath (PKStockChart)

- (void)pk_addLine:(CGPoint)start end:(CGPoint)end {
    [self moveToPoint:start];
    [self addLineToPoint:end];
}

- (void)pk_addHorizontalLine:(CGPoint)start len:(CGFloat)len {
    [self moveToPoint:start];
    [self addLineToPoint:CGPointMake(start.x + len, start.y)];
}

- (void)pk_addVerticalLine:(CGPoint)start len:(CGFloat)len {
    [self moveToPoint:start];
    [self addLineToPoint:CGPointMake(start.x, start.y + len)];
}

- (void)pk_addRect:(CGRect)rect {
    [self moveToPoint:rect.origin];
    CGFloat maxX = rect.origin.x + rect.size.width;
    CGFloat maxY = rect.origin.y + rect.size.height;
    [self addLineToPoint:CGPointMake(maxX, rect.origin.y)];
    [self addLineToPoint:CGPointMake(maxX, maxY)];
    [self addLineToPoint:CGPointMake(rect.origin.x, maxY)];
    [self closePath];
}

- (void)pk_addCandleShape:(CGCandleShape)shape {
    [self pk_addRect:shape.rect];
    [self moveToPoint:shape.top];
    [self addLineToPoint:CGPointMake(shape.top.x, CGRectGetMinY(shape.rect))];
    [self moveToPoint:shape.bottom];
    [self addLineToPoint:CGPointMake(shape.bottom.x, shape.rect.origin.y + shape.rect.size.height)];
}

- (void)pk_addTwigCandleShape:(CGCandleShape)shape {
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
