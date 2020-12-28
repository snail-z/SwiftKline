//
//  NSDate+PKExtend.m
//  PKCategories
//
//  Created by zhanghao on 2018/10/21.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "NSDate+PKExtend.h"

@implementation NSDate (PKExtend)

+ (NSCalendar *)PKCalendar {
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

+ (NSDateFormatter *)PKDateFormatter {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        formatter.locale = [NSLocale currentLocale];
        formatter.timeZone = [NSTimeZone systemTimeZone];
    });
    return formatter;
}

- (NSInteger)pk_year {
    return [[NSDate PKCalendar] components:NSCalendarUnitYear fromDate:self].year;
}

- (NSInteger)pk_quarter {
    return (NSInteger)(self.pk_month / 3 + 1);
}

- (NSInteger)pk_month {
    return [[NSDate PKCalendar] components:NSCalendarUnitMonth fromDate:self].month;
}

- (NSInteger)pk_day {
    return [[NSDate PKCalendar] components:NSCalendarUnitDay fromDate:self].day;
}

- (NSInteger)pk_hour {
    return [[NSDate PKCalendar] components:NSCalendarUnitHour fromDate:self].hour;
}

- (NSInteger)pk_minute {
    return [[NSDate PKCalendar] components:NSCalendarUnitMinute fromDate:self].minute;
}

- (NSInteger)pk_second {
    return [[NSDate PKCalendar] components:NSCalendarUnitSecond fromDate:self].second;
}

- (NSInteger)pk_nanosecond {
    return [[NSDate PKCalendar] components:NSCalendarUnitNanosecond fromDate:self].nanosecond;
}

- (NSInteger)pk_weekday {
    return [[NSDate PKCalendar] components:NSCalendarUnitWeekday fromDate:self].weekday;
}

- (NSInteger)pk_weekOfMonth {
    return [[NSDate PKCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self].weekOfMonth;
}

- (NSInteger)pk_weekOfYear {
    return [[NSDate PKCalendar] components:NSCalendarUnitWeekOfYear fromDate:self].weekOfYear;
}

- (BOOL)pk_isLeapMonth {
    return [[NSDate PKCalendar] components:NSCalendarUnitQuarter fromDate:self].isLeapMonth;
}

- (BOOL)pk_isLeapYear {
    NSUInteger year = self.pk_year;
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

- (BOOL)pk_isToday {
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
    return [NSDate date].pk_day == self.pk_day;
}

- (BOOL)pk_isYesterday {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 86400;
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [date pk_isToday];
}

- (BOOL)pk_isInPast {
    return ([self compare:[NSDate date]] == NSOrderedAscending);
}

- (BOOL)pk_isInFuture {
    return ([self compare:[NSDate date]] == NSOrderedDescending);
}

- (BOOL)pk_isWorkingDay {
    return ![self pk_isWeekend];
}

- (BOOL)pk_isWeekend {
    NSDateComponents *components = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday | NSCalendarUnitMonth fromDate:self];
    return ((components.weekday == 1) || (components.weekday == 7));
}

- (NSString *)pk_vivid1Weekday {
    switch(self.pk_weekday) {
        case 1:
            return @"星期天";
        case 2:
            return @"星期一";
        case 3:
            return @"星期二";
        case 4:
            return @"星期三";
        case 5:
            return @"星期四";
        case 6:
            return @"星期五";
        case 7:
            return @"星期六";
        default:
            return @"";
    }
}

- (NSString *)pk_vivid2Weekday {
    switch(self.pk_weekday) {
        case 1:
            return @"周日";
        case 2:
            return @"周一";
        case 3:
            return @"周二";
        case 4:
            return @"周三";
        case 5:
            return @"周四";
        case 6:
            return @"周五";
        case 7:
            return @"周六";
        default:
            return @"";
    }
}

- (NSString *)pk_vividEnWeekday {
    switch(self.pk_weekday) {
        case 1:
            return @"Sunday";
        case 2:
            return @"Monday";
        case 3:
            return @"Tuesday";
        case 4:
            return @"Wednesday";
        case 5:
            return @"Thursday";
        case 6:
            return @"Friday";
        case 7:
            return @"Saturday";
        default:
            return @"";
    }
}

+ (NSString *)pk_stringFromDate:(NSDate *)date formatter:(NSString *)dateFormat {
    NSDateFormatter *formatter = [NSDate PKDateFormatter];
    formatter.dateFormat = dateFormat;
    return [formatter stringFromDate:date];
}

+ (NSDate *)pk_dateFromString:(NSString *)string formatter:(NSString *)dateFormat {
    NSDateFormatter *formatter = [NSDate PKDateFormatter];
    formatter.dateFormat = dateFormat;
    return [formatter dateFromString:string];
}

+ (NSInteger)pk_timestampFromDate:(NSDate *)date {
    return [NSNumber numberWithDouble:date.timeIntervalSince1970].integerValue;
}

+ (NSDate *)pk_dateFromTimestamp:(NSInteger)timestamp {
    return [NSDate dateWithTimeIntervalSince1970:timestamp];
}

+ (NSInteger)pk_timestampFromString:(NSString *)string formatter:(NSString *)dateFormat {
    NSDateFormatter *formatter = [NSDate PKDateFormatter];
    formatter.dateFormat = dateFormat;
    NSDate *date = [formatter dateFromString:string];
    return [self pk_timestampFromDate:date];
}

+ (NSString *)pk_stringFromTimestamp:(NSInteger)timestamp formatter:(NSString *)dateFormat {
    NSDate *date = [self pk_dateFromTimestamp:timestamp];
    NSDateFormatter *formatter = [NSDate PKDateFormatter];
    formatter.dateFormat = dateFormat;
    return [formatter stringFromDate:date];
}

+ (NSArray<NSString *> *)pk_getCurrentComponents {
    NSDateFormatter *formatter = [NSDate PKDateFormatter];
    formatter.dateFormat = @"yyyy,MM,dd,HH,mm,ss";
    NSString *times = [formatter stringFromDate:[NSDate date]];
    return [times componentsSeparatedByString:@","];
}

- (NSDate *)pk_backward:(NSInteger)backward forComponent:(NSCalendarUnit)unit {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setValue:backward forComponent:unit];
    return [[NSDate PKCalendar] dateByAddingComponents:dateComponents toDate:self options:kNilOptions];;
}

- (NSDate *)pk_forward:(NSInteger)forward forComponent:(NSCalendarUnit)unit {
    return [self pk_backward:-forward forComponent:unit];
}

+ (NSInteger)pk_numberOfDaysInYear:(NSInteger)year forMonth:(NSInteger)month {
    NSString *string = [NSString stringWithFormat:@"%@-%@", @(year), @(month)];
    NSDateFormatter *formatter = [NSDate PKDateFormatter];
    formatter.dateFormat = @"yyyy-MM";
    NSDate *date = [formatter dateFromString:string];
    NSCalendar *calendar = [NSDate PKCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

+ (NSDate *)pk_dateOfLastDayInYear:(NSInteger)year forMonth:(NSInteger)month {
    NSString *string = [NSString stringWithFormat:@"%@-%@", @(year), @(month)];
    NSDateFormatter *formatter = [NSDate PKDateFormatter];
    formatter.dateFormat = @"yyyy-MM";
    NSDate *date = [formatter dateFromString:string];
    NSCalendar *calendar = [NSDate PKCalendar];
    NSDate *startDate = nil;
    NSTimeInterval interval = 0;
    BOOL isOK = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:&interval forDate:date];
    return isOK ? [startDate dateByAddingTimeInterval:interval - 1] : nil;
}

+ (NSDateComponents *)pk_components:(NSCalendarUnit)unitFlags fromDate:(NSDate *)startingDate toDate:(NSDate *)resultDate {
    NSCalendar *calendar = [NSDate PKCalendar];
    return [calendar components:unitFlags fromDate:startingDate toDate:resultDate options:kNilOptions];
}

- (NSDate *)pk_dateByAddingComponents:(NSDateComponents *)comps {
    NSCalendar *calendar =  [NSDate PKCalendar];
    return [calendar dateByAddingComponents:comps toDate:self options:kNilOptions];
}

+ (NSComparisonResult)pk_compare:(NSString *)dateString other:(NSString *)other formatter:(NSString *)dateFormat {
    NSDateFormatter *formatter = [NSDate PKDateFormatter];
    formatter.dateFormat = dateFormat;
    NSDate *aDate = [[NSDate alloc] init];
    NSDate *bDate = [[NSDate alloc] init];
    aDate = [formatter dateFromString:dateString];
    bDate = [formatter dateFromString:other];
    return [aDate compare:bDate];;
}

- (NSDate *)pk_localizationDateTimeZone:(NSString *)abbreviation {
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:abbreviation];// UTC或GMT
    NSTimeZone *destinationTimeZone = [NSTimeZone localTimeZone];
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:self];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:self];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    NSDate *destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:self];
    return destinationDateNow;
}

@end


@implementation NSDate (PKLunarCalendar)

+ (NSCalendar *)PKChineseCalendar {
    static NSCalendar *chineseCalendar;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chineseCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    });
    return chineseCalendar;
}

+ (NSArray<NSString *> *)pk_allChineseYears {
    return @[@"甲子", @"乙丑", @"丙寅", @"丁卯", @"戊辰", @"己巳", @"庚午", @"辛未", @"壬申", @"癸酉", @"甲戌",   @"乙亥", @"丙子", @"丁丑", @"戊寅", @"己卯", @"庚辰", @"辛己", @"壬午", @"癸未", @"甲申", @"乙酉", @"丙戌",  @"丁亥", @"戊子", @"己丑", @"庚寅", @"辛卯", @"壬辰", @"癸巳", @"甲午", @"乙未", @"丙申", @"丁酉", @"戊戌",  @"己亥", @"庚子", @"辛丑", @"壬寅", @"癸丑", @"甲辰", @"乙巳", @"丙午", @"丁未", @"戊申", @"己酉", @"庚戌",  @"辛亥", @"壬子", @"癸丑", @"甲寅", @"乙卯", @"丙辰", @"丁巳", @"戊午", @"己未", @"庚申", @"辛酉", @"壬戌", @"癸亥"];
}

+ (NSArray<NSString *> *)pk_allChineseMonths {
    return @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",@"九月", @"十月", @"冬月", @"腊月"];
}

+ (NSArray<NSString *> *)pk_allChineseDays {
    return @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",@"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"];
}

- (NSString *)pk_ymdLunarTimestring {
    NSCalendar *chineseCalendar = [NSDate PKChineseCalendar];
    if (!chineseCalendar) return nil;
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [chineseCalendar components:unitFlags fromDate:self];
    NSString *year = NSDate.pk_allChineseYears[components.year -1];
    NSString *month = NSDate.pk_allChineseMonths[components.month -1];
    NSString *day = NSDate.pk_allChineseDays[components.day -1];
    return [[year stringByAppendingString:month] stringByAppendingString:day];
}

- (NSString *)pk_mdLunarTimestring {
    NSCalendar *chineseCalendar = [NSDate PKChineseCalendar];
    if (!chineseCalendar) return nil;
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [chineseCalendar components:unitFlags fromDate:self];
    NSString *month = NSDate.pk_allChineseMonths[components.month -1];
    NSString *day = NSDate.pk_allChineseDays[components.day -1];
    return [month stringByAppendingString:day];
}

@end
