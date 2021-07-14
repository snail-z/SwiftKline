//
//  TQIndicatorParentLayer.m
//  TQChartKit
//
//  Created by zhanghao on 2018/9/18.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndicatorParentLayer.h"

@implementation TQIndicatorParentLayer

- (void)setStyles:(TQIndicatorChartStyle *)styles {
    if (!styles) return;
    _styles = styles;
    [self updateStyle];
}

- (void)updateStyle {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)updateChartInRange:(NSRange)range {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)dealloc {
    NSLog(@"%@~~~~~~dealloc!✈️", NSStringFromClass(self.class));
}

@end

@implementation TQIndicatorParentLayer (DrawLine)

- (void)drawLineInRange:(NSRange)range atLayer:(CAShapeLayer *)layer evaluatedBlock:(CGFloat (^NS_NOESCAPE)(TQStockCacheModel * _Nonnull))block {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat value = block(self.cacheModels[range.location]);
    CGPoint p = CGPointMake(self.axisXCallback(range.location), self.axisYCallback(value));
    [path moveToPoint:p];
    [self.cacheModels enumerateObjsAtRange:NS_RangeOffset1(range) ceaselessBlock:^(TQStockCacheModel * _Nonnull obj, NSUInteger idx) {
        CGFloat value = block(obj);
        CGPoint p = CGPointMake(self.axisXCallback(idx), self.axisYCallback(value));
        [path addLineToPoint:p];
    }];
    layer.path = path.CGPath;
}

- (void)drawLineSkipZeroInRange:(NSRange)range atLayer:(CAShapeLayer *)layer evaluatedBlock:(CGFloat (^NS_NOESCAPE)(TQStockCacheModel * _Nonnull))block {
    __block BOOL _skip = YES;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [self.cacheModels enumerateObjsAtRange:range ceaselessBlock:^(TQStockCacheModel * _Nonnull obj, NSUInteger idx) {
        CGFloat value = block(obj);
        if (CG_FloatIsZero(value)) {
            _skip = YES;
        } else {
            CGPoint p = CGPointMake(self.axisXCallback(idx), self.axisYCallback(value));
            if (_skip) {
                _skip = NO;
                [path moveToPoint:p];
            } else {
                [path addLineToPoint:p];
            }
        }
    }];
    layer.path = path.CGPath;
}

@end
