//
//  TQIndexVOLLayer.m
//  TQChartKit
//
//  Created by zhanghao on 2018/8/2.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndexVOLLayer.h"

@interface TQIndexVOLLayer ()

@property (nonatomic, strong) CAShapeLayer *riseLayer;
@property (nonatomic, strong) CAShapeLayer *fallLayer;
@property (nonatomic, strong) CAShapeLayer *flatLayer;

@end

@implementation TQIndexVOLLayer

- (instancetype)init {
    if (self = [super init]) {
        [self sublayersInitialization];
    }
    return self;
}

- (void)sublayersInitialization {
    _riseLayer = [CAShapeLayer layer];
    [self addSublayer:_riseLayer];
    
    _fallLayer = [CAShapeLayer layer];
    [self addSublayer:_fallLayer];
    
    _flatLayer = [CAShapeLayer layer];
    [self addSublayer:_flatLayer];
}

- (void)updateStyle {
    UIColor *riseFillColor = self.style1.VOLShouldRiseSolid ? self.style1.VOLRiseColor : [UIColor clearColor];
    _riseLayer.fillColor = riseFillColor.CGColor;
    _riseLayer.strokeColor = self.style1.VOLRiseColor.CGColor;
    _riseLayer.lineWidth = self.style1.VOLLineWidth;
    
    UIColor *fallFillColor = self.style1.VOLShouldFallSolid ? self.style1.VOLFallColor : [UIColor clearColor];
    _fallLayer.fillColor = fallFillColor.CGColor;
    _fallLayer.strokeColor = self.style1.VOLFallColor.CGColor;
    _fallLayer.lineWidth = self.style1.VOLLineWidth;

    _flatLayer.fillColor = [UIColor clearColor].CGColor;
    _flatLayer.strokeColor = self.style1.VOLFlatColor.CGColor;
    _flatLayer.lineWidth = self.style1.VOLLineWidth;
}

- (void)updateChartWithRange:(NSRange)range {
    CGPeakValue peak = [self indexChartPeakValueForRange:range];
    CGFloat strokeWidth = self.style1.VOLLineWidth;
    CGFloat oneGap = self.plotter.shapeGap;
    CGFloat oneWidth = self.plotter.shapeWidth;
    CGFloat oneRealWidth = oneWidth - strokeWidth;
    CGRect drawRect = self.plotter.drawRect;
    CGpYFromValueCallback pYCallback = CGpYConverterMake(peak, drawRect, self.plotter.gridLineWidth);
    
    UIBezierPath *risePath = [UIBezierPath bezierPath];
    UIBezierPath *fallPath = [UIBezierPath bezierPath];
    UIBezierPath *flatPath = [UIBezierPath bezierPath];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.dataArray enumerateObjectsAtIndexes:indexSet options:kNilOptions usingBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat originX = (oneWidth + oneGap) * idx + half(strokeWidth);
        CGFloat originY = pYCallback(obj.tq_volume);
        // TODO减去底部边线的一半
        CGRect shapeRect = CGRectMake(originX, originY + half(strokeWidth), oneRealWidth, CGRectGetMaxY(drawRect) - originY - strokeWidth);
        if (obj.tq_open > obj.tq_close) [risePath addRect:shapeRect];
        else if (obj.tq_open < obj.tq_close) [fallPath addRect:shapeRect];
        else [flatPath addRect:shapeRect];
    }];
    _riseLayer.path = risePath.CGPath;
    _fallLayer.path = fallPath.CGPath;
    _flatLayer.path = flatPath.CGPath;
}

- (CGPeakValue)indexChartPeakValueForRange:(NSRange)range {
    CGPeakValue peak = [self.dataArray tq_peakValueWithRange:range bySel:@selector(tq_volume)];
    peak = CGPeakValueMake(peak.max, 0);
    return peak;
}

- (NSArray<TQChartTextRenderer *> *)indexChartGraphForRange:(NSRange)range gridPath:(UIBezierPath *__autoreleasing *)pathPointer {
    CGPeakValue peak = [self indexChartPeakValueForRange:range];
    NSArray<NSString *> *array = [NSArray tq_gridSegments:2 peakValue:peak attached:@"万"];
    CGFloat gap = self.plotter.drawRect.size.height / (CGFloat)(array.count - 1);
    CGFloat originY = self.plotter.drawRect.origin.y;
    
    NSMutableArray<TQChartTextRenderer *> *renders = [NSMutableArray array];
    TQChartTextRenderer *render = [TQChartTextRenderer defaultRenderer];
    render.font = [UIFont fontWithName:TQChartThonburiBoldFontName size:10];
    render.text = array.firstObject;
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

@end
