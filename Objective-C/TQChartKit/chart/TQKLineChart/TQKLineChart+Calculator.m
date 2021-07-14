//
//  TQKLineChart+Calculator.m
//  TQChartKit
//
//  Created by zhanghao on 2018/8/1.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQKLineChart+Calculator.h"

@implementation TQKLineChart (Calculator)

- (NSRange)getVisualRange {
    CGFloat currentOffsetX = self.scrollView.contentOffset.x - self.scrollView.origin.x;
    CGFloat sumWidthGap = self.style.shapeWidth + self.style.shapeGap;
    NSInteger index = (NSInteger)round(currentOffsetX / sumWidthGap);
    NSUInteger length = self.style.numberOfVisual;
    index -= 1; length += 2; // draw two more lines for a smooth transition.
    NSUInteger dataCount = self.dataArray.count;
    index = MIN(dataCount, MAX(0, index));
    NSRange range = NSMakeRange(index, length);
    if (NSMaxRange(range) > dataCount) {
        range.length = dataCount - range.location;
    }
    return range;
}

- (NSRange)getCalculatedRange {
    CGFloat currentOffsetX = self.scrollView.contentOffset.x - self.scrollView.origin.x;
    CGFloat sumWidthGap = self.style.shapeWidth + self.style.shapeGap;
    NSInteger index = (NSInteger)round(currentOffsetX / sumWidthGap);
    NSUInteger dataCount = self.dataArray.count;
    index = MIN(dataCount, MAX(0, index));
    NSRange range = NSMakeRange(index, self.style.numberOfVisual);
    if (NSMaxRange(range) > dataCount) {
        range.length = dataCount - range.location;
    }
    if (self.scrollView.contentOffset.x < 0) {
        range.length -= (NSInteger)round(fabs(self.scrollView.contentOffset.x) / sumWidthGap);
    }
    return range;
}

- (CGPeakIndexValue)getPeakIndexValueWithRange:(NSRange)range {
    __block CGIndexValue max = CGIndexValueMake(0, CGFLOAT_MIN);
    __block CGIndexValue min = CGIndexValueMake(0, CGFLOAT_MAX);
    [self.dataArray enumerateObjsAtRange:range ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
        if (obj.tq_high > max.value) max = CGIndexValueMake(idx, obj.tq_high);
        if (obj.tq_low < min.value) min = CGIndexValueMake(idx, obj.tq_low);
    }];
    return CGPeakIndexValueMake(max, min);
}

- (CGPeakValue)getPeakValueWithRange:(NSRange)range {
    __block CGPeakValue peak = CGPeakValueMake(CGFLOAT_MIN, CGFLOAT_MAX);
    [self.dataArray enumerateObjsAtRange:range ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
        if (obj.tq_high > peak.max) peak.max = obj.tq_high;
        if (obj.tq_low < peak.min) peak.min = obj.tq_low;
    }];
    return peak;
}

- (CGPeakValue)getEnlargePeakValue:(CGPeakValue)peak {
    CGFloat proportion = CG_GetPeakDistance(peak) / self.layout.topChartFrame.size.height;
    CGFloat enlarge = self.style.peakEdgePadding * proportion;
    return CGPeakValueMake(peak.max + enlarge, peak.min - enlarge);
}

- (CGFloat)getCenterXInRootViewWithIndex:(NSInteger)index {
    CGFloat centerX = CGaxisXConverMaker(self.style.shapeWidth, self.style.shapeGap)(index);
    centerX -= self.scrollView.contentOffset.x;
    return centerX;
}

@end

