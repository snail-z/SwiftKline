//
//  NSNumber+PKExtend.h
//  PKCategories
//
//  Created by zhanghao on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (PKExtend)

/**
*  @brief 根据字符串创建并返回一个NSNumber对象，解析出错则返回nil
*
*  @param string 字符串 (有效格式: @"12", @"12.345", @" -0xFF", @" .23e99 "...)
*
*  @return 返回NSNumber对象或nil
*/
+ (nullable NSNumber *)pk_numberWithString:(NSString *)string;

/**
 *  @brief 将浮点数四舍五入，自定义小数点后保留的位数 (例如保留小数点后三位的结果 0.1256 = 0.126)
 *
 *  @param number 浮点数对象
 *  @param place 小数点后保留的位数
 *
 *  @return 返回NSString字符串
 */
+ (NSString *)pk_stringWithDigits:(NSNumber *)number keepPlaces:(short)place;

/** 将浮点数四舍五入，保留小数点后两位 (例如 0.1256 = 0.13) */
+ (NSString *)pk_stringWithDoubleDigits:(NSNumber *)number;

/**
 *  @brief 直接取浮点数，不四舍五入 (例如保留小数点后三位的结果 0.1256 = 0.125)
 *
 *  @param number 浮点数对象
 *  @param place 小数点后的保留的位数
 *
 *  @return 返回NSString字符串
 */
+ (NSString *)pk_stringWithPlainDigits:(NSNumber *)number keepPlaces:(short)place;

/** 直接取浮点数，保留小数点后两位 (例如 0.1256 = 0.12) */
+ (NSString *)pk_stringWithPlainDoubleDigits:(NSNumber *)number;

/**
 *  @brief NSNumber转百分比字符串，保留四舍五入后的两位小数
 *
 *  @e.g.  0.125 = 12.50%
 *         0.12567 = 12.57%
 *
 *  @return 返回百分比字符串
 */
+ (NSString *)pk_percentStringWithDoubleDigits:(NSNumber *)number;

/**
 *  @brief NSNumber转百分比字符串，直接取两位小数，不四舍五入
 *
 *  @e.g.  0.125 = 12.50%
 *         0.12567 = 12.56%
 *
 *  @return 返回百分比字符串
 */
+ (NSString *)pk_percentStringWithPlainDoubleDigits:(NSNumber *)number;

/**
 *  @brief NSNumber转百分比字符串，四舍五入但不保留小数
 *
 *  @e.g.  0.125 = 13%
 *         0.12567 = 13%
 *
 *  @return 返回百分比字符串
 */
+ (NSString *)pk_percentStringWithTidyDigits:(NSNumber *)number;

/** 百分比字符串转NSNumber，例如1.23% = 0.0123 */
+ (nullable NSNumber *)pk_numberWithPercentString:(NSString *)aString;

/** NSNumber转货币字符串，例如10000 = ￥10,000.00 */
+ (NSString *)pk_currencyStringWithDigits:(NSNumber *)number;

/**
 *  @brief NSNumber转万亿字符串，自定义小数点后保留的位数
 *
 *  @e.g.  125601 = 12.56万
 *         125651 = 12.57万
 *         1256010101 = 12.56亿
 *         12560101015001 = 12.56万亿
 *
 *  @return 返回万或亿字符串
 */
+ (NSString *)pk_trillionStringWithDigits:(NSNumber *)number keepPlaces:(short)place;

/** NSNumber转万亿字符串，保留四舍五入后的两位小数 */
+ (NSString *)pk_trillionStringWithDoubleDigits:(NSNumber *)number;

/** 判断浮点数对象是否为0值 (最小误差为1e-6) */
- (BOOL)pk_isEqualZero;

/**
 *  @brief 判断浮点数对象是否为0值
 *
 *  @param minimumError 设置最小误差 (小于最小误差即视为0值)
 *
 *  @return 小于最小误差minimumError返回YES，反之返回NO
 */
- (BOOL)pk_isEqualZeroWithMinimumError:(CGFloat)minimumError;

/** 判断字符串是否为浮点数(包括正数负数和零) */
- (BOOL)isFloatNumber:(NSString *)string;

/** 判断字符串是否为整形(包括正整数负整数和零) */
- (BOOL)isIntegerNumber:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
