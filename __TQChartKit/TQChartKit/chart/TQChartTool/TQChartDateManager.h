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

- (NSInteger)year:(NSDate *)date;
- (NSInteger)month:(NSDate *)date;
- (NSInteger)day:(NSDate *)date;
- (NSInteger)hour:(NSDate *)date;
- (NSInteger)minute:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
