//
//  PKIndicatorKDJLayer.m
//  PKChartKit
//
//  Created by zhanghao on 2018/12/16.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import "PKIndicatorKDJLayer.h"

@interface PKIndicatorKDJLayer ()

@property (nonatomic, strong) CAShapeLayer *kValueLayer;
@property (nonatomic, strong) CAShapeLayer *dValueLayer;
@property (nonatomic, strong) CAShapeLayer *jValueLayer;

@end

@implementation PKIndicatorKDJLayer

- (instancetype)init {
    if (self = [super init]) {
        [self sublayerInitialization];
    }
    return self;
}

- (void)sublayerInitialization {
    _kValueLayer = [CAShapeLayer layer];
    _kValueLayer.lineCap = kCALineCapRound;
    _kValueLayer.lineJoin = kCALineJoinRound;
    [self addSublayer:_kValueLayer];
    
    _dValueLayer = [CAShapeLayer layer];
    _dValueLayer.lineCap = kCALineCapRound;
    _dValueLayer.lineJoin = kCALineJoinRound;
    [self addSublayer:_dValueLayer];
    
    _jValueLayer = [CAShapeLayer layer];
    _jValueLayer.lineCap = kCALineCapRound;
    _jValueLayer.lineJoin = kCALineJoinRound;
    [self addSublayer:_jValueLayer];
}

- (void)_sublayerStyleUpdates {
    _kValueLayer.fillColor = [UIColor clearColor].CGColor;
    _kValueLayer.strokeColor = self.set.KDJKLineColor.CGColor;
    _kValueLayer.lineWidth = self.set.KDJLineWidth;
    
    _dValueLayer.fillColor = [UIColor clearColor].CGColor;
    _dValueLayer.strokeColor = self.set.KDJDLineColor.CGColor;
    _dValueLayer.lineWidth = self.set.KDJLineWidth;
    
    _jValueLayer.fillColor = [UIColor clearColor].CGColor;
    _jValueLayer.strokeColor = self.set.KDJJLineColor.CGColor;
    _jValueLayer.lineWidth = self.set.KDJLineWidth;
}
    
- (void)drawMinorChartInRange:(NSRange)range {
    [self drawLineInRange:range atLayer:_kValueLayer evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
        return evaluatedObject.KValue;
    }];
    
    [self drawLineInRange:range atLayer:_dValueLayer evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
        return evaluatedObject.DValue;
    }];
    
    [self drawLineInRange:range atLayer:_jValueLayer evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
        return evaluatedObject.JValue;
    }];
}

- (CGPeakValue)minorChartPeakValueForRange:(NSRange)range {
    CGPeakValue value1 = [self.cacheList pk_peakValueAtRange:range evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
        return evaluatedObject.KValue;
    }];
    
    CGPeakValue value2 = [self.cacheList pk_peakValueAtRange:range evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
        return evaluatedObject.DValue;
    }];
    
    CGPeakValue value3 = [self.cacheList pk_peakValueAtRange:range evaluatedBlock:^CGFloat(PKIndicatorCacheItem * _Nonnull evaluatedObject) {
        return evaluatedObject.JValue;
    }];
    
    CGPeakValue values[] = {value1, value2, value3};
    return CGPeakValueTraverses(values, 3);
}

- (nullable NSArray<PKChartTextRenderer *> *)minorChartTrellisForPeakValue:(CGPeakValue)peakValue path:(UIBezierPath *__autoreleasing *)pathPointer {
    NSArray<NSString *> *strings = [NSArray pk_arrayWithParagraphs:2 peakValue:peakValue];
    
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
    NSString *kvalue = [NSNumber pk_stringWithDoubleDigits:@(cache.KValue)];
    NSString *dvalue = [NSNumber pk_stringWithDoubleDigits:@(cache.DValue)];
    NSString *jvalue = [NSNumber pk_stringWithDoubleDigits:@(cache.JValue)];
    
    NSString *prefix = [NSString stringWithFormat:@" KDJ(%@,3,3)", @(PKCYCLER.KDJ_CYELE)];
    NSString *textK =  [@" K:" stringByAppendingString:kvalue];
    NSString *textD =  [@" D:" stringByAppendingString:dvalue];
    NSString *textJ =  [@" J:" stringByAppendingString:jvalue];
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    
    NSMutableAttributedString *prefixText = [NSMutableAttributedString pk_attributedWithString:prefix];
    [prefixText pk_setForegroundColor:self.set.legendTextColor];
    [text appendAttributedString:prefixText];
    
    NSMutableAttributedString *kText = [NSMutableAttributedString pk_attributedWithString:textK];
    [kText pk_setForegroundColor:self.set.KDJKLineColor];
    [text appendAttributedString:kText];
    
    NSMutableAttributedString *dText = [NSMutableAttributedString pk_attributedWithString:textD];
    [dText pk_setForegroundColor:self.set.KDJDLineColor];
    [text appendAttributedString:dText];
    
    NSMutableAttributedString *jText = [NSMutableAttributedString pk_attributedWithString:textJ];
    [jText pk_setForegroundColor:self.set.KDJJLineColor];
    [text appendAttributedString:jText];
    
    [text pk_setFont:self.set.legendTextFont];
    return text;
}

@end
