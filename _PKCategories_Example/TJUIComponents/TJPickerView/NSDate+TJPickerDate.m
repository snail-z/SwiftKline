//
//  NSDate+TJPickerDate.m
//  TJCategories_Example
//
//  Created by zhanghao on 2020/12/23.
//  Copyright © 2020 gren-beans. All rights reserved.
//

#import "NSDate+TJPickerDate.h"
#import "NSDate+PKExtend.h"

typedef NS_ENUM(NSInteger, TJPickerDateUnit) { /// 年月日时分秒
    TJPickerDateUnitYear = 0,
    TJPickerDateUnitMonth,
    TJPickerDateUnitDay,
    TJPickerDateUnitHour,
    TJPickerDateUnitMinute
};

@implementation NSDate (TJPickerDate)

+ (NSArray<id<TJPickerDataSource>> *)tj_allYears {
    return [self tj_yearsFrom:1970 toYear:2099];
}

+ (NSArray<id<TJPickerDataSource>> *)tj_tillNowYears {
    NSDate *now = [NSDate date];
    return [self tj_yearsFrom:1970 toYear:now.pk_year];
}

+ (NSArray<id<TJPickerDataSource>> *)tj_yearsFrom:(NSInteger)a toYear:(NSInteger)b {
    NSMutableArray *mua = @[].mutableCopy;
    for (NSInteger idx = a; idx <= b; idx++) {
        NSString *text = [[self tj_format:idx by:TJPickerDateUnitYear] stringByAppendingString:@"年"];
        
        TJPickerItem *item = [TJPickerItem itemWithPickerText:text pickerId:idx];
        [mua addObject:item];
    }
    return mua.copy;
}

+ (NSArray<id<TJPickerDataSource>> *)tj_months {
    NSMutableArray *mua = @[].mutableCopy;
    for (NSInteger idx = 1; idx <= 12; idx++) {
        NSString *text = [[self tj_format:idx by:TJPickerDateUnitMonth] stringByAppendingString:@"月"];
        TJPickerItem *item = [TJPickerItem itemWithPickerText:text pickerId:idx];
        [mua addObject:item];
    }
    return mua.copy;
}

+ (NSArray<id<TJPickerDataSource>> *)tj_daysOfDate:(NSDate *)date {
    NSInteger max = [NSDate pk_numberOfDaysInYear:date.pk_year forMonth:date.pk_month];
    NSMutableArray *mua = @[].mutableCopy;
    for (NSInteger idx = 1; idx <= max; idx++) {
        NSString *text = [[self tj_format:idx by:TJPickerDateUnitMonth] stringByAppendingString:@"日"];
        TJPickerItem *item = [TJPickerItem itemWithPickerText:text pickerId:idx];
        [mua addObject:item];
    }
    return mua.copy;
}

+ (NSArray<NSArray<id<TJPickerDataSource>> *> *)tj_yearsMonthsAndDays {
    return @[[self tj_allYears], [self tj_months], [self tj_daysOfDate:[NSDate date]]];
}

+ (NSString *)tj_format:(NSInteger)value by:(TJPickerDateUnit)unit {
    switch (unit) {
        case TJPickerDateUnitYear:
            return [NSString stringWithFormat:@"%@", @(value)];
        case TJPickerDateUnitMonth:
            return [NSString stringWithFormat:@"%.ld", value];
        case TJPickerDateUnitDay:
            return [NSString stringWithFormat:@"%.ld", value];
        case TJPickerDateUnitHour:
            return [NSString stringWithFormat:@"%.2ld", value];
        case TJPickerDateUnitMinute:
            return [NSString stringWithFormat:@"%.2ld", value];
        default: return @"";
    }
}

@end
