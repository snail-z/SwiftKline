//
//  UIBezierPath+PKExtend.m
//  PKCategories
//
//  Created by jiaohong on 2019/1/8.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "UIBezierPath+PKExtend.h"

@implementation UIBezierPath (PKExtend)

- (void)pk_addRect:(CGRect)rect {
    [self moveToPoint:rect.origin];
    CGFloat maxX = rect.origin.x + rect.size.width;
    CGFloat maxY = rect.origin.y + rect.size.height;
    [self addLineToPoint:CGPointMake(maxX, rect.origin.y)];
    [self addLineToPoint:CGPointMake(maxX, maxY)];
    [self addLineToPoint:CGPointMake(rect.origin.x, maxY)];
    [self closePath];
}

@end
