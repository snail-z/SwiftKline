//
//  TQIndexOBVLayer.m
//  TQChartKit
//
//  Created by zhanghao on 2018/8/18.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndexOBVLayer.h"

@interface TQIndexOBVLayer ()

@property (nonatomic, strong) CAShapeLayer *timelyLayer;
@property (nonatomic, strong) CAShapeLayer *meanLayer;

@end

@implementation TQIndexOBVLayer

- (instancetype)init {
    if (self = [super init]) {
        [self sublayersInitialization];
    }
    return self;
}

- (void)sublayersInitialization {
    _timelyLayer = [CAShapeLayer layer];
    [self addSublayer:_timelyLayer];
    
    _meanLayer = [CAShapeLayer layer];
    [self addSublayer:_meanLayer];
}

- (void)updateStyle {
    _timelyLayer.fillColor = [UIColor clearColor].CGColor;
    _timelyLayer.strokeColor = self.style1.OBVLineColor.CGColor;
    _timelyLayer.lineWidth = self.style1.OBVLineWidth;
    
    _meanLayer.fillColor = [UIColor clearColor].CGColor;
    _meanLayer.strokeColor = self.style1.OBVLineColorM.CGColor;
    _meanLayer.lineWidth = self.style1.OBVLineWidth;
}

- (void)updateChartWithRange:(NSRange)range {
    CGPeakValue peak = [self indexChartPeakValueForRange:range];
    CGpYFromValueCallback pYCallback = CGpYConverterMake(peak, self.plotter.drawRect, self.plotter.gridLineWidth);
    
    UIBezierPath *timelyPath = [UIBezierPath bezierPath];
    UIBezierPath *meanPath = [UIBezierPath bezierPath];

    id<TQKlineChartProtocol> obj = [self.dataArray tq_firstObjectAtRange:range];
    CGFloat centerX = [self getCenterXWithIndex:range.location];
    CGFloat originY = pYCallback(obj.tq_high);
    CGFloat originY1 = pYCallback(obj.tq_low);
    [timelyPath moveToPoint:CGPointMake(centerX, originY)];
    [meanPath moveToPoint:CGPointMake(centerX, originY1)];

    [self.dataArray tq_enumerateObjectsAtRange:NS_RangeOffset1(range) usingBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat centerX = [self getCenterXWithIndex:idx];
        CGFloat originY = pYCallback(obj.tq_high);
        CGFloat originY1 = pYCallback(obj.tq_low);
        [timelyPath addLineToPoint:CGPointMake(centerX, originY)];
        [meanPath addLineToPoint:CGPointMake(centerX, originY1)];
    }];
    _timelyLayer.path = timelyPath.CGPath;
    _meanLayer.path = meanPath.CGPath;
}

- (CGFloat)getCenterXWithIndex:(NSInteger)index {
    CGFloat oneHalfWidth = self.plotter.shapeWidth * 0.5;
    CGFloat centerX = (self.plotter.shapeWidth + self.plotter.shapeGap) * index + oneHalfWidth;
    return centerX;
}

- (CGPeakValue)indexChartPeakValueForRange:(NSRange)range {
    CGPeakValue peak = [self.dataArray tq_peakValueWithRange:range bySel:@selector(tq_high)];
    CGPeakValue peak1 = [self.dataArray tq_peakValueWithRange:range bySel:@selector(tq_low)];
    peak = CGPeakValueMake(peak.max, peak1.min);
    return peak;
}

- (NSArray<TQChartTextRenderer *> *)indexChartGraphForRange:(NSRange)range gridPath:(UIBezierPath *__autoreleasing *)pathPointer {
    CGPeakValue peak = [self indexChartPeakValueForRange:range];
    NSArray<NSString *> *array = [NSArray tq_gridSegments:2 peakValue:peak attached:@"OBV"];
    CGFloat gap = self.plotter.drawRect.size.height / (CGFloat)(array.count - 1);
    CGFloat originY = self.plotter.drawRect.origin.y - self.plotter.gridLineWidth * 0.5;
    
    UIBezierPath *path = *pathPointer;
    NSMutableArray<TQChartTextRenderer *> *renders = [NSMutableArray array];
    for (NSInteger i = 0; i < array.count; i++) {
        CGPoint start = CGPointMake(self.plotter.drawRect.origin.x, originY + gap * i);
        [path addHorizontalLine:start len:CGRectGetWidth(self.plotter.drawRect)];
        
        TQChartTextRenderer *render = [TQChartTextRenderer defaultRenderer];
        render.text = array[i];
        render.positionCenter = start;
        [renders addObject:render];
    }
    renders.firstObject.offsetRatio = kCGOffsetRatioTopLeft;
    
    return renders;
}

@end
