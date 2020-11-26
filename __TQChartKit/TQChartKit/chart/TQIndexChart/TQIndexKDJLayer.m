//
//  TQIndexKDJLayer.m
//  TQChartKit
//
//  Created by zhanghao on 2018/8/18.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndexKDJLayer.h"

@interface TQIndexKDJLayer ()

@property (nonatomic, strong) CAShapeLayer *kValueLayer;
@property (nonatomic, strong) CAShapeLayer *dValueLayer;
@property (nonatomic, strong) CAShapeLayer *jValueLayer;

@end

@implementation TQIndexKDJLayer

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
    _kValueLayer.strokeColor = self.style1.KDJLineColorK.CGColor;
    _kValueLayer.lineWidth = self.style1.KDJLineWidth;
    
    _dValueLayer.fillColor = [UIColor clearColor].CGColor;
    _dValueLayer.strokeColor = self.style1.KDJLineColorD.CGColor;
    _dValueLayer.lineWidth = self.style1.KDJLineWidth;
    
    _jValueLayer.fillColor = [UIColor clearColor].CGColor;
    _jValueLayer.strokeColor = self.style1.KDJLineColorJ.CGColor;
    _jValueLayer.lineWidth = self.style1.KDJLineWidth;
}

- (void)updateChartWithRange:(NSRange)range {
    
}

- (CGPeakValue)indexChartPeakValueForRange:(NSRange)range {
    return CGPeakValueMake(10, 100);
}

- (NSArray<TQChartTextRenderer *> *)indexChartGraphForRange:(NSRange)range gridPath:(UIBezierPath *__autoreleasing *)pathPointer {
    NSInteger segments = 3;
    CGPeakValue peak = [self indexChartPeakValueForRange:range];
    NSArray<NSString *> *array = [NSArray tq_gridSegments:segments peakValue:peak attached:@"kdj"];
    CGFloat gap = self.plotter.drawRect.size.height / (CGFloat)segments;
    CGFloat originY = self.plotter.drawRect.origin.y - half(self.plotter.gridLineWidth);
    
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
