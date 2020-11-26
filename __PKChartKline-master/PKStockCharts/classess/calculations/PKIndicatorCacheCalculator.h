//
//  PKIndicatorCacheCalculator.h
//  PKChartKit
//
//  Created by zhanghao on 2017/12/26.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKIndicatorCacheItem.h"
#import "PKKLineChartProtocol.h"
#import "PKIndicatorIdentifier.h"

NS_ASSUME_NONNULL_BEGIN

@interface PKIndicatorCacheCalculator : NSObject

/** 清除所有缓存 */
- (void)clearAllCache;

/** 所有计算过的缓存数据 */
@property (nonatomic, copy, readonly) NSArray<PKIndicatorCacheItem *> *allCache;

/** 原始数据源 */
@property (nonatomic, copy, readonly) NSArray<id<PKKLineChartProtocol>> *dataList;

/** 初始化并赋值原始数据 */
+ (instancetype)managerWithDataList:(NSArray<id<PKKLineChartProtocol>> *)dataList;

/** 更新原始数据 */
- (void)updateCacheForDataList:(NSArray<id<PKKLineChartProtocol>> *)dataList;

/** 计算不同类型的指标数据 */
- (void)parseResultRange:(NSRange)range byIndicatorIdentifier:(PKIndicatorIdentifier)identifier;

@end

NS_ASSUME_NONNULL_END
