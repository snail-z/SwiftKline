//
//  TQStockCacheManager.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/30.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQStockCacheManager.h"

@interface TQStockCacheManager ()

@property (nonatomic, strong) NSMutableArray<TQStockCacheModel *> *cacheModels;

@end

@implementation TQStockCacheManager

+ (instancetype)cacheManagerWithCount:(NSInteger)count {
    return [[self alloc] initWithCacheCount:count];
}

- (instancetype)initWithCacheCount:(NSInteger)count {
    if (self = [super init]) {
        while (count > 0) {
            TQStockCacheModel *model = [TQStockCacheModel new];
            [self.cacheModels addObject:model];
            count--;
        }
    }
    return self;
}

- (NSMutableArray<TQStockCacheModel *> *)cacheModels {
    if (!_cacheModels) {
        _cacheModels = [NSMutableArray array];
    }
    return _cacheModels;
}

- (NSArray<TQStockCacheModel *> *)allCache {
    return self.cacheModels;
}

- (TQStockCacheModel *)cacheObjectAtIndex:(NSInteger)index {
    TQStockCacheModel *model = nil;
    if (index < self.cacheModels.count) {
        model = self.cacheModels[index];
        return model;
    }
    model = [TQStockCacheModel new];
    [self.cacheModels addObject:model];
    return model;
}

- (void)addCacheObject:(TQStockCacheModel *)model {
    [self.cacheModels addObject:model];
}

- (void)addObjectsWithCacheCount:(NSInteger)count {
    for (NSInteger i = 0; i < count; i++) {
        TQStockCacheModel *model = [TQStockCacheModel new];
        [self.cacheModels addObject:model];
    }
}

- (void)insertCacheObject:(TQStockCacheModel *)model atIndex:(NSInteger)index {
    if (index > self.cacheModels.count) return;
    [self.cacheModels insertObject:model atIndex:index];
}

- (void)insertObjectsWithCacheCount:(NSInteger)count atIndex:(NSInteger)index {
    if (index > self.cacheModels.count) return;
    NSUInteger idx = index;
    for (NSUInteger i = 0; i < count; i++) {
        TQStockCacheModel *model = [TQStockCacheModel new];
        [self.cacheModels insertObject:model atIndex:idx++];
    }
}

- (void)removeObjectAtIndex:(NSInteger)index {
    [self.cacheModels removeObjectAtIndex:index];
}

- (void)clearCache {
    [self.cacheModels removeAllObjects];
}

@end
