//
//  TQIndicatorDMILayer.m
//  TQChartKit
//
//  Created by zhanghao on 2018/9/6.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndicatorDMILayer.h"

@interface TQIndicatorDMILayer ()

@property (nonatomic, strong) CAShapeLayer *pdiValueLayer;
@property (nonatomic, strong) CAShapeLayer *mdiValueLayer;
@property (nonatomic, strong) CAShapeLayer *adxValueLayer;
@property (nonatomic, strong) CAShapeLayer *adxrValueLayer;

@end

@implementation TQIndicatorDMILayer

- (instancetype)init {
    if (self = [super init]) {
        [self sublayersInitialization];
    }
    return self;
}

- (void)sublayersInitialization {
    _pdiValueLayer = [CAShapeLayer layer];
    [self addSublayer:_pdiValueLayer];
    
    _mdiValueLayer = [CAShapeLayer layer];
    [self addSublayer:_mdiValueLayer];
    
    _adxValueLayer = [CAShapeLayer layer];
    [self addSublayer:_adxValueLayer];
    
    _adxrValueLayer = [CAShapeLayer layer];
    [self addSublayer:_adxrValueLayer];
}

- (void)updateStyle {
    _pdiValueLayer.fillColor = [UIColor clearColor].CGColor;
    _pdiValueLayer.strokeColor = self.styles.DMIPDILineColor.CGColor;
    _pdiValueLayer.lineWidth = self.styles.DMILineWidth;
    
    _mdiValueLayer.fillColor = [UIColor clearColor].CGColor;
    _mdiValueLayer.strokeColor = self.styles.DMIMDILineColor.CGColor;
    _mdiValueLayer.lineWidth = self.styles.DMILineWidth;
    
    _adxValueLayer.fillColor = [UIColor clearColor].CGColor;
    _adxValueLayer.strokeColor = self.styles.DMIADXLineColor.CGColor;
    _adxValueLayer.lineWidth = self.styles.DMILineWidth;
    
    _adxrValueLayer.fillColor = [UIColor clearColor].CGColor;
    _adxrValueLayer.strokeColor = self.styles.DMIADXRLineColor.CGColor;
    _adxrValueLayer.lineWidth = self.styles.DMILineWidth;
}

- (void)updateChartInRange:(NSRange)range {
    [self drawLineInRange:range atLayer:_pdiValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.DMIPDIValue;
    }];
    
    [self drawLineInRange:range atLayer:_mdiValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.DMIMDIValue;
    }];
    
    [self drawLineInRange:range atLayer:_adxValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.DMIADXValue;
    }];
    
    [self drawLineInRange:range atLayer:_adxrValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.DMIADXRValue;
    }];
}

- (CGPeakValue)indicatorPeakValueForRange:(NSRange)range {
    CGPeakValue value1 = [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.DMIPDIValue;
    }];
    CGPeakValue value2 = [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.DMIMDIValue;
    }];
    CGPeakValue value3 = [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.DMIADXValue;
    }];
    CGPeakValue extractedExpr = [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.DMIADXRValue;
    }];
    CGPeakValue value4 = extractedExpr;
    CGPeakValue values[] = {value1, value2, value3, value4};
    return CG_TraversePeakValues(values, 4);
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
