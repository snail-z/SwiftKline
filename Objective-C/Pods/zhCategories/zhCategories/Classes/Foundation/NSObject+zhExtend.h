//
//  NSObject+zhExtend.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/6.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (zhExtend)

/** 获取当前类名 */
- (NSString *)zh_className;

/** 父类名 */
- (NSString *)zh_superClassName;

/** 获取当前实例属性及对应值的信息 */
- (NSDictionary *)zh_propertyListDictionary;

/** 获取当前实例方法列表 */
- (NSArray *)zh_methodListArray;

/** 转成NData */
- (nullable NSData *)zh_JSONData;

/** 转成JSON字符串 */
- (nullable NSString *)zh_JSONString;

@end

NS_ASSUME_NONNULL_END
