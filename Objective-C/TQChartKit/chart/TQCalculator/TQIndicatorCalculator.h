//
//  TQIndicatorCalculator.h
//  TQChartKit
//
//  Created by zhanghao on 2018/8/31.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TQStockChartProtocol.h"
#import "TQStockCacheManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface TQIndicatorCalculator : NSObject

/** 计算结果的缓存管理者 */
@property (nonatomic, strong, readonly) TQStockCacheManager *cacheManager;

/** 原始数据源 */
@property (nonatomic, strong) NSArray<id<TQKlineChartProtocol>> *dataArray;

/** 根据range计算不同类型的指标 */
- (void)parseResultRange:(NSRange)range byIndicatorIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
