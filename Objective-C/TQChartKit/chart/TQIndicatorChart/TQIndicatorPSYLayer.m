//
//  TQIndicatorPSYLayer.m
//  TQChartKit
//
//  Created by zhanghao on 2018/9/8.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndicatorPSYLayer.h"

@interface TQIndicatorPSYLayer ()

@property (nonatomic, strong) CAShapeLayer *psyValueLayer;
@property (nonatomic, strong) CAShapeLayer *psymaValueLayer;

@end

@implementation TQIndicatorPSYLayer

- (instancetype)init {
    if (self = [super init]) {
        [self sublayersInitialization];
    }
    return self;
}

- (void)sublayersInitialization {
    _psyValueLayer = [CAShapeLayer layer];
    [self addSublayer:_psyValueLayer];
    
    _psymaValueLayer = [CAShapeLayer layer];
    [self addSublayer:_psymaValueLayer];
}

- (void)updateStyle {
    _psyValueLayer.fillColor = [UIColor clearColor].CGColor;
    _psyValueLayer.strokeColor = self.styles.PSYLineColor.CGColor;
    _psyValueLayer.lineWidth = self.styles.PSYLineWidth;
    
    _psymaValueLayer.fillColor = [UIColor clearColor].CGColor;
    _psymaValueLayer.strokeColor = self.styles.PSYMALineColor.CGColor;
    _psymaValueLayer.lineWidth = self.styles.PSYLineWidth;
}

- (void)updateChartInRange:(NSRange)range {
    [self drawLineInRange:range atLayer:_psyValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.PSYValue;
    }];
    
    [self drawLineInRange:range atLayer:_psymaValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.PSYMAValue;
    }];
}

- (CGPeakValue)indicatorPeakValueForRange:(NSRange)range {
    CGPeakValue value1 = [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.PSYValue;
    }];
    CGPeakValue value2 = [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.PSYMAValue;
    }];
    CGPeakValue values[] = {value1, value2};
    return CG_TraversePeakValues(values, 2);
}

- (NSArray<TQChartTextRenderer *> *)indicatorTrellisForPeakValue:(CGPeakValue)peakValue path:(UIBezierPath *__autoreleasing *)pathPointer {
    CGFloat baseline = 50.0;
    CGFloat distance = CG_GetPeakDistance(peakValue);
    CGFloat baselineGap = (peakValue.max - baseline) / distance * self.plotter.drawRect.size.height;
    CGFloat originY = self.plotter.drawRect.origin.y + baselineGap;
    NSString *string1 = [NSString stringWithFormat:@"%.2f", (baseline)];
    NSString *maxText = [NSString stringWithFormat:@"%.2f", (peakValue.max)];
    NSString *minText = [NSString stringWithFormat:@"%.2f", (peakValue.min)];
    NSArray<NSString *> *array = @[string1];
    
    TQChartTextRenderer* (^makeRender)(NSString *, CGPoint) = ^(NSString *text, CGPoint p) {
        TQChartTextRenderer *render = [TQChartTextRenderer defaultRendererWithText:text];
        render.font = self.styles.plainAxisTextFont;
        render.color = self.styles.plainAxisTextColor;
        render.positionCenter = p;
        render.offsetRatio = kCGOffsetRatioBottomLeft;
        return render;
    };
    
    NSMutableArray<TQChartTextRenderer *> *renders = [NSMutableArray array];
    UIBezierPath *path = *pathPointer;
    CGPoint p1 = self.plotter.drawRect.origin;
    CGPoint p2 = CGPointMake(p1.x, CGRectGetMaxY(self.plotter.drawRect));
    [renders addObject:makeRender(maxText, p1)];
    [renders addObject:makeRender(minText, p2)];
    [path addHorizontalLine:p1 len:CGRectGetWidth(self.plotter.drawRect)];
    [path addHorizontalLine:p2 len:CGRectGetWidth(self.plotter.drawRect)];
    for (NSInteger i = 0; i < array.count; i++) {
        CGPoint start = CGPointMake(self.plotter.drawRect.origin.x, originY + baselineGap * i);
        [path addHorizontalLine:start len:CGRectGetWidth(self.plotter.drawRect)];
        [renders addObject:makeRender(array[i], start)];
    }
    renders.firstObject.offsetRatio = kCGOffsetRatioTopLeft;
    return renders;
}

@end
