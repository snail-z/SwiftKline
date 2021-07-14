//
//  TQIndicatorRSILayer.m
//  TQChartKit
//
//  Created by zhanghao on 2018/9/6.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndicatorRSILayer.h"

@interface TQIndicatorRSILayer ()

@property (nonatomic, strong) CAShapeLayer *rsi6ValueLayer;
@property (nonatomic, strong) CAShapeLayer *rsi12VlaueLayer;
@property (nonatomic, strong) CAShapeLayer *rsi24VlaueLayer;

@end

@implementation TQIndicatorRSILayer

- (instancetype)init {
    if (self = [super init]) {
        [self sublayersInitialization];
    }
    return self;
}

- (void)sublayersInitialization {
    _rsi6ValueLayer = [CAShapeLayer layer];
    [self addSublayer:_rsi6ValueLayer];
    
    _rsi12VlaueLayer = [CAShapeLayer layer];
    [self addSublayer:_rsi12VlaueLayer];
    
    _rsi24VlaueLayer = [CAShapeLayer layer];
    [self addSublayer:_rsi24VlaueLayer];
}

- (void)updateStyle {
    _rsi6ValueLayer.fillColor = [UIColor clearColor].CGColor;
    _rsi6ValueLayer.strokeColor = self.styles.RSI6LineColor.CGColor;
    _rsi6ValueLayer.lineWidth = self.styles.RSILineWidth;
    
    _rsi12VlaueLayer.fillColor = [UIColor clearColor].CGColor;
    _rsi12VlaueLayer.strokeColor = self.styles.RSI12LineColor.CGColor;
    _rsi12VlaueLayer.lineWidth = self.styles.RSILineWidth;
    
    _rsi24VlaueLayer.fillColor = [UIColor clearColor].CGColor;
    _rsi24VlaueLayer.strokeColor = self.styles.RSI24LineColor.CGColor;
    _rsi24VlaueLayer.lineWidth = self.styles.RSILineWidth;
}

- (void)updateChartInRange:(NSRange)range {
    [self drawLineInRange:range atLayer:_rsi6ValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.RSI6Value;
    }];
    
    [self drawLineInRange:range atLayer:_rsi12VlaueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.RSI12Value;
    }];
    
    [self drawLineInRange:range atLayer:_rsi24VlaueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.RSI24Value;
    }];
}

- (CGPeakValue)indicatorPeakValueForRange:(NSRange)range {
    CGPeakValue value1 = [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.RSI6Value;
    }];
    CGPeakValue value2 = [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.RSI12Value;
    }];
    CGPeakValue value3 = [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.RSI24Value;
    }];
    CGPeakValue values[] = {value1, value2, value3};
    return CG_TraversePeakValues(values, 3);
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
