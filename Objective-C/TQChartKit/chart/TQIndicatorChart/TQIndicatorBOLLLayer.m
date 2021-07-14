//
//  TQIndicatorBOLLLayer.m
//  TQChartKit
//
//  Created by zhanghao on 2018/9/6.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndicatorBOLLLayer.h"

@interface TQIndicatorBOLLLayer ()

@property (nonatomic, strong) CAShapeLayer *riseBOLLLayer;
@property (nonatomic, strong) CAShapeLayer *fallBOLLLayer;
@property (nonatomic, strong) CAShapeLayer *flatBOLLLayer;
@property (nonatomic, strong) CAShapeLayer *mbLineLayer;
@property (nonatomic, strong) CAShapeLayer *upLineLayer;
@property (nonatomic, strong) CAShapeLayer *dpLineLayer;

@end

@implementation TQIndicatorBOLLLayer

- (instancetype)init {
    if (self = [super init]) {
        [self sublayersInitialization];
    }
    return self;
}

- (void)sublayersInitialization {
    _riseBOLLLayer = [CAShapeLayer layer];
    _riseBOLLLayer.lineJoin = kCALineJoinRound;
    _riseBOLLLayer.lineCap = kCALineCapRound;
    [self addSublayer:_riseBOLLLayer];
    
    _fallBOLLLayer = [CAShapeLayer layer];
    _fallBOLLLayer.lineJoin = kCALineJoinRound;
    _fallBOLLLayer.lineCap = kCALineCapRound;
    [self addSublayer:_fallBOLLLayer];
    
    _flatBOLLLayer = [CAShapeLayer layer];
    _flatBOLLLayer.lineJoin = kCALineJoinRound;
    _flatBOLLLayer.lineCap = kCALineCapRound;
    [self addSublayer:_flatBOLLLayer];
    
    _mbLineLayer = [CAShapeLayer layer];
    [self addSublayer:_mbLineLayer];
    
    _upLineLayer = [CAShapeLayer layer];
    [self addSublayer:_upLineLayer];
    
    _dpLineLayer = [CAShapeLayer layer];
    [self addSublayer:_dpLineLayer];
}

- (void)updateStyle {
    UIColor *riseColor = self.styles.BOLLKLineColor ? self.styles.BOLLKLineColor : self.styles.VOLRiseColor;
    UIColor *fallColor = self.styles.BOLLKLineColor ? self.styles.BOLLKLineColor : self.styles.VOLFallColor;
    UIColor *flatColor = self.styles.BOLLKLineColor ? self.styles.BOLLKLineColor : self.styles.VOLFlatColor;
    
    _riseBOLLLayer.fillColor = [UIColor clearColor].CGColor;
    _riseBOLLLayer.strokeColor = riseColor.CGColor;
    _riseBOLLLayer.lineWidth = self.styles.BOLLLineWidth;
    
    _fallBOLLLayer.fillColor = [UIColor clearColor].CGColor;
    _fallBOLLLayer.strokeColor = fallColor.CGColor;
    _fallBOLLLayer.lineWidth = self.styles.BOLLLineWidth;
    
    _flatBOLLLayer.fillColor = [UIColor clearColor].CGColor;
    _flatBOLLLayer.strokeColor = flatColor.CGColor;
    _flatBOLLLayer.lineWidth = self.styles.BOLLLineWidth;
    
    _mbLineLayer.fillColor = [UIColor clearColor].CGColor;
    _mbLineLayer.strokeColor = self.styles.BOLLMBLineColor.CGColor;
    _mbLineLayer.lineWidth = self.styles.BOLLLineWidth;
    
    _upLineLayer.fillColor = [UIColor clearColor].CGColor;
    _upLineLayer.strokeColor = self.styles.BOLLUPLineColor.CGColor;
    _upLineLayer.lineWidth = self.styles.BOLLLineWidth;
    
    _dpLineLayer.fillColor = [UIColor clearColor].CGColor;
    _dpLineLayer.strokeColor = self.styles.BOLLDPLineColor.CGColor;
    _dpLineLayer.lineWidth = self.styles.BOLLLineWidth;
}

- (void)updateChartInRange:(NSRange)range {
    UIBezierPath *risePath = [UIBezierPath bezierPath];
    UIBezierPath *fallPath = [UIBezierPath bezierPath];
    UIBezierPath *flatPath = [UIBezierPath bezierPath];
    CGFloat shapeWidth = self.plotter.shapeWidth - self.plotter.strokeWidth;
    CGFloat halfShapeWidth = half(shapeWidth);
    [self.dataArray enumerateObjsAtRange:range ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
        CGFloat highY = self.axisYCallback(obj.tq_high);
        CGFloat lowY = self.axisYCallback(obj.tq_low);
        CGFloat openY = self.axisYCallback(obj.tq_open);
        CGFloat closeY = self.axisYCallback(obj.tq_close);
        CGFloat centerX = self.axisXCallback(idx);
        CGFloat originY = MIN(openY, closeY);
        CGFloat shapeHeight = fabs(openY - closeY);
        CGPoint top = CGPointMake(centerX, highY);
        CGPoint bottom = CGPointMake(centerX, lowY);
        CGRect shapeRect = CGRectMake(centerX - halfShapeWidth, originY, shapeWidth, shapeHeight);
        CGCandleShape shape = CGCandleShapeMake(top, shapeRect, bottom);
        if (obj.tq_open < obj.tq_close) [risePath addTwigCandleShape:shape];
        else if (obj.tq_open > obj.tq_close) [fallPath addTwigCandleShape:shape];
        else [flatPath addTwigCandleShape:shape];
    }];
    _riseBOLLLayer.path = risePath.CGPath;
    _fallBOLLLayer.path = fallPath.CGPath;
    _flatBOLLLayer.path = flatPath.CGPath;
    
    [self drawLineInRange:range atLayer:_mbLineLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.BOLLMBValue;
    }];
    
    [self drawLineInRange:range atLayer:_upLineLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.BOLLUPValue;
    }];
    
    [self drawLineInRange:range atLayer:_dpLineLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.BOLLDPValue;
    }];
}

- (CGPeakValue)indicatorPeakValueForRange:(NSRange)range {
    CGPeakValue value1 = [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.BOLLMBValue;
    }];
    
    CGPeakValue value2 = [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.BOLLUPValue;
    }];
    CGPeakValue value3 = [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.BOLLDPValue;
    }];
    __block CGPeakValue peakValue = CGPeakValueMake(-CGFLOAT_MAX, CGFLOAT_MAX);
    [self.dataArray enumerateObjsAtRange:range ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
        if (obj.tq_high > peakValue.max) peakValue.max = obj.tq_high;
        if (obj.tq_low < peakValue.min) peakValue.min = obj.tq_low;
    }];
    CGPeakValue values[] = {value1, value2, value3, peakValue};
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

