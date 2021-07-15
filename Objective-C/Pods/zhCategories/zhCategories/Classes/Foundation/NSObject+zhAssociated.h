//
//  NSObject+zhAssociated.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/13.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (zhAssociated)

/// Association Policy - OBJC_ASSOCIATION_RETAIN_NONATOMIC
- (void)zh_setAssociatedValue:(nullable id)value withKey:(void *)key;

/// Association Policy - OBJC_ASSOCIATION_ASSIGN
- (void)zh_setAssociatedWeakValue:(nullable id)value withKey:(void *)key;

/// Association Policy - OBJC_ASSOCIATION_COPY_NONATOMIC
- (void)zh_setCopyValue:(nullable id)value withKey:(SEL)key;

/// Get the associated value from `self`.
- (nullable id)zh_getAssociatedValueForKey:(void *)key;

/// Remove all associated values.
- (void)zh_removeAssociatedValues;

/// 为NSObject关联一个obj属性
@property (nonatomic, strong, nullable) id zh_associatedObj;

@end

NS_ASSUME_NONNULL_END
