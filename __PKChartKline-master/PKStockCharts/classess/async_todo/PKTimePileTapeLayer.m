//
//  PKTimePileTapeLayer.m
//  PKStockCharts
//
//  Created by zhanghao on 2019/8/13.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import "PKTimePileTapeLayer.h"
#import "PKStockObjects.h"

@interface PKTimePileTapeLayer ()

/** 持仓成本线 */
@property (nonatomic, strong) CAShapeLayer *positionLineLayer;

@end

@implementation PKTimePileTapeLayer

- (instancetype)init {
    if (self = [super init]) {
        [self sublayerInitialization];
    }
    return self;
}

- (void)sublayerInitialization {
    _positionLineLayer = [CAShapeLayer layer];
    _positionLineLayer.lineJoin = kCALineJoinRound;
    _positionLineLayer.lineCap = kCALineCapRound;
    [self addSublayer:_positionLineLayer];
    
    _positionLineLayer.fillColor = [UIColor clearColor].CGColor;
    _positionLineLayer.strokeColor = [UIColor blueColor].CGColor;
    _positionLineLayer.lineWidth = 1;
}

- (PKChartRegionType)pileChartRegionType {
    return PKChartRegionTypeMajor;
}

- (CGPeakValue)pileChartPeakValue:(CGPeakValue)peakValue {
    return peakValue;
}

- (void)pileChart {
    [self drawLineInLayer:self.positionLineLayer evaluatedBlock:^CGFloat(PKTimeItem *evaluatedObject) {
        return evaluatedObject.avg_price;
    }];
}

@end
