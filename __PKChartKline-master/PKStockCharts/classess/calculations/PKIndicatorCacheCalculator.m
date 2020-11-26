//
//  PKIndicatorCacheCalculator.m
//  PKChartKit
//
//  Created by zhanghao on 2017/12/26.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import "PKIndicatorCacheCalculator.h"
#import "NSArray+PKIndicatorCacheCalculator.h"
#import "NSArray+PKStockChart.h"
#import "PKIndicatorCycler.h"
#import "NSValue+PKGeometry.h"

@interface PKIndicatorCacheCalculator ()

@property (nonatomic, strong) NSMutableArray<PKIndicatorCacheItem *> *allCacheItems;
@property (nonatomic, assign, readonly) NSInteger dataListCount;

/** 已计算出的数据范围 */
@property (nonatomic, assign, readonly) NSRange cachedVOLRange;
@property (nonatomic, assign, readonly) NSRange cachedMARange;
@property (nonatomic, assign, readonly) NSRange cachedBOLLRange;
@property (nonatomic, assign, readonly) NSRange cachedMACDRange;
@property (nonatomic, assign, readonly) NSRange cachedKDJRange;

@end

@implementation PKIndicatorCacheCalculator

- (NSMutableArray<PKIndicatorCacheItem *> *)allCacheItems {
    if (!_allCacheItems) {
        _allCacheItems = [NSMutableArray array];
    }
    return _allCacheItems;
}

- (NSArray<PKIndicatorCacheItem *> *)allCache {
    return self.allCacheItems;
}

- (void)clearAllCache {
    [self.allCacheItems removeAllObjects];
}

- (void)makeAllCache:(NSInteger)numbers {
    while (numbers) {
        PKIndicatorCacheItem *item = [PKIndicatorCacheItem new];
        [self.allCacheItems addObject:item];
        numbers--;
    }
}

+ (instancetype)managerWithDataList:(NSArray<id<PKKLineChartProtocol>> *)dataList {
    NSParameterAssert(dataList || dataList.count);
    return [[self alloc] initWithDataList:dataList];
}

- (instancetype)initWithDataList:(NSArray<id<PKKLineChartProtocol>> *)dataList {
    if (self = [super init]) {
        _dataList = dataList;
        [self makeAllCache:dataList.count];
    }
    return self;
}

- (void)updateCacheForDataList:(NSArray<id<PKKLineChartProtocol>> *)dataList {
    if (!dataList.count) return;
    _dataList = dataList;
    _dataListCount = dataList.count;
    [self clearAllCache];
    [self clearAllRange];
    [self makeAllCache:dataList.count];
}

- (void)clearAllRange {
    _cachedVOLRange = NSMakeRange(0, 0);
    _cachedMARange = NSMakeRange(0, 0);
    _cachedMACDRange = NSMakeRange(0, 0);
    _cachedBOLLRange = NSMakeRange(0, 0);
    _cachedKDJRange = NSMakeRange(0, 0);
}

#pragma mark - Utilities

/** 检查range是否有效 */
- (NSRange)checkRange:(NSRange)range method:(SEL)method {
    NSRange allRange = NSMakeRange(0, self.dataList.count);
    NSRange targetRange = NSIntersectionRange(allRange, range);
    if (!targetRange.length) {
        NSLog(@"No range can be calculated. %@ '- %@'", NSStringFromRange(targetRange), NSStringFromSelector(method));
    }
    return targetRange;
}

/** 从idx位置起向前计算days日内最高价最低价的最大最小值 */
- (CGPeakValue)calculateHnlnValueAtIdx:(NSUInteger)idx cycles:(NSUInteger)days {
    NSRange range = idx < days ? NSMakeRange(0, idx + 1) : NSMakeRange(idx - days + 1, days);
    __block CGPeakValue peakValue = CGPeakValueMake(-CGFLOAT_MAX, CGFLOAT_MAX);
    [self.dataList pk_enumerateObjsAtRange:range ceaselessBlock:^(id<PKKLineChartProtocol>  _Nonnull obj, NSUInteger idx) {
        if (obj.pk_kHighPrice > peakValue.max) peakValue.max = obj.pk_kHighPrice;
        if (obj.pk_kLowPrice < peakValue.min) peakValue.min = obj.pk_kLowPrice;
    }];
    return peakValue;
}

/** 获取一个有效的cache模型 */
- (PKIndicatorCacheItem *)getCacheItemAtIndex:(NSInteger)index {
    if (index < self.allCacheItems.count) {
        return self.allCacheItems[index];
    }
    PKIndicatorCacheItem *item = [PKIndicatorCacheItem new];
    [self.allCacheItems addObject:item];
    return item;
}

#pragma mark - Parser

- (void)parseResultRange:(NSRange)range byIndicatorIdentifier:(PKIndicatorIdentifier)identifier {
    if (!identifier) return;
    
    if ([identifier isEqualToString:PKIndicatorVOL]) {
        return [self parseResultVOLForRnange:range];
    } else if ([identifier isEqualToString:PKIndicatorMA]) {
        return [self parseResultMAForRnange:range];
    } else if ([identifier isEqualToString:PKIndicatorBOLL]) {
        return [self parseResultBOLLForRnange:range];
    } else if ([identifier isEqualToString:PKIndicatorMACD]) {
        return [self parseResultMACDForRnange:range];
    } else if ([identifier isEqualToString:PKIndicatorKDJ]) {
        return [self parseResultKDJForRnange:range];
    } else if ([identifier isEqualToString:PKIndicatorOBV]) {
        return [self parseResultOBVForRnange:range];
    } else if ([identifier isEqualToString:PKIndicatorRSI]) {
        return [self parseResultRSIForRnange:range];
    } else if ([identifier isEqualToString:PKIndicatorASI]) {
        return [self parseResultASIForRnange:range];
    } else if ([identifier isEqualToString:PKIndicatorWR]) {
        return [self parseResultWRForRnange:range];
    } else if ([identifier isEqualToString:PKIndicatorVR]) {
        return [self parseResultVRForRnange:range];
    } else if ([identifier isEqualToString:PKIndicatorCR]) {
        return [self parseResultCRForRnange:range];
    } else if ([identifier isEqualToString:PKIndicatorBIAS]) {
        return [self parseResultBIASForRnange:range];
    } else if ([identifier isEqualToString:PKIndicatorCCI]) {
        return [self parseResultCCIForRnange:range];
    } else if ([identifier isEqualToString:PKIndicatorDMI]) {
        return [self parseResultDMIForRnange:range];
    } else if ([identifier isEqualToString:PKIndicatorDMA]) {
        return [self parseResultDMAForRnange:range];
    } else if ([identifier isEqualToString:PKIndicatorSAR]) {
        return [self parseResultDMAForRnange:range];
    } else if ([identifier isEqualToString:PKIndicatorPSY]) {
        return [self parseResultPSYForRnange:range];
    } else if ([identifier isEqualToString:PKIndicatorEMA]) {
        return [self parseResultEMAForRnange:range];
    } else if ([identifier isEqualToString:PKIndicatorTRIX]) {
        return [self parseResultTRIXForRnange:range];
    } else if ([identifier isEqualToString:PKIndicatorBRAR]) {
        return [self parseResultBRARForRnange:range];
    } else if ([identifier isEqualToString:PKIndicatorEMV]) {
        return [self parseResultEMVForRnange:range];
    } else if ([identifier isEqualToString:PKIndicatorWVAD]) {
        return [self parseResultWVADForRnange:range];
    } else if ([identifier isEqualToString:PKIndicatorROC]) {
        return [self parseResultROCForRnange:range];
    }
}

#pragma mark - VOL

- (void)parseResultVOLForRnange:(NSRange)range {
    NSRange usableRange = NSMakeRange(0, self.dataListCount);
    if (NS_RangeContainsRange(self.cachedVOLRange, range)) return;
    [self calculateVOLAtRange:usableRange];
    _cachedVOLRange = usableRange;
}

- (void)calculateVOLAtRange:(NSRange)range {
    [self.dataList pk_enumerateMAValue:PKCYCLER.VOL_MAA_CYELE range:range evaluatedBlock:^CGFloat(id<PKKLineChartProtocol>  _Nonnull evaluatedObject) {
        return evaluatedObject.pk_kVolume;
    } usingBlock:^(NSUInteger idx, CGFloat MAValue) {
        PKIndicatorCacheItem *item = [self getCacheItemAtIndex:idx];
        item.VOLMAAValue = MAValue;
    }];
    
    [self.dataList pk_enumerateMAValue:PKCYCLER.VOL_MAB_CYELE range:range evaluatedBlock:^CGFloat(id<PKKLineChartProtocol>  _Nonnull evaluatedObject) {
        return evaluatedObject.pk_kVolume;
    } usingBlock:^(NSUInteger idx, CGFloat MAValue) {
        PKIndicatorCacheItem *item = [self getCacheItemAtIndex:idx];
        item.VOLMABValue = MAValue;
    }];
    
    [self.dataList pk_enumerateMAValue:PKCYCLER.VOL_MAC_CYELE range:range evaluatedBlock:^CGFloat(id<PKKLineChartProtocol>  _Nonnull evaluatedObject) {
        return evaluatedObject.pk_kVolume;
    } usingBlock:^(NSUInteger idx, CGFloat MAValue) {
        PKIndicatorCacheItem *item = [self getCacheItemAtIndex:idx];
        item.VOLMACValue = MAValue;
    }];
    
    [self.dataList pk_enumerateMAValue:PKCYCLER.VOL_MAD_CYELE range:range evaluatedBlock:^CGFloat(id<PKKLineChartProtocol>  _Nonnull evaluatedObject) {
        return evaluatedObject.pk_kVolume;
    } usingBlock:^(NSUInteger idx, CGFloat MAValue) {
        PKIndicatorCacheItem *item = [self getCacheItemAtIndex:idx];
        item.VOLMADValue = MAValue;
    }];
}

#pragma mark - MA

- (void)parseResultMAForRnange:(NSRange)range {
//    NSRange intersectionRange = NSIntersectionRange(canUseRange, range);
//    NSInteger endIndex = NSMaxRange(intersectionRange);
//    intersectionRange.location = 0;
//    if (!endIndex) return;
    NSRange usableRange = NSMakeRange(0, self.dataListCount);
    if (NS_RangeContainsRange(self.cachedMARange, range)) return;
    
    // 起始下标(使计算从首位开始)
    [self calculateMAAtRange:usableRange];
    _cachedMARange = usableRange;
}

- (void)calculateMAAtRange:(NSRange)range {
    [self.dataList pk_enumerateMAValue:PKCYCLER.MAA_CYELE range:range evaluatedBlock:^CGFloat(id<PKKLineChartProtocol>  _Nonnull evaluatedObject) {
        return evaluatedObject.pk_kClosePrice;
    } usingBlock:^(NSUInteger idx, CGFloat MAValue) {
        PKIndicatorCacheItem *item = [self getCacheItemAtIndex:idx];
        item.MAAValue = MAValue;
    }];
    
    [self.dataList pk_enumerateMAValue:PKCYCLER.MAB_CYELE range:range evaluatedBlock:^CGFloat(id<PKKLineChartProtocol>  _Nonnull evaluatedObject) {
        return evaluatedObject.pk_kClosePrice;
    } usingBlock:^(NSUInteger idx, CGFloat MAValue) {
        PKIndicatorCacheItem *item = [self getCacheItemAtIndex:idx];
        item.MABValue = MAValue;
    }];
    
    [self.dataList pk_enumerateMAValue:PKCYCLER.MAC_CYELE range:range evaluatedBlock:^CGFloat(id<PKKLineChartProtocol>  _Nonnull evaluatedObject) {
        return evaluatedObject.pk_kClosePrice;
    } usingBlock:^(NSUInteger idx, CGFloat MAValue) {
        PKIndicatorCacheItem *item = [self getCacheItemAtIndex:idx];
        item.MACValue = MAValue;
    }];
    
    [self.dataList pk_enumerateMAValue:PKCYCLER.MAD_CYELE range:range evaluatedBlock:^CGFloat(id<PKKLineChartProtocol>  _Nonnull evaluatedObject) {
        return evaluatedObject.pk_kClosePrice;
    } usingBlock:^(NSUInteger idx, CGFloat MAValue) {
        PKIndicatorCacheItem *cache = [self getCacheItemAtIndex:idx];
        cache.MADValue = MAValue;
    }];
    
    [self.dataList pk_enumerateMAValue:PKCYCLER.MAE_CYELE range:range evaluatedBlock:^CGFloat(id<PKKLineChartProtocol>  _Nonnull evaluatedObject) {
        return evaluatedObject.pk_kClosePrice;
    } usingBlock:^(NSUInteger idx, CGFloat MAValue) {
        PKIndicatorCacheItem *cache = [self getCacheItemAtIndex:idx];
        cache.MAEValue = MAValue;
    }];
}

#pragma mark - BOLL

- (void)parseResultBOLLForRnange:(NSRange)range {
    NSUInteger startIndex = self.cachedBOLLRange.location > 0 ? 0: self.cachedBOLLRange.length;
    NSUInteger endIndex = NSMaxRange(range);
    if (startIndex < endIndex) {
        NSRange usingRange = NSMakeRange(startIndex, endIndex);
        [self calculateBOLLAtRange:usingRange];
    }
}

- (void)calculateBOLLAtRange:(NSRange)range {
    // 计算(N - 1)日的sum
    __block CGFloat sumValue = 0;
    NSInteger len = PKCYCLER.BOLL_CYELE - 1;
    if (range.location > 0) {
        sumValue = [self.dataList pk_sumValueStart:range.location - 1 length:len evaluatedBlock:^CGFloat(id<PKKLineChartProtocol>  _Nonnull evaluatedObject) {
            return evaluatedObject.pk_kClosePrice;
        }];
    }
    
    [self.dataList pk_enumerateObjsAtRange:range ceaselessBlock:^(id<PKKLineChartProtocol>  _Nonnull obj, NSUInteger idx) {
       
        sumValue += obj.pk_kClosePrice;
        if (idx >= len) {
            CGFloat delClose = [self.dataList objectAtIndex:idx - len].pk_kClosePrice;
            sumValue -= delClose;
        }
        
        // 计算(N-1)日的MA
        CGFloat closeMA = sumValue / len;
        
        // 计算中轨线
        CGFloat MB = closeMA;
        // 计算标准差MD
        CGFloat MD = [self.dataList pk_ssdValueStart:idx length:PKCYCLER.BOLL_CYELE avg:closeMA evaluatedBlock:^CGFloat(id<PKKLineChartProtocol>  _Nonnull evaluatedObject) {
            return evaluatedObject.pk_kClosePrice;
        }];
        // 计算上轨线
        CGFloat UP = MB + PKCYCLER.BOLL_PARAM * MD;
        // 计算下轨线
        CGFloat DP = MB - PKCYCLER.BOLL_PARAM * MD;
        
        // 赋值结果
        PKIndicatorCacheItem *cache = [self getCacheItemAtIndex:idx];
        cache.BOLLMBValue = MB;
        cache.BOLLUPValue = UP;
        cache.BOLLDPValue = DP;
    }];
}

#pragma mark - MACD

- (void)parseResultMACDForRnange:(NSRange)range {
    NSRange usableRange = NSMakeRange(0, self.dataListCount);
    if (NS_RangeContainsRange(self.cachedMACDRange, range)) return;
    
    // 起始下标(使计算从首位开始)
    [self calculateMACDAtRange:usableRange];
    _cachedMACDRange = usableRange;
}

- (void)calculateMACDAtRange:(NSRange)range {
    range = [self checkRange:range method:_cmd];
    if (!range.length) return;
    NSInteger startIdx = range.location;
    NSInteger endIdx = NSMaxRange(range);

    PKIndicatorCacheItem *prevCache = nil;
    PKIndicatorCacheItem *cache = nil;

    if (startIdx == 0) { // 初始值
        CGFloat close = self.dataList[startIdx].pk_kPreClosePrice;
        cache = [self getCacheItemAtIndex:startIdx];
        cache.EMAFastValue = close;
        cache.EMASlowValue = close;
        cache.DIFFValue = 0;
        cache.DEAValue = 0;
        cache.MACDValue = 0;
        prevCache = cache;
        startIdx++;
    } else {
        prevCache = [self getCacheItemAtIndex:startIdx - 1];
    }

    for (NSInteger idx = startIdx; idx < endIdx; idx++) {
        cache = [self getCacheItemAtIndex:idx];
        prevCache = [self getCacheItemAtIndex:idx - 1];
        CGFloat close = self.dataList[idx].pk_kClosePrice;
        
        // 计算移动平均值(快速/慢速)
        CGFloat fastEMA = close * 2.f / (PKCYCLER.EMA_SHORT + 1.f) + prevCache.EMAFastValue * (PKCYCLER.EMA_SHORT - 1.f) / (PKCYCLER.EMA_SHORT + 1.f);
        CGFloat slowEMA = close * 2.f / (PKCYCLER.EMA_LONG + 1.f) + prevCache.EMASlowValue * (PKCYCLER.EMA_LONG - 1.f) / (PKCYCLER.EMA_LONG + 1.f);
       
        // 计算离差值(DIF)
        CGFloat DIF = fastEMA - slowEMA;
       
        // 计算DIF的n日EMA
        CGFloat DEA = prevCache.DEAValue * (PKCYCLER.DIFF_CYCLE - 1.f) / (PKCYCLER.DIFF_CYCLE + 1.f) + DIF * 2.f / (PKCYCLER.DIFF_CYCLE + 1.f);
        
        // 计算MACD
        CGFloat MACD = (DIF - DEA) * 2.f;
      
        // 赋值结果
        cache.EMAFastValue = fastEMA;
        cache.EMASlowValue = slowEMA;
        cache.DIFFValue = DIF;
        cache.DEAValue = DEA;
        cache.MACDValue = MACD;
    }
}

#pragma mark - KDJ

- (void)parseResultKDJForRnange:(NSRange)range {
    NSRange usableRange = NSMakeRange(0, self.dataListCount);
    if (NS_RangeContainsRange(self.cachedKDJRange, range)) return;
    
    // 起始下标(使计算从首位开始)
    [self calculateKDJAtRange:usableRange];
    _cachedKDJRange = usableRange;
}

- (void)calculateKDJAtRange:(NSRange)range {
    range = [self checkRange:range method:_cmd];
    if (!range.length) return;
    NSInteger startIdx = range.location;
    NSInteger endIdx = NSMaxRange(range);

    PKIndicatorCacheItem *prevCache = nil;
    PKIndicatorCacheItem *cache = nil;

    if (startIdx == 0) {
        cache = [self getCacheItemAtIndex:startIdx];
        cache.KValue = 50.f;
        cache.DValue = 50.f;
        cache.JValue = 50.f;
        startIdx++;
    } else {
        prevCache = [self getCacheItemAtIndex:startIdx - 1];
    }

    for (NSInteger idx = startIdx; idx < endIdx; idx++) {
        cache = [self getCacheItemAtIndex:idx];
        prevCache = [self getCacheItemAtIndex:idx - 1];

        CGFloat close = self.dataList[idx].pk_kClosePrice;
        
        // 计算n日内的最高价及最低价
        CGPeakValue peakValue = [self calculateHnlnValueAtIdx:idx cycles:PKCYCLER.KDJ_CYELE];
        CGFloat lowN = peakValue.min;
        CGFloat highN = peakValue.max;
        
        // 计算当日RSV
        CGFloat RSV = CGFloatEqualZero(highN - lowN) ? 0.0 : ((close - lowN) / (highN - lowN) * 100.0);
        
        // 计算K值
        CGFloat kValue = prevCache.KValue * 2 / 3 + RSV * 1 / 3;
       
        // 计算D值
        CGFloat dValue = prevCache.DValue * 2 / 3 + kValue * 1 / 3;
        
        // 计算J值 (3K-2D)
        CGFloat jValue = kValue * 3 - dValue * 2;
        
        // 赋值结果
        cache.KValue = kValue;
        cache.DValue = dValue;
        cache.JValue = jValue;
    }
}

#pragma mark - DMA

- (void)parseResultDMAForRnange:(NSRange)range {
    [self calculateDMAAtRange:range];
}

- (void)calculateDMAAtRange:(NSRange)range {
//    __block CGFloat long_sum = 0;
//    __block CGFloat short_sum = 0;
//    __block CGFloat dma_sum = 0;
    
//    if (range.location > 0) {
//        short_sum = [self.dataArray sumCalculation:range.location - 1 length:INdC.DMA_SHORT_CYELE evaluatedBlock:^CGFloat(id<TQKlineChartProtocol>  _Nonnull evaluatedObject) {
//            return evaluatedObject.tq_close;
//        }];
//        long_sum = [self.dataArray sumCalculation:range.location - 1 length:INdC.DMA_LONG_CYELE evaluatedBlock:^CGFloat(id<TQKlineChartProtocol>  _Nonnull evaluatedObject) {
//            return evaluatedObject.tq_close;
//        }];
//        dma_sum = [self.cacheManager.allCache sumCalculation:range.location -1 length:INdC.DMA_SHORT_CYELE evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
//            return evaluatedObject.DMAValue;
//        }];
//    }
    
    // 小于该周期的不计算
    //    NSRange usingRange = NSMakeRange(0, 0);
    //    NSUInteger maxlen = NSMaxRange(range);
    //    if (maxlen < DMA_SHORT10_CYELE) {
    //        return;
    //    } else {
    //        usingRange.location = DMA_SHORT10_CYELE;
    //        NSUInteger chc = DMA_SHORT10_CYELE - range.location;
    //        usingRange.length = range.length - range.location - chc;
    //    }
    //
//    CGFloat (^block)(NSUInteger, NSInteger, CGFloat*) = ^(NSUInteger idx, NSInteger cycle, CGFloat *sum) {
//        id<TQKlineChartProtocol> obj = self.dataArray[idx];
//        // 计算N日内收盘价累和
//        *sum += obj.tq_close;
//        if (idx < cycle) return 0.0;
//        *sum -= self.dataArray[idx - cycle].tq_close;
//        // 计算N日内收盘价的移动平均价
//        CGFloat maValue = *sum / cycle;
//        return maValue;
//    };
    
//    [self.dataArray enumerateObjsAtRange:range ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
//
//        CGFloat shortMA = block(idx, INdC.DMA_SHORT_CYELE, &short_sum);
//        CGFloat longMA = block(idx, INdC.DMA_LONG_CYELE, &long_sum);
//
//        // 计算DMA值
//        CGFloat DMA = shortMA - longMA;
//
//        DMA = longMA > 0 ? DMA : 0.0;
//        // 计算AMA值
//        dma_sum += DMA;
//        if (idx >= INdC.DMA_SHORT_CYELE) {
//            TQStockCacheModel *delCache = [self.cacheManager cacheObjectAtIndex:idx - INdC.DMA_SHORT_CYELE];
//            dma_sum -= delCache.DMAValue;
//        }
//
//        CGFloat AMA = dma_sum / INdC.DMA_SHORT_CYELE;
//        // 赋值结果
//        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:idx];
//        cache.DMAValue = DMA;
//        cache.AMAValue = AMA;
//    }];
}

#pragma mark - BIAS

- (void)parseResultBIASForRnange:(NSRange)range {
    // 起始下标(使计算从首位开始)
//    NSUInteger startIndex = self.cacheManager.BIASComputedRange.location > 0 ? 0: self.cacheManager.BIASComputedRange.length;
//    // 结束下标
//    NSUInteger endIndex = NSMaxRange(range);
//    if (startIndex < endIndex) {
//        NSRange usingRange = NSMakeRange(startIndex, endIndex);
//        [self calculateBIASAtRange:usingRange];
//    }
}

- (void)calculateBIASAtRange:(NSRange)range {
//    CGFloat (^block)(NSUInteger, NSInteger, CGFloat*) = ^(NSUInteger idx, NSInteger cycle, CGFloat *sum) {
//        id<TQKlineChartProtocol> obj = self.dataArray[idx];
//        // 计算N日内收盘价累和
//        *sum += obj.tq_close;
//        if (idx < cycle) return 0.0;
//        *sum -= self.dataArray[idx - cycle].tq_close;
//        // 计算N日内收盘价的移动平均价
//        CGFloat maValue = *sum / cycle;
//        // 计算返回乖离率BIAS
//        return (obj.tq_close - maValue) * 100.0  / maValue;;
//    };
//
//    __block CGFloat close6_sum = 0, close12_sum = 0, close24_sum = 0;
//    if (range.location > 0) {
//        close6_sum = [self.dataArray sumCalculation:range.location - 1 length:INdC.BIAS6_CYELE evaluatedBlock:^CGFloat(id<TQKlineChartProtocol>  _Nonnull evaluatedObject) {
//            return evaluatedObject.tq_close;
//        }];
//        close12_sum = [self.dataArray sumCalculation:range.location -1 length:INdC.BIAS12_CYELE evaluatedBlock:^CGFloat(id<TQKlineChartProtocol>  _Nonnull evaluatedObject) {
//            return evaluatedObject.tq_close;
//        }];
//        close24_sum = [self.dataArray sumCalculation:range.location -1 length:INdC.BIAS24_CYELE evaluatedBlock:^CGFloat(id<TQKlineChartProtocol>  _Nonnull evaluatedObject) {
//            return evaluatedObject.tq_close;
//        }];
//    }
//    [self.dataArray enumerateObjsAtRange:range ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
//        CGFloat bias6Value = block(idx, INdC.BIAS6_CYELE, &close6_sum);
//        CGFloat bias12Value = block(idx, INdC.BIAS12_CYELE, &close12_sum);
//        CGFloat bias24Value = block(idx, INdC.BIAS24_CYELE, &close24_sum);
//        // 赋值结果
//        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:idx];
//        cache.BIAS6Value = bias6Value;
//        cache.BIAS12Value = bias12Value;
//        cache.BIAS24Value = bias24Value;
//    }];
}

#pragma mark - DMI

- (void)parseResultDMIForRnange:(NSRange)range {
    [self calculateDMIAtRange:range];
}

- (void)calculateDMIAtRange:(NSRange)range {
    
}

#pragma mark - CR

- (void)parseResultCRForRnange:(NSRange)range {
//    // 起始下标(使计算从首位开始)
//    NSUInteger startIndex = self.cacheManager.CRComputedRange.location > 0 ? 0: self.cacheManager.CRComputedRange.length;
//    // 结束下标
//    NSUInteger endIndex = NSMaxRange(range);
//    if (startIndex < endIndex) {
//        NSRange usingRange = NSMakeRange(startIndex, endIndex);
//        [self calculateCRAtRange:usingRange];
//    }
}

- (void)calculateCRAtRange:(NSRange)range {
//    __block CGFloat p1_sum = 0, p2_sum = 0;
//
//    if (range.location == 0) {
//        id<TQKlineChartProtocol> obj = [self.dataArray objectAtIndex:range.location];
//        CGFloat high = obj.tq_high;
//        CGFloat low = obj.tq_low;
//        //        CGFloat midValue = (high + low) / 2.0;
//        CGFloat prevMidValue = 0.0;
//        CGFloat upValue = high - prevMidValue;
//        upValue = MAX(0.0, upValue);
//        CGFloat dpValue = prevMidValue - low;
//        dpValue = MAX(0.0, dpValue);
//        p1_sum += upValue;
//        p2_sum += dpValue;
//        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:range.location];
//        cache.crUpValue = p1_sum;
//        cache.crDpValue = p2_sum;
//        cache.CR26Value = p1_sum / p2_sum * 100.0;
//    }
//
//    //    __block CGFloat prevMID = 0;
//    [self.dataArray enumerateObjsAtRange:NS_RangeOffset1(range) ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
//        id<TQKlineChartProtocol> prevObj = [self.dataArray objectAtIndex:idx - 1];
//        CGFloat prevHigh = prevObj.tq_high;
//        CGFloat prevLow = prevObj.tq_low;
//        // 计算当日中间价
//        CGFloat prevMidValue = (prevHigh + prevLow) / 2.0;
//        // 计算多方力量及空方力量
//        CGFloat upValue = obj.tq_high - prevMidValue;
//        upValue = MAX(0.0, upValue);
//        CGFloat dpValue = prevMidValue - obj.tq_low;
//        // 计算P1/P2
//        p1_sum += upValue;
//        p2_sum += dpValue;
//
//        if (idx >= INdC.CR26_CYELE) {
//            TQStockCacheModel *delCache = [self.cacheManager cacheObjectAtIndex:idx - INdC.CR26_CYELE];
//            p1_sum -= delCache.crUpValue;
//            p2_sum -= delCache.crDpValue;
//        }
//
//        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:idx];
//        cache.crUpValue = p1_sum;
//        cache.crDpValue = p2_sum;
//        if (!CG_FloatIsZero(p2_sum)) {
//            cache.CR26Value = p1_sum / p2_sum * 100.0;
//        }
//
//    }];
}

#pragma mark - VR

- (void)parseResultVRForRnange:(NSRange)range {
//    // 起始下标(使计算从首位开始)
//    NSUInteger startIndex = self.cacheManager.VRComputedRange.location > 0 ? 0: self.cacheManager.VRComputedRange.length;
//    // 结束下标
//    NSUInteger endIndex = NSMaxRange(range);
//    if (startIndex < endIndex) {
//        NSRange usingRange = NSMakeRange(startIndex, endIndex);
//        [self calculateVRAtRange:usingRange];
//    }
}

- (void)calculateVRAtRange:(NSRange)range {
//    __block CGFloat avs = 0, bvs = 0, cvs = 0;
//    if (range.location > 0) {
//        avs = [self.cacheManager.allCache sumCalculation:range.location length:INdC.VR24_CYELE evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
//            return evaluatedObject.vr24TpValue.avs;
//        }];
//        bvs = [self.cacheManager.allCache sumCalculation:range.location length:INdC.VR24_CYELE evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
//            return evaluatedObject.vr24TpValue.bvs;
//        }];
//        cvs = [self.cacheManager.allCache sumCalculation:range.location length:INdC.VR24_CYELE evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
//            return evaluatedObject.vr24TpValue.cvs;
//        }];
//    }
//    CGFloat (^block)(id) = ^(id<TQKlineChartProtocol> _Nonnull obj) {
//        CGFloat close = obj.tq_close;
//        CGFloat prevClose = obj.tq_closeYesterday;
//        return (close - prevClose) / prevClose;
//    };
//    [self.dataArray enumerateObjsAtRange:range ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
//        CGFloat volumes = obj.tq_volume;
//        // 计算股价条件判断
//        CGFloat change = block(obj);
//        // 计算vr24TpValue(avs/bvs/cvs)
//        if (change > 0) avs += volumes;
//        else if (change < 0) bvs += volumes;
//        else cvs += volumes;
//        // 减去之前的delValue
//        if (idx >= INdC.VR24_CYELE) {
//            id<TQKlineChartProtocol> delObj = [self.dataArray objectAtIndex:idx - INdC.VR24_CYELE];
//            CGFloat delVolumes = delObj.tq_volume;
//            CGFloat delChange = block(delObj);
//            if (delChange > 0) avs -= delVolumes;
//            else if (delChange < 0) bvs -= delVolumes;
//            else cvs -= delVolumes;
//        }
//        CGTempVRValue vr24TpValue = CGVRTempValueMake(avs, bvs, cvs);
//        // 计算VR24
//        CGFloat VR24Value = 500.0;
//        if(!CG_FloatIsZero(bvs + cvs)) {
//            VR24Value = (avs + cvs / 2.0) / (bvs + cvs / 2.0) * 100.0;
//        }
//        // 赋值结果
//        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:idx];
//        cache.vr24TpValue = vr24TpValue;
//        cache.VR24Value = VR24Value;
//    }];
}

#pragma mark - OBV

- (void)parseResultOBVForRnange:(NSRange)range {
//    // 起始下标(使计算从首位开始)
//    NSUInteger startIndex = self.cacheManager.OBVComputedRange.location > 0 ? 0: self.cacheManager.OBVComputedRange.length;
//    // 结束下标
//    NSUInteger endIndex = NSMaxRange(range);
//    if (startIndex < endIndex) {
//        NSRange usingRange = NSMakeRange(startIndex, endIndex);
//        [self calculateOBVAtRange:usingRange];
//    }
}

- (void)calculateOBVAtRange:(NSRange)range {
//    __block CGFloat obvValue = 0, obv_sum = 0;
//    if (range.location > 0) {
//        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:range.location - 1];
//        obvValue = cache.OBVValue;
//        obv_sum = [self.cacheManager.allCache sumCalculation:range.location length:INdC.OBVM_CYELE evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
//            return evaluatedObject.OBVValue;
//        }];
//    }
//    [self.dataArray enumerateObjsAtRange:range ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
//        CGFloat close = obj.tq_close;
//        CGFloat prevClose = obj.tq_closeYesterday;
//        CGFloat volumes = obj.tq_volume;
//        // 判断sgn的值
//        CGFloat sgn = 0;
//        if (close > prevClose) sgn = 1;
//        else if (close < prevClose) sgn = -1;
//        // 计算OBV
//        obvValue += sgn * volumes;
//        // 计算OBVM
//        CGFloat delValue = [self.cacheManager cacheObjectAtIndex:idx - INdC.OBVM_CYELE].OBVValue;
//        obv_sum += obvValue;
//        obv_sum -= delValue;
//        CGFloat obvmValue = obv_sum / INdC.OBVM_CYELE;
//        // 赋值结果
//        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:idx];
//        cache.OBVValue = obvValue;
//        cache.OBVMValue = obvmValue;
//    }];
}

#pragma mark - RSI

- (void)parseResultRSIForRnange:(NSRange)range {
//    // 起始下标(使计算从首位开始)
//    NSUInteger startIndex = self.cacheManager.RSIComputedRange.location > 0 ? 0: self.cacheManager.RSIComputedRange.length;
//    // 结束下标
//    NSUInteger endIndex = NSMaxRange(range);
//    if (startIndex < endIndex) {
//        NSRange usingRange = NSMakeRange(startIndex, endIndex);
//        [self calculateRSIAtRange:usingRange];
//    }
}

- (void)calculateRSIAtRange:(NSRange)range {
//    CGFloat (^block)(CGTempRSIValue) = ^(CGTempRSIValue tpValue) {
//        return CG_FloatIsZero(tpValue.sabs) ? 0.0 : (tpValue.smax / tpValue.sabs * 100.0);
//    };
//
//    if (range.location == 0) {
//        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:0];
//        cache.rsi6TpValue = CGStoreRSIValueMake(0.0, 0.0);
//        cache.rsi12TpValue = CGStoreRSIValueMake(0.0, 0.0);
//        cache.rsi24TpValue = CGStoreRSIValueMake(0.0, 0.0);
//        cache.RSI6Value = block(cache.rsi6TpValue);
//        cache.RSI12Value = block(cache.rsi12TpValue);
//        cache.RSI24Value = block(cache.rsi24TpValue);
//    }
//
//    [self.dataArray enumerateObjsAtRange:NS_RangeOffset1(range) ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
//        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:idx];
//        TQStockCacheModel *prevCache = [self.cacheManager cacheObjectAtIndex:idx - 1];
//        CGFloat close = obj.tq_close;
//        CGFloat prevClose = obj.tq_closeYesterday;
//        // 计算max/abs收盘价
//        CGFloat maxClose = MAX((close - prevClose), 0);
//        CGFloat absClose = fabs(close - prevClose);
//        // 计算smax/sabs值
//        CGFloat smax6 = (prevCache.rsi6TpValue.smax * (INdC.RSI6_CYELE - 1) + maxClose) / INdC.RSI6_CYELE;
//        CGFloat sabs6 = (prevCache.rsi6TpValue.sabs * (INdC.RSI6_CYELE - 1) + absClose) / INdC.RSI6_CYELE;
//        cache.rsi6TpValue = CGStoreRSIValueMake(smax6, sabs6);
//        CGFloat smax12 = (prevCache.rsi12TpValue.smax * (INdC.RSI12_CYELE - 1) + maxClose) / INdC.RSI12_CYELE;
//        CGFloat sabs12 = (prevCache.rsi12TpValue.sabs * (INdC.RSI12_CYELE - 1) + absClose) / INdC.RSI12_CYELE;
//        cache.rsi12TpValue = CGStoreRSIValueMake(smax12, sabs12);
//        CGFloat smax24 = (prevCache.rsi24TpValue.smax * (INdC.RSI24_CYELE - 1) + maxClose) / INdC.RSI24_CYELE;
//        CGFloat sabs24 = (prevCache.rsi24TpValue.sabs * (INdC.RSI24_CYELE - 1) + absClose) / INdC.RSI24_CYELE;
//        cache.rsi24TpValue = CGStoreRSIValueMake(smax24, sabs24);
//        // 计算RSI值并赋值结果
//        cache.RSI6Value = block(cache.rsi6TpValue);
//        cache.RSI12Value = block(cache.rsi12TpValue);
//        cache.RSI24Value = block(cache.rsi24TpValue);
//    }];
}

#pragma mark - ASI

- (void)parseResultASIForRnange:(NSRange)range {
    
}

#pragma mark - WR

- (void)parseResultWRForRnange:(NSRange)range {
    [self calculateWRAtRange:range];
}

- (void)calculateWRAtRange:(NSRange)range {
//    CGFloat (^block)(CGPeakValue, CGFloat) = ^(CGPeakValue peakValue, CGFloat close) {
//        if (CG_FloatIsZero(peakValue.max - peakValue.min)) return 0.0;
//        return 100.0 * (peakValue.max - close) / (peakValue.max - peakValue.min);
//    };
//    [self.dataArray enumerateObjsAtRange:range ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
//        CGFloat close = obj.tq_close;
//        // 计算n日内的最高价最低价的极值
//        CGPeakValue peakValue = [self calculateHnlnAtIdx:idx numberOfCycles:INdC.WR_SHORT_CYELE];
//        CGPeakValue peakValue1 = [self calculateHnlnAtIdx:idx numberOfCycles:INdC.WR_LONG_CYELE];
//        // 计算WR值
//        CGFloat WR6 = block(peakValue, close);
//        CGFloat WR10 = block(peakValue1, close);
//        // 赋值结果
//        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:idx];
//        cache.WR6Value = WR6;
//        cache.WR10Value = WR10;
//    }];
}

#pragma mark - CCI

- (void)parseResultCCIForRnange:(NSRange)range {
    [self calculateCCIAtRange:range];
}

- (void)calculateCCIAtRange:(NSRange)range {
    //    NSInteger cycleN = 14;
//    [self.dataArray enumerateObjsAtRange:range ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
//        CGFloat high = obj.tq_high;
//        CGFloat low = obj.tq_low;
//        CGFloat close = obj.tq_close;
//        // 计算TP值
//        CGFloat TP = (high + low + close) / 3.0;
//        NSLog(@"TP is: %@", @(TP));
//        // 计算MA (近N日收盘价的移动平均)
//        //        CGFloat sum = [self.dataModels calculateSum:idx length:cycleN evaluatedBlock:^CGFloat(id<TQKlineChartProtocol>  _Nonnull obj) {
//        //            return obj.tq_close;
//        //        }];
//        //        CGFloat MA = sum / cycleN;
//        // 计算MD
//        //        for (NSInteger j = 0 ; j < cycleN; j++) {
//        //            //            YTSCFloat avetempDiff = fabs(queue_tp[j] - (tpSum / days))
//        //            avetempDiffSum += fabs(queue_tp[j] - tpMA);
//        //        }
//        //        CGFloat MD = 近N日（MA－收盘价）的累计之和÷N
//
//    }];
}

#pragma mark - SAR

- (void)parseResultSARForRnange:(NSRange)range {
}

#pragma mark - PSY

- (void)parseResultPSYForRnange:(NSRange)range {
    //    // 起始下标(使计算从首位开始)
    //    NSUInteger startIndex = self.cacheManager.PSYComputedRange.location > 0 ? 0: self.cacheManager.PSYComputedRange.length;
    //    // 结束下标
    //    NSUInteger endIndex = NSMaxRange(range);
    //    if (startIndex < endIndex) {
    //        NSRange usingRange = NSMakeRange(startIndex, endIndex);
    //        [self calculatePSYAtRange:usingRange];
    //    }
}

- (void)calculatePSYAtRange:(NSRange)range {
    //    __block CGFloat psy_sum = 0;
    //    if (range.location > 0) {
    //        psy_sum = [self.cacheManager.allCache sumCalculation:range.location length:INdC.PSYMA_CYELE evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
    //            return evaluatedObject.PSYValue;
    //        }];
    //    }
    //    [self.dataArray enumerateObjsAtRange:range ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
    //        // 计算上涨天数
    //        CGFloat times = [self.dataArray timesCalculation:idx length:INdC.PSY_CYELE conditionBlock:^BOOL(id<TQKlineChartProtocol>  _Nonnull object) {
    //            CGFloat close = object.tq_close;
    //            CGFloat prevClose = object.tq_closeYesterday;
    //            // 上涨天条件判断
    //            return ((close - prevClose) / prevClose) > 0;
    //        }];
    //        // 计算PSY
    //        CGFloat PSY = times / (INdC.PSY_CYELE * 1.0) * 100.0;
    //        // 计算PSYMA
    //        CGFloat delValue = [self.cacheManager cacheObjectAtIndex:idx - INdC.PSYMA_CYELE].PSYValue;
    //        psy_sum += PSY;
    //        psy_sum -= delValue;
    //        CGFloat psymaValue = psy_sum / INdC.PSYMA_CYELE;
    //        // 赋值结果
    //        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:idx];
    //        cache.PSYValue = PSY;
    //        cache.PSYMAValue = psymaValue;
    //    }];
}

#pragma mark - EMA

- (void)parseResultEMAForRnange:(NSRange)range {
}

#pragma mark - EMV

- (void)parseResultEMVForRnange:(NSRange)range {
}

#pragma mark - TRIX

- (void)parseResultTRIXForRnange:(NSRange)range {
}

#pragma mark - BRAR

- (void)parseResultBRARForRnange:(NSRange)range {
}

#pragma mark - WVAD

- (void)parseResultWVADForRnange:(NSRange)range {
}

#pragma mark - ROC

- (void)parseResultROCForRnange:(NSRange)range {
}

//- (void)dealloc {
//    NSLog(@"%@-dealloc✈️", NSStringFromClass(self.class));
//}

@end
