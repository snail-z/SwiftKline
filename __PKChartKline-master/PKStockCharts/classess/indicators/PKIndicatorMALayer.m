//
//  PKIndicatorMALayer.m
//  PKChartKit
//
//  Created by zhanghao on 2017/12/16.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import "PKIndicatorMALayer.h"

@interface PKIndicatorMALayer ()

@property (nonatomic, strong) CAShapeLayer *maAValueLayer;
@property (nonatomic, strong) CAShapeLayer *maBValueLayer;
@property (nonatomic, strong) CAShapeLayer *maCValueLayer;
@property (nonatomic, strong) CAShapeLayer *maDValueLayer;
@property (nonatomic, strong) CAShapeLayer *maEValueLayer;

@end

@implementation PKIndicatorMALayer

- (instancetype)init {
    if (self = [super init]) {
        [self sublayerInitialization];
    }
    return self;
}

- (void)sublayerInitialization {
    _maAValueLayer = [CAShapeLayer layer];
    _maAValueLayer.lineCap = kCALineCapRound;
    _maAValueLayer.lineJoin = kCALineJoinRound;
    [self addSublayer:_maAValueLayer];
    
    _maBValueLayer = [CAShapeLayer layer];
    _maBValueLayer.lineCap = kCALineCapRound;
    _maBValueLayer.lineJoin = kCALineJoinRound;
    [self addSublayer:_maBValueLayer];
    
    _maCValueLayer = [CAShapeLayer layer];
    _maCValueLayer.lineCap = kCALineCapRound;
    _maCValueLayer.lineJoin = kCALineJoinRound;
    [self addSublayer:_maCValueLayer];
    
    _maDValueLayer = [CAShapeLayer layer];
    _maDValueLayer.lineCap = kCALineCapRound;
    _maDValueLayer.lineJoin = kCALineJoinRound;
    [self addSublayer:_maDValueLayer];
    
    _maEValueLayer = [CAShapeLayer layer];
    _maEValueLayer.lineCap = kCALineCapRound;
    _maEValueLayer.lineJoin = kCALineJoinRound;
    [self addSublayer:_maEValueLayer];
}

- (void)playLayer:(CALayer *)layer display:(BOOL)isDisplay {
    if (isDisplay) {
        if (!layer.superlayer) [self addSublayer:layer];
    } else {
        if (layer.superlayer) [layer removeFromSuperlayer];
    }
}

- (void)_sublayerStyleUpdates {
    [self playLayer:_maAValueLayer display:self.set.MAALineDisplayed];
    [self playLayer:_maBValueLayer display:self.set.MABLineDisplayed];
    [self playLayer:_maCValueLayer display:self.set.MACLineDisplayed];
    [self playLayer:_maDValueLayer display:self.set.MADLineDisplayed];
    [self playLayer:_maEValueLayer display:self.set.MAELineDisplayed];
    
    _maAValueLayer.fillColor = [UIColor clearColor].CGColor;
    _maAValueLayer.strokeColor = self.set.MAALineColor.CGColor;
    _maAValueLayer.lineWidth = self.set.MALineWidth;
    
    _maBValueLayer.fillColor = [UIColor clearColor].CGColor;
    _maBValueLayer.strokeColor = self.set.MABLineColor.CGColor;
    _maBValueLayer.lineWidth = self.set.MALineWidth;
    
    _maCValueLayer.fillColor = [UIColor clearColor].CGColor;
    _maCValueLayer.strokeColor = self.set.MACLineColor.CGColor;
    _maCValueLayer.lineWidth = self.set.MALineWidth;
    
    _maDValueLayer.fillColor = [UIColor clearColor].CGColor;
    _maDValueLayer.strokeColor = self.set.MADLineColor.CGColor;
    _maDValueLayer.lineWidth = self.set.MALineWidth;
    
    _maEValueLayer.fillColor = [UIColor clearColor].CGColor;
    _maEValueLayer.strokeColor = self.set.MAELineColor.CGColor;
    _maEValueLayer.lineWidth = self.set.MALineWidth;
}

- (void)drawMajorChartInRange:(NSRange)range {
    if (self.set.MAALineDisplayed) {
        [self drawLineSkipZeroInRange:range atLayer:_maAValueLayer evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
            return evaluatedObject.MAAValue;
        }];
    }
    
    if (self.set.MABLineDisplayed) {
        [self drawLineSkipZeroInRange:range atLayer:_maBValueLayer evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
            return evaluatedObject.MABValue;
        }];
    }
    
    if (self.set.MACLineDisplayed) {
        [self drawLineSkipZeroInRange:range atLayer:_maCValueLayer evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
            return evaluatedObject.MACValue;
        }];
    }
    
    if (self.set.MADLineDisplayed) {
        [self drawLineSkipZeroInRange:range atLayer:_maDValueLayer evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
            return evaluatedObject.MADValue;
        }];
    }
    
    if (self.set.MAELineDisplayed) {
        [self drawLineSkipZeroInRange:range atLayer:_maEValueLayer evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
            return evaluatedObject.MAEValue;
        }];
    }
}

- (CGPeakValue)majorChartPeakValue:(CGPeakValue)peakValue forRange:(NSRange)range {
    CGPeakValue value1 = CGPeakValueZero;
    if (self.set.MAALineDisplayed) {
        value1 = [self.cacheList pk_peakValueSkipZeroAtRange:range evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
            return evaluatedObject.MAAValue;
        }];
    }
    
    CGPeakValue value2 = CGPeakValueZero;
    if (self.set.MABLineDisplayed) {
        value2 = [self.cacheList pk_peakValueSkipZeroAtRange:range evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
            return evaluatedObject.MABValue;
        }];
    }
    
    CGPeakValue value3 = CGPeakValueZero;
    if (self.set.MACLineDisplayed) {
        value3 = [self.cacheList pk_peakValueSkipZeroAtRange:range evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
            return evaluatedObject.MACValue;
        }];
    }
    
    CGPeakValue value4 = CGPeakValueZero;
    if (self.set.MADLineDisplayed) {
        value4 = [self.cacheList pk_peakValueSkipZeroAtRange:range evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
            return evaluatedObject.MADValue;
        }];
    }
    
    CGPeakValue value5 = CGPeakValueZero;
    if (self.set.MAELineDisplayed) {
        value5 = [self.cacheList pk_peakValueSkipZeroAtRange:range evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
            return evaluatedObject.MAEValue;
        }];
    }
    
    CGPeakValue values[] = {peakValue, value1, value2, value3, value4, value5};
    return CGPeakValueSkipZeroTraverses(values, 6);
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
    NSString *prefix = @" 均线";
    NSString *textMA = @" MA";
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    NSMutableArray<UIColor *> *maColors = [NSMutableArray array];
    
    NSMutableAttributedString *prefixText = [NSMutableAttributedString pk_attributedWithString:prefix];
    [prefixText pk_setForegroundColor:self.set.legendTextColor];
    [text appendAttributedString:prefixText];
    
    NSMutableAttributedString *maText = [NSMutableAttributedString pk_attributedWithString:textMA];
    [text appendAttributedString:maText];
    
    if (self.set.MAALineDisplayed) {
        NSString *maa = [NSNumber pk_stringWithDigits:@(cache.MAAValue) keepPlaces:self.set.decimalKeepPlace];
        NSString *textMAA = [NSString stringWithFormat:@"%@:%@ ", @(PKCYCLER.MAA_CYELE), maa];
        NSMutableAttributedString *maAText = [NSMutableAttributedString pk_attributedWithString:textMAA];
        [maAText pk_setForegroundColor:self.set.MAALineColor];
        [text appendAttributedString:maAText];
        [maColors addObject:maAText.pk_foregroundColor];
    }
    
    if (self.set.MABLineDisplayed) {
        NSString *mab = [NSNumber pk_stringWithDigits:@(cache.MABValue) keepPlaces:self.set.decimalKeepPlace];
        NSString *textMAB = [NSString stringWithFormat:@"%@:%@ ", @(PKCYCLER.MAB_CYELE), mab];
        NSMutableAttributedString *maBText = [NSMutableAttributedString pk_attributedWithString:textMAB];
        [maBText pk_setForegroundColor:self.set.MABLineColor];
        [text appendAttributedString:maBText];
        [maColors addObject:maBText.pk_foregroundColor];
    }
    
    if (self.set.MACLineDisplayed) {
        NSString *mac = [NSNumber pk_stringWithDigits:@(cache.MACValue) keepPlaces:self.set.decimalKeepPlace];
        NSString *textMAC = [NSString stringWithFormat:@"%@:%@ ", @(PKCYCLER.MAC_CYELE), mac];
        NSMutableAttributedString *maCText = [NSMutableAttributedString pk_attributedWithString:textMAC];
        [maCText pk_setForegroundColor:self.set.MACLineColor];
        [text appendAttributedString:maCText];
        [maColors addObject:maCText.pk_foregroundColor];
    }
    
    if (self.set.MADLineDisplayed) {
        NSString *mad = [NSNumber pk_stringWithDigits:@(cache.MADValue) keepPlaces:self.set.decimalKeepPlace];
        NSString *textMAD = [NSString stringWithFormat:@"%@:%@ ", @(PKCYCLER.MAD_CYELE), mad];
        NSMutableAttributedString *maDText = [NSMutableAttributedString pk_attributedWithString:textMAD];
        [maDText pk_setForegroundColor:self.set.MADLineColor];
        [text appendAttributedString:maDText];
        [maColors addObject:maDText.pk_foregroundColor];
    }
    
    if (self.set.MAELineDisplayed) {
        NSString *mae = [NSNumber pk_stringWithDigits:@(cache.MAEValue) keepPlaces:self.set.decimalKeepPlace];
        NSString *textMAE = [NSString stringWithFormat:@"%@:%@ ", @(PKCYCLER.MAE_CYELE), mae];
        NSMutableAttributedString *maEText = [NSMutableAttributedString pk_attributedWithString:textMAE];
        [maEText pk_setForegroundColor:self.set.MAELineColor];
        [text appendAttributedString:maEText];
        [maColors addObject:maEText.pk_foregroundColor];
    }

    if (maColors.count) {
        [text pk_setForegroundColor:maColors.firstObject range:NSMakeRange(prefixText.length, maText.length)];
        [text pk_setFont:self.set.legendTextFont];
        return text;
    }
    
    return nil;
}

@end
