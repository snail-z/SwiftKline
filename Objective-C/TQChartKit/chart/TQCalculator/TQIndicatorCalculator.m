//
//  TQIndicatorCalculator.m
//  TQChartKit
//
//  Created by zhanghao on 2018/8/31.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndicatorCalculator.h"
#import "NSArray+TQStockChart.h"
#import "TQIndicatorType.h"
#import "TQIndicatorCycles.h"

#define INdC [TQIndicatorCycles sharedIndicatorCycles]

@implementation TQIndicatorCalculator

/** 检查range是否有效 */
- (NSRange)checkRange:(NSRange)range method:(SEL)method {
    NSRange allRange = NSMakeRange(0, self.dataArray.count);
    NSRange targetRange = NSIntersectionRange(allRange, range);
    if (!targetRange.length) {
        NSLog(@"No range can be calculated. %@ '- %@'", NSStringFromRange(targetRange), NSStringFromSelector(method));
    }
    return targetRange;
}

/** 从idx位置起向前计算days日内最高价最低价的最大最小值 */
- (CGPeakValue)calculateHnlnAtIdx:(NSUInteger)idx numberOfCycles:(NSUInteger)days {
    NSRange range = idx < days ? NSMakeRange(0, idx + 1) : NSMakeRange(idx - days + 1, days);
    __block CGPeakValue peak = CGPeakValueMake(-CGFLOAT_MAX, CGFLOAT_MAX);
    [self.dataArray enumerateObjsAtRange:range ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
        if (obj.tq_high > peak.max) peak.max = obj.tq_high;
        if (obj.tq_low < peak.min) peak.min = obj.tq_low;
    }];
    return peak;
}

#pragma mark - parseResult

- (void)setDataArray:(NSArray<id<TQKlineChartProtocol>> *)dataModels {
    if (!dataModels.count) return;
    _dataArray = dataModels;
    [_cacheManager clearCache];
    _cacheManager = [TQStockCacheManager cacheManagerWithCount:dataModels.count];
}

- (void)parseResultRange:(NSRange)range byIndicatorIdentifier:(NSString *)identifier {
    if ([identifier isEqualToString:TQIndicatorMA]) {
        return [self parseResultMAForRnange:range];
    } else if ([identifier isEqualToString:TQIndicatorVOL]) {
        return [self parseResultVOLForRnange:range];
    } else if ([identifier isEqualToString:TQIndicatorMACD]) {
        return [self parseResultMACDForRnange:range];
    } else if ([identifier isEqualToString:TQIndicatorKDJ]) {
        return [self parseResultKDJForRnange:range];
    } else if ([identifier isEqualToString:TQIndicatorCCI]) {
        return [self parseResultCCIForRnange:range];
    } else if ([identifier isEqualToString:TQIndicatorWR]) {
        return [self parseResultWRForRnange:range];
    } else if ([identifier isEqualToString:TQIndicatorRSI]) {
        return [self parseResultRSIForRnange:range];
    } else if ([identifier isEqualToString:TQIndicatorOBV]) {
        return [self parseResultOBVForRnange:range];
    } else if ([identifier isEqualToString:TQIndicatorPSY]) {
        return [self parseResultPSYForRnange:range];
    } else if ([identifier isEqualToString:TQIndicatorVR]) {
        return [self parseResultVRForRnange:range];
    } else if ([identifier isEqualToString:TQIndicatorCR]) {
        return [self parseResultCRForRnange:range];
    } else if ([identifier isEqualToString:TQIndicatorBOLL]) {
        return [self parseResultBOLLForRnange:range];
    } else if ([identifier isEqualToString:TQIndicatorDMI]) {
        return [self parseResultDMIForRnange:range];
    } else if ([identifier isEqualToString:TQIndicatorBIAS]) {
        return [self parseResultBIASForRnange:range];
    } else if ([identifier isEqualToString:TQIndicatorDMA]) {
        return [self parseResultDMAForRnange:range];
    }
}

#pragma mark - MA

- (void)parseResultMAForRnange:(NSRange)range {
    // 起始下标(使计算从首位开始)
    NSUInteger startIndex = self.cacheManager.MAComputedRange.location > 0 ? 0: self.cacheManager.MAComputedRange.length;
    // 结束下标
    NSUInteger endIndex = NSMaxRange(range);
    if (startIndex < endIndex) {
        NSRange usingRange = NSMakeRange(startIndex, endIndex);
        [self calculateMAAtRange:usingRange];
    }
}

- (void)extracted:(const NSRange *)range {
    [self.dataArray enumerateCalculateMA:INdC.MA5_CYELE range:*range evaluatedBlock:^CGFloat(id<TQKlineChartProtocol>  _Nonnull evaluatedObject) {
        return evaluatedObject.tq_close;
    } usingBlock:^(NSUInteger idx, CGFloat maValue) {
        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:idx];
        cache.MA5Value = maValue;
    }];
}

- (void)calculateMAAtRange:(NSRange)range {
    [self extracted:&range];
    [self.dataArray enumerateCalculateMA:INdC.MA10_CYELE range:range evaluatedBlock:^CGFloat(id<TQKlineChartProtocol>  _Nonnull evaluatedObject) {
        return evaluatedObject.tq_close;
    } usingBlock:^(NSUInteger idx, CGFloat maValue) {
        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:idx];
        cache.MA10Value = maValue;
    }];
    [self.dataArray enumerateCalculateMA:INdC.MA20_CYELE range:range evaluatedBlock:^CGFloat(id<TQKlineChartProtocol>  _Nonnull evaluatedObject) {
        return evaluatedObject.tq_close;
    } usingBlock:^(NSUInteger idx, CGFloat maValue) {
        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:idx];
        cache.MA20Value = maValue;
    }];
    [self.dataArray enumerateCalculateMA:INdC.MA60_CYELE range:range evaluatedBlock:^CGFloat(id<TQKlineChartProtocol>  _Nonnull evaluatedObject) {
        return evaluatedObject.tq_close;
    } usingBlock:^(NSUInteger idx, CGFloat maValue) {
        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:idx];
        cache.MA60Value = maValue;
    }];
}

#pragma mark - DMA

- (void)parseResultDMAForRnange:(NSRange)range {
    [self calculateDMAAtRange:range];
}

- (void)calculateDMAAtRange:(NSRange)range {
    __block CGFloat long_sum = 0;
    __block CGFloat short_sum = 0;
    __block CGFloat dma_sum = 0;
    
    if (range.location > 0) {
        short_sum = [self.dataArray sumCalculation:range.location - 1 length:INdC.DMA_SHORT_CYELE evaluatedBlock:^CGFloat(id<TQKlineChartProtocol>  _Nonnull evaluatedObject) {
            return evaluatedObject.tq_close;
        }];
        long_sum = [self.dataArray sumCalculation:range.location - 1 length:INdC.DMA_LONG_CYELE evaluatedBlock:^CGFloat(id<TQKlineChartProtocol>  _Nonnull evaluatedObject) {
            return evaluatedObject.tq_close;
        }];
        dma_sum = [self.cacheManager.allCache sumCalculation:range.location -1 length:INdC.DMA_SHORT_CYELE evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
            return evaluatedObject.DMAValue;
        }];
    }
    
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
    CGFloat (^block)(NSUInteger, NSInteger, CGFloat*) = ^(NSUInteger idx, NSInteger cycle, CGFloat *sum) {
        id<TQKlineChartProtocol> obj = self.dataArray[idx];
        // 计算N日内收盘价累和
        *sum += obj.tq_close;
        if (idx < cycle) return 0.0;
        *sum -= self.dataArray[idx - cycle].tq_close;
        // 计算N日内收盘价的移动平均价
        CGFloat maValue = *sum / cycle;
        return maValue;
    };
    
    [self.dataArray enumerateObjsAtRange:range ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
        
        CGFloat shortMA = block(idx, INdC.DMA_SHORT_CYELE, &short_sum);
        CGFloat longMA = block(idx, INdC.DMA_LONG_CYELE, &long_sum);

        // 计算DMA值
        CGFloat DMA = shortMA - longMA;
        
        DMA = longMA > 0 ? DMA : 0.0;
        // 计算AMA值
        dma_sum += DMA;
        if (idx >= INdC.DMA_SHORT_CYELE) {
            TQStockCacheModel *delCache = [self.cacheManager cacheObjectAtIndex:idx - INdC.DMA_SHORT_CYELE];
            dma_sum -= delCache.DMAValue;
        }
        
        CGFloat AMA = dma_sum / INdC.DMA_SHORT_CYELE;
        // 赋值结果
        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:idx];
        cache.DMAValue = DMA;
        cache.AMAValue = AMA;
    }];
}

#pragma mark - BIAS

- (void)parseResultBIASForRnange:(NSRange)range {
    // 起始下标(使计算从首位开始)
    NSUInteger startIndex = self.cacheManager.BIASComputedRange.location > 0 ? 0: self.cacheManager.BIASComputedRange.length;
    // 结束下标
    NSUInteger endIndex = NSMaxRange(range);
    if (startIndex < endIndex) {
        NSRange usingRange = NSMakeRange(startIndex, endIndex);
        [self calculateBIASAtRange:usingRange];
    }
}

- (void)calculateBIASAtRange:(NSRange)range {
    CGFloat (^block)(NSUInteger, NSInteger, CGFloat*) = ^(NSUInteger idx, NSInteger cycle, CGFloat *sum) {
        id<TQKlineChartProtocol> obj = self.dataArray[idx];
        // 计算N日内收盘价累和
        *sum += obj.tq_close;
        if (idx < cycle) return 0.0;
        *sum -= self.dataArray[idx - cycle].tq_close;
        // 计算N日内收盘价的移动平均价
        CGFloat maValue = *sum / cycle;
        // 计算返回乖离率BIAS
        return (obj.tq_close - maValue) * 100.0  / maValue;;
    };
    
    __block CGFloat close6_sum = 0, close12_sum = 0, close24_sum = 0;
    if (range.location > 0) {
        close6_sum = [self.dataArray sumCalculation:range.location - 1 length:INdC.BIAS6_CYELE evaluatedBlock:^CGFloat(id<TQKlineChartProtocol>  _Nonnull evaluatedObject) {
            return evaluatedObject.tq_close;
        }];
        close12_sum = [self.dataArray sumCalculation:range.location -1 length:INdC.BIAS12_CYELE evaluatedBlock:^CGFloat(id<TQKlineChartProtocol>  _Nonnull evaluatedObject) {
            return evaluatedObject.tq_close;
        }];
        close24_sum = [self.dataArray sumCalculation:range.location -1 length:INdC.BIAS24_CYELE evaluatedBlock:^CGFloat(id<TQKlineChartProtocol>  _Nonnull evaluatedObject) {
            return evaluatedObject.tq_close;
        }];
    }
    [self.dataArray enumerateObjsAtRange:range ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
        CGFloat bias6Value = block(idx, INdC.BIAS6_CYELE, &close6_sum);
        CGFloat bias12Value = block(idx, INdC.BIAS12_CYELE, &close12_sum);
        CGFloat bias24Value = block(idx, INdC.BIAS24_CYELE, &close24_sum);
        // 赋值结果
        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:idx];
        cache.BIAS6Value = bias6Value;
        cache.BIAS12Value = bias12Value;
        cache.BIAS24Value = bias24Value;
    }];
}

#pragma mark - DMI

- (void)parseResultDMIForRnange:(NSRange)range {
    [self calculateDMIAtRange:range];
}

- (void)calculateDMIAtRange:(NSRange)range {
    
}

#pragma mark - BOLL

- (void)parseResultBOLLForRnange:(NSRange)range {
    // 起始下标(使计算从首位开始)
    NSUInteger startIndex = self.cacheManager.BOLLComputedRange.location > 0 ? 0: self.cacheManager.BOLLComputedRange.length;
    // 结束下标
    NSUInteger endIndex = NSMaxRange(range);
    if (startIndex < endIndex) {
        NSRange usingRange = NSMakeRange(startIndex, endIndex);
        [self calculateBOLLAtRange:usingRange];
    }
}

- (void)calculateBOLLAtRange:(NSRange)range {
    __block CGFloat close_sum = 0;
    // 计算(N - 1)日的sum
    NSInteger len = INdC.BOLL20_CYELE - 1;
    if (range.location > 0) {
        close_sum = [self.dataArray sumCalculation:range.location - 1 length:len evaluatedBlock:^CGFloat(id<TQKlineChartProtocol>  _Nonnull evaluatedObject) {
            return evaluatedObject.tq_close;
        }];
    }
    [self.dataArray enumerateObjsAtRange:range ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
        close_sum += obj.tq_close;
        if (idx >= len) {
            CGFloat delClose = [self.dataArray objectAtIndex:idx - len].tq_close;
            close_sum -= delClose;
        }
        // 计算(N-1)日的MA
        CGFloat closeMA = close_sum / len;
        // 计算中轨线
        CGFloat MB = closeMA;
        // 计算标准差MD
        CGFloat MD = [self.dataArray ssdCalculation:idx length:INdC.BOLL20_CYELE avg:closeMA evaluatedBlock:^CGFloat(id<TQKlineChartProtocol>  _Nonnull evaluatedObject) {
            return evaluatedObject.tq_close;
        }];
        // 计算上轨线
        CGFloat UP = MB + INdC.BOLL_PARAM * MD;
        // 计算下轨线
        CGFloat DP = MB - INdC.BOLL_PARAM * MD;
        // 赋值结果
        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:idx];
        cache.BOLLMBValue = MB;
        cache.BOLLUPValue = UP;
        cache.BOLLDPValue = DP;
    }];
}

#pragma mark - CR

- (void)parseResultCRForRnange:(NSRange)range {
    // 起始下标(使计算从首位开始)
    NSUInteger startIndex = self.cacheManager.CRComputedRange.location > 0 ? 0: self.cacheManager.CRComputedRange.length;
    // 结束下标
    NSUInteger endIndex = NSMaxRange(range);
    if (startIndex < endIndex) {
        NSRange usingRange = NSMakeRange(startIndex, endIndex);
        [self calculateCRAtRange:usingRange];
    }
}

- (void)calculateCRAtRange:(NSRange)range {
    __block CGFloat p1_sum = 0, p2_sum = 0;
    
    if (range.location == 0) {
        id<TQKlineChartProtocol> obj = [self.dataArray objectAtIndex:range.location];
        CGFloat high = obj.tq_high;
        CGFloat low = obj.tq_low;
//        CGFloat midValue = (high + low) / 2.0;
        CGFloat prevMidValue = 0.0;
        CGFloat upValue = high - prevMidValue;
        upValue = MAX(0.0, upValue);
        CGFloat dpValue = prevMidValue - low;
        dpValue = MAX(0.0, dpValue);
        p1_sum += upValue;
        p2_sum += dpValue;
        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:range.location];
        cache.crUpValue = p1_sum;
        cache.crDpValue = p2_sum;
        cache.CR26Value = p1_sum / p2_sum * 100.0;
    }
    
//    __block CGFloat prevMID = 0;
    [self.dataArray enumerateObjsAtRange:NS_RangeOffset1(range) ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
        id<TQKlineChartProtocol> prevObj = [self.dataArray objectAtIndex:idx - 1];
        CGFloat prevHigh = prevObj.tq_high;
        CGFloat prevLow = prevObj.tq_low;
        // 计算当日中间价
        CGFloat prevMidValue = (prevHigh + prevLow) / 2.0;
        // 计算多方力量及空方力量
        CGFloat upValue = obj.tq_high - prevMidValue;
        upValue = MAX(0.0, upValue);
        CGFloat dpValue = prevMidValue - obj.tq_low;
        // 计算P1/P2
        p1_sum += upValue;
        p2_sum += dpValue;
        
        if (idx >= INdC.CR26_CYELE) {
            TQStockCacheModel *delCache = [self.cacheManager cacheObjectAtIndex:idx - INdC.CR26_CYELE];
            p1_sum -= delCache.crUpValue;
            p2_sum -= delCache.crDpValue;
        }
        
        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:idx];
        cache.crUpValue = p1_sum;
        cache.crDpValue = p2_sum;
        if (!CG_FloatIsZero(p2_sum)) {
            cache.CR26Value = p1_sum / p2_sum * 100.0;
        }
        
    }];
}

#pragma mark - VR

- (void)parseResultVRForRnange:(NSRange)range {
    // 起始下标(使计算从首位开始)
    NSUInteger startIndex = self.cacheManager.VRComputedRange.location > 0 ? 0: self.cacheManager.VRComputedRange.length;
    // 结束下标
    NSUInteger endIndex = NSMaxRange(range);
    if (startIndex < endIndex) {
        NSRange usingRange = NSMakeRange(startIndex, endIndex);
        [self calculateVRAtRange:usingRange];
    }
}

- (void)calculateVRAtRange:(NSRange)range {
    __block CGFloat avs = 0, bvs = 0, cvs = 0;
    if (range.location > 0) {
        avs = [self.cacheManager.allCache sumCalculation:range.location length:INdC.VR24_CYELE evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
            return evaluatedObject.vr24TpValue.avs;
        }];
        bvs = [self.cacheManager.allCache sumCalculation:range.location length:INdC.VR24_CYELE evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
            return evaluatedObject.vr24TpValue.bvs;
        }];
        cvs = [self.cacheManager.allCache sumCalculation:range.location length:INdC.VR24_CYELE evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
            return evaluatedObject.vr24TpValue.cvs;
        }];
    }
    CGFloat (^block)(id) = ^(id<TQKlineChartProtocol> _Nonnull obj) {
        CGFloat close = obj.tq_close;
        CGFloat prevClose = obj.tq_closeYesterday;
        return (close - prevClose) / prevClose;
    };
    [self.dataArray enumerateObjsAtRange:range ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
        CGFloat volumes = obj.tq_volume;
        // 计算股价条件判断
        CGFloat change = block(obj);
        // 计算vr24TpValue(avs/bvs/cvs)
        if (change > 0) avs += volumes;
        else if (change < 0) bvs += volumes;
        else cvs += volumes;
        // 减去之前的delValue
        if (idx >= INdC.VR24_CYELE) {
            id<TQKlineChartProtocol> delObj = [self.dataArray objectAtIndex:idx - INdC.VR24_CYELE];
            CGFloat delVolumes = delObj.tq_volume;
            CGFloat delChange = block(delObj);
            if (delChange > 0) avs -= delVolumes;
            else if (delChange < 0) bvs -= delVolumes;
            else cvs -= delVolumes;
        }
        CGTempVRValue vr24TpValue = CGVRTempValueMake(avs, bvs, cvs);
        // 计算VR24
        CGFloat VR24Value = 500.0;
        if(!CG_FloatIsZero(bvs + cvs)) {
            VR24Value = (avs + cvs / 2.0) / (bvs + cvs / 2.0) * 100.0;
        }
        // 赋值结果
        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:idx];
        cache.vr24TpValue = vr24TpValue;
        cache.VR24Value = VR24Value;
    }];
}

#pragma mark - PSY

- (void)parseResultPSYForRnange:(NSRange)range {
    // 起始下标(使计算从首位开始)
    NSUInteger startIndex = self.cacheManager.PSYComputedRange.location > 0 ? 0: self.cacheManager.PSYComputedRange.length;
    // 结束下标
    NSUInteger endIndex = NSMaxRange(range);
    if (startIndex < endIndex) {
        NSRange usingRange = NSMakeRange(startIndex, endIndex);
        [self calculatePSYAtRange:usingRange];
    }
}

- (void)calculatePSYAtRange:(NSRange)range {
    __block CGFloat psy_sum = 0;
    if (range.location > 0) {
        psy_sum = [self.cacheManager.allCache sumCalculation:range.location length:INdC.PSYMA_CYELE evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
            return evaluatedObject.PSYValue;
        }];
    }
    [self.dataArray enumerateObjsAtRange:range ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
        // 计算上涨天数
        CGFloat times = [self.dataArray timesCalculation:idx length:INdC.PSY_CYELE conditionBlock:^BOOL(id<TQKlineChartProtocol>  _Nonnull object) {
            CGFloat close = object.tq_close;
            CGFloat prevClose = object.tq_closeYesterday;
            // 上涨天条件判断
            return ((close - prevClose) / prevClose) > 0;
        }];
        // 计算PSY
        CGFloat PSY = times / (INdC.PSY_CYELE * 1.0) * 100.0;
        // 计算PSYMA
        CGFloat delValue = [self.cacheManager cacheObjectAtIndex:idx - INdC.PSYMA_CYELE].PSYValue;
        psy_sum += PSY;
        psy_sum -= delValue;
        CGFloat psymaValue = psy_sum / INdC.PSYMA_CYELE;
        // 赋值结果
        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:idx];
        cache.PSYValue = PSY;
        cache.PSYMAValue = psymaValue;
    }];
}

#pragma mark - OBV

- (void)parseResultOBVForRnange:(NSRange)range {
    // 起始下标(使计算从首位开始)
    NSUInteger startIndex = self.cacheManager.OBVComputedRange.location > 0 ? 0: self.cacheManager.OBVComputedRange.length;
    // 结束下标
    NSUInteger endIndex = NSMaxRange(range);
    if (startIndex < endIndex) {
        NSRange usingRange = NSMakeRange(startIndex, endIndex);
        [self calculateOBVAtRange:usingRange];
    }
}

- (void)calculateOBVAtRange:(NSRange)range {
    __block CGFloat obvValue = 0, obv_sum = 0;
    if (range.location > 0) {
        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:range.location - 1];
        obvValue = cache.OBVValue;
        obv_sum = [self.cacheManager.allCache sumCalculation:range.location length:INdC.OBVM_CYELE evaluatedBlock:^CGFloat(TQStockCacheModel * _Nonnull evaluatedObject) {
            return evaluatedObject.OBVValue;
        }];
    }
    [self.dataArray enumerateObjsAtRange:range ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
        CGFloat close = obj.tq_close;
        CGFloat prevClose = obj.tq_closeYesterday;
        CGFloat volumes = obj.tq_volume;
        // 判断sgn的值
        CGFloat sgn = 0;
        if (close > prevClose) sgn = 1;
        else if (close < prevClose) sgn = -1;
        // 计算OBV
        obvValue += sgn * volumes;
        // 计算OBVM
        CGFloat delValue = [self.cacheManager cacheObjectAtIndex:idx - INdC.OBVM_CYELE].OBVValue;
        obv_sum += obvValue;
        obv_sum -= delValue;
        CGFloat obvmValue = obv_sum / INdC.OBVM_CYELE;
        // 赋值结果
        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:idx];
        cache.OBVValue = obvValue;
        cache.OBVMValue = obvmValue;
    }];
}

#pragma mark - RSI

- (void)parseResultRSIForRnange:(NSRange)range {
    // 起始下标(使计算从首位开始)
    NSUInteger startIndex = self.cacheManager.RSIComputedRange.location > 0 ? 0: self.cacheManager.RSIComputedRange.length;
    // 结束下标
    NSUInteger endIndex = NSMaxRange(range);
    if (startIndex < endIndex) {
        NSRange usingRange = NSMakeRange(startIndex, endIndex);
        [self calculateRSIAtRange:usingRange];
    }
}

- (void)calculateRSIAtRange:(NSRange)range {
    CGFloat (^block)(CGTempRSIValue) = ^(CGTempRSIValue tpValue) {
        return CG_FloatIsZero(tpValue.sabs) ? 0.0 : (tpValue.smax / tpValue.sabs * 100.0);
    };
    
    if (range.location == 0) {
        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:0];
        cache.rsi6TpValue = CGRSITempValueMake(0.0, 0.0);
        cache.rsi12TpValue = CGRSITempValueMake(0.0, 0.0);
        cache.rsi24TpValue = CGRSITempValueMake(0.0, 0.0);
        cache.RSI6Value = block(cache.rsi6TpValue);
        cache.RSI12Value = block(cache.rsi12TpValue);
        cache.RSI24Value = block(cache.rsi24TpValue);
    }
    
    [self.dataArray enumerateObjsAtRange:NS_RangeOffset1(range) ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:idx];
        TQStockCacheModel *prevCache = [self.cacheManager cacheObjectAtIndex:idx - 1];
        CGFloat close = obj.tq_close;
        CGFloat prevClose = obj.tq_closeYesterday;
        // 计算max/abs收盘价
        CGFloat maxClose = MAX((close - prevClose), 0);
        CGFloat absClose = fabs(close - prevClose);
        // 计算smax/sabs值
        CGFloat smax6 = (prevCache.rsi6TpValue.smax * (INdC.RSI6_CYELE - 1) + maxClose) / INdC.RSI6_CYELE;
        CGFloat sabs6 = (prevCache.rsi6TpValue.sabs * (INdC.RSI6_CYELE - 1) + absClose) / INdC.RSI6_CYELE;
        cache.rsi6TpValue = CGRSITempValueMake(smax6, sabs6);
        CGFloat smax12 = (prevCache.rsi12TpValue.smax * (INdC.RSI12_CYELE - 1) + maxClose) / INdC.RSI12_CYELE;
        CGFloat sabs12 = (prevCache.rsi12TpValue.sabs * (INdC.RSI12_CYELE - 1) + absClose) / INdC.RSI12_CYELE;
        cache.rsi12TpValue = CGRSITempValueMake(smax12, sabs12);
        CGFloat smax24 = (prevCache.rsi24TpValue.smax * (INdC.RSI24_CYELE - 1) + maxClose) / INdC.RSI24_CYELE;
        CGFloat sabs24 = (prevCache.rsi24TpValue.sabs * (INdC.RSI24_CYELE - 1) + absClose) / INdC.RSI24_CYELE;
        cache.rsi24TpValue = CGRSITempValueMake(smax24, sabs24);
        // 计算RSI值并赋值结果
        cache.RSI6Value = block(cache.rsi6TpValue);
        cache.RSI12Value = block(cache.rsi12TpValue);
        cache.RSI24Value = block(cache.rsi24TpValue);
    }];
}

#pragma mark - WR

- (void)parseResultWRForRnange:(NSRange)range {
    [self calculateWRAtRange:range];
}

- (void)calculateWRAtRange:(NSRange)range {
    CGFloat (^block)(CGPeakValue, CGFloat) = ^(CGPeakValue peakValue, CGFloat close) {
        if (CG_FloatIsZero(peakValue.max - peakValue.min)) return 0.0;
        return 100.0 * (peakValue.max - close) / (peakValue.max - peakValue.min);
    };
    [self.dataArray enumerateObjsAtRange:range ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
        CGFloat close = obj.tq_close;
        // 计算n日内的最高价最低价的极值
        CGPeakValue peakValue = [self calculateHnlnAtIdx:idx numberOfCycles:INdC.WR_SHORT_CYELE];
        CGPeakValue peakValue1 = [self calculateHnlnAtIdx:idx numberOfCycles:INdC.WR_LONG_CYELE];
        // 计算WR值
        CGFloat WR6 = block(peakValue, close);
        CGFloat WR10 = block(peakValue1, close);
        // 赋值结果
        TQStockCacheModel *cache = [self.cacheManager cacheObjectAtIndex:idx];
        cache.WR6Value = WR6;
        cache.WR10Value = WR10;
    }];
}

#pragma mark - CCI

- (void)parseResultCCIForRnange:(NSRange)range {
    [self calculateCCIAtRange:range];
}

- (void)calculateCCIAtRange:(NSRange)range {
//    NSInteger cycleN = 14;
    [self.dataArray enumerateObjsAtRange:range ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
        CGFloat high = obj.tq_high;
        CGFloat low = obj.tq_low;
        CGFloat close = obj.tq_close;
        // 计算TP值
        CGFloat TP = (high + low + close) / 3.0;
        NSLog(@"TP is: %@", @(TP));
        // 计算MA (近N日收盘价的移动平均)
//        CGFloat sum = [self.dataModels calculateSum:idx length:cycleN evaluatedBlock:^CGFloat(id<TQKlineChartProtocol>  _Nonnull obj) {
//            return obj.tq_close;
//        }];
//        CGFloat MA = sum / cycleN;
        // 计算MD
        //        for (NSInteger j = 0 ; j < cycleN; j++) {
        //            //            YTSCFloat avetempDiff = fabs(queue_tp[j] - (tpSum / days))
        //            avetempDiffSum += fabs(queue_tp[j] - tpMA);
        //        }
        //        CGFloat MD = 近N日（MA－收盘价）的累计之和÷N
        
    }];
}

#pragma mark - VOL

- (void)parseResultVOLForRnange:(NSRange)range {
    [self calculateVOLAtRange:range];
}

- (void)calculateVOLAtRange:(NSRange)range {
    [self.dataArray enumerateObjsAtRange:range ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
        TQStockCacheModel *currentModel = [self.cacheManager cacheObjectAtIndex:idx];
        currentModel.VOLValue = obj.tq_volume;
        currentModel.openValue = obj.tq_open;
        currentModel.closeValue = obj.tq_close;
    }];
}

#pragma mark - MACD

/** 计算MACD */
- (void)parseResultMACDForRnange:(NSRange)range {
    // 起始下标(使计算从首位开始)
    NSUInteger startIndex = self.cacheManager.MACDComputedRange.location > 0 ? 0: self.cacheManager.MACDComputedRange.length;
    // 结束下标
     NSUInteger endIndex = NSMaxRange(range);
    if (startIndex < endIndex) {
        NSRange usingRange = NSMakeRange(startIndex, endIndex);
        [self calculateMACDAtRange:usingRange];
    }
}

- (void)calculateMACDAtRange:(NSRange)range {
    range = [self checkRange:range method:_cmd];
    if (!range.length) return;
    NSInteger startIdx = range.location;
    NSInteger endIdx = NSMaxRange(range);
    
    TQStockCacheModel *prevCache = nil;
    TQStockCacheModel *cache = nil;
    
    if (startIdx == 0) { // 初始值
        CGFloat close = self.dataArray[startIdx].tq_closeYesterday;
        cache = [self.cacheManager cacheObjectAtIndex:startIdx];
        cache.EMAFastValue = close;
        cache.EMASlowValue = close;
        cache.DIFValue = 0;
        cache.DEAValue = 0;
        cache.MACDValue = 0;
        prevCache = cache;
        startIdx++;
    } else {
        prevCache = [self.cacheManager cacheObjectAtIndex:startIdx - 1];
    }
    
    for (NSInteger idx = startIdx; idx < endIdx; idx++) {
        cache = [self.cacheManager cacheObjectAtIndex:idx];
        prevCache = [self.cacheManager cacheObjectAtIndex:idx -1];
        CGFloat close = self.dataArray[idx].tq_close;
        // 计算移动平均值(快速/慢速)
        CGFloat fastEMA = close * 2.f / (INdC.EMA_SHORT + 1.f) + prevCache.EMAFastValue * (INdC.EMA_SHORT - 1.f) / (INdC.EMA_SHORT + 1.f);
        CGFloat slowEMA = close * 2.f / (INdC.EMA_LONG + 1.f) + prevCache.EMASlowValue * (INdC.EMA_LONG - 1.f) / (INdC.EMA_LONG + 1.f);
        // 计算离差值(DIF)
        CGFloat DIF = fastEMA - slowEMA;
        // 计算DIF的n日EMA
        CGFloat DEA = prevCache.DEAValue * (INdC.DIF_CYCLE - 1.f) / (INdC.DIF_CYCLE + 1.f) + DIF * 2.f / (INdC.DIF_CYCLE + 1.f);
        // 计算MACD
        CGFloat MACD = (DIF - DEA) * 2.f;
        // 赋值结果
        cache.EMAFastValue = fastEMA;
        cache.EMASlowValue = slowEMA;
        cache.DIFValue = DIF;
        cache.DEAValue = DEA;
        cache.MACDValue = MACD;
    }
    self.cacheManager.MACDComputedRange = range;
}

#pragma mark - KDJ

/** 计算KDJ */
- (void)parseResultKDJForRnange:(NSRange)range {
    [self calculateKDJAtRange:range];
}

- (void)calculateKDJAtRange:(NSRange)range {
    range = [self checkRange:range method:_cmd];
    if (!range.length) return;
    NSInteger startIdx = range.location;
    NSInteger endIdx = NSMaxRange(range);
    
    TQStockCacheModel *prevCache = nil;
    TQStockCacheModel *cache = nil;
    
    if (startIdx == 0) {
        cache = [self.cacheManager cacheObjectAtIndex:startIdx];
        cache.KValue = 50.f;
        cache.DValue = 50.f;
        cache.JValue = 50.f;
        startIdx++;
    } else {
        prevCache = [self.cacheManager cacheObjectAtIndex:startIdx - 1];
    }
    
    for (NSInteger idx = startIdx; idx < endIdx; idx++) {
        cache = [self.cacheManager cacheObjectAtIndex:idx];
        prevCache = [self.cacheManager cacheObjectAtIndex:idx - 1];
        
        CGFloat close = self.dataArray[idx].tq_close;
        // 计算n日内的最高价及最低价
        CGPeakValue peakValue = [self calculateHnlnAtIdx:idx numberOfCycles:INdC.KDJ_CYELE];
        CGFloat lowN = peakValue.min;
        CGFloat highN = peakValue.max;
        // 计算当日RSV
        CGFloat RSV = CG_FloatIsZero(highN - lowN) ? 0.0 : ((close - lowN) / (highN - lowN) * 100.0);
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
    self.cacheManager.KDJComputedRange = range;
}

@end
