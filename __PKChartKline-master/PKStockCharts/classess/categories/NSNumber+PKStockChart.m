//
//  NSNumber+PKStockChart.m
//  MApiSample
//
//  Created by zhanghao on 2018/12/29.
//  Copyright © 2018年 Mitake. All rights reserved.
//

#import "NSNumber+PKStockChart.h"

@implementation NSNumber (PKStockChart)

+ (NSString *)pk_stringWithDigits:(NSNumber *)number keepPlaces:(short)place {
    CGFloat numberValue = number.doubleValue;
    CGFloat factor = pow(10, place);
    CGFloat targetValue = (floor(numberValue * factor + 0.5)) / factor;
    return [NSString stringWithFormat:@"%.*lf", place, targetValue];
}

+ (NSString *)pk_stringWithDoubleDigits:(NSNumber *)number {
    return [self pk_stringWithDigits:number keepPlaces:2];
}

+ (NSString *)pk_percentStringWithDoubleDigits:(NSNumber *)number {
    CGFloat numberValue = number.doubleValue * 100;
    NSString *targetValue = [NSNumber pk_stringWithDoubleDigits:@(numberValue)];
    return [NSString stringWithFormat:@"%@%%", targetValue];
}

+ (double)pk_makeFactors:(CGFloat)value units:(NSString *__autoreleasing *)unitsFlag {
    NSInteger index = 0; *unitsFlag = @"";
    if (value < 10000) {
    } else if (value < 100000000) {
        index = 4; *unitsFlag = @"万";
    } else if (value < 1000000000000) {
        index = 8; *unitsFlag = @"亿";
    } else {
        index = 12; *unitsFlag = @"万亿";
    }
    return pow(10, index);
}

+ (NSString *)pk_trillionStringWithDigits:(NSNumber *)number keepPlaces:(short)place {
    CGFloat numberValue = number.doubleValue;
    NSString *unit = @"";
    double factor = [self pk_makeFactors:fabs(numberValue) units:&unit];
    CGFloat value1 = numberValue / factor;
    NSString *string = [NSNumber pk_stringWithDigits:@(value1) keepPlaces:place];
    return [string stringByAppendingString:unit];
}

+ (NSString *)pk_trillionStringWithDoubleDigits:(NSNumber *)number {
    return [self pk_trillionStringWithDigits:number keepPlaces:2];
}

@end
