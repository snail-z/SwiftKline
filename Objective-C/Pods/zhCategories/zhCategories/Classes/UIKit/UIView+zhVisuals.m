//
//  UIView+zhVisuals.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/3.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UIView+zhVisuals.h"
#import <objc/runtime.h>

@implementation UIView (zhVisuals)

- (void)zh_addLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 1;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)zh_addCornerRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners {
    CGRect rect = self.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (CAShapeLayer *)zh_borderLayer {
    CAShapeLayer *layer = objc_getAssociatedObject(self, _cmd);
    if (!layer) {
        layer = [CAShapeLayer layer];
        objc_setAssociatedObject(self, _cmd, layer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return layer;
}

- (void)zh_addSidelinePosition:(zhSidelinePosition)position lineWidth:(CGFloat)width lineColor:(UIColor *)color {
    if (!self.translatesAutoresizingMaskIntoConstraints) {
        [self.superview layoutIfNeeded];
    }
    if (CGRectIsEmpty(self.frame) || !position) return;
    if (width <= 0) {
        void *constKey = @selector(zh_borderLayer);
        id obj = objc_getAssociatedObject(self, constKey);
        if (obj) {
            if (self.zh_borderLayer.superlayer) {
                [self.zh_borderLayer removeFromSuperlayer];
            }
            objc_setAssociatedObject(self, constKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        return;
    }
    CGFloat halfWidth = width / 2;
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (position & zhSidelinePositionLeft) {
        [path moveToPoint:CGPointMake(halfWidth, 0)];
        [path addLineToPoint:CGPointMake(halfWidth, self.frame.size.height)];
    }
    if (position & zhSidelinePositionRight) {
        [path moveToPoint:CGPointMake(self.frame.size.width - halfWidth, 0)];
        [path addLineToPoint:CGPointMake(self.frame.size.width - halfWidth, self.frame.size.height)];
    }
    if (position & zhSidelinePositionTop) {
        [path moveToPoint:CGPointMake(0, halfWidth)];
        [path addLineToPoint:CGPointMake(self.frame.size.width, halfWidth)];
    }
    if (position & zhSidelinePositionBottom) {
        [path moveToPoint:CGPointMake(0, self.frame.size.height - halfWidth)];
        [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height - halfWidth)];
    }
    self.zh_borderLayer.path = path.CGPath;
    self.zh_borderLayer.strokeColor = color.CGColor;
    self.zh_borderLayer.lineWidth = width;
    self.zh_borderLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:self.zh_borderLayer];
}

- (void)zh_add1pxSidelinePosition:(zhSidelinePosition)position {
    CGFloat width = 1 / [UIScreen mainScreen].scale;
    UIColor *color = [UIColor grayColor];
    [self zh_addSidelinePosition:position lineWidth:width lineColor:color];
}

@end
