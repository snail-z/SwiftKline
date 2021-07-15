//
//  NSString+zhExtend.h
//  zhCategoryKit
//
//  Created by zhanghao on 2016/12/7.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (zhExtend)

/** 检查字符串是否不为空 (nil, @"", @"  ", @"\n" 将返回NO) */
- (BOOL)zh_isNotEmpty;

/** 从字符串的起始处提取到某个位置结束 (nil, @"", @"  ", @"\n" 将返回@"") */
- (NSString *)zh_substringToIndex:(NSUInteger)to;

/** 提取字符串从某个位置开始到末尾结束 (nil, @"", @"  ", @"\n" 将返回@"") */
- (NSString *)zh_substringFromIndex:(NSUInteger)from;

/** 删掉字符串中的首字符，并返回一个新字符串 */
- (NSString *)zh_deleteFirstCharacter;

/** 删掉字符串中的末尾字符，并返回一个新字符串 */
- (NSString *)zh_deleteLastCharacter;

/** 将常见的HTML转成NSString */
- (NSString *)zh_stringByEscapingHTML;

/** 去除字符串中的首尾空白符 */
- (NSString *)zh_trimmingWhitespace;

/** 去除换行符和首尾空白符 */
- (NSString *)zh_trimmingNewlineWhitespace;

/** 去除字符串中的所有空白符 */
- (NSString *)zh_trimmingAllWhitespace;

/** 格式化字符串，去除多余的空白符 */
- (NSString *)zh_formattedTrimmingWhitespace;

/** 字符串版本号比较 (判断self版本号是否大于aString版本号，若大于返回YES，反之返回NO) */
- (BOOL)zh_greaterVersionCompare:(NSString *)aString;

/** 对URL中特殊字符转码 (常用于URL包含中文转码的解决办法) */
- (nullable NSString *)zh_unwontedCharacterEncoding;

/** JSON字符串转成NSDictionary */
- (nullable NSDictionary *)zh_JSONToDictionary;

/** JSON字符串转成NSArray */
- (nullable NSArray *)zh_JSONToArray;

@end

NS_ASSUME_NONNULL_END
