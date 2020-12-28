//
//  NSArray+PKSafeAccess.h
//  PKCategories
//
//  Created by zhanghao on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (PKSafeAccess)

/**
 *  根据数组下标获取对象，避免数组越界导致的crach，若传入index大于数组个数时，则返回nil
 *
 *  @param index 下标
 *
 *  @return 对象或nil
 */
- (nullable ObjectType)pk_objectAtIndex:(NSUInteger)index;

/** 同上方法，根据下标获取值为nil时，返回默认值defObj */
- (ObjectType)pk_objectAtIndex:(NSUInteger)index defaultObj:(id)defObj;

/**
 *  根据对象获取在数组内的下标，避免访问不存在对象时导致的crach，若对象不存在返回0
 *
 *  @param anObject 对象
 *
 *  @return 下标
 */
- (NSUInteger)pk_indexOfObject:(ObjectType)anObject;

- (nullable NSString *)pk_stringAtIndex:(NSInteger)index;

- (nullable NSNumber *)pk_numberAtIndex:(NSUInteger)index;

- (nullable NSArray *)pk_arrayAtIndex:(NSUInteger)index;

- (nullable NSDictionary *)pk_dictionaryAtIndex:(NSUInteger)index;

- (NSInteger)pk_integerAtIndex:(NSUInteger)index;

- (BOOL)pk_boolAtIndex:(NSUInteger)index;

- (CGFloat)pk_CGFloatAtIndex:(NSUInteger)index;

- (CGPoint)pk_CGPointAtIndex:(NSUInteger)index;

- (CGSize)pk_CGSizeAtIndex:(NSUInteger)index;

- (CGRect)pk_CGRectAtIndex:(NSUInteger)index;

@end


@interface NSMutableArray<ObjectType> (PKSafeAccess)

-(void)pk_addCGPoint:(CGPoint)p;

-(void)pk_addCGSize:(CGSize)s;

-(void)pk_addCGRect:(CGRect)r;

- (void)pk_addObject:(ObjectType)anObject;

/** 添加元素到数组中，当anObject为nil时则添加备选值aObj */
- (void)pk_addObject:(ObjectType)anObject defaultObj:(id)aObj;

/** 根据下标插入一个元素到当前数组中 */
- (void)pk_insertObject:(ObjectType)anObject atIndex:(NSUInteger)index;

/**
 *  根据下标插入另一个数组中的所有对象到当前数组
 *
 *  @param objects 数组对象
 *  @param index   指定下标
 *
 *  (index等于self.count时，添加在其末尾)
 */
- (void)pk_insertObjects:(NSArray *)objects atIndex:(NSUInteger)index;

/** 将某一数组中的元素依次添加到当前数组中 */
- (void)pk_appendObjects:(NSArray *)objects;

/** 根据下标删除数组中对应的元素 */
- (void)pk_removeObjectAtIndex:(NSUInteger)index;

/** 根据范围删除数组中对应的元素 */
- (void)pk_removeObjectsInRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
