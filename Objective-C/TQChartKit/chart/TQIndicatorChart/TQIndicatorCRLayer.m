//
//  TQIndicatorCRLayer.m
//  TQChartKit
//
//  Created by zhanghao on 2018/9/6.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndicatorCRLayer.h"

@interface TQIndicatorCRLayer ()

@property (nonatomic, strong) CAShapeLayer *cr26ValueLayer;

@end

@implementation TQIndicatorCRLayer

- (instancetype)init {
    if (self = [super init]) {
        [self sublayersInitialization];
    }
    return self;
}

- (void)sublayersInitialization {
    _cr26ValueLayer = [CAShapeLayer layer];
    [self addSublayer:_cr26ValueLayer];
}

- (void)updateStyle {
    _cr26ValueLayer.fillColor = [UIColor clearColor].CGColor;
    _cr26ValueLayer.strokeColor = self.styles.CR26LineColor.CGColor;
    _cr26ValueLayer.lineWidth = self.styles.CRLineWidth;
}

- (void)updateChartInRange:(NSRange)range {
    [self drawLineInRange:range atLayer:_cr26ValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.CR26Value;
    }];
}

- (CGPeakValue)indicatorPeakValueForRange:(NSRange)range {
    return [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.CR26Value;
    }];
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
