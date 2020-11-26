//
//  PKTimePileBaseLayer.m
//  PKStockCharts
//
//  Created by zhanghao on 2019/8/8.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import "PKTimePileBaseLayer.h"

@implementation PKTimePileBaseLayer

@end

@implementation PKTimePileBaseLayer (DrawLines)

- (void)drawHorizontalLineInLayer:(CAShapeLayer *)layer
                   evaluatedBlock:(CGFloat (^ NS_NOESCAPE)(void))block {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint point = CGPointMake(self.scaler.chartRect.origin.x, self.axisYCallback(block()));
    [path pk_addHorizontalLine:point len:self.scaler.chartRect.size.width];
    layer.path = path.CGPath;
}

- (void)drawVerticalLineInLayer:(CAShapeLayer *)layer
                 evaluatedBlock:(CGFloat (^ NS_NOESCAPE)(void))block {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint point = CGPointMake(self.scaler.chartRect.origin.y, self.axisXCallback(block()));
    [path pk_addVerticalLine:point len:self.scaler.chartRect.size.height];
    layer.path = path.CGPath;
}

- (void)drawLineInLayer:(CAShapeLayer *)layer
         evaluatedBlock:(CGFloat (^ NS_NOESCAPE)(id<PKTimeChartProtocol> _Nonnull))block {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat value = block(self.dataList[0]);
    CGPoint p = CGPointMake(self.axisXCallback(0), self.axisYCallback(value));
    [path moveToPoint:p];
    for (NSInteger idx = 1; idx < self.dataList.count; idx++) {
        @autoreleasepool {
            CGFloat value = block(self.dataList[idx]);
            CGPoint p = CGPointMake(self.axisXCallback(idx), self.axisYCallback(value));
            [path addLineToPoint:p];
        }
    }
    layer.path = path.CGPath;
}

- (void)drawLineSkipZeroInLayer:(CAShapeLayer *)layer
                 evaluatedBlock:(CGFloat (^ NS_NOESCAPE)(id<PKTimeChartProtocol> _Nonnull))block {
    BOOL _skip = YES;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    NSInteger length = self.dataList.count;
    for (NSInteger idx = 0; idx < length; idx++) {
        @autoreleasepool {
            CGFloat value = block(self.dataList[idx]);
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

@implementation PKTimePileBaseLayer (SetValues)

- (void)setValueForDataList:(NSArray<id<PKTimeChartProtocol>> *)dataList {
    _dataList = dataList;
}

- (void)setValueForScaler:(CGChartScaler)scaler {
    _scaler = scaler;
}

- (void)setValueForAxisYCallback:(CGMakeYaxisBlock)axisYCallback {
    _axisYCallback = axisYCallback;
}

- (void)setValueForAxisXCallback:(CGMakeXaxisBlock)axisXCallback {
    _axisXCallback = axisXCallback;
}

@end
