//
//  NSSet+PKExtend.h
//  PKCategories
//
//  Created by zhanghao on 2019/4/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSSet<ObjectType> (PKExtend)

/**
 *  取并集，保留两个集合中identified不重复的所有元素
 *  block块中用于返回对象的唯一标识符
 *
 *  @return 返回新集合
 */
- (NSSet<ObjectType> *)pk_unionSet:(NSSet *)set
                        identified:(NSString* (NS_NOESCAPE ^)(ObjectType obj))block;

/** 取交集，保留两个集合中相同identified的元素，返回新集合 */
- (NSSet<ObjectType> *)pk_intersectSet:(NSSet *)set
                            identified:(NSString* (NS_NOESCAPE ^)(ObjectType obj))block;

/** 取差集，去掉两个集合中相同identified的元素，返回新集合 */
- (NSSet<ObjectType> *)pk_minusSet:(NSSet *)set
                        identified:(NSString* (NS_NOESCAPE ^)(ObjectType obj))block;

@end

NS_ASSUME_NONNULL_END
