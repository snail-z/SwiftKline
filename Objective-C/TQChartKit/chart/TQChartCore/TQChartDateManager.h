//
//  TQChartDateManager.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/24.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TQChartDateManager : NSObject

@property (nonatomic, strong, class, readonly) TQChartDateManager *sharedManager;
- (nullable NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)format;
- (nullable NSDate *)dateFromString:(NSString *)string dateFormat:(NSString *)format;

@end

@interface NSDate (TQStockChart)

@property (nonatomic, assign, readonly) NSInteger tq_year;
@property (nonatomic, assign, readonly) NSInteger tq_month;
@property (nonatomic, assign, readonly) NSInteger tq_day;
@property (nonatomic, assign, readonly) NSInteger tq_hour;
@property (nonatomic, assign, readonly) NSInteger tq_minute;

@end

NS_ASSUME_NONNULL_END
