//
//  NSDate+PKStockChart.m
//  PKChartKit
//
//  Created by zhanghao on 2019/3/1.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import "NSDate+PKStockChart.h"

@implementation NSDate (PKStockChart)

+ (NSCalendar *)_PKCalendar {
    static NSCalendar *calendar;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
            calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        } else {
            calendar = [NSCalendar currentCalendar];
        }
    });
    return calendar;
}

+ (NSDateFormatter *)_PKDateFormatter {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.timeStyle = NSDateFormatterShortStyle;
        formatter.locale = [NSLocale currentLocale];
        formatter.timeZone = [NSTimeZone systemTimeZone];
    });
    return formatter;
}

- (NSInteger)pk_year {
    return [[NSDate _PKCalendar] components:NSCalendarUnitYear fromDate:self].year;
}

- (NSInteger)pk_quarter {
    return (NSInteger)(self.pk_month / 3 + 1);
}

- (NSInteger)pk_month {
    return [[NSDate _PKCalendar] components:NSCalendarUnitMonth fromDate:self].month;
}

- (NSInteger)pk_day {
    return [[NSDate _PKCalendar] components:NSCalendarUnitDay fromDate:self].day;
}

- (NSInteger)pk_hour {
    return [[NSDate _PKCalendar] components:NSCalendarUnitHour fromDate:self].hour;
}

- (NSInteger)pk_minute {
    return [[NSDate _PKCalendar] components:NSCalendarUnitMinute fromDate:self].minute;
}

- (NSInteger)pk_second {
    return [[NSDate _PKCalendar] components:NSCalendarUnitSecond fromDate:self].second;
}

+ (NSString *)pk_stringFromDate:(NSDate *)date formatter:(NSString *)dateFormat {
    NSDateFormatter *formatter = [NSDate _PKDateFormatter];
    formatter.dateFormat = dateFormat;
    return [formatter stringFromDate:date];
}

+ (NSDate *)pk_dateFromString:(NSString *)string formatter:(NSString *)dateFormat {
    NSDateFormatter *formatter = [NSDate _PKDateFormatter];
    formatter.dateFormat = dateFormat;
    return [formatter dateFromString:string];
}

+ (NSArray<NSNumber *> *)pk_minutesSetsBegin:(NSInteger)begin end:(NSInteger)end {
    NSMutableArray<NSNumber *> *mud = [NSMutableArray array];
    for (NSInteger idx = begin; idx <= end; idx++) {
        [mud addObject:@(idx)];
    }
    return mud.copy;
}

+ (NSString *)pk_stringFromMinutes:(NSInteger)minutes {
    NSString *stringA = nil;
    if ((minutes / 60) < 10) {
        stringA = [NSString stringWithFormat:@"0%ld", (long)(minutes / 60)];
    } else {
        stringA = [NSString stringWithFormat:@"%ld", (long)(minutes / 60)];
    }
    NSString *stringB = nil;
    if ((minutes % 60) < 10) {
        stringB = [NSString stringWithFormat:@"0%ld", (long)(minutes % 60)];
    } else {
        stringB = [NSString stringWithFormat:@"%ld", (long)(minutes % 60)];
    }
    return [NSString stringWithFormat:@"%@:%@", stringA, stringB];
}

+ (NSInteger)pk_minutesFromDate:(NSDate *)date {
    NSCalendar *calendar = [NSDate _PKCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date];
    return comps.hour * 60 + comps.minute;
}

@end
