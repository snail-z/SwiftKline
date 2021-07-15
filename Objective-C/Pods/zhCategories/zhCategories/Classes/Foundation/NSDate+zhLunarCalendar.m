//
//  NSDate+zhLunarCalendar.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/15.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "NSDate+zhLunarCalendar.h"

@implementation NSDate (zhLunarCalendar)

+ (NSArray<NSString *> *)zh_chineseYearsArray {
    return @[@"甲子", @"乙丑", @"丙寅", @"丁卯", @"戊辰", @"己巳", @"庚午", @"辛未", @"壬申", @"癸酉", @"甲戌",   @"乙亥", @"丙子", @"丁丑", @"戊寅", @"己卯", @"庚辰", @"辛己", @"壬午", @"癸未", @"甲申", @"乙酉", @"丙戌",  @"丁亥", @"戊子", @"己丑", @"庚寅", @"辛卯", @"壬辰", @"癸巳", @"甲午", @"乙未", @"丙申", @"丁酉", @"戊戌",  @"己亥", @"庚子", @"辛丑", @"壬寅", @"癸丑", @"甲辰", @"乙巳", @"丙午", @"丁未", @"戊申", @"己酉", @"庚戌",  @"辛亥", @"壬子", @"癸丑", @"甲寅", @"乙卯", @"丙辰", @"丁巳", @"戊午", @"己未", @"庚申", @"辛酉", @"壬戌", @"癸亥"];
}

+ (NSArray<NSString *> *)zh_chineseMonthsArray {
  return @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",@"九月", @"十月", @"冬月", @"腊月"];
}

+ (NSArray<NSString *> *)zh_chineseDaysArray {
    return @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",@"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"];
}

- (NSString *)zh_lunarYMDTimestring {
    NSCalendar *chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [chineseCalendar components:unitFlags fromDate:self];
    NSString *year = [NSDate zh_chineseYearsArray][components.year -1];
    NSString *month = [NSDate zh_chineseMonthsArray][components.month -1];
    NSString *day = [NSDate zh_chineseDaysArray][components.day -1];
    NSString *lunarString =[NSString stringWithFormat:@"%@%@%@", year, month, day];
    return lunarString;
}

- (NSString *)zh_lunarMDTimestring {
    NSCalendar *chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [chineseCalendar components:unitFlags fromDate:self];
    NSString *month = [NSDate zh_chineseMonthsArray][components.month -1];
    NSString *day = [NSDate zh_chineseDaysArray][components.day -1];
    return [month stringByAppendingString:day];
}

@end
