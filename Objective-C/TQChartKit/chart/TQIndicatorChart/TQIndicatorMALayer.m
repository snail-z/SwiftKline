//
//  TQIndicatorMALayer.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/29.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndicatorMALayer.h"

@interface TQIndicatorMALayer ()

@property (nonatomic, strong) CAShapeLayer *ma5ValueLayer;
@property (nonatomic, strong) CAShapeLayer *ma10ValueLayer;
@property (nonatomic, strong) CAShapeLayer *ma20ValueLayer;
@property (nonatomic, strong) CAShapeLayer *ma60ValueLayer;

@end

@implementation TQIndicatorMALayer

- (instancetype)init {
    if (self = [super init]) {
        [self sublayersInitialization];
    }
    return self;
}

- (void)sublayersInitialization {
    _ma5ValueLayer = [CAShapeLayer layer];
    [self addSublayer:_ma5ValueLayer];
    
    _ma10ValueLayer = [CAShapeLayer layer];
    [self addSublayer:_ma10ValueLayer];
    
    _ma20ValueLayer = [CAShapeLayer layer];
    [self addSublayer:_ma20ValueLayer];
    
    _ma60ValueLayer = [CAShapeLayer layer];
    [self addSublayer:_ma60ValueLayer];
}

- (void)updateStyle {
    _ma5ValueLayer.fillColor = [UIColor clearColor].CGColor;
    _ma5ValueLayer.strokeColor = self.styles.MA5LineColor.CGColor;
    _ma5ValueLayer.lineWidth = self.styles.MALineWidth;
    
    _ma10ValueLayer.fillColor = [UIColor clearColor].CGColor;
    _ma10ValueLayer.strokeColor = self.styles.MA10LineColor.CGColor;
    _ma10ValueLayer.lineWidth = self.styles.MALineWidth;
    
    _ma20ValueLayer.fillColor = [UIColor clearColor].CGColor;
    _ma20ValueLayer.strokeColor = self.styles.MA20LineColor.CGColor;
    _ma20ValueLayer.lineWidth = self.styles.MALineWidth;
    
    _ma60ValueLayer.fillColor = [UIColor clearColor].CGColor;
    _ma60ValueLayer.strokeColor = self.styles.MA60LineColor.CGColor;
    _ma60ValueLayer.lineWidth = self.styles.MALineWidth;
}

- (void)updateChartInRange:(NSRange)range {
    [self drawLineSkipZeroInRange:range atLayer:_ma5ValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull obj) {
        return obj.MA5Value;
    }];
    
    [self drawLineSkipZeroInRange:range atLayer:_ma10ValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull obj) {
        return obj.MA10Value;
    }];
    
    [self drawLineSkipZeroInRange:range atLayer:_ma20ValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull obj) {
        return obj.MA20Value;
    }];
    
    [self drawLineSkipZeroInRange:range atLayer:_ma60ValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull obj) {
        return obj.MA60Value;
    }];
}

- (CGPeakValue)KIndicatorPeakValue:(CGPeakValue)peakValue forRange:(NSRange)range {
    CGPeakValue value1 = [self.cacheModels peakValueSkipZeroWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.MA5Value;
    }];
    CGPeakValue value2 = [self.cacheModels peakValueSkipZeroWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.MA10Value;
    }];
    CGPeakValue value3 = [self.cacheModels peakValueSkipZeroWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.MA20Value;
    }];
    CGPeakValue value4 = [self.cacheModels peakValueSkipZeroWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.MA60Value;
    }];
    CGPeakValue values[] = {peakValue, value1, value2, value3, value4};
    return CG_TraversePeakValues(values, 5);
}

- (NSAttributedString *)KIndicatorAttributedTextForIndex:(NSInteger)index {
    
    return [[NSAttributedString alloc] initWithString:@"MA0099"];
}

- (NSAttributedString *)KIndicatorAttributedTextForRange:(NSRange)range {
    TQStockCacheModel *cache = [self.cacheModels lastObjInRange:range];
    NSString *ma5 = NS_StringFromRoundFloatKeep2(cache.MA5Value);
    NSString *ma10 = NS_StringFromRoundFloatKeep2(cache.MA10Value);
    NSString *ma20 = NS_StringFromRoundFloatKeep2(cache.MA20Value);
    NSString *ma60 = NS_StringFromRoundFloatKeep2(cache.MA60Value);
    
    NSString *prefix = @"均线";
    NSString *textMA5 = [@"MA5:" stringByAppendingString:ma5];
    NSString *textMA10 = [@"10:" stringByAppendingString:ma10];
    NSString *textMA20 = [@"20:" stringByAppendingString:ma20];
    NSString *textMA60 = [@"60:" stringByAppendingString:ma60];

    NSString *text = [NSString stringWithFormat:@" %@  %@  %@  %@  %@", prefix, textMA5, textMA10, textMA20, textMA60];
    NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:text];
    [attriText addAttribute:NSFontAttributeName value:self.styles.plainRefTextFont range:[text rangeOfString:text]];
    
    [attriText addAttribute:NSForegroundColorAttributeName value:self.styles.plainRefTextColor range:[text rangeOfString:prefix]];
    [attriText addAttribute:NSForegroundColorAttributeName value:self.styles.MA5LineColor range:[text rangeOfString:textMA5]];
    [attriText addAttribute:NSForegroundColorAttributeName value:self.styles.MA10LineColor range:[text rangeOfString:textMA10]];
    [attriText addAttribute:NSForegroundColorAttributeName value:self.styles.MA20LineColor range:[text rangeOfString:textMA20]];
    [attriText addAttribute:NSForegroundColorAttributeName value:self.styles.MA60LineColor range:[text rangeOfString:textMA60]];
    return attriText;
}

@end
