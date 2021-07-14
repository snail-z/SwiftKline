//
//  TQIndicatorKDJLayer.m
//  TQChartKit
//
//  Created by zhanghao on 2018/9/5.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndicatorKDJLayer.h"

@interface TQIndicatorKDJLayer ()

@property (nonatomic, strong) CAShapeLayer *kValueLayer;
@property (nonatomic, strong) CAShapeLayer *dValueLayer;
@property (nonatomic, strong) CAShapeLayer *jValueLayer;

@end

@implementation TQIndicatorKDJLayer

- (instancetype)init {
    if (self = [super init]) {
        [self sublayersInitialization];
    }
    return self;
}

- (void)sublayersInitialization {
    _kValueLayer = [CAShapeLayer layer];
    [self addSublayer:_kValueLayer];
    
    _dValueLayer = [CAShapeLayer layer];
    [self addSublayer:_dValueLayer];
    
    _jValueLayer = [CAShapeLayer layer];
    [self addSublayer:_jValueLayer];
}

- (void)updateStyle {
    _kValueLayer.fillColor = [UIColor clearColor].CGColor;
    _kValueLayer.strokeColor = self.styles.KDJLineColorK.CGColor;
    _kValueLayer.lineWidth = self.styles.KDJLineWidth;
    
    _dValueLayer.fillColor = [UIColor clearColor].CGColor;
    _dValueLayer.strokeColor = self.styles.KDJLineColorD.CGColor;
    _dValueLayer.lineWidth = self.styles.KDJLineWidth;
    
    _jValueLayer.fillColor = [UIColor clearColor].CGColor;
    _jValueLayer.strokeColor = self.styles.KDJLineColorJ.CGColor;
    _jValueLayer.lineWidth = self.styles.KDJLineWidth;
}

- (void)updateChartInRange:(NSRange)range {
    [self drawLineInRange:range atLayer:_kValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.KValue;
    }];
    
    [self drawLineInRange:range atLayer:_dValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.DValue;
    }];
    
    [self drawLineInRange:range atLayer:_jValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.JValue;
    }];
}

- (CGPeakValue)indicatorPeakValueForRange:(NSRange)range {
    return CGPeakValueMake(100.00, 0.00);
}

- (NSArray<TQChartTextRenderer *> *)indicatorTrellisForPeakValue:(CGPeakValue)peakValue path:(UIBezierPath *__autoreleasing *)pathPointer {
    // KDJ网格坐标始终在0~100，固定间距为20/30
    CGFloat lesser = 20; CGFloat largish = 30;
    CGFloat distance = CG_GetPeakDistance(peakValue);
    if (CG_FloatIsZero(distance)) return nil;
    CGFloat lesGap = self.plotter.drawRect.size.height * (lesser / distance);
    CGFloat larGap = self.plotter.drawRect.size.height * (largish / distance);
    CGFloat originY = self.plotter.drawRect.origin.y + lesGap;
    NSString *string1 = [NSString stringWithFormat:@"%.2f", (lesser + largish * 2)];
    NSString *string2 = [NSString stringWithFormat:@"%.2f", (lesser + largish)];
    NSString *string3 = [NSString stringWithFormat:@"%.2f", lesser];
    NSArray<NSString *> *array = @[string1, string2, string3];
    
    NSMutableArray<TQChartTextRenderer *> *renders = [NSMutableArray array];
    UIBezierPath *path = *pathPointer;
    for (NSInteger i = 0; i < array.count; i++) {
        CGPoint start = CGPointMake(self.plotter.drawRect.origin.x, originY + larGap * i);
        [path addHorizontalLine:start len:CGRectGetWidth(self.plotter.drawRect)];
        TQChartTextRenderer *render = [TQChartTextRenderer defaultRendererWithText:array[i]];
        render.font = self.styles.plainAxisTextFont;
        render.color = self.styles.plainAxisTextColor;
        render.positionCenter = start;
        render.offsetRatio = kCGOffsetRatioBottomLeft;
        [renders addObject:render];
    }
    CGPoint p1 = self.plotter.drawRect.origin;
    CGPoint p2 = CGPointMake(p1.x, CGRectGetMaxY(self.plotter.drawRect));
    [path addHorizontalLine:p1 len:CGRectGetWidth(self.plotter.drawRect)];
    [path addHorizontalLine:p2 len:CGRectGetWidth(self.plotter.drawRect)];
    renders.firstObject.offsetRatio = kCGOffsetRatioTopLeft;
    return renders;
}

@end
