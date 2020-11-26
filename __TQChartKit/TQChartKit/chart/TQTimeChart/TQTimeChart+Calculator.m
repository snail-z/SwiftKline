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
    return CGPeakValueMake(self.propConfig.tq_maxPrice, self.propConfig.tq_minPrice);
}

- (CGPeakValue)changeRatioPeakValue {
    return CGPeakValueMake(self.propConfig.tq_maxChangeRatio, self.propConfig.tq_minChangeRatio);
}

- (CGFloat)getCenterXWithIndex:(NSInteger)index {
    CGFloat halfWidth = self.style.volumeShapeWidth * 0.5;
    CGFloat centerX = (self.style.volumeShapeWidth + self.style.volumeShapeGap) * index + halfWidth;
    return centerX + self.layout.contentFrame.origin.x;
}

- (CGFloat)getOriginXWithIndex:(NSInteger)index {
    CGFloat halfWidth = self.style.volumeShapeWidth * 0.5;
    CGFloat centerX = [self getCenterXWithIndex:index];
    return centerX - halfWidth;
}

- (NSInteger)mapIndexWithOriginX:(CGFloat)pointX {
    CGFloat widthAndGap = self.style.volumeShapeWidth + self.style.volumeShapeGap;
    CGFloat widthAndHalfGap = self.style.volumeShapeWidth + self.style.volumeShapeGap * 0.5;
    NSInteger index = pointX / widthAndGap;
    CGFloat ref = index * widthAndGap + widthAndHalfGap;
    if (pointX > ref) index += 1;
    index = MAX(0, index);
    index = MIN(self.dataArray.count - 1, index);
    return index;
}

- (void)makeDateRenderer:(CGFloat *)positionY baseOffsetVertical:(CGFloat *)vertical {
    CGFloat positionCenterY; CGFloat baseOffsetVertical;
    if ([self.style.dateLocation isEqualToString:@"middle"]) {
        positionCenterY = CGRectGetMaxY(self.layout.topChartFrame);
        baseOffsetVertical = half(self.layout.separatedGap);
    } else if ([self.style.dateLocation isEqualToString:@"top"]) {
        positionCenterY = 0;
        baseOffsetVertical = half(self.layout.contentEdgeInset.top);
    } else {
        positionCenterY = CGRectGetMaxY(self.layout.bottomChartFrame);
        baseOffsetVertical = half(self.layout.contentEdgeInset.bottom);
    }
    *positionY = positionCenterY;
    *vertical = baseOffsetVertical;
}

@end
