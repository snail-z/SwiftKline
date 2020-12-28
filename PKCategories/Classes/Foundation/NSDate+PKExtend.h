//
//  NSDate+PKExtend.h
//  PKCategories
//
//  Created by zhanghao on 2018/10/21.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (PKExtend)

+ (nullable NSCalendar *)PKCalendar;
+ (NSDateFormatter *)PKDateFormatter;

@property (nonatomic, assign, readonly) NSInteger pk_year;
@property (nonatomic, assign, readonly) NSInteger pk_quarter;   // (1~4)
@property (nonatomic, assign, readonly) NSInteger pk_month;     // (1~12)
@property (nonatomic, assign, readonly) NSInteger pk_day;       // (1~31)
@property (nonatomic, assign, readonly) NSInteger pk_hour;      // (0~23)
@property (nonatomic, assign, readonly) NSInteger pk_minute;    // (0~59)
@property (nonatomic, assign, readonly) NSInteger pk_second;    // (0~59)
@property (nonatomic, assign, readonly) NSInteger pk_nanosecond;

/** 该日期是星期几(美式) */
@property (nonatomic, assign, readonly) NSInteger pk_weekday;

/** 该月份的第几周 */
@property (nonatomic, assign, readonly) NSInteger pk_weekOfMonth;

/** 该年份的第几周 */
@property (nonatomic, assign, readonly) NSInteger pk_weekOfYear;

/** 是否为闰月 */
@property (nonatomic, assign, readonly) BOOL pk_isLeapMonth;

/** 是否为闰年 */
@property (nonatomic, assign, readonly) BOOL pk_isLeapYear;

/** 是否是今天 */
@property (nonatomic, assign, readonly) BOOL pk_isToday;

/** 是否是昨天 */
@property (nonatomic, assign, readonly) BOOL pk_isYesterday;

/** 是否小于当前时间(过去时间) */
@property (nonatomic, assign, readonly) BOOL pk_isInPast;

/** 是否大于当前时间(未来时间) */
@property (nonatomic, assign, readonly) BOOL pk_isInFuture;

/** 是否是工作日 */
@property (nonatomic, assign, readonly) BOOL pk_isWorkingDay;

/** 是否是周末 */
@property (nonatomic, assign, readonly) BOOL pk_isWeekend;

/** 星期几形式 */
@property (nonatomic, strong, readonly) NSString *pk_vivid1Weekday;

/** 周几形式 */
@property (nonatomic, strong, readonly) NSString *pk_vivid2Weekday;

/** 英文形式 */
@property (nonatomic, strong, readonly) NSString *pk_vividEnWeekday;

/** 将NSDate转成NSString */
+ (NSString *)pk_stringFromDate:(NSDate *)date formatter:(NSString *)dateFormat;

/** 将NSString转成NSDate */
+ (nullable NSDate *)pk_dateFromString:(NSString *)string formatter:(NSString *)dateFormat;

/** 将NSDate转成NSInteger时间戳 */
+ (NSInteger)pk_timestampFromDate:(NSDate *)date;

/** 将NSInteger时间戳转成NSDate */
+ (nullable NSDate *)pk_dateFromTimestamp:(NSInteger)timestamp;

/** 将NSString转成NSInteger时间戳 */
+ (NSInteger)pk_timestampFromString:(NSString *)string formatter:(NSString *)dateFormat;

/** 将NSInteger时间戳转成NSString */
+ (NSString *)pk_stringFromTimestamp:(NSInteger)timestamp formatter:(NSString *)dateFormat;

/** 获取当前时间的"年月日时分秒" */
+ (nullable NSArray<NSString *> *)pk_getCurrentComponents;

/**
 * @brief 获取未来时间
 *
 * @e.g. 获取2天后的时间 [date pk_backward:2 forComponent:NSCalendarUnitDay];
 */
- (nullable NSDate *)pk_backward:(NSInteger)backward forComponent:(NSCalendarUnit)unit;

/**
 * @brief 获取过去时间
 *
 * @e.g. 获取2年前的时间 [date pk_forward:2 forComponent:NSCalendarUnitYear];
 */
- (nullable NSDate *)pk_forward:(NSInteger)forward forComponent:(NSCalendarUnit)unit;

/**
 * @brief 获取某年某个月份的天数
 *
 * @e.g. 获取2017年2月份天数 [NSDate pk_numberOfDaysInYear:2017 forMonth:2];
 */
+ (NSInteger)pk_numberOfDaysInYear:(NSInteger)year forMonth:(NSInteger)month;

/**
 * @brief 获取某年某个月份的最后一天日期
 *
 * @e.g. 获取2017年2月份最后一天日期 [NSDate pk_dateOfLastDayInYear:2017 forMonth:2];
 */
+ (nullable NSDate *)pk_dateOfLastDayInYear:(NSInteger)year forMonth:(NSInteger)month;

/**
 * @brief 计算两个日期的相隔时间
 *
 * @param unitFlags 日历单元
 * @param startingDate 起始日期
 * @param resultDate 结束日期
 *
 * @return 返回日期组件(通过NSDateComponents访问年、月、日、时、分、秒等)
 *
 * @e.g. 计算两日期相差天数 [NSDate pk_componentsByUnit:NSCalendarUnitDay fromDate:date1 toDate:date2].day;
 */
+ (NSDateComponents *)pk_components:(NSCalendarUnit)unitFlags
                           fromDate:(NSDate *)startingDate toDate:(NSDate *)resultDate;

/**
 * @brief 返回调整后的日期，根据NSDateComponents来改变
 *
 * @param comps 日期组件
 *
 * @return 调整后的日期或nil
 *
 * @e.g. 将date向后调整5个月之后的日期:
 * NSDateComponents *comps = [[NSDateComponents alloc] init];
 * comps.month = 5;
 * NSDate *adjustedDate = [date pk_dateByAddingComponents:comps];
 */
- (nullable NSDate *)pk_dateByAddingComponents:(NSDateComponents *)comps;

/**
 * @brief 比较两个时间字符串的大小关系
 *
 * @param dateString a时间
 * @param other b时间
 * @param dateFormat 时间格式
 *
 * @return NSComparisonResult
 * NSOrderedAscending  (a时间 < b时间)
 * NSOrderedDescending (a时间 > b时间)
 * NSOrderedSame       (a时间 = b时间)
 */
+ (NSComparisonResult)pk_compare:(NSString *)dateString other:(NSString *)other formatter:(NSString *)dateFormat;

/**
 *  @brief 任意时区转换为本地时间
 *
 *  @param abbreviation 时区名称
 *
 *  @return 本地时间
 */
- (NSDate *)pk_localizationDateTimeZone:(NSString *)abbreviation;

@end


@interface NSDate (PKLunarCalendar)

+ (nullable NSCalendar *)PKChineseCalendar;

/** 获取所有农历年份名称 */
@property (nonatomic, strong, class, readonly) NSArray<NSString *> *pk_allChineseYears;

/** 获取所有农历月份名称 */
@property (nonatomic, strong, class, readonly) NSArray<NSString *> *pk_allChineseMonths;

/** 获取所有农历每日名称 */
@property (nonatomic, strong, class, readonly) NSArray<NSString *> *pk_allChineseDays;

/**
 * @brief 将date转为农历年月日
 *
 * @return 农历日期字符串或nil
 *
 * @e.g. 2017-12-15 => 丁酉十月廿八
 */
- (nullable NSString *)pk_ymdLunarTimestring;

/**
 * @brief 将date转为农历月日
 *
 * @return 农历日期字符串或nil
 *
 * @e.g. 2017-12-15 => 十月廿八
 */
- (nullable NSString *)pk_mdLunarTimestring;

@end

NS_ASSUME_NONNULL_END
