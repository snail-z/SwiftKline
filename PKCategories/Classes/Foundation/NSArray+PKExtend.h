//
//  NSArray+PKExtend.h
//  PKCategories
//
//  Created by zhanghao on 2018/10/25.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (PKExtend)

/** 判断索引在数组中是否有效 */
- (BOOL)pk_containsIndex:(NSInteger)index;

/** 获取一个位于随机索引值的对象 */
- (nullable ObjectType)pk_randomObject;

/** 获取数组中前count个元素(返回新数组) */
- (nullable NSArray *)pk_subarrayWithFrontCount:(NSUInteger)count;

/** 获取数组中后count个元素(返回新数组) */
- (nullable NSArray *)pk_subarrayWithBackCount:(NSUInteger)count;

/** 将数组分成多个子数组，每组有group个元素，不足group个的单独一组 (group > 0) */
- (nonnull NSArray<NSArray *> *)pk_subarraysSeparated:(NSInteger)group;

/** 获取anObject的后一个元素 (若anObject是末尾元素，则返回首元素) */
- (nullable ObjectType)pk_objectGreaterThanObject:(ObjectType)anObject;

/** 获取anObject的前一个元素 (若anObject是首元素，则返回末尾元素) */
- (nullable ObjectType)pk_objectLessThanObject:(ObjectType)anObject;

/** 获取anObject的后一个元素 (若anObject是末尾元素，则返回末尾元素) */
- (nullable ObjectType)pk_objectGreaterThanOrEqualToObject:(ObjectType)anObject;

/** 获取anObject的前一个元素 (若anObject是首元素，则返回首元素) */
- (nullable ObjectType)pk_objectLessThanOrEqualToObject:(ObjectType)anObject;

/** 映射操作，可以对数组中的每一个元素做一次处理，返回处理后的数据 */
- (NSArray<id> *)pk_map:(id (NS_NOESCAPE ^)(ObjectType obj))block;

/** 过滤操作，可以对数组中的元素按照某种规则进行一次过滤 */
- (NSArray<ObjectType> *)pk_filer:(BOOL (NS_NOESCAPE ^)(ObjectType obj))block;

/**
 *  将数组转换成json字符串，json字符串显示一整行
 *  格式错误时返回nil
 *
 *  @return json格式的字符串或nil
 */
- (nullable NSString *)pk_JSONString;

/**
 *  将数组转换成json字符串，字符串以json格式化输出
 *  格式错误时返回nil
 *  NSJSONWritingPrettyPrinted的意思是将生成的json数据格式化输出，提高可读性，若不设置则输出的json字符串就是一整行
 *
 *  @return json格式的字符串或nil
 */
- (nullable NSString *)pk_JSONPrettyString;

/**
 * @brief 将Json格式字符串转数组
 *
 * @param jsonString JSON格式的字符串
 * @return 返回数组或nil
 */
+ (nullable NSArray *)pk_arrayWithJSONString:(NSString *)jsonString;

@end


@interface NSMutableArray<ObjectType> (PKExtend)

/** 移除数组中第一个对象，若数组为空，则忽略此操作 */
- (void)pk_removeFirstObject;

/** 移除数组中最后一个对象，若数组为空，则忽略此操作 */
- (void)pk_removeLastObject;

/** 返回数组中的第一个对象，并将其从原数组中删除 */
- (nullable ObjectType)pk_popFirstObject;

/** 返回数组中的最后一个对象，并将其从原数组中删除 */
- (nullable ObjectType)pk_popLastObject;

/** 随机打乱数组 */
- (void)pk_shuffleAllObjects;

@end

NS_ASSUME_NONNULL_END
