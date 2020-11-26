//
//  TQKLineChart+Calculator.m
//  TQChartKit
//
//  Created by zhanghao on 2018/8/1.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQKLineChart+Calculator.h"
#import "TQStockChart+Categories.h"

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
    NSUInteger length = self.style.numberOfVisual;
    NSUInteger dataCount = self.dataArray.count;
    index = MIN(dataCount, MAX(0, index));
    NSRange range = NSMakeRange(index, length);
    if (NSMaxRange(range) > dataCount) {
        range.length = dataCount - range.location;
    }
    if (self.scrollView.contentOffset.x < 0) {
        range.length -= (NSInteger)round(fabs(self.scrollView.contentOffset.x) / sumWidthGap);
    }
    return range;
}

#pragma mark - Center X

- (CGFloat)getCenterXInRootViewWithIndex:(NSInteger)index {
    CGFloat centerX = [self getCenterXInScrollViewWithIndex:index];
    centerX -= self.scrollView.contentOffset.x;
    return centerX;
}

- (CGFloat)getCenterXInScrollViewWithIndex:(NSInteger)index {
    CGFloat oneHalfWidth = self.style.shapeWidth * 0.5;
    CGFloat centerX = (self.style.shapeWidth + self.style.shapeGap) * index + oneHalfWidth;
    return centerX;
}

- (CGPeakIndexValue)getPeakIndexValueWithRange:(NSRange)range {
    __block CGIndexValue max = CGIndexValueMake(0, CGFLOAT_MIN);
    __block CGIndexValue min = CGIndexValueMake(0, CGFLOAT_MAX);
    [self.dataArray tq_enumerateObjectsAtRange:range usingBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tq_high > max.value) max = CGIndexValueMake(idx, obj.tq_high);
        if (obj.tq_low < min.value) min = CGIndexValueMake(idx, obj.tq_low);
    }];
    return CGPeakIndexValueMake(max, min);
}

- (CGPeakValue)getPeakValueWithRange:(NSRange)range {
    __block CGPeakValue peak = CGPeakValueMake(CGFLOAT_MIN, CGFLOAT_MAX);
    [self.dataArray tq_enumerateObjectsAtRange:range usingBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tq_high > peak.max) peak.max = obj.tq_high;
        if (obj.tq_low < peak.min) peak.min = obj.tq_low;
    }];
    return peak;
}

- (CGPeakValue)getEnlargePeakValue:(CGPeakValue)peak {
    CGFloat proportion = (peak.max - peak.min) / self.layout.topChartFrame.size.height;
    CGFloat enlarge = self.style.peakEdgePadding * proportion;
    return CGPeakValueMake(peak.max + enlarge, peak.min - enlarge);
}

- (CGFloat)mapValueInRect:(CGRect)rect originY:(CGFloat)originY peakValue:(CGPeakValue)peak {
    CGFloat proportion = (originY - rect.origin.y) / rect.size.height;
    CGFloat proportionValue = (peak.max - peak.min) * proportion;
    return peak.max - proportionValue;
}

- (CGFloat (^)(CGFloat))makeOriginYConverter:(CGPeakValue)peak inRect:(CGRect)rect {
    CGFloat factor = peak.max - peak.min; factor = (factor != 0 ? factor : 1);
    return ^(CGFloat value) {
        CGFloat proportion = fabs(peak.max - value) / factor;
        return (rect.size.height - self.style.gridLineWidth) * proportion + rect.origin.y + self.style.gridLineWidth * 0.5;
    };
}

- (NSInteger)mapCorrespondIndexWithPointX:(CGFloat)pointX {
    CGFloat shapeOne = (self.style.shapeWidth + self.style.shapeGap);
    NSInteger index = pointX / shapeOne;
    CGFloat baseline = (index * shapeOne + shapeOne) - (self.style.shapeGap * 0.5);
    if (pointX > baseline) index += 1;
    return (index < self.dataArray.count) ? index : self.dataArray.count - 1;
}

@end
