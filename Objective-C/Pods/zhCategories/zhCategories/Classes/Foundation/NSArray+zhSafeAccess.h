//
//  NSArray+zhSafeAccess.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/12.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (zhSafeAccess)

- (nullable id)zh_objectAtIndex:(NSUInteger)index;

- (nullable NSString *)zh_stringAtIndex:(NSInteger)index;

- (nullable NSNumber *)zh_numberAtIndex:(NSUInteger)index;

- (nullable NSArray *)zh_arrayAtIndex:(NSUInteger)index;

- (nullable NSDictionary *)zh_dictionaryAtIndex:(NSUInteger)index;

- (NSInteger)zh_integerAtIndex:(NSUInteger)index;

- (BOOL)zh_boolAtIndex:(NSUInteger)index;

- (int)zh_intAtIndex:(NSUInteger)index;

- (double)zh_doubleAtIndex:(NSUInteger)index;

- (int64_t)zh_longLongAtIndex:(NSUInteger)index;

- (CGFloat)zh_CGFloatAtIndex:(NSUInteger)index;

- (CGPoint)zh_CGPointAtIndex:(NSUInteger)index;

- (CGSize)zh_CGSizeAtIndex:(NSUInteger)index;

- (CGRect)zh_CGRectAtIndex:(NSUInteger)index;

- (NSUInteger)zh_indexOfObject:(id)anObject;

@end


@interface NSMutableArray(zhSafeAccess)

- (void)zh_addObject:(id)anObj;

/** 当anObj为nil/NSNull/<null>时，则添加def */
- (void)zh_addObject:(id)anObj defaults:(NSString *)def;

- (void)zh_addCGPoint:(CGPoint)p;

- (void)zh_addCGSize:(CGSize)s;

- (void)zh_addRect:(CGRect)r;

- (void)zh_addObjectsFromArray:(NSArray *)otherArray;

@end

NS_ASSUME_NONNULL_END
