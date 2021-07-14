//
//  TQIndicatorWRLayer.m
//  TQChartKit
//
//  Created by zhanghao on 2018/9/6.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndicatorWRLayer.h"

@interface TQIndicatorWRLayer ()

@property (nonatomic, strong) CAShapeLayer *wr6ValueLayer;
@property (nonatomic, strong) CAShapeLayer *wr10VlaueLayer;

@end

@implementation TQIndicatorWRLayer

- (instancetype)init {
    if (self = [super init]) {
        [self sublayersInitialization];
    }
    return self;
}

- (void)sublayersInitialization {
    _wr6ValueLayer = [CAShapeLayer layer];
    [self addSublayer:_wr6ValueLayer];
    
    _wr10VlaueLayer = [CAShapeLayer layer];
    [self addSublayer:_wr10VlaueLayer];
}

- (void)updateStyle {
    _wr6ValueLayer.fillColor = [UIColor clearColor].CGColor;
    _wr6ValueLayer.strokeColor = self.styles.WR6LineColor.CGColor;
    _wr6ValueLayer.lineWidth = self.styles.WRLineWidth;
    
    _wr10VlaueLayer.fillColor = [UIColor clearColor].CGColor;
    _wr10VlaueLayer.strokeColor = self.styles.WR10LineColor.CGColor;
    _wr10VlaueLayer.lineWidth = self.styles.WRLineWidth;
}

- (void)updateChartInRange:(NSRange)range {
    [self drawLineInRange:range atLayer:_wr6ValueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.WR6Value;
    }];
    
    [self drawLineInRange:range atLayer:_wr10VlaueLayer evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
        return evaluatedObject.WR10Value;
    }];
}

- (CGPeakValue)indicatorPeakValueForRange:(NSRange)range {
    return CGPeakValueMake(100, 0.00);
}

- (NSArray<TQChartTextRenderer *> *)indicatorTrellisForPeakValue:(CGPeakValue)peakValue path:(UIBezierPath *__autoreleasing *)pathPointer {
    // KDJ网格坐标始终在0~100，固定间距为20/30
    CGFloat lesser = 20; CGFloat largish = 30;
    CGFloat distance = CG_GetPeakDistance(peakValue);
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
