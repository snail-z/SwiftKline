//
//  TQKTimeChart+Calculator.m
//  CoreGraphics_demo
//
//  Created by zhanghao on 2018/7/8.
//  Copyright © 2018年 snail-z. All rights reserved.
//

#import "TQTimeChart+Calculator.h"

@implementation TQTimeChart (Calculator)

- (CGPeakValue)timePeakValue {
    return CGPeakValueMake(self.propData.tq_maxPrice, self.propData.tq_minPrice);
}

- (CGPeakValue)changeRatioPeakValue {
    return CGPeakValueMake(self.propData.tq_maxChangeRatio, self.propData.tq_minChangeRatio);
}

- (CGFloat)getCenterXWithIndex:(NSInteger)index {
    CGFloat halfWidth = self.configuration.volumeBarBodyWidth * 0.5;
    CGFloat centerX = (self.configuration.volumeBarBodyWidth + self.configuration.volumeBarGap) * index + halfWidth;
    return centerX + self.chartFrame.origin.x;
}

- (CGFloat)getOriginXWithIndex:(NSInteger)index {
    CGFloat halfWidth = self.configuration.volumeBarBodyWidth * 0.5;
    CGFloat centerX = [self getCenterXWithIndex:index];
    return centerX - halfWidth;
}

- (CGFloat)mapRefValueWithPointY:(CGFloat)py peak:(CGPeakValue)peak inRect:(CGRect)rect {
    CGFloat pointY = py - rect.origin.y;
    CGFloat proportion = pointY / rect.size.height;
    CGFloat proportionValue = (peak.max - peak.min) * proportion;
    return peak.max - proportionValue;
}

- (NSInteger)mapIndexWithPointX:(CGFloat)pointX {
    CGFloat widthAndGap = self.configuration.volumeBarBodyWidth + self.configuration.volumeBarGap;
    CGFloat widthAndHalfGap = self.configuration.volumeBarBodyWidth + self.configuration.volumeBarGap * 0.5;
    NSInteger index = pointX / widthAndGap;
    CGFloat ref = index * widthAndGap + widthAndHalfGap;
    if (pointX > ref) index += 1;
    index = MAX(0, index);
    index = MIN(self.dataArray.count - 1, index);
    return index;
}

@end
