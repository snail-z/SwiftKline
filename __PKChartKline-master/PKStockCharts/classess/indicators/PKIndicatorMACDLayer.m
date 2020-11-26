//
//  PKIndicatorMACDLayer.m
//  PKChartKit
//
//  Created by zhanghao on 2017/12/16.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import "PKIndicatorMACDLayer.h"

@interface PKIndicatorMACDLayer ()

@property (nonatomic, strong) CAShapeLayer *diffValueLayer;
@property (nonatomic, strong) CAShapeLayer *deaValueLayer;
@property (nonatomic, strong) CAShapeLayer *macdUpValueLayer;
@property (nonatomic, strong) CAShapeLayer *macdDnValueLayer;

@end

@implementation PKIndicatorMACDLayer

- (instancetype)init {
    if (self = [super init]) {
        [self sublayerInitialization];
    }
    return self;
}

- (void)sublayerInitialization {
    _macdUpValueLayer = [CAShapeLayer layer];
    [self addSublayer:_macdUpValueLayer];
    
    _macdDnValueLayer = [CAShapeLayer layer];
    [self addSublayer:_macdDnValueLayer];
    
    _diffValueLayer = [CAShapeLayer layer];
    _diffValueLayer.lineCap = kCALineCapRound;
    _diffValueLayer.lineJoin = kCALineJoinRound;
    [self addSublayer:_diffValueLayer];
    
    _deaValueLayer = [CAShapeLayer layer];
    _deaValueLayer.lineCap = kCALineCapRound;
    _deaValueLayer.lineJoin = kCALineJoinRound;
    [self addSublayer:_deaValueLayer];
}

- (void)_sublayerStyleUpdates {
    _diffValueLayer.fillColor = [UIColor clearColor].CGColor;
    _diffValueLayer.strokeColor = self.set.DIFFLineColor.CGColor;
    _diffValueLayer.lineWidth = self.set.MACDLineWidth;
    
    _deaValueLayer.fillColor = [UIColor clearColor].CGColor;
    _deaValueLayer.strokeColor = self.set.DEALineColor.CGColor;
    _deaValueLayer.lineWidth = self.set.MACDLineWidth;
    
    _macdUpValueLayer.fillColor = self.set.VOLRiseColor.CGColor;
    _macdUpValueLayer.strokeColor = [UIColor clearColor].CGColor;
    _macdUpValueLayer.lineWidth = 0;
    
    _macdDnValueLayer.fillColor = self.set.VOLFallColor.CGColor;
    _macdDnValueLayer.strokeColor = [UIColor clearColor].CGColor;
    _macdDnValueLayer.lineWidth = 0;
}
    
- (void)drawMinorChartInRange:(NSRange)range {
    CGFloat baseLineY = self.axisYCallback(0);
    CGFloat barWidth = self.scaler.shapeWidth - self.set.MACDLineWidth;
    if (self.set.MACDBarWidth) barWidth = self.set.MACDBarWidth;
    CGFloat halfWidth = half(barWidth);
    
    UIBezierPath *upPath = [UIBezierPath bezierPath];
    UIBezierPath *dpPath = [UIBezierPath bezierPath];
    [self.cacheList pk_enumerateObjsAtRange:range ceaselessBlock:^(PKIndicatorCacheItem * _Nonnull obj, NSUInteger idx) {
        CGFloat macdValue = obj.MACDValue;
        CGPoint p = CGPointMake(self.axisXCallback(idx), self.axisYCallback(macdValue));
        CGRect rect = CGRectMake(p.x - halfWidth, baseLineY, barWidth,  p.y - baseLineY);
        macdValue > 0 ? [upPath pk_addRect:rect] : [dpPath pk_addRect:rect];
    }];
    _macdUpValueLayer.path = upPath.CGPath;
    _macdDnValueLayer.path = dpPath.CGPath;
    
    [self drawLineInRange:range atLayer:_diffValueLayer evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
        return evaluatedObject.DIFFValue;
    }];
    
    [self drawLineInRange:range atLayer:_deaValueLayer evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
        return evaluatedObject.DEAValue;
    }];
}

- (CGPeakValue)minorChartPeakValueForRange:(NSRange)range {
    CGPeakValue value1 = [self.cacheList pk_peakValueAtRange:range evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
        return evaluatedObject.MACDValue;
    }];
    
    CGPeakValue value2 = [self.cacheList pk_peakValueAtRange:range evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
        return evaluatedObject.DIFFValue;
    }];
    
    CGPeakValue value3 = [self.cacheList pk_peakValueAtRange:range evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
        return evaluatedObject.DEAValue;
    }];
    
    CGPeakValue values[] = {value1, value2, value3};
    return CGPeakValueTraverses(values, 3);
}

- (nullable NSArray<PKChartTextRenderer *> *)minorChartTrellisForPeakValue:(CGPeakValue)peakValue path:(UIBezierPath *__autoreleasing *)pathPointer {
    NSArray<NSString *> *strings = [NSArray pk_arrayWithParagraphs:2 peakValue:peakValue];
    
    CGFloat gap = self.scaler.chartRect.size.height / CGValidDivisor(strings.count - 1);
    CGFloat originY = self.scaler.chartRect.origin.y;
    
    NSMutableArray<PKChartTextRenderer *> *renders = [NSMutableArray arrayWithCapacity:strings.count];
    UIBezierPath *path = *pathPointer;
    for (NSInteger i = 0; i < strings.count; i++) {
        CGPoint start = CGPointMake(self.scaler.chartRect.origin.x, originY + gap * i);
        [path pk_addHorizontalLine:start len:CGRectGetWidth(self.scaler.chartRect)];
        
        PKChartTextRenderer *render = [PKChartTextRenderer defaultRenderer];
        render.text = strings[i];
        render.font = self.set.plainTextFont;
        render.color = self.set.plainTextColor;
        render.positionCenter = start;
        render.offsetRatio = kCGOffsetRatioBottomLeft;
        [renders addObject:render];
    }
    
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
    NSString *diff = [NSNumber pk_stringWithDoubleDigits:@(cache.DIFFValue)];
    NSString *dea  = [NSNumber pk_stringWithDoubleDigits:@(cache.DEAValue)];
    NSString *macd = [NSNumber pk_stringWithDoubleDigits:@(cache.MACDValue)];
    
    NSString *prefix = [NSString stringWithFormat:@" MACD(%@,%@,%@)", @(PKCYCLER.EMA_SHORT), @(PKCYCLER.EMA_LONG), @(PKCYCLER.DIFF_CYCLE)];
    NSString *textDiff =  [@" DIFF:" stringByAppendingString:diff];
    NSString *textDea =  [@" DEA:" stringByAppendingString:dea];
    NSString *textMacd =  [@" MACD:" stringByAppendingString:macd];
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    
    NSMutableAttributedString *prefixText = [NSMutableAttributedString pk_attributedWithString:prefix];
    [prefixText pk_setForegroundColor:self.set.legendTextColor];
    [text appendAttributedString:prefixText];
    
    NSMutableAttributedString *diffText = [NSMutableAttributedString pk_attributedWithString:textDiff];
    [diffText pk_setForegroundColor:self.set.DIFFLineColor];
    [text appendAttributedString:diffText];
    
    NSMutableAttributedString *deaText = [NSMutableAttributedString pk_attributedWithString:textDea];
    [deaText pk_setForegroundColor:self.set.DEALineColor];
    [text appendAttributedString:deaText];
    
    NSMutableAttributedString *macdText = [NSMutableAttributedString pk_attributedWithString:textMacd];
    [macdText pk_setForegroundColor:self.set.MACDTintColor];
    [text appendAttributedString:macdText];
    
    [text pk_setFont:self.set.legendTextFont];
    return text;
}

@end
