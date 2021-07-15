//
//  NSDate+zhExtend.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/14.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (zhExtend)

#pragma mark - 获取当前的时间☟

@property (nonatomic, assign, readonly) NSInteger zh_year;
@property (nonatomic, assign, readonly) NSInteger zh_month; // (1~12)
@property (nonatomic, assign, readonly) NSInteger zh_day; // (1~31)
@property (nonatomic, assign, readonly) NSInteger zh_hour; // (0~23)
@property (nonatomic, assign, readonly) NSInteger zh_minute; // (0~59)
@property (nonatomic, assign, readonly) NSInteger zh_second; // (0~59)
@property (nonatomic, assign, readonly) NSInteger zh_nanosecond;

/** Weekday component (1~7, first day is based on user setting) */
@property (nonatomic, assign, readonly) NSInteger zh_weekday;

@property (nonatomic, assign, readonly) NSInteger zh_weekdayOrdinal;

/** WeekOfMonth component (1~5) */
@property (nonatomic, assign, readonly) NSInteger zh_weekOfMonth;

/** WeekOfYear component (1~53) */
@property (nonatomic, assign, readonly) NSInteger zh_weekOfYear;
@property (nonatomic, assign, readonly) NSInteger zh_yearForWeekOfYear;
@property (nonatomic, assign, readonly) NSInteger zh_quarter;

@property (nonatomic, assign, readonly) BOOL zh_isLeapMonth;
@property (nonatomic, assign, readonly) BOOL zh_isLeapYear;

@property (nonatomic, assign, readonly) BOOL zh_isToday;
@property (nonatomic, assign, readonly) BOOL zh_isYesterday;

/** 是否小于当前时间 (是否是过去时间) */
@property (nonatomic, assign, readonly) BOOL zh_isInPast;
/** 是否大于当前时间 (是否是未来时间) */
@property (nonatomic, assign, readonly) BOOL zh_isInFuture;


/**
 获取星期几 (名称)
 
 @return Return weekday as a localized string
 [1 - Sunday]
 [2 - Monday]
 [3 - Tuerday]
 [4 - Wednesday]
 [5 - Thursday]
 [6 - Friday]
 [7 - Saturday]
 */
/** 星期几的形式 (如：星期一) */
+ (NSString *)zh_dayFromWeekday:(NSDate *)date;
/** 周几的形式 (如：周一) */
+ (NSString *)zh_dayFromWeekday2:(NSDate *)date;
/** 英文的形式 (如：Monday) */
+ (NSString *)zh_dayFromWeekdayEN:(NSDate *)date;
/** 星期几的形式 */
- (NSString *)zh_dayFromWeekday;
/** 周几的形式 */
- (NSString *)zh_dayFromWeekday2;
/** 英文的形式 */
- (NSString *)zh_dayFromWeekdayEN;


/** Returns the format "yyyy-MM-dd" */
+ (NSString *)zh_ymdFormat;
/** Returns the format "dd/MM/yyyy" */
+ (NSString *)zh_dmyFormat;
/** Returns the format "MM/yyyy" */
+ (NSString *)zh_myFormat;
/** Returns the format "HH:mm:ss" */
+ (NSString *)zh_hmsFormat;
/** Returns the format "yyyy-MM-dd HH:mm:ss" */
+ (NSString *)zh_ymdHmsFormat;


/**
 获取未来的日期时间
 如：获取2天后的时间 [date zh_backward:2 unitType:NSCalendarUnitDay];
 */
+ (nullable NSDate *)zh_backward:(NSInteger)backwardN unitType:(NSCalendarUnit)unit;

/**
 获取之前的日期时间
 如：获取2天前的时间 [date zh_forward:2 unitType:NSCalendarUnitDay];
 */
+ (nullable NSDate *)zh_forward:(NSInteger)forwardN unitType:(NSCalendarUnit)unit;


/** 获取当前系统时间的时间戳 (北京时间) */
+ (NSInteger)zh_getNowTimestampWithDateFormat:(NSString *)dateFormat;

/** 获取当前时间戳字符串 */
+ (NSString *)zh_getCurrentTimestampString;

/**
 将时间戳转换成时间字符串 (Timestamp => Timestring) (北京时间)
 Example:
 NSInteger timestamp = 1513303403;
 NSString *timestring = [NSDate zh_timestringFromTimestamp:timestamp dateFormat:@"yyyy-MM-dd"];
 */
+ (nullable NSString *)zh_timestringFromTimestamp:(NSInteger)timestamp dateFormat:(NSString *)dateFormat;

/**
 将时间字符串转换成时间戳 (Timestring => Timestamp) (北京时间)
 Example:
 NSString *timestring = @"2017-12-15";
 NSInteger timestamp = [NSDate zh_timestampFromTimestring:timestring dateFormat:@"yyyy-MM-dd"];
 */
+ (NSInteger)zh_timestampFromTimestring:(NSString *)timeString dateFormat:(NSString *)dateFormat;

/**
 将时间字符串转换成date (Timestring => NSDate) (北京时间)
 Example:
 NSString *timestring = @"2017-09-15";
 NSDate *date = [NSDate zh_dateFromTimestring:timestring dateFormat:@"yyyy-MM-dd"];
 */
+ (nullable NSDate *)zh_dateFromTimestring:(NSString *)timestring dateFormat:(NSString *)dateFormat;

/** 将时间字符串转换成date (可设置时区和本地化信息) */
+ (nullable NSDate *)zh_dateFromTimestring:(NSString *)dateString
                                dateFormat:(NSString *)dateFormat
                                  timeZone:(NSTimeZone *)timeZone
                                    locale:(NSLocale *)locale;

/** 将date转换成时间戳 (NSDate => Timestamp) */
+ (NSInteger)zh_timestampFromDate:(NSDate *)date;

/** 将时间戳转换成date (Timestamp => NSDate) (北京时间) */
+ (nullable NSDate *)zh_dateFromTimestamp:(NSInteger)timestamp;

/** 将date转换成时间字符串 (NSDate => Timestring) */
+ (nullable NSString *)zh_timestringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat;

/** 将date转换成时间字符串 (instance method) */
- (nullable NSString *)zh_timestringWithDateFormat:(NSString *)dateFormat;


/** 获取当前的"年月日时分秒" */
+ (nullable NSArray<NSString *> *)zh_getCurrentTimeComponents;

/**
 计算两日期之间相差的时间
 Example:
 (获取两日期相差多少天)
 NSInteger days = [NSDate zh_numberOfApartWithFromDate:date1 toDate:date2 unit:NSCalendarUnitDay].day;
 (获取两日期相差多少个月)
 NSInteger months = [NSDate zh_numberOfApartWithFromDate:date toDate:endDate unit:NSCalendarUnitMonth].month;
 */
+ (NSDateComponents *)zh_numberOfApartWithFromDate:(NSDate *)fromDate
                                            toDate:(NSDate *)toDate
                                              unit:(NSCalendarUnit)calendarUnit;

/**
 比较两个时间字符串的大小关系 return NSComparisonResult
 NSOrderedAscending     => (dateString1 < dateString2)
 NSOrderedDescending    => (dateString1 > dateString2)
 NSOrderedSame          => (dateString1 = dateString2)
 */
+ (NSComparisonResult)zh_dateCompareWithString1:(NSString *)dateString1
                                    dateString2:(NSString *)dateString2
                                     dateFormat:(NSString *)dateFormat;

/**
 获取某个月份的天数
 Example:
 NSInteger days = [NSDate zh_getSumOfDaysWithMonth:2 inYear:2017];
 */
+ (NSInteger)zh_getSumOfDaysWithMonth:(NSInteger)month inYear:(NSInteger)year;

/** 是否是工作日 */
- (BOOL)zh_isTypicallyWorkday;
/** 是否是周末 */
- (BOOL)zh_isTypicallyWeekend;

#pragma mark - 转为秒级单位☟

+ (NSInteger)zh_oneMinuteSeconds;
+ (NSInteger)zh_oneHoursSeconds;
+ (NSInteger)zh_oneDaySeconds;
+ (NSInteger)zh_oneWeekSeconds;

#pragma mark - 返回调整后的日期，根据提供的参数来改变☟

- (nullable NSDate *)zh_dateByAddingYears:(NSInteger)years;
- (nullable NSDate *)zh_dateByAddingMonths:(NSInteger)months;
- (nullable NSDate *)zh_dateByAddingWeeks:(NSInteger)weeks;
- (nullable NSDate *)zh_dateByAddingDays:(NSInteger)days;
- (nullable NSDate *)zh_dateByAddingHours:(NSInteger)hours;
- (nullable NSDate *)zh_dateByAddingMinutes:(NSInteger)minutes;
- (nullable NSDate *)zh_dateByAddingSeconds:(NSInteger)seconds;

@end

NS_ASSUME_NONNULL_END
