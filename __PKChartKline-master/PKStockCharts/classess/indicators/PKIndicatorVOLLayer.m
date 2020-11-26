//
//  PKIndicatorVOLLayer.m
//  PKChartKit
//
//  Created by zhanghao on 2017/12/16.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import "PKIndicatorVOLLayer.h"

@interface PKIndicatorVOLLayer ()

@property (nonatomic, strong) CAShapeLayer *riseValueLayer;
@property (nonatomic, strong) CAShapeLayer *fallValueLayer;
@property (nonatomic, strong) CAShapeLayer *flatValueLayer;
@property (nonatomic, strong) CAShapeLayer *maaValueLayer;
@property (nonatomic, strong) CAShapeLayer *mabValueLayer;
@property (nonatomic, strong) CAShapeLayer *macValueLayer;
@property (nonatomic, strong) CAShapeLayer *madValueLayer;

@end

@implementation PKIndicatorVOLLayer

- (instancetype)init {
    if (self = [super init]) {
        [self sublayerInitialization];
    }
    return self;
}

- (void)sublayerInitialization {
    _riseValueLayer = [CAShapeLayer layer];
    [self addSublayer:_riseValueLayer];
    
    _fallValueLayer = [CAShapeLayer layer];
    [self addSublayer:_fallValueLayer];
    
    _flatValueLayer = [CAShapeLayer layer];
    [self addSublayer:_flatValueLayer];
    
    _maaValueLayer = [CAShapeLayer layer];
    _maaValueLayer.lineJoin = kCALineJoinRound;
    _maaValueLayer.lineCap = kCALineCapRound;
    [self addSublayer:_maaValueLayer];
    
    _mabValueLayer = [CAShapeLayer layer];
    _mabValueLayer.lineJoin = kCALineJoinRound;
    _mabValueLayer.lineCap = kCALineCapRound;
    [self addSublayer:_mabValueLayer];
    
    _macValueLayer = [CAShapeLayer layer];
    _macValueLayer.lineJoin = kCALineJoinRound;
    _macValueLayer.lineCap = kCALineCapRound;
    [self addSublayer:_macValueLayer];
    
    _madValueLayer = [CAShapeLayer layer];
    _madValueLayer.lineJoin = kCALineJoinRound;
    _madValueLayer.lineCap = kCALineCapRound;
    [self addSublayer:_madValueLayer];
}

- (void)playLayer:(CALayer *)layer display:(BOOL)isDisplay {
    if (isDisplay) {
        if (!layer.superlayer) [self addSublayer:layer];
    } else {
        if (layer.superlayer) [layer removeFromSuperlayer];
    }
}

- (void)_sublayerStyleUpdates {
    [self playLayer:_maaValueLayer display:self.set.VOLMAALineDisplayed];
    [self playLayer:_mabValueLayer display:self.set.VOLMABLineDisplayed];
    [self playLayer:_macValueLayer display:self.set.VOLMACLineDisplayed];
    [self playLayer:_madValueLayer display:self.set.VOLMADLineDisplayed];
    
    UIColor *fillRiseColor = self.set.VOLShouldRiseSolid ? self.set.VOLRiseColor : [UIColor clearColor];
    _riseValueLayer.fillColor = fillRiseColor.CGColor;
    _riseValueLayer.strokeColor = self.set.VOLRiseColor.CGColor;
    _riseValueLayer.lineWidth = self.set.VOLLineWidth;
    
    UIColor *fillFallColor = self.set.VOLShouldFallSolid ? self.set.VOLFallColor : [UIColor clearColor];
    _fallValueLayer.fillColor = fillFallColor.CGColor;
    _fallValueLayer.strokeColor = self.set.VOLFallColor.CGColor;
    _fallValueLayer.lineWidth = self.set.VOLLineWidth;
    
    UIColor *fillFlatColor = self.set.VOLShouldFlatSolid ? self.set.VOLFlatColor : [UIColor clearColor];
    _flatValueLayer.fillColor = fillFlatColor.CGColor;
    _flatValueLayer.strokeColor = self.set.VOLFlatColor.CGColor;
    _flatValueLayer.lineWidth = self.set.VOLLineWidth;
    
    _maaValueLayer.fillColor = [UIColor clearColor].CGColor;
    _maaValueLayer.strokeColor = self.set.VOLMAALineColor.CGColor;
    _maaValueLayer.lineWidth = self.set.VOLLineWidth;
    
    _mabValueLayer.fillColor = [UIColor clearColor].CGColor;
    _mabValueLayer.strokeColor = self.set.VOLMABLineColor.CGColor;
    _mabValueLayer.lineWidth = self.set.VOLLineWidth;
    
    _macValueLayer.fillColor = [UIColor clearColor].CGColor;
    _macValueLayer.strokeColor = self.set.VOLMACLineColor.CGColor;
    _macValueLayer.lineWidth = self.set.VOLLineWidth;
    
    _madValueLayer.fillColor = [UIColor clearColor].CGColor;
    _madValueLayer.strokeColor = self.set.VOLMADLineColor.CGColor;
    _madValueLayer.lineWidth = self.set.VOLLineWidth;
}

- (void)drawMinorChartInRange:(NSRange)range {
    CGFloat shapeWidth = self.scaler.shapeWidth - self.set.VOLLineWidth;
    CGFloat halfWidth = half(shapeWidth);
    CGFloat rectMaxY = CGRectGetMaxY(self.scaler.chartRect) - half(self.set.VOLLineWidth);
    
    UIBezierPath *risePath = [UIBezierPath bezierPath];
    UIBezierPath *fallPath = [UIBezierPath bezierPath];
    UIBezierPath *flatPath = [UIBezierPath bezierPath];
    [self.dataList pk_enumerateObjsAtRange:range ceaselessBlock:^(id<PKKLineChartProtocol>  _Nonnull obj, NSUInteger idx) {
        CGFloat originX = self.axisXCallback(idx);
        CGFloat originY = self.axisYCallback(obj.pk_kVolume);
        CGRect shapeRect = CGRectMake(originX - halfWidth, originY, shapeWidth, rectMaxY - originY);
        
        if (obj.pk_kOpenPrice < obj.pk_kClosePrice) [risePath pk_addRect:shapeRect];
        else if (obj.pk_kOpenPrice > obj.pk_kClosePrice) [fallPath pk_addRect:shapeRect];
        else [flatPath pk_addRect:shapeRect];
    }];
    _riseValueLayer.path = risePath.CGPath;
    _fallValueLayer.path = fallPath.CGPath;
    _flatValueLayer.path = flatPath.CGPath;
    
    if (self.set.VOLMAALineDisplayed) {
        [self drawLineSkipZeroInRange:range atLayer:_maaValueLayer evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
            return evaluatedObject.VOLMAAValue;
        }];
    }

    if (self.set.VOLMABLineDisplayed) {
        [self drawLineSkipZeroInRange:range atLayer:_mabValueLayer evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
            return evaluatedObject.VOLMABValue;
        }];
    }
    
    if (self.set.VOLMACLineDisplayed) {
        [self drawLineSkipZeroInRange:range atLayer:_macValueLayer evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
            return evaluatedObject.VOLMACValue;
        }];
    }
    
    if (self.set.VOLMADLineDisplayed) {
        [self drawLineSkipZeroInRange:range atLayer:_madValueLayer evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
            return evaluatedObject.VOLMADValue;
        }];
    }
}

- (CGPeakValue)minorChartPeakValueForRange:(NSRange)range {
    CGPeakValue peakValue = [self.dataList pk_peakValueAtRange:range evaluatedBlock:^CGFloat(id<PKKLineChartProtocol>  _Nonnull evaluatedObject) {
        return evaluatedObject.pk_kVolume;
    }];
    
    CGPeakValue value1 = CGPeakValueZero;
    if (self.set.VOLMAALineDisplayed) {
        value1 = [self.cacheList pk_peakValueAtRange:range evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
            return evaluatedObject.VOLMAAValue;
        }];
    }
    
    CGPeakValue value2 = CGPeakValueZero;
    if (self.set.VOLMABLineDisplayed) {
        value2 = [self.cacheList pk_peakValueAtRange:range evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
            return evaluatedObject.VOLMABValue;
        }];
    }
    
    CGPeakValue value3 = CGPeakValueZero;
    if (self.set.VOLMACLineDisplayed) {
        value3 = [self.cacheList pk_peakValueAtRange:range evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
            return evaluatedObject.VOLMACValue;
        }];
    }
    
    CGPeakValue value4 = CGPeakValueZero;
    if (self.set.VOLMADLineDisplayed) {
        value4 = [self.cacheList pk_peakValueAtRange:range evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
            return evaluatedObject.VOLMADValue;
        }];
    }
    
    CGPeakValue values[] = {peakValue, value1, value2, value3, value4};
    CGPeakValue targetPeakValue = CGPeakValueSkipZeroTraverses(values, 5);
    return CGPeakValueMake(targetPeakValue.max, 0.00);
}

- (nullable NSArray<PKChartTextRenderer *> *)minorChartTrellisForPeakValue:(CGPeakValue)peakValue path:(UIBezierPath *__autoreleasing *)pathPointer {
    NSArray<NSString *> *strings = [NSArray pk_arrayWithParagraphs:2 peakValue:peakValue resultBlock:^NSString * _Nonnull(CGFloat floatValue, NSUInteger index) {
        return [NSNumber pk_trillionStringWithDigits:@(floatValue) keepPlaces:self.set.decimalKeepPlace];
    }];
   
    CGFloat gap = self.scaler.chartRect.size.height / CGValidDivisor(strings.count - 1);
    CGFloat originY = self.scaler.chartRect.origin.y;
    
    UIBezierPath *path = *pathPointer;
    [strings pk_enumerateIndexsCeaselessBlock:^(NSUInteger idx) {
        CGPoint start = CGPointMake(self.scaler.chartRect.origin.x, originY + gap * idx);
        [path pk_addHorizontalLine:start len:CGRectGetWidth(self.scaler.chartRect)];
    }];
    
    NSMutableArray<PKChartTextRenderer *> *renders = [NSMutableArray array];
    PKChartTextRenderer *render = [PKChartTextRenderer defaultRenderer];
    render.text = strings.firstObject;
    render.color = self.set.plainTextColor;
    render.font = self.set.plainTextFont;
    render.positionCenter = CGPointMake(self.scaler.chartRect.origin.x, originY);
    render.offsetRatio = kCGOffsetRatioTopLeft;
    [renders addObject:render];
    
    return renders;
}

- (NSAttributedString *)minorChartAttributedTextForIndex:(NSInteger)index {
    PKIndicatorCacheItem *cache = [self.cacheList objectAtIndex:index];
    id<PKKLineChartProtocol>obj = [self.dataList objectAtIndex:index];
    return [self makeAttriTextsWithCache:cache object:obj];
}

- (NSAttributedString *)minorChartAttributedTextForRange:(NSRange)range {
    PKIndicatorCacheItem *cache = [self.cacheList pk_lastObjAtRange:range];
    id<PKKLineChartProtocol>obj = [self.dataList pk_lastObjAtRange:range];
    return [self makeAttriTextsWithCache:cache object:obj];
}

- (NSAttributedString *)makeAttriTextsWithCache:(PKIndicatorCacheItem *)cache
                                         object:(id<PKKLineChartProtocol>)obj {
    NSString *string = [NSNumber pk_trillionStringWithDoubleDigits:@(obj.pk_kVolume)];
    NSString *prefix = [NSString stringWithFormat:@"%@ %@手", @" 成交量", string];
    NSString *textMA = @" MA";
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    NSMutableArray<UIColor *> *maColors = [NSMutableArray array];
    
    NSMutableAttributedString *prefixText = [NSMutableAttributedString pk_attributedWithString:prefix];
    [prefixText pk_setForegroundColor:self.set.legendTextColor];
    [text appendAttributedString:prefixText];
    
    NSMutableAttributedString *maText = [NSMutableAttributedString pk_attributedWithString:textMA];
    [text appendAttributedString:maText];
    
    if (self.set.VOLMAALineDisplayed) {
        NSString *maa = [NSNumber pk_trillionStringWithDigits:@(cache.VOLMAAValue) keepPlaces:self.set.decimalKeepPlace];
        NSString *textMAA = [NSString stringWithFormat:@"%@:%@手 ", @(PKCYCLER.VOL_MAA_CYELE), maa];
        NSMutableAttributedString *maAText = [NSMutableAttributedString pk_attributedWithString:textMAA];
        [maAText pk_setForegroundColor:self.set.VOLMAALineColor];
        [text appendAttributedString:maAText];
        [maColors addObject:maAText.pk_foregroundColor];
    }
    
    if (self.set.VOLMABLineDisplayed) {
        NSString *mab = [NSNumber pk_trillionStringWithDigits:@(cache.VOLMABValue) keepPlaces:self.set.decimalKeepPlace];
        NSString *textMAB = [NSString stringWithFormat:@"%@:%@手 ", @(PKCYCLER.VOL_MAB_CYELE), mab];
        NSMutableAttributedString *maBText = [NSMutableAttributedString pk_attributedWithString:textMAB];
        [maBText pk_setForegroundColor:self.set.VOLMABLineColor];
        [text appendAttributedString:maBText];
        [maColors addObject:maBText.pk_foregroundColor];
    }
    
    if (self.set.VOLMACLineDisplayed) {
        NSString *mac = [NSNumber pk_trillionStringWithDigits:@(cache.VOLMACValue) keepPlaces:self.set.decimalKeepPlace];
        NSString *textMAC = [NSString stringWithFormat:@"%@:%@手 ", @(PKCYCLER.VOL_MAC_CYELE), mac];
        NSMutableAttributedString *maCText = [NSMutableAttributedString pk_attributedWithString:textMAC];
        [maCText pk_setForegroundColor:self.set.VOLMACLineColor];
        [text appendAttributedString:maCText];
        [maColors addObject:maCText.pk_foregroundColor];
    }
    
    if (self.set.VOLMADLineDisplayed) {
        NSString *mad = [NSNumber pk_trillionStringWithDigits:@(cache.VOLMADValue) keepPlaces:self.set.decimalKeepPlace];
        NSString *textMAD = [NSString stringWithFormat:@"%@:%@手 ", @(PKCYCLER.VOL_MAD_CYELE), mad];
        NSMutableAttributedString *maDText = [NSMutableAttributedString pk_attributedWithString:textMAD];
        [maDText pk_setForegroundColor:self.set.VOLMADLineColor];
        [text appendAttributedString:maDText];
        [maColors addObject:maDText.pk_foregroundColor];
    }
    
    if (maColors.count) {
        [text pk_setForegroundColor:maColors.firstObject range:NSMakeRange(prefix.length, maText.length)];
        [text pk_setFont:self.set.legendTextFont];
        return text;
    }
    
    return nil;
}

@end
