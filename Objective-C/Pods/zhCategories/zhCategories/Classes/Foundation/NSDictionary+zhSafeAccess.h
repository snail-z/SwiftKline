//
//  NSDictionary+zhSafeAccess.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/12.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (zhSafeAccess)

- (BOOL)zh_hasKey:(NSString *)aKey;

- (nullable id)zh_objectForKey:(id)aKey;

- (nullable NSArray *)zh_arrayForKey:(id)aKey;

- (nullable NSDictionary *)zh_dictionaryForKey:(id)aKey;

- (nullable NSString *)zh_stringForKey:(id)aKey;

- (nullable NSNumber *)zh_numberForKey:(id)aKey;

- (int)zh_intValueForKey:(id)aKey;

- (double)zh_doubleValueForKey:(id)aKey;

- (int64_t)zh_longLongValueForKey: (id)aKey;

- (BOOL)zh_boolValueForKey:(id)aKey;

- (NSInteger)zh_integerValueForKey:(id)aKey;

- (CGFloat)zh_CGFloatValueForKey:(id)aKey;

- (CGPoint)zh_CGPointForKey:(id)aKey;

- (CGSize)zh_CGSizeForKey:(id)aKey;

- (CGRect)zh_CGRectForKey:(id)aKey;

@end


@interface NSMutableDictionary(zhSafeAccess)

- (void)zh_setObject:(id)anObject forKey:(id<NSCopying>)aKey;

- (void)zh_setCGPoint:(CGPoint)p forKey:(id<NSCopying>)aKey;

- (void)zh_setCGSize:(CGSize)s forKey:(id<NSCopying>)aKey;

- (void)zh_setCGRect:(CGRect)r forKey:(id<NSCopying>)aKey;

@end

NS_ASSUME_NONNULL_END
