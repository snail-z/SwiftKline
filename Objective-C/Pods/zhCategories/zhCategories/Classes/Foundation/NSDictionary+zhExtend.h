//
//  NSDictionary+zhExtend.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/12.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (zhExtend)

/** 将字典中的key进行排序 (排序方式：按字母顺序排序，不区分大小写) */
- (NSArray *)zh_allKeysSorted; // The keys should be NSString

/** 根据keys排序后得到的values */
- (NSArray *)zh_allValuesSortedByKeys;

/** 将NSDictionary转换成URL参数字符串 */
- (NSString *)zh_convertToURLString;

@end
