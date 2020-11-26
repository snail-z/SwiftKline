//
//  PKIndicatorBaseLayer.m
//  PKChartKit
//
//  Created by zhanghao on 2017/12/16.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import "PKIndicatorBaseLayer.h"

@implementation PKIndicatorBaseLayer

- (void)_sublayerStyleUpdates {}

@end

@implementation PKIndicatorBaseLayer (DrawLines)

- (void)drawLineInRange:(NSRange)range
                atLayer:(CAShapeLayer *)layer
         evaluatedBlock:(CGFloat (^ NS_NOESCAPE)(PKIndicatorCacheItem * _Nonnull))block {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat value = block(self.cacheList[range.location]);
    CGPoint p = CGPointMake(self.axisXCallback(range.location), self.axisYCallback(value));
    [path moveToPoint:p];
    
    range = NS_RangeOffset1(range);
    NSInteger length = NSMaxRange(range);
    for (NSInteger idx = range.location; idx < length; idx++) {
        @autoreleasepool {
            CGFloat value = block(self.cacheList[idx]);
            CGPoint p = CGPointMake(self.axisXCallback(idx), self.axisYCallback(value));
            [path addLineToPoint:p];
        }
    }

    layer.path = path.CGPath;
}

- (void)drawLineSkipZeroInRange:(NSRange)range
                        atLayer:(CAShapeLayer *)layer
                 evaluatedBlock:(CGFloat (^ NS_NOESCAPE)(PKIndicatorCacheItem * _Nonnull))block {
    BOOL _skip = YES;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    NSInteger length = NSMaxRange(range);
    for (NSInteger idx = range.location; idx < length; idx++) {
        @autoreleasepool {
            CGFloat value = block(self.cacheList[idx]);
            if (CGFloatEqualZero(value)) { _skip = YES; continue; }
            
            CGPoint p = CGPointMake(self.axisXCallback(idx), self.axisYCallback(value));
            if (_skip) {
                _skip = NO;
                [path moveToPoint:p];
            } else {
                [path addLineToPoint:p];
            }
        }
    }
    
    layer.path = path.CGPath;
}

@end

@implementation PKIndicatorBaseLayer (SetValues)

- (void)setValueForDataList:(NSArray<id<PKKLineChartProtocol>> *)dataList {
    _dataList = dataList;
}

- (void)setValueForCacheList:(NSArray<PKIndicatorCacheItem *> *)cacheList {
    _cacheList = cacheList;
}

- (void)setValueForSet:(PKIndicatorChartSet *)set {
    _set = set;
    [self _sublayerStyleUpdates];
}

- (void)setValueForScaler:(CGChartScaler)scaler {
    _scaler = scaler;
}

- (void)setValueForAxisXCallback:(CGMakeXaxisBlock)axisXCallback {
    _axisXCallback = axisXCallback;
}

- (void)setValueForAxisYCallback:(CGMakeYaxisBlock)axisYCallback {
    _axisYCallback = axisYCallback;
}

@end
