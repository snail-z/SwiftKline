//
//  TQStockCacheManager.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/30.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TQStockCacheModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TQStockCacheManager : NSObject

/** 创建一个缓存管理者，并生成count个模型到缓存容器allCache */
+ (instancetype)cacheManagerWithCount:(NSInteger)count;

/** 根据索引取缓存模型 */
- (TQStockCacheModel *)cacheObjectAtIndex:(NSInteger)index;

/** 在allCache末尾添加一个缓存模型 */
- (void)addCacheObject:(TQStockCacheModel *)model;

/** 在allCache末尾依次添加缓存数组中的count个模型 */
- (void)addObjectsWithCacheCount:(NSInteger)count;

/** 插入一个缓存模型到allCache */
- (void)insertCacheObject:(TQStockCacheModel *)model atIndex:(NSInteger)index;

/** 依次插入缓存数组中的count个模型到allCache */
- (void)insertObjectsWithCacheCount:(NSInteger)count atIndex:(NSInteger)index;

/** 根据index删除指定缓存模型 */
- (void)removeObjectAtIndex:(NSInteger)index;

/** 清除所有缓存 */
- (void)clearCache;

/** 所有计算过的缓存模型 */
@property (nonatomic, copy, readonly) NSArray<TQStockCacheModel *> *allCache;

/** 已计算的数据范围 */
@property (nonatomic, assign) NSRange MACDComputedRange;
@property (nonatomic, assign) NSRange KDJComputedRange;
@property (nonatomic, assign) NSRange RSIComputedRange;
@property (nonatomic, assign) NSRange OBVComputedRange;
@property (nonatomic, assign) NSRange PSYComputedRange;
@property (nonatomic, assign) NSRange VRComputedRange;
@property (nonatomic, assign) NSRange CRComputedRange;
@property (nonatomic, assign) NSRange BOLLComputedRange;
@property (nonatomic, assign) NSRange BIASComputedRange;
@property (nonatomic, assign) NSRange MAComputedRange;

@end

NS_ASSUME_NONNULL_END
