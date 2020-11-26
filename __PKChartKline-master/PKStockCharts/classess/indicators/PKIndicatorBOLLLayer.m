//
//  PKIndicatorBOLLLayer.m
//  PKChartKit
//
//  Created by zhanghao on 2017/12/16.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import "PKIndicatorBOLLLayer.h"

#pragma mark - 主图区域布林线

@interface PKIndicatorBOLL1Layer ()

@property (nonatomic, strong) CAShapeLayer *mbLineLayer;
@property (nonatomic, strong) CAShapeLayer *upLineLayer;
@property (nonatomic, strong) CAShapeLayer *dpLineLayer;

@end

@implementation PKIndicatorBOLL1Layer

- (instancetype)init {
    if (self = [super init]) {
        [self sublayerInitialization];
    }
    return self;
}

- (void)sublayerInitialization {
    _mbLineLayer = [CAShapeLayer layer];
    [self addSublayer:_mbLineLayer];
    
    _upLineLayer = [CAShapeLayer layer];
    [self addSublayer:_upLineLayer];
    
    _dpLineLayer = [CAShapeLayer layer];
    [self addSublayer:_dpLineLayer];
}

- (void)_sublayerStyleUpdates {
    _mbLineLayer.fillColor = [UIColor clearColor].CGColor;
    _mbLineLayer.strokeColor = self.set.BOLLMBLineColor.CGColor;
    _mbLineLayer.lineWidth = self.set.BOLLLineWidth;
    
    _upLineLayer.fillColor = [UIColor clearColor].CGColor;
    _upLineLayer.strokeColor = self.set.BOLLUPLineColor.CGColor;
    _upLineLayer.lineWidth = self.set.BOLLLineWidth;
    
    _dpLineLayer.fillColor = [UIColor clearColor].CGColor;
    _dpLineLayer.strokeColor = self.set.BOLLDPLineColor.CGColor;
    _dpLineLayer.lineWidth = self.set.BOLLLineWidth;
}

- (void)drawMajorChartInRange:(NSRange)range {
    [self drawLineInRange:range atLayer:_mbLineLayer evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
        return evaluatedObject.BOLLMBValue;
    }];
    
    [self drawLineInRange:range atLayer:_upLineLayer evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
        return evaluatedObject.BOLLUPValue;
    }];
    
    [self drawLineInRange:range atLayer:_dpLineLayer evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
        return evaluatedObject.BOLLDPValue;
    }];
}

- (CGPeakValue)majorChartPeakValue:(CGPeakValue)peakValue forRange:(NSRange)range {
    CGPeakValue value1 = [self.cacheList pk_peakValueAtRange:range evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
        return evaluatedObject.BOLLMBValue;
    }];
    
    CGPeakValue value2 = [self.cacheList pk_peakValueAtRange:range evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
        return evaluatedObject.BOLLUPValue;
    }];
    
    CGPeakValue value3 = [self.cacheList pk_peakValueAtRange:range evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
        return evaluatedObject.BOLLDPValue;
    }];
    
    CGPeakValue values[] = {peakValue, value1, value2, value3};
    return CGPeakValueTraverses(values, 4);
}

- (NSAttributedString *)majorChartAttributedTextForIndex:(NSInteger)index {
    PKIndicatorCacheItem *cache = [self.cacheList objectAtIndex:index];
    return [self makeAttriTextsWithCache:cache];
}

- (NSAttributedString *)majorChartAttributedTextForRange:(NSRange)range {
    PKIndicatorCacheItem *cache = [self.cacheList pk_lastObjAtRange:range];
    return [self makeAttriTextsWithCache:cache];
}

- (NSAttributedString *)makeAttriTextsWithCache:(PKIndicatorCacheItem *)cache {
    NSString *upValue = [NSNumber pk_stringWithDoubleDigits:@(cache.BOLLUPValue)];
    NSString *midValue = [NSNumber pk_stringWithDoubleDigits:@(cache.BOLLMBValue)];
    NSString *lowValue = [NSNumber pk_stringWithDoubleDigits:@(cache.BOLLDPValue)];
    
    NSString *prefix = [NSString stringWithFormat:@" BOLL(%@,%@)", @(PKCYCLER.BOLL_CYELE), @(PKCYCLER.BOLL_PARAM)];
    NSString *textUp =  [@" UP:" stringByAppendingString:upValue];
    NSString *textMid =  [@" MID:" stringByAppendingString:midValue];
    NSString *textLow =  [@" LOW:" stringByAppendingString:lowValue];
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    
    NSMutableAttributedString *prefixText = [NSMutableAttributedString pk_attributedWithString:prefix];
    [prefixText pk_setForegroundColor:self.set.legendTextColor];
    [text appendAttributedString:prefixText];
    
    NSMutableAttributedString *upText = [NSMutableAttributedString pk_attributedWithString:textUp];
    [upText pk_setForegroundColor:self.set.BOLLUPLineColor];
    [text appendAttributedString:upText];
    
    NSMutableAttributedString *midText = [NSMutableAttributedString pk_attributedWithString:textMid];
    [midText pk_setForegroundColor:self.set.BOLLMBLineColor];
    [text appendAttributedString:midText];
    
    NSMutableAttributedString *lowText = [NSMutableAttributedString pk_attributedWithString:textLow];
    [lowText pk_setForegroundColor:self.set.BOLLDPLineColor];
    [text appendAttributedString:lowText];
    
    [text pk_setFont:self.set.legendTextFont];
    return text;
}

@end


#pragma mark - 副图区域布林线

@interface PKIndicatorBOLLLayer ()

@property (nonatomic, strong) CAShapeLayer *riseBOLLLayer;
@property (nonatomic, strong) CAShapeLayer *fallBOLLLayer;
@property (nonatomic, strong) CAShapeLayer *flatBOLLLayer;
@property (nonatomic, strong) CAShapeLayer *mbLineLayer;
@property (nonatomic, strong) CAShapeLayer *upLineLayer;
@property (nonatomic, strong) CAShapeLayer *dpLineLayer;

@end

@implementation PKIndicatorBOLLLayer

- (instancetype)init {
    if (self = [super init]) {
        [self sublayerInitialization];
    }
    return self;
}

- (void)sublayerInitialization {
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
    _mbLineLayer.lineJoin = kCALineJoinRound;
    _mbLineLayer.lineCap = kCALineCapRound;
    [self addSublayer:_mbLineLayer];
    
    _upLineLayer = [CAShapeLayer layer];
    _upLineLayer.lineJoin = kCALineJoinRound;
    _upLineLayer.lineCap = kCALineCapRound;
    [self addSublayer:_upLineLayer];
    
    _dpLineLayer = [CAShapeLayer layer];
    _dpLineLayer.lineJoin = kCALineJoinRound;
    _dpLineLayer.lineCap = kCALineCapRound;
    [self addSublayer:_dpLineLayer];
}

- (void)_sublayerStyleUpdates {
    UIColor *riseColor = self.set.BOLLKLineColor ? self.set.BOLLKLineColor : self.set.VOLRiseColor;
    UIColor *fallColor = self.set.BOLLKLineColor ? self.set.BOLLKLineColor : self.set.VOLFallColor;
    UIColor *flatColor = self.set.BOLLKLineColor ? self.set.BOLLKLineColor : self.set.VOLFlatColor;
    
    _riseBOLLLayer.fillColor = [UIColor clearColor].CGColor;
    _riseBOLLLayer.strokeColor = riseColor.CGColor;
    _riseBOLLLayer.lineWidth = self.set.BOLLLineWidth;
    
    _fallBOLLLayer.fillColor = [UIColor clearColor].CGColor;
    _fallBOLLLayer.strokeColor = fallColor.CGColor;
    _fallBOLLLayer.lineWidth = self.set.BOLLLineWidth;
    
    _flatBOLLLayer.fillColor = [UIColor clearColor].CGColor;
    _flatBOLLLayer.strokeColor = flatColor.CGColor;
    _flatBOLLLayer.lineWidth = self.set.BOLLLineWidth;
    
    _mbLineLayer.fillColor = [UIColor clearColor].CGColor;
    _mbLineLayer.strokeColor = self.set.BOLLMBLineColor.CGColor;
    _mbLineLayer.lineWidth = self.set.BOLLLineWidth;
    
    _upLineLayer.fillColor = [UIColor clearColor].CGColor;
    _upLineLayer.strokeColor = self.set.BOLLUPLineColor.CGColor;
    _upLineLayer.lineWidth = self.set.BOLLLineWidth;
    
    _dpLineLayer.fillColor = [UIColor clearColor].CGColor;
    _dpLineLayer.strokeColor = self.set.BOLLDPLineColor.CGColor;
    _dpLineLayer.lineWidth = self.set.BOLLLineWidth;
}

- (void)drawMinorChartInRange:(NSRange)range {
    CGFloat shapeWidth = self.scaler.shapeWidth;
    CGFloat halfWidth = half(shapeWidth);
    
    UIBezierPath *risePath = [UIBezierPath bezierPath];
    UIBezierPath *fallPath = [UIBezierPath bezierPath];
    UIBezierPath *flatPath = [UIBezierPath bezierPath];
    
    [self.dataList pk_enumerateObjsAtRange:range ceaselessBlock:^(id<PKKLineChartProtocol>  _Nonnull obj, NSUInteger idx) {
        CGFloat highY = self.axisYCallback(obj.pk_kHighPrice);
        CGFloat lowY = self.axisYCallback(obj.pk_kLowPrice);
        CGFloat openY = self.axisYCallback(obj.pk_kOpenPrice);
        CGFloat closeY = self.axisYCallback(obj.pk_kClosePrice);
        CGFloat centerX = self.axisXCallback(idx);
        CGFloat originX = centerX - halfWidth;
        CGFloat originY = MIN(openY, closeY);
        CGFloat shapeHeight = fabs(openY - closeY);
        
        CGPoint top = CGPointMake(centerX, highY);
        CGPoint bottom = CGPointMake(centerX, lowY);
        CGRect rect = CGRectMake(originX, originY, shapeWidth, shapeHeight);
        CGCandleShape shape = CGCandleShapeMake(top, rect, bottom);
        
        if (obj.pk_kOpenPrice < obj.pk_kClosePrice) [risePath pk_addTwigCandleShape:shape];
        else if (obj.pk_kOpenPrice > obj.pk_kClosePrice) [fallPath pk_addTwigCandleShape:shape];
        else [flatPath pk_addTwigCandleShape:shape];
    }];

    _riseBOLLLayer.path = risePath.CGPath;
    _fallBOLLLayer.path = fallPath.CGPath;
    _flatBOLLLayer.path = flatPath.CGPath;
    
    [self drawLineInRange:range atLayer:_mbLineLayer evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
        return evaluatedObject.BOLLMBValue;
    }];
    
    [self drawLineInRange:range atLayer:_upLineLayer evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
        return evaluatedObject.BOLLUPValue;
    }];
    
    [self drawLineInRange:range atLayer:_dpLineLayer evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
        return evaluatedObject.BOLLDPValue;
    }];
}

- (CGPeakValue)minorChartPeakValueForRange:(NSRange)range {
    CGPeakValue value1 = [self.cacheList pk_peakValueAtRange:range evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
        return evaluatedObject.BOLLMBValue;
    }];
    
    CGPeakValue value2 = [self.cacheList pk_peakValueAtRange:range evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
        return evaluatedObject.BOLLUPValue;
    }];
    
    CGPeakValue value3 = [self.cacheList pk_peakValueAtRange:range evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
        return evaluatedObject.BOLLDPValue;
    }];
    
    __block CGPeakValue peakValue = CGPeakValueMake(-CGFLOAT_MAX, CGFLOAT_MAX);
    [self.dataList pk_enumerateObjsAtRange:range ceaselessBlock:^(id<PKKLineChartProtocol>  _Nonnull obj, NSUInteger idx) {
        if (obj.pk_kHighPrice > peakValue.max) peakValue.max = obj.pk_kHighPrice;
        if (obj.pk_kLowPrice < peakValue.min) peakValue.min = obj.pk_kLowPrice;
    }];
    
    CGPeakValue values[] = {peakValue, value1, value2, value3};
    return CGPeakValueTraverses(values, 4);
}

- (nullable NSArray<PKChartTextRenderer *> *)minorChartTrellisForPeakValue:(CGPeakValue)peakValue path:(UIBezierPath *__autoreleasing *)pathPointer {
    NSArray<NSString *> *strings = [NSArray pk_arrayWithParagraphs:1 peakValue:peakValue];

    CGFloat gap = self.scaler.chartRect.size.height / CGValidDivisor(strings.count - 1);
    CGFloat originY = self.scaler.chartRect.origin.y;
    
    UIBezierPath *path = *pathPointer;
    NSMutableArray<PKChartTextRenderer *> *renders = [NSMutableArray array];
    [strings pk_enumerateObjsCeaselessBlock:^(NSString * _Nonnull text, NSUInteger idx) {
        CGPoint start = CGPointMake(self.scaler.chartRect.origin.x, originY + gap * idx);
        [path pk_addHorizontalLine:start len:CGRectGetWidth(self.scaler.chartRect)];
        
        PKChartTextRenderer *render = [PKChartTextRenderer defaultRenderer];
        render.text = text;
        render.font = self.set.plainTextFont;
        render.color = self.set.plainTextColor;
        render.positionCenter = start;
        render.offsetRatio = kCGOffsetRatioBottomLeft;
        [renders addObject:render];
    }];
    renders.firstObject.offsetRatio = kCGOffsetRatioTopLeft;
    
    return renders;
}

- (NSAttributedString *)minorChartAttributedTextForIndex:(NSInteger)index {
    PKIndicatorCacheItem *cache = [self.cacheList objectAtIndex:index];
    return [self makeAttriTextsWithCache:cache];
}

- (NSAttributedString *)minorChartAttributedTextForRange:(NSRange)range {
    PKIndicatorCacheItem *cache = [self.cacheList pk_lastObjAtRange:range];
    return [self makeAttriTextsWithCache:cache];
}

- (NSAttributedString *)makeAttriTextsWithCache:(PKIndicatorCacheItem *)cache {
    NSString *upValue = [NSNumber pk_stringWithDoubleDigits:@(cache.BOLLUPValue)];
    NSString *midValue = [NSNumber pk_stringWithDoubleDigits:@(cache.BOLLMBValue)];
    NSString *lowValue = [NSNumber pk_stringWithDoubleDigits:@(cache.BOLLDPValue)];
    
    NSString *prefix = [NSString stringWithFormat:@" BOLL(%@,%@)", @(PKCYCLER.BOLL_CYELE), @(PKCYCLER.BOLL_PARAM)];
    NSString *textUp =  [@" UP:" stringByAppendingString:upValue];
    NSString *textMid =  [@" MID:" stringByAppendingString:midValue];
    NSString *textLow =  [@" LOW:" stringByAppendingString:lowValue];
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    
    NSMutableAttributedString *prefixText = [NSMutableAttributedString pk_attributedWithString:prefix];
    [prefixText pk_setForegroundColor:self.set.legendTextColor];
    [text appendAttributedString:prefixText];
    
    NSMutableAttributedString *upText = [NSMutableAttributedString pk_attributedWithString:textUp];
    [upText pk_setForegroundColor:self.set.BOLLUPLineColor];
    [text appendAttributedString:upText];
    
    NSMutableAttributedString *midText = [NSMutableAttributedString pk_attributedWithString:textMid];
    [midText pk_setForegroundColor:self.set.BOLLMBLineColor];
    [text appendAttributedString:midText];
    
    NSMutableAttributedString *lowText = [NSMutableAttributedString pk_attributedWithString:textLow];
    [lowText pk_setForegroundColor:self.set.BOLLDPLineColor];
    [text appendAttributedString:lowText];
    
    [text pk_setFont:self.set.legendTextFont];
    return text;
}

@end
