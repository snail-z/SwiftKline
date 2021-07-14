//
//  TQIndicatorDMALayer.m
//  TQChartKit
//
//  Created by zhanghao on 2018/9/6.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndicatorDMALayer.h"

@interface TQIndicatorDMALayer ()

@property (nonatomic, strong) CAShapeLayer *dmaValueLayer;
@property (nonatomic, strong) CAShapeLayer *amaValueLayer;

@end

@implementation TQIndicatorDMALayer

- (instancetype)init {
    if (self = [super init]) {
        [self sublayersInitialization];
    }
    return self;
}

- (void)sublayersInitialization {
    _dmaValueLayer = [CAShapeLayer layer];
    [self addSublayer:_dmaValueLayer];
    
    _amaValueLayer = [CAShapeLayer layer];
    [self addSublayer:_amaValueLayer];
}

- (void)updateStyle {
    _dmaValueLayer.fillColor = [UIColor clearColor].CGColor;
    _dmaValueLayer.strokeColor = self.styles.DMALineColor.CGColor;
    _dmaValueLayer.lineWidth = self.styles.DMALineWidth;
    
    _amaValueLayer.fillColor = [UIColor clearColor].CGColor;
    _amaValueLayer.strokeColor = self.styles.AMALineColor.CGColor;
    _amaValueLayer.lineWidth = self.styles.DMALineWidth;
}

- (void)updateChartInRange:(NSRange)range {
    [self drawLineSkipZeroInRange:range atLayer:_dmaValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.DMAValue;
    }];

    [self drawLineSkipZeroInRange:range atLayer:_amaValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.AMAValue;
    }];
}

- (CGPeakValue)indicatorPeakValueForRange:(NSRange)range {
    CGPeakValue value1 = [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.DMAValue;
    }];
    CGPeakValue value2 = [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.AMAValue;
    }];
    CGPeakValue values[] = {value1, value2};
    return CG_TraversePeakValues(values, 2);
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
