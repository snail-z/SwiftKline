//
//  TQIndicatorOBVLayer.m
//  TQChartKit
//
//  Created by zhanghao on 2018/9/6.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndicatorOBVLayer.h"

@interface TQIndicatorOBVLayer ()

@property (nonatomic, strong) CAShapeLayer *obvValueLayer;
@property (nonatomic, strong) CAShapeLayer *obvmValueLayer;

@end

@implementation TQIndicatorOBVLayer

- (instancetype)init {
    if (self = [super init]) {
        [self sublayersInitialization];
    }
    return self;
}

- (void)sublayersInitialization {
    _obvValueLayer = [CAShapeLayer layer];
    [self addSublayer:_obvValueLayer];
    
    _obvmValueLayer = [CAShapeLayer layer];
    [self addSublayer:_obvmValueLayer];
}

- (void)updateStyle {
    _obvValueLayer.fillColor = [UIColor clearColor].CGColor;
    _obvValueLayer.strokeColor = self.styles.OBVLineColor.CGColor;
    _obvValueLayer.lineWidth = self.styles.OBVLineWidth;
    
    _obvmValueLayer.fillColor = [UIColor clearColor].CGColor;
    _obvmValueLayer.strokeColor = self.styles.OBVMLineColor.CGColor;
    _obvmValueLayer.lineWidth = self.styles.OBVLineWidth;
}

- (void)updateChartInRange:(NSRange)range {
    [self drawLineInRange:range atLayer:_obvValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.OBVValue;
    }];
    
    [self drawLineInRange:range atLayer:_obvmValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.OBVMValue;
    }];
}

- (CGPeakValue)indicatorPeakValueForRange:(NSRange)range {
    CGPeakValue value1 = [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.OBVValue;
    }];
    CGPeakValue value2 = [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.OBVMValue;
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
