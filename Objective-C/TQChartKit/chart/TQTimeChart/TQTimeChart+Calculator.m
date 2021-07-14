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
    return CGPeakValueMake(self.coordsConfig.tq_maxPrice, self.coordsConfig.tq_minPrice);
}

- (CGPeakValue)changeRatioPeakValue {
    return CGPeakValueMake(self.coordsConfig.tq_maxChangeRatio, self.coordsConfig.tq_minChangeRatio);
}

- (CGFloat)getCenterXWithIndex:(NSInteger)index {
    CGFloat halfWidth = self.style.volumeShapeWidth * 0.5;
    CGFloat centerX = (self.style.volumeShapeWidth + self.style.volumeShapeGap) * index + halfWidth;
    return centerX + self.layout.contentFrame.origin.x;
}

- (CGFloat)getOriginXWithIndex:(NSInteger)index {
    CGFloat centerX = [self getCenterXWithIndex:index];
    return centerX - half(self.style.volumeShapeWidth);
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
