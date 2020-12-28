//
//  NSDate+TJPickerDate.h
//  TJCategories_Example
//
//  Created by zhanghao on 2020/12/23.
//  Copyright © 2020 gren-beans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJPickerDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (TJPickerDate)

/// 获取所有年份 (1970年~2099年)
+ (NSArray<id<TJPickerDataSource>> *)tj_allYears;

/// 截止到当前的所有年份 (1970年~今年)
+ (NSArray<id<TJPickerDataSource>> *)tj_tillNowYears;

/// 指定区间内所有年份 (a年~b年)
+ (NSArray<id<TJPickerDataSource>> *)tj_yearsFrom:(NSInteger)a toYear:(NSInteger)b;

/// 获取所有月份 (1月~12月)
+ (NSArray<id<TJPickerDataSource>> *)tj_months;

/// 获取某年份中某月所有天数
+ (NSArray<id<TJPickerDataSource>> *)tj_daysOfDate:(NSDate *)date;

/// 获取年月日数据
+ (NSArray<NSArray<id<TJPickerDataSource>> *> *)tj_yearsMonthsAndDays;

@end

NS_ASSUME_NONNULL_END
