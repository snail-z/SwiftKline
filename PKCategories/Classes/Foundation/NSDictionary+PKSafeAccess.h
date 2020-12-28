//
//  NSDictionary+PKSafeAccess.h
//  PKCategories
//
//  Created by zhanghao on 2018/10/25.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary<__covariant KeyType, __covariant ObjectType> (PKSafeAccess)

- (BOOL)pk_containsKey:(NSString *)aKey;

/**
 *  传入Key不存在时，返回nil
 *
 *  @return object或nil
 */
- (nullable ObjectType)pk_objectForKey:(KeyType)aKey;

/**
 *  当传入Key为nil或者取出的object为nil时，则返回默认值defObj
 */
- (ObjectType)pk_objectForKey:(KeyType)aKey defaultObj:(id)defObj;;

- (nullable NSArray *)pk_arrayForKey:(KeyType)aKey;

- (nullable NSDictionary *)pk_dictionaryForKey:(KeyType)aKey;

- (nullable NSString *)pk_stringForKey:(KeyType)aKey;

- (nullable NSNumber *)pk_numberForKey:(KeyType)aKey;

- (BOOL)pk_boolForKey:(KeyType)aKey;

- (NSInteger)pk_integerForKey:(KeyType)aKey;

- (CGFloat)pk_CGFloatForKey:(KeyType)aKey;

- (CGPoint)pk_CGPointForKey:(KeyType)aKey;

- (CGSize)pk_CGSizeForKey:(KeyType)aKey;

- (CGRect)pk_CGRectForKey:(KeyType)aKey;

@end

@interface NSMutableDictionary<KeyType, ObjectType> (PKSafeAccess)

/** 避免存入Object为空值时crach (传入Object不存在时，忽略存储操作) */
- (void)pk_setObject:(ObjectType)anObject forKey:(KeyType <NSCopying>)aKey;

- (void)pk_setCGPoint:(CGPoint)p forKey:(KeyType <NSCopying>)aKey;

- (void)pk_setCGSize:(CGSize)s forKey:(KeyType <NSCopying>)aKey;

- (void)pk_setCGRect:(CGRect)r forKey:(KeyType <NSCopying>)aKey;

@end

NS_ASSUME_NONNULL_END
