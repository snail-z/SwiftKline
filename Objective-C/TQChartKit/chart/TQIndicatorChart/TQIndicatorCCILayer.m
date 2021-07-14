//
//  TQIndicatorCCILayer.m
//  TQChartKit
//
//  Created by zhanghao on 2018/9/5.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndicatorCCILayer.h"

@interface TQIndicatorCCILayer ()

@property (nonatomic, strong) CAShapeLayer *cciValueLayer;

@end

@implementation TQIndicatorCCILayer

- (instancetype)init {
    if (self = [super init]) {
        [self sublayersInitialization];
    }
    return self;
}

- (void)sublayersInitialization {
    _cciValueLayer = [CAShapeLayer layer];
    [self addSublayer:_cciValueLayer];
}

- (void)updateStyle {
    _cciValueLayer.fillColor = [UIColor clearColor].CGColor;
    _cciValueLayer.strokeColor = self.styles.CCILineColor.CGColor;
    _cciValueLayer.lineWidth = self.styles.CCILineWidth;
}

- (void)updateChartInRange:(NSRange)range {
    [self drawLineInRange:range atLayer:_cciValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.CCIValue;
    }];
}

- (CGPeakValue)indicatorPeakValueForRange:(NSRange)range {
    return [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull obj) {
        return obj.CCIValue;
    }];
}

- (NSArray<TQChartTextRenderer *> *)indicatorTrellisForPeakValue:(CGPeakValue)peakValue path:(UIBezierPath *__autoreleasing *)pathPointer {
    // CCI常态区间+100线～-100线，不等分三段实时变动
    CGFloat lesser = -100; CGFloat largish = 100;
    CGFloat distance = CG_GetPeakDistance(peakValue);
    if (CG_FloatIsZero(distance)) return nil;
    CGFloat nolGap = (fabs(lesser) + largish) / distance * self.plotter.drawRect.size.height;
    CGFloat larGap = fabs(fabs(peakValue.max) - largish) / distance * self.plotter.drawRect.size.height;
    CGFloat originY = self.plotter.drawRect.origin.y + larGap;
    NSString *string1 = [NSString stringWithFormat:@"%.2f", largish];
    NSString *string2 = [NSString stringWithFormat:@"%.2f", lesser];
    NSArray<NSString *> *array = @[string1, string2];
    
    NSMutableArray<TQChartTextRenderer *> *renders = [NSMutableArray array];
    UIBezierPath *path = *pathPointer;
    for (NSInteger i = 0; i < array.count; i++) {
        CGPoint start = CGPointMake(self.plotter.drawRect.origin.x, originY + i * nolGap);
        [path addHorizontalLine:start len:CGRectGetWidth(self.plotter.drawRect)];
        TQChartTextRenderer *render = [TQChartTextRenderer defaultRendererWithText:array[i]];
        render.font = self.styles.plainAxisTextFont;
        render.color = self.styles.plainAxisTextColor;
        render.positionCenter = start;
        render.offsetRatio = kCGOffsetRatioBottomLeft;
        [renders addObject:render];
    }
    CGPoint p1 = self.plotter.drawRect.origin;
    CGPoint p2 = CGPointMake(p1.x, CGRectGetMaxY(self.plotter.drawRect));
    [path addHorizontalLine:p1 len:CGRectGetWidth(self.plotter.drawRect)];
    [path addHorizontalLine:p2 len:CGRectGetWidth(self.plotter.drawRect)];
    return renders;
}

@end
