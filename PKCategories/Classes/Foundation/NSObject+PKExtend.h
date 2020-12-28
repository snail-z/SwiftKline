//
//  NSObject+PKExtend.h
//  PKCategories
//
//  Created by zhanghao on 2018/10/27.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (PKExtend)

@property (nonatomic, strong, class, readonly) NSString *pk_className;
@property (nonatomic, strong, readonly, nullable) NSString *pk_className;

/** 获取当前实例方法列表 */
- (NSArray<NSString *> *)pk_listOfMethods;

/** 获取当前实例属性信息列表及对应的值 */
- (NSDictionary<NSString *, id> *)pk_listOfPropertyAttributes;

@end


@interface NSObject (PKAssociated)

/** A weak reference associated */
- (void)pk_setWeakAssociatedValue:(nullable id)value withKey:(void *)key;

/** Get weak associated value */
- (nullable id)pk_getWeakAssociatedValueForKey:(void *)key;

/** Association Policy - OBJC_ASSOCIATION_RETAIN_NONATOMIC */
- (void)pk_setAssociatedValue:(nullable id)value withKey:(void *)key;

/** Association Policy - OBJC_ASSOCIATION_ASSIGN */
- (void)pk_setAssociatedAssignValue:(nullable id)value withKey:(void *)key;

/** Association Policy - OBJC_ASSOCIATION_COPY_NONATOMIC */
- (void)pk_setCopyValue:(nullable id)value withKey:(SEL)key;

/** Get the associated value from `self`. */
- (nullable id)pk_getAssociatedValueForKey:(void *)key;

/** Remove all associated values. */
- (void)pk_removeAssociatedValues;

/** 为NSObject关联一个Object属性 */
@property (nonatomic, strong, nullable) id pk_associatedObject;

/** 为NSObject关联一个String属性 */
@property (nonatomic, strong, nullable) NSString *pk_associatedStringValue;

/** 为NSObject关联一个BOOL属性 */
@property (nonatomic, assign) BOOL pk_associatedBoolValue;

@end


@interface NSObject (PKSwizzle)

/**
*  @brief 交换两个实例方法的实现
*
*  @param originalSel 原始方法
*  @param swizzledSel 交换后的方法
*
*  @return 交换成功返回YES，反之为NO
*/
+ (BOOL)pk_swizzleInstanceMethod:(SEL)originalSel with:(SEL)swizzledSel;

/**
 *  @brief 交换两个静态方法的实现
 *
 *  @param originalSel 原始方法
 *  @param swizzledSel 交换后的方法
 *
 *  @return 交换成功返回YES，反之为NO
 */
+ (BOOL)pk_swizzleClassMethod:(SEL)originalSel with:(SEL)swizzledSel;

@end

NS_ASSUME_NONNULL_END
