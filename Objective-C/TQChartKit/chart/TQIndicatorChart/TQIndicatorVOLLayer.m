//
//  TQIndicatorVOLLayer.m
//  TQChartKit
//
//  Created by zhanghao on 2018/9/6.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndicatorVOLLayer.h"

@interface TQIndicatorVOLLayer ()

@property (nonatomic, strong) CAShapeLayer *riseValueLayer;
@property (nonatomic, strong) CAShapeLayer *fallVlaueLayer;
@property (nonatomic, strong) CAShapeLayer *flatVlaueLayer;

@end

@implementation TQIndicatorVOLLayer

- (instancetype)init {
    if (self = [super init]) {
        [self sublayersInitialization];
    }
    return self;
}

- (void)sublayersInitialization {
    _riseValueLayer = [CAShapeLayer layer];
    [self addSublayer:_riseValueLayer];
    
    _fallVlaueLayer = [CAShapeLayer layer];
    [self addSublayer:_fallVlaueLayer];
    
    _flatVlaueLayer = [CAShapeLayer layer];
    [self addSublayer:_flatVlaueLayer];
}

- (void)updateStyle {
    UIColor *riseFillColor = self.styles.VOLShouldRiseSolid ? self.styles.VOLRiseColor : [UIColor clearColor];
    _riseValueLayer.fillColor = riseFillColor.CGColor;
    _riseValueLayer.strokeColor = self.styles.VOLRiseColor.CGColor;
    _riseValueLayer.lineWidth = self.styles.VOLLineWidth;
    
    UIColor *fallFillColor = self.styles.VOLShouldFallSolid ? self.styles.VOLFallColor : [UIColor clearColor];
    _fallVlaueLayer.fillColor = fallFillColor.CGColor;
    _fallVlaueLayer.strokeColor = self.styles.VOLFallColor.CGColor;
    _fallVlaueLayer.lineWidth = self.styles.VOLLineWidth;
    
    UIColor *flatFillColor = self.styles.VOLShouldFlatSolid ? self.styles.VOLFlatColor : [UIColor clearColor];
    _flatVlaueLayer.fillColor = flatFillColor.CGColor;
    _flatVlaueLayer.strokeColor = self.styles.VOLFlatColor.CGColor;
    _flatVlaueLayer.lineWidth = self.styles.VOLLineWidth;
}

- (void)updateChartInRange:(NSRange)range {
    CGFloat shapeWidth = self.plotter.shapeWidth - self.styles.VOLLineWidth;
    CGFloat halfShapeWidth = half(shapeWidth);
    CGRect drawRect = self.plotter.drawRect;
    
    UIBezierPath *risePath = [UIBezierPath bezierPath];
    UIBezierPath *fallPath = [UIBezierPath bezierPath];
    UIBezierPath *flatPath = [UIBezierPath bezierPath];
    [self.cacheModels enumerateObjsAtRange:range ceaselessBlock:^(TQStockCacheModel * _Nonnull obj, NSUInteger idx) {
        CGFloat originX = self.axisXCallback(idx);
        CGFloat originY = self.axisYCallback(obj.VOLValue);
        // TODO减去底部边线的一半
        CGRect shapeRect = CGRectMake(originX - halfShapeWidth, originY, shapeWidth, CGRectGetMaxY(drawRect) - originY - self.styles.VOLLineWidth);
        if (obj.openValue > obj.closeValue) [risePath addRect:shapeRect];
        else if (obj.openValue < obj.closeValue) [fallPath addRect:shapeRect];
        else [flatPath addRect:shapeRect];
    }];
    
    _riseValueLayer.path = risePath.CGPath;
    _fallVlaueLayer.path = fallPath.CGPath;
    _flatVlaueLayer.path = flatPath.CGPath;
}

- (CGPeakValue)indicatorPeakValueForRange:(NSRange)range {
    CGPeakValue peakValue = [self.cacheModels peakValueWithRange:range evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull obj) {
        return obj.VOLValue;
    }];
    return CGPeakValueMake(peakValue.max, 0.00);
}

- (NSArray<TQChartTextRenderer *> *)indicatorTrellisForPeakValue:(CGPeakValue)peakValue path:(UIBezierPath *__autoreleasing *)pathPointer {
    NSArray<NSString *> *array = [NSArray arrayWithPartition:2 peakValue:peakValue resultBlock:^NSString * _Nonnull(CGFloat floatValue, NSUInteger idx) {
        return [NSString stringWithFormat:@"%.2f %@", floatValue / 10000.0, @"万"];
    }];
    CGFloat gap = self.plotter.drawRect.size.height / (CGFloat)(array.count - 1);
    CGFloat originY = self.plotter.drawRect.origin.y;
    
    NSMutableArray<TQChartTextRenderer *> *renders = [NSMutableArray array];
    TQChartTextRenderer *render = [TQChartTextRenderer defaultRendererWithText:array.firstObject];
    render.font = self.styles.plainAxisTextFont;
    render.color = self.styles.plainAxisTextColor;
    render.positionCenter = CGPointMake(self.plotter.drawRect.origin.x, originY);
    render.offsetRatio = kCGOffsetRatioTopLeft;
    [renders addObject:render];
    
    UIBezierPath *path = *pathPointer;
    for (NSInteger i = 0; i < array.count; i++) {
        CGPoint start = CGPointMake(self.plotter.drawRect.origin.x, originY + gap * i);
        [path addHorizontalLine:start len:CGRectGetWidth(self.plotter.drawRect)];
    }
    
    return renders;
}

- (NSAttributedString *)indicatorAttributedTextForRange:(NSRange)range {
    TQStockCacheModel *cache = [self.cacheModels lastObjInRange:range];
    NSString *volText = NS_StringFromRoundFloatKeep2(cache.VOLValue / 10000.0);
    
    NSString *prefix = @"成交量";
    NSString *textVOL = [volText stringByAppendingString:@"万手"];
    
    NSString *text = [NSString stringWithFormat:@" %@  %@", prefix, textVOL];
    NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:text];
    [attriText addAttribute:NSFontAttributeName value:self.styles.plainRefTextFont range:[text rangeOfString:text]];
    
    [attriText addAttribute:NSForegroundColorAttributeName value:self.styles.plainRefTextColor range:[text rangeOfString:prefix]];
    [attriText addAttribute:NSForegroundColorAttributeName value:self.styles.plainRefTextColor range:[text rangeOfString:textVOL]];
    return attriText;
}

@end
