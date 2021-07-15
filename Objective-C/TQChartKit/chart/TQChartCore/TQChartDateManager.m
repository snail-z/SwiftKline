//
//  TQChartDateManager.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/24.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQChartDateManager.h"

@implementation TQChartDateManager {
    dispatch_semaphore_t _lock;
    NSCache *_dateFormatCache;
}

+ (instancetype)sharedManager {
    static TQChartDateManager *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[TQChartDateManager alloc] init];
        [instance _initialization];
    });
    return instance;
}

- (void)_initialization {
    NSArray<NSString *> *array = @[@"yyyy-MM", @"MM-dd", @"HH:mm"];
    
    _lock = dispatch_semaphore_create(1);
    
    _dateFormatCache = [NSCache new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSString *stringKey in array) {
            [self dateFormatterWithKey:stringKey];
        }
    });
}

- (NSDateFormatter *)dateFormatterWithKey:(NSString *)key {
    NSDateFormatter *dateFormatter =  [_dateFormatCache objectForKey:key];
    if (dateFormatter) return dateFormatter;
    
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    formatter.locale = [NSLocale currentLocale];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    formatter.dateFormat = key;
    @autoreleasepool {
        [_dateFormatCache setObject:formatter forKey:key];
    }
    
    dispatch_semaphore_signal(_lock);
    return formatter;
}

- (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)format {
    NSDateFormatter *formatter = [self dateFormatterWithKey:format];
    return [formatter stringFromDate:date];
}

- (NSDate *)dateFromString:(NSString *)string dateFormat:(NSString *)format {
    NSDateFormatter *formatter = [self dateFormatterWithKey:format];
    return [formatter dateFromString:string];
}

@end

@implementation NSDate (TQStockChart)

- (NSCalendar *)tq_Calendar {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
#else
    return [NSCalendar currentCalendar];
#endif
}

- (NSInteger)tq_year {
    return [[self tq_Calendar] components:NSCalendarUnitYear fromDate:self].year;
}

- (NSInteger)tq_month {
    return [[self tq_Calendar] components:NSCalendarUnitMonth fromDate:self].month;
}

- (NSInteger)tq_day {
    return [[self tq_Calendar] components:NSCalendarUnitDay fromDate:self].day;
}

- (NSInteger)tq_hour {
    return [[self tq_Calendar] components:NSCalendarUnitHour fromDate:self].hour;
}

- (NSInteger)tq_minute {
    return [[self tq_Calendar] components:NSCalendarUnitMinute fromDate:self].minute;
}

@end
