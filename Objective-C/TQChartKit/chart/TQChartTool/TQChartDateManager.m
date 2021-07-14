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
    NSCalendar *_calendar;
}

+ (instancetype)sharedManager {
    static TQChartDateManager *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[TQChartDateManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _lock = dispatch_semaphore_create(1);
    _dateFormatCache = [NSCache new];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    _calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
#else
    _calendar = [NSCalendar currentCalendar];
#endif
    
    NSArray<NSString *> *array = @[@"yyyy-MM-dd", @"yyyy-MM", @"MM-dd", @"HH:mm"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSString *stringKey in array) {
            [self dateFormatterWithKey:stringKey];
        }
    });
    
    return self;
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
    [_dateFormatCache setObject:formatter forKey:key];
    
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

- (NSInteger)year:(NSDate *)date {
    return [_calendar components:NSCalendarUnitYear fromDate:date].year;
}

- (NSInteger)month:(NSDate *)date {
    return [_calendar components:NSCalendarUnitMonth fromDate:date].month;
}

- (NSInteger)day:(NSDate *)date {
    return [_calendar components:NSCalendarUnitDay fromDate:date].day;
}

- (NSInteger)hour:(NSDate *)date {
    return [_calendar components:NSCalendarUnitHour fromDate:date].hour;
}

- (NSInteger)minute:(NSDate *)date {
    return [_calendar components:NSCalendarUnitMinute fromDate:date].minute;
}

@end
