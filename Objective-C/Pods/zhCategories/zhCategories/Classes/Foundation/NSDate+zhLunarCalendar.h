//
//  NSDate+zhLunarCalendar.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/15.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (zhLunarCalendar)

/** 农历年份名称 */
+ (NSArray<NSString *> *)zh_chineseYearsArray;

/** 农历月份名称 */
+ (NSArray<NSString *> *)zh_chineseMonthsArray;

/** 农历几号名称 */
+ (NSArray<NSString *> *)zh_chineseDaysArray;

/** 将date转为农历日期 (如：2017-12-15 => 丁酉十月廿八) */
- (nullable NSString *)zh_lunarYMDTimestring; // 年月日
- (nullable NSString *)zh_lunarMDTimestring; // 月日

@end

NS_ASSUME_NONNULL_END
