//
//  TQIndicatorMACDLayer.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/31.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndicatorMACDLayer.h"

@interface TQIndicatorMACDLayer ()

@property (nonatomic, strong) CAShapeLayer *difValueLayer;
@property (nonatomic, strong) CAShapeLayer *deaValueLayer;
@property (nonatomic, strong) CAShapeLayer *macdUpValueLayer;
@property (nonatomic, strong) CAShapeLayer *macdDnValueLayer;

@end

@implementation TQIndicatorMACDLayer

- (instancetype)init {
    if (self = [super init]) {
        [self sublayersInitialization];
    }
    return self;
}

- (void)sublayersInitialization {
    _difValueLayer = [CAShapeLayer layer];
    [self addSublayer:_difValueLayer];
    
    _deaValueLayer = [CAShapeLayer layer];
    [self addSublayer:_deaValueLayer];
    
    _macdUpValueLayer = [CAShapeLayer layer];
    [self addSublayer:_macdUpValueLayer];
    
    _macdDnValueLayer = [CAShapeLayer layer];
    [self addSublayer:_macdDnValueLayer];
}

- (void)updateStyle {
    _difValueLayer.fillColor = [UIColor clearColor].CGColor;
    _difValueLayer.strokeColor = self.styles.DIFLineColor.CGColor;
    _difValueLayer.lineWidth = self.styles.MACDLineWidth;
    
    _deaValueLayer.fillColor = [UIColor clearColor].CGColor;
    _deaValueLayer.strokeColor = self.styles.DEALineColor.CGColor;
    _deaValueLayer.lineWidth = self.styles.MACDLineWidth;
    
    _macdUpValueLayer.fillColor = self.styles.VOLRiseColor.CGColor;
    _macdUpValueLayer.strokeColor = [UIColor clearColor].CGColor;
    _macdUpValueLayer.lineWidth = 0;
    
    _macdDnValueLayer.fillColor = self.styles.VOLFallColor.CGColor;
    _macdDnValueLayer.strokeColor = [UIColor clearColor].CGColor;
    _macdDnValueLayer.lineWidth = 0;
}

- (void)updateChartInRange:(NSRange)range {
    UIBezierPath *pathUp = [UIBezierPath bezierPath];
    UIBezierPath *pathDn = [UIBezierPath bezierPath];
    CGFloat baseLineY = self.axisYCallback(0);
    CGFloat barWidth = self.styles.MACDBarWidth;
    CGFloat halfWidth = half(barWidth);
    [self.cacheModels enumerateObjsAtRange:range ceaselessBlock:^(TQStockCacheModel * _Nonnull obj, NSUInteger idx) {
        CGFloat macdValue = obj.MACDValue;
        CGPoint p = CGPointMake(self.axisXCallback(idx), self.axisYCallback(macdValue));
        CGFloat height  = p.y - baseLineY;
        CGRect rect = CGRectMake(p.x - halfWidth, baseLineY, barWidth, height);
        macdValue > 0 ? [pathUp addRect:rect] : [pathDn addRect:rect];
    }];
    _macdUpValueLayer.path = pathUp.CGPath;
    _macdDnValueLayer.path = pathDn.CGPath;
    
    [self drawLineInRange:range atLayer:_difValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.DIFValue;
    }];
    
    [self drawLineInRange:range atLayer:_deaValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.DEAValue;
    }];
}

- (CGPeakValue)indicatorPeakValueForRange:(NSRange)range {
    CGPeakValue value1 = [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.MACDValue;
    }];
    CGPeakValue value2 = [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.DIFValue;
    }];
    CGPeakValue value3 = [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.DEAValue;
    }];
//    [NSValue valueWithPeakValue:value1];
//    NSStringFromCGRect(CGRectZero);
    CGPeakValue values[] = {value1, value2, value3};
    return CG_TraversePeakValues(values, 3);
}

- (NSArray<TQChartTextRenderer *> *)indicatorTrellisForPeakValue:(CGPeakValue)peakValue path:(UIBezierPath *__autoreleasing *)pathPointer {
    NSArray<NSString *> *array = [NSArray arrayWithPartition:2 peakValue:peakValue];
    CGFloat gap = self.plotter.drawRect.size.height / (CGFloat)(array.count - 1);
    CGFloat originY = self.plotter.drawRect.origin.y;
    
    NSMutableArray<TQChartTextRenderer *> *renders = [NSMutableArray array];
    UIBezierPath *path = *pathPointer;
    for (NSInteger i = 0; i < array.count; i++) {
        CGPoint start = CGPointMake(self.plotter.drawRect.origin.x, originY + gap * i);
        [path addHorizontalLine:start len:CGRectGetWidth(self.plotter.drawRect)];
        TQChartTextRenderer *render = [TQChartTextRenderer defaultRendererWithText:array[i]];
        render.font = self.styles.plainAxisTextFont;
        render.color = self.styles.plainAxisTextColor;
        render.positionCenter = start;
        render.offsetRatio = kCGOffsetRatioBottomLeft;
        [renders addObject:render];
    }
    renders.firstObject.offsetRatio = kCGOffsetRatioTopLeft;
    return renders;
}

@end
