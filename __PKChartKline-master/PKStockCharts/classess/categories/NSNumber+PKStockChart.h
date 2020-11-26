//
//  NSNumber+PKStockChart.h
//  MApiSample
//
//  Created by zhanghao on 2018/12/29.
//  Copyright © 2018年 Mitake. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (PKStockChart)

/** 将浮点数四舍五入，自定义小数点后保留的位数 (例如保留小数点后三位的结果 0.1256 = 0.126) */
+ (NSString *)pk_stringWithDigits:(NSNumber *)number keepPlaces:(short)place;

/** 将浮点数四舍五入，保留小数点后两位 (例如 0.1256 = 0.13) */
+ (NSString *)pk_stringWithDoubleDigits:(NSNumber *)number;

/** NSNumber转百分比字符串，保留四舍五入后的两位小数 */
+ (NSString *)pk_percentStringWithDoubleDigits:(NSNumber *)number;

/** NSNumber转万亿字符串，自定义小数点后保留的位数 */
+ (NSString *)pk_trillionStringWithDigits:(NSNumber *)number keepPlaces:(short)place;

/** NSNumber转万亿字符串，保留四舍五入后的两位小数 */
+ (NSString *)pk_trillionStringWithDoubleDigits:(NSNumber *)number;

@end

NS_ASSUME_NONNULL_END
