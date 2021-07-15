//
//  NSDate+zhExtend.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/14.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "NSDate+zhExtend.h"

@implementation NSDate (zhExtend)

- (NSCalendar *)zh_Calendar {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
#else
    return [NSCalendar currentCalendar];
#endif
}

- (NSInteger)zh_year {
    return [[[self zh_Calendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)zh_month {
    return [[[self zh_Calendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)zh_day {
    return [[[self zh_Calendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)zh_hour {
    return [[[self zh_Calendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)zh_minute {
    return [[[self zh_Calendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)zh_second {
    return [[[self zh_Calendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)zh_nanosecond {
    return [[[self zh_Calendar] components:NSCalendarUnitSecond fromDate:self] nanosecond];
}

- (NSInteger)zh_weekday {
    return [[[self zh_Calendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSInteger)zh_weekdayOrdinal {
    return [[[self zh_Calendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

- (NSInteger)zh_weekOfMonth {
    return [[[self zh_Calendar] components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

- (NSInteger)zh_weekOfYear {
    return [[[self zh_Calendar] components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}

- (NSInteger)zh_yearForWeekOfYear {
    return [[[self zh_Calendar] components:NSCalendarUnitYearForWeekOfYear fromDate:self] yearForWeekOfYear];
}

- (NSInteger)zh_quarter {
    return [[[self zh_Calendar] components:NSCalendarUnitQuarter fromDate:self] quarter];
}

- (BOOL)zh_isLeapMonth {
    return [[[self zh_Calendar] components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}

- (BOOL)zh_isLeapYear {
    NSUInteger year = self.zh_year;
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

- (BOOL)zh_isToday {
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
    return [NSDate new].zh_day == self.zh_day;
}

- (BOOL)zh_isYesterday {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 86400;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [newDate zh_isToday];
}

- (BOOL)zh_isInPast {
    return ([self compare:[NSDate date]] == NSOrderedAscending);
}

- (BOOL)zh_isInFuture {
    return ([self compare:[NSDate date]] == NSOrderedDescending);
}


+ (NSString *)zh_dayFromWeekday:(NSDate *)date {
    switch([date zh_weekday]) {
        case 1:
            return @"星期天";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            break;
    }
    return @"";
}

+ (NSString *)zh_dayFromWeekday2:(NSDate *)date {
    switch([date zh_weekday]) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
        default:
            break;
    }
    return @"";
}

+ (NSString *)zh_dayFromWeekdayEN:(NSDate *)date {
    switch([date zh_weekday]) {
        case 1:
            return @"Sunday";
            break;
        case 2:
            return @"Monday";
            break;
        case 3:
            return @"Tuesday";
            break;
        case 4:
            return @"Wednesday";
            break;
        case 5:
            return @"Thursday";
            break;
        case 6:
            return @"Friday";
            break;
        case 7:
            return @"Saturday";
            break;
        default:
            break;
    }
    return @"";
}

- (NSString *)zh_dayFromWeekday {
    return [NSDate zh_dayFromWeekday:self];
}

- (NSString *)zh_dayFromWeekday2 {
    return [NSDate zh_dayFromWeekday2:self];
}

- (NSString *)zh_dayFromWeekdayEN {
    return [NSDate zh_dayFromWeekdayEN:self];
}


+ (NSString *)zh_ymdFormat {
    return @"yyyy-MM-dd";
}

+ (NSString *)zh_dmyFormat {
    return @"dd/MM/yyyy";
}

+ (NSString *)zh_myFormat {
    return @"MM/yyyy";
}

+ (NSString *)zh_hmsFormat {
    return @"HH:mm:ss";
}

+ (NSString *)zh_ymdHmsFormat {
    return [NSString stringWithFormat:@"%@ %@", [self zh_ymdFormat], [self zh_hmsFormat]];
}


+ (NSDate *)zh_backward:(NSInteger)backwardN unitType:(NSCalendarUnit)unit {
    NSDateComponents *dateComponentsAsTimeQantum = [[NSDateComponents alloc] init];
    [dateComponentsAsTimeQantum setValue:backwardN forComponent:unit];
    NSDate *dateFromDateComponentsAsTimeQantum = [[[self alloc] zh_Calendar] dateByAddingComponents:dateComponentsAsTimeQantum toDate:[NSDate date] options:0];
    return dateFromDateComponentsAsTimeQantum;
}

+ (NSDate *)zh_forward:(NSInteger)forwardN unitType:(NSCalendarUnit)unit {
    return [self zh_backward:-forwardN unitType:unit];
}


+ (NSInteger)zh_getNowTimestampWithDateFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:dateFormat];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    return [self zh_timestampFromDate:[NSDate date]];
}

+ (NSString *)zh_getCurrentTimestampString {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [date timeIntervalSince1970];
    NSString *timestampString = [NSString stringWithFormat:@"%d", (int)a];
    return timestampString;
}

+ (NSString *)zh_timestringFromTimestamp:(NSInteger)timestamp dateFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:dateFormat];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *timeDate = [self zh_dateFromTimestamp:timestamp];
    return [formatter stringFromDate:timeDate];
}

+ (NSInteger)zh_timestampFromTimestring:(NSString *)timeString dateFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:dateFormat];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *date = [formatter dateFromString:timeString];
    return [self zh_timestampFromDate:date];
}

+ (NSDate *)zh_dateFromTimestring:(NSString *)timestring dateFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:dateFormat];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    return [formatter dateFromString:timestring];
}

+ (NSDate *)zh_dateFromTimestring:(NSString *)dateString dateFormat:(NSString *)dateFormat timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    return [formatter dateFromString:dateString];
}

+ (NSInteger)zh_timestampFromDate:(NSDate *)date {
    return [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
}

+ (NSDate *)zh_dateFromTimestamp:(NSInteger)timestamp {
    return [NSDate dateWithTimeIntervalSince1970:timestamp];
}

+ (NSString *)zh_timestringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat {
    return [date zh_timestringWithDateFormat:dateFormat];;
}

- (NSString *)zh_timestringWithDateFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:[NSLocale currentLocale]];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    return [formatter stringFromDate:self];
}


+ (NSArray<NSString *> *)zh_getCurrentTimeComponents {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy,MM,dd,HH,mm,ss"];
    NSDate *date = [NSDate date];
    NSString *time = [formatter stringFromDate:date];
    return [time componentsSeparatedByString:@","];
}


+ (NSDateComponents *)zh_numberOfApartWithFromDate:(NSDate *)fromDate
                                            toDate:(NSDate *)toDate
                                              unit:(NSCalendarUnit)calendarUnit {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calendar components:calendarUnit fromDate:fromDate toDate:toDate options:0];
}


+ (NSComparisonResult)zh_dateCompareWithString1:(NSString *)dateString1 dateString2:(NSString *)dateString2 dateFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:dateFormat];
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] init];
    date1 = [formatter dateFromString:dateString1];
    date2 = [formatter dateFromString:dateString2];
    return [date1 compare:date2];
}


+ (NSInteger)zh_getSumOfDaysWithMonth:(NSInteger)month inYear:(NSInteger)year {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *dateString = [NSString stringWithFormat:@"%lu-%lu", (long)year, (long)month];
    NSDate *date = [formatter dateFromString:dateString];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSRange range = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] rangeOfUnit:NSCalendarUnitDay
                                                                                            inUnit:NSCalendarUnitMonth
                                                                                           forDate:date];
    return range.length;
#else
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit
                                                       inUnit:NSMonthCalendarUnit
                                                      forDate:date];
    return range.length;
#endif
}


- (BOOL)zh_isTypicallyWorkday {
    return ![self zh_isTypicallyWeekend];
}

- (BOOL)zh_isTypicallyWeekend {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    NSDateComponents *components;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        components = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday | NSCalendarUnitMonth fromDate:self];
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        components = [[NSCalendar autoupdatingCurrentCalendar] components:NSWeekdayCalendarUnit fromDate:self];
#pragma clang diagnostic pop
    }
#else
    NSDateComponents *components = [[NSCalendar autoupdatingCurrentCalendar] components:NSWeekdayCalendarUnit fromDate:self];
#endif
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}


+ (NSInteger)zh_oneMinuteSeconds {
    return 60;
}

+ (NSInteger)zh_oneHoursSeconds {
    return 3600;
}

+ (NSInteger)zh_oneDaySeconds {
    return 86400;
}

+ (NSInteger)zh_oneWeekSeconds {
    return 604800;
}

- (NSDate *)zh_dateByAddingYears:(NSInteger)years {
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)zh_dateByAddingMonths:(NSInteger)months {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)zh_dateByAddingWeeks:(NSInteger)weeks {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfYear:weeks];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)zh_dateByAddingDays:(NSInteger)days {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 86400 * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)zh_dateByAddingHours:(NSInteger)hours {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 3600 * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)zh_dateByAddingMinutes:(NSInteger)minutes {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 60 * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)zh_dateByAddingSeconds:(NSInteger)seconds {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + seconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

@end
