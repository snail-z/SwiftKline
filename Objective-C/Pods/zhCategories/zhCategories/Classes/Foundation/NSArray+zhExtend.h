//
//  NSArray+zhExtend.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/12.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (zhExtend)

/** 提取数组中的前n个元素并返回新数组 */
- (nullable NSArray *)zh_subarrayWithFront:(NSInteger)n;

/** 提取数组中的最后n个元素并返回新数组 */
- (nullable NSArray *)zh_subarrayWithBehind:(NSInteger)n;

/** 返回一个位于随机索引值的对象，数组为空返回nil */
- (nullable id)zh_randomObject;

@end

@interface NSMutableArray(zhExtend)

- (void)zh_removeFirstObject;
- (void)zh_removeLastObject;

/** 返回数组中的首元素，并将其从原数组中删除 */
- (nullable id)zh_popFirstObject;

/** 返回数组中的末尾元素，并将其从原数组中删除 */
- (nullable id)zh_popLastObject;

/**
 将另一个数组中的所有元素插入到当前数组的指定索引处
 example:
 array1 = @[@"a", @"b"];
 slef = @[@"A", @"B", @"C"].mutableCopy;
 [self zh_insertArray:array atIndex:2];
 结果为 @[@"A", @"B", @"a", @"b", @"C"]
 */
- (void)zh_insertArray:(NSArray *)array atIndex:(NSUInteger)index; // index等于self.count时，添加在其末尾

@end

NS_ASSUME_NONNULL_END
