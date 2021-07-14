//
//  TQIndicatorBIASLayer.m
//  TQChartKit
//
//  Created by zhanghao on 2018/9/6.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndicatorBIASLayer.h"

@interface TQIndicatorBIASLayer ()

@property (nonatomic, strong) CAShapeLayer *bias6ValueLayer;
@property (nonatomic, strong) CAShapeLayer *bias12ValueLayer;
@property (nonatomic, strong) CAShapeLayer *bias24ValueLayer;

@end

@implementation TQIndicatorBIASLayer

- (instancetype)init {
    if (self = [super init]) {
        [self sublayersInitialization];
    }
    return self;
}

- (void)sublayersInitialization {
    _bias6ValueLayer = [CAShapeLayer layer];
    [self addSublayer:_bias6ValueLayer];
    
    _bias12ValueLayer = [CAShapeLayer layer];
    [self addSublayer:_bias12ValueLayer];
    
    _bias24ValueLayer = [CAShapeLayer layer];
    [self addSublayer:_bias24ValueLayer];
}

- (void)updateStyle {
    _bias6ValueLayer.fillColor = [UIColor clearColor].CGColor;
    _bias6ValueLayer.strokeColor = self.styles.BIAS6LineColor.CGColor;
    _bias6ValueLayer.lineWidth = self.styles.BIASLineWidth;
    
    _bias12ValueLayer.fillColor = [UIColor clearColor].CGColor;
    _bias12ValueLayer.strokeColor = self.styles.BIAS12LineColor.CGColor;
    _bias12ValueLayer.lineWidth = self.styles.BIASLineWidth;
    
    _bias24ValueLayer.fillColor = [UIColor clearColor].CGColor;
    _bias24ValueLayer.strokeColor = self.styles.BIAS24LineColor.CGColor;
    _bias24ValueLayer.lineWidth = self.styles.BIASLineWidth;
}

- (void)updateChartInRange:(NSRange)range {
    [self drawLineSkipZeroInRange:range atLayer:_bias6ValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.BIAS6Value;
    }];
    
    [self drawLineSkipZeroInRange:range atLayer:_bias12ValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.BIAS12Value;
    }];
    
    [self drawLineSkipZeroInRange:range atLayer:_bias24ValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.BIAS24Value;
    }];
}

- (CGPeakValue)indicatorPeakValueForRange:(NSRange)range {
    CGPeakValue value1 = [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.BIAS6Value;
    }];
    CGPeakValue value2 = [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.BIAS12Value;
    }];
    CGPeakValue value3 = [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.BIAS24Value;
    }];
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
