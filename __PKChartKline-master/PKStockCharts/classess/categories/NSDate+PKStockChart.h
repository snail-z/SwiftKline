//
//  NSDate+PKStockChart.h
//  PKChartKit
//
//  Created by zhanghao on 2019/3/1.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (PKStockChart)

@property (nonatomic, assign, readonly) NSInteger pk_year;
@property (nonatomic, assign, readonly) NSInteger pk_quarter;   // (1~4)
@property (nonatomic, assign, readonly) NSInteger pk_month;     // (1~12)
@property (nonatomic, assign, readonly) NSInteger pk_day;       // (1~31)
@property (nonatomic, assign, readonly) NSInteger pk_hour;      // (0~23)
@property (nonatomic, assign, readonly) NSInteger pk_minute;    // (0~59)
@property (nonatomic, assign, readonly) NSInteger pk_second;    // (0~59)

/** 将NSDate转成NSString */
+ (NSString *)pk_stringFromDate:(NSDate *)date formatter:(NSString *)dateFormat;

/** 将NSString转成NSDate */
+ (nullable NSDate *)pk_dateFromString:(NSString *)string formatter:(NSString *)dateFormat;

/**
 * 获取某时间段的分钟数集，用于自定义分时日期线时使用【分钟数 = hours * 60 + minutes】
 *
 * @param begin 开始分钟数 (如09:30的分钟数为570)
 * @param end   结束分钟数 (如11:30的分钟数为690)
 *
 * @return 返回该时间段的分钟数集
 */
+ (NSArray<NSNumber *> *)pk_minutesSetsBegin:(NSInteger)begin end:(NSInteger)end;

/** 根据分钟数获取HH:mm */
+ (NSString *)pk_stringFromMinutes:(NSInteger)minutes;

/** 将NSDate转分钟数 */
+ (NSInteger)pk_minutesFromDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
