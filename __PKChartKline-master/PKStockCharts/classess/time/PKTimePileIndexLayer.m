//
//  PKTimePileIndexLayer.m
//  PKStockCharts
//
//  Created by zhanghao on 2019/8/13.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import "PKTimePileIndexLayer.h"

@interface PKTimePileIndexLayer ()

@property (nonatomic, strong) CAShapeLayer *indexRbarLayer;
@property (nonatomic, strong) CAShapeLayer *indexGbarLayer;

@end

@implementation PKTimePileIndexLayer

- (instancetype)init {
    if (self = [super init]) {
        [self sublayerInitialization];
    }
    return self;
}

- (void)sublayerInitialization {
    _indexRbarLayer = [CAShapeLayer layer];
    _indexRbarLayer.lineJoin = kCALineJoinRound;
    _indexRbarLayer.lineCap = kCALineCapRound;
    [self addSublayer:_indexRbarLayer];
    
    _indexRbarLayer.fillColor = [UIColor clearColor].CGColor;
    _indexRbarLayer.strokeColor = [UIColor redColor].CGColor;
    _indexRbarLayer.lineWidth = 1;
    
    _indexGbarLayer = [CAShapeLayer layer];
    _indexGbarLayer.lineJoin = kCALineJoinRound;
    _indexGbarLayer.lineCap = kCALineCapRound;
    [self addSublayer:_indexGbarLayer];
    
    _indexGbarLayer.fillColor = [UIColor clearColor].CGColor;
    _indexGbarLayer.strokeColor = [UIColor greenColor].CGColor;
    _indexGbarLayer.lineWidth = 1;
}

- (PKChartRegionType)pileChartRegionType {
    return PKChartRegionTypeMajor;
}

- (CGPeakValue)pileChartPeakValue:(CGPeakValue)peakValue {
    return peakValue;
}

- (void)pileChart {

    
}

@end
