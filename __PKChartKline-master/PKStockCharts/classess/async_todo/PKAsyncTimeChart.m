//
//  PKAsyncTimeChart.m
//  PKStockCharts
//
//  Created by zhanghao on 2019/7/31.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import "PKAsyncTimeChart.h"
#import "PKAsyncTimeLayer.h"
#import "PKChartCategories.h"

@interface PKAsyncTimeChart () <CALayerDelegate>

@property (nonatomic, strong) PKAsyncTimeLayer *timeLayer;

@end

@implementation PKAsyncTimeChart

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    
        _timeLayer = [PKAsyncTimeLayer layer];
        [self.layer addSublayer:_timeLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)drawChart {
    [_timeLayer setNeedsDisplay];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    
}
- (void)displayLayer:(CALayer *)layer {
    NSLog(@"sdfsdfsdf");
}

- (CGFloat)getVaildPreClosePrice {
//    if ([self.dataList.firstObject respondsToSelector:@selector(pk_preClosePrice)]) {
//        CGFloat prePrice = self.dataList.firstObject.pk_preClosePrice;
//        if (!CGFloatEqualZero(prePrice)) return prePrice;
//        return self.dataList.firstObject.pk_latestPrice;
//    }
    return self.dataList.firstObject.pk_latestPrice;
}

- (CGFloat)getRealPreClosePrice {
//    if ([self.dataList.firstObject respondsToSelector:@selector(pk_preClosePrice)]) {
//        return self.dataList.firstObject.pk_preClosePrice;
//    }
    return 0.0;
}

- (CGPeakValue)getPricePeakValue {
    CGFloat defaultChangeRate = self.set.defaultChange;
    CGFloat preClosePrice = [self getVaildPreClosePrice];
    
    CGPeakValue peakValue = CGPeakValueZero;
    if (![self.coordinates respondsToSelector:@selector(pk_maxPrice)] ||
        ![self.coordinates respondsToSelector:@selector(pk_minPrice)]) {
        CGFloat spanValue = [self.dataList pk_spanValueWithReferenceValue:preClosePrice
                                                           evaluatedBlock:^CGFloat(id<PKTimeChartProtocol>  _Nonnull evaluatedObject) {
                                                               return evaluatedObject.pk_latestPrice;
                                                           }];
        
        CGFloat avgSpanValue = [self.dataList pk_spanValueWithReferenceValue:preClosePrice
                                                              evaluatedBlock:^CGFloat(id<PKTimeChartProtocol>  _Nonnull evaluatedObject) {
                                                                  return evaluatedObject.pk_averagePrice;
                                                              }];
        
        spanValue = MAX(avgSpanValue, spanValue); // 获取较大跨度
        
        if (CGFloatEqualZero(spanValue)) { // 若跨度为0，或极值无效，则使用默认比率
            spanValue = defaultChangeRate / 100.0 * preClosePrice;
        }
        
        peakValue = CGPeakValueMake(preClosePrice + spanValue, preClosePrice - spanValue);
    } else {
        peakValue = CGPeakValueMake(self.coordinates.pk_maxPrice, self.coordinates.pk_minPrice);
    }
    return peakValue;
}

- (CGPeakValue)getChangeRatePeakValue {
    CGFloat defaultChangeRate = self.set.defaultChange;
    CGFloat preClosePrice = [self getRealPreClosePrice];
    CGPeakValue pricePeakValue = [self getPricePeakValue];
    
    CGPeakValue peakValue = CGPeakValueZero;
    if (![self.coordinates respondsToSelector:@selector(pk_maxChangeRate)] ||
        ![self.coordinates respondsToSelector:@selector(pk_minChangeRate)]) {
        if(preClosePrice <= 0) {
            peakValue.max = defaultChangeRate / 100.0;
            peakValue.min = -defaultChangeRate / 100.0;
        } else {
            peakValue.max = (pricePeakValue.max - preClosePrice) / preClosePrice;
            peakValue.min = (pricePeakValue.min - preClosePrice) / preClosePrice;
        }
    } else {
        peakValue = CGPeakValueMake(self.coordinates.pk_maxChangeRate, self.coordinates.pk_minChangeRate);
    }
    return peakValue;
}

- (CGPeakValue)getVolumePeakValue {
    CGPeakValue peakValue = CGPeakValueZero;
    if (![self.coordinates respondsToSelector:@selector(pk_maxVolume)] ||
        ![self.coordinates respondsToSelector:@selector(pk_minVolume)]) {
        peakValue = [self.dataList pk_peakValueWithEvaluatedBlock:^CGFloat(id<PKTimeChartProtocol>  _Nonnull evaluatedObject) {
            return evaluatedObject.pk_volume;
        }];
    } else {
        peakValue = CGPeakValueMake(self.coordinates.pk_maxVolume, self.coordinates.pk_minVolume);
    }
    return peakValue;
}

@end
