//
//  NSDictionary+PKExtend.h
//  PKCategories
//
//  Created by zhanghao on 2018/10/25.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (PKExtend)

/**
 *  将字典按key进行排序，key必须为NSString类型 (排序方式：按key字母顺序排序，不区分大小写)
 *
 *  @return 返回包含字典中所有key的数组，或空数组或nil
 */
- (nullable NSArray *)pk_allKeysSorted;

/** 返回根据[-pk_allKeysSorted]方法排序后的keys，然后获取对应的values数组 */
- (nullable NSArray *)pk_allValuesSortedByKeys;

/**
 *  将字典转换成json字符串，json字符串显示一整行
 *  格式错误时返回nil
 *
 *  @return json格式的字符串或nil
 */
- (nullable NSString *)pk_JSONString;

/**
 *  将字典转换成json字符串，字符串以json格式化输出
 *  格式错误时返回nil
 *  NSJSONWritingPrettyPrinted的意思是将生成的json数据格式化输出，提高可读性，若不设置则输出的json字符串就是一整行
 *
 *  @return json格式的字符串或nil
 */
- (nullable NSString *)pk_JSONPrettyString;

/**
 * @brief 将Json格式字符串转字典
 *
 * @param jsonString JSON格式的字符串
 * @return 返回字典或nil
 */
+ (nullable NSDictionary *)pk_dictionaryWithJSONString:(NSString *)jsonString;

/** 将字典转换成URL参数字符串 */
- (NSString *)pk_convertToURLString;

@end

@interface NSMutableDictionary<KeyType, ObjectType> (PKExtend)

/** 根据Key返回一个对应的value对象，并将其从原字典中删除 */
- (nullable ObjectType)pk_popObjectForKey:(id)aKey;

/** 根据数组中的Keys返回一个对应的values数组，并将对应的Keys从原字典中删除 */
- (NSDictionary<KeyType, ObjectType> *)pk_popObjectsForKeys:(NSArray *)keys;

@end

NS_ASSUME_NONNULL_END
