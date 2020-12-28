//
//  NSNumber+PKExtend.m
//  PKCategories
//
//  Created by zhanghao on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "NSNumber+PKExtend.h"

@implementation NSNumber (PKExtend)

+ (NSNumber *)pk_numberWithString:(NSString *)string {
    NSString *str = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].lowercaseString;
    if (!str || !str.length) return nil;
    static NSDictionary *dict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dict = @{@"true" :   @(YES),
                @"yes" :    @(YES),
                @"false" :  @(NO),
                @"no" :     @(NO),
                @"nil" :    [NSNull null],
                @"null" :   [NSNull null],
                @"<null>" : [NSNull null]};
    });
    id num = dict[str];
    if (num) {
        if (num == [NSNull null]) return nil;
        return num;
    }
    int sign = 0;
    if ([str hasPrefix:@"0x"]) sign = 1;
    else if ([str hasPrefix:@"-0x"]) sign = -1;
    if (sign != 0) {
        NSScanner *scan = [NSScanner scannerWithString:str];
        unsigned num = -1;
        BOOL suc = [scan scanHexInt:&num];
        if (suc)
            return [NSNumber numberWithLong:((long)num * sign)];
        else
            return nil;
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter numberFromString:string];
}

+ (NSString *)pk_stringWithDigits:(NSNumber *)number keepPlaces:(short)place {
    CGFloat numberValue = number.doubleValue;
    CGFloat factor = pow(10, place);
    CGFloat targetValue = (floor(numberValue * factor + 0.5)) / factor;
    return [NSString stringWithFormat:@"%.*lf", place, targetValue];
}

+ (NSString *)pk_stringWithDoubleDigits:(NSNumber *)number {
    return [self pk_stringWithDigits:number keepPlaces:2];
}

+ (NSString *)pk_stringWithPlainDigits:(NSNumber *)number keepPlaces:(short)place {
    CGFloat numberValue = number.doubleValue;
    CGFloat factor = pow(10, place);
    CGFloat targetValue = ((NSInteger)(numberValue * factor)) / factor;
    return [NSString stringWithFormat:@"%.*lf", place, targetValue];
}

+ (NSString *)pk_stringWithPlainDoubleDigits:(NSNumber *)number {
    return [self pk_stringWithPlainDigits:number keepPlaces:2];
}

+ (NSString *)pk_percentStringWithDoubleDigits:(NSNumber *)number {
    CGFloat numberValue = number.doubleValue * 100;
    NSString *targetValue = [NSNumber pk_stringWithDoubleDigits:@(numberValue)];
    return [NSString stringWithFormat:@"%@%%", targetValue];
}

+ (NSString *)pk_percentStringWithPlainDoubleDigits:(NSNumber *)number {
    CGFloat numberValue = number.doubleValue * 100;
    NSString *targetValue = [NSNumber pk_stringWithPlainDoubleDigits:@(numberValue)];
    return [NSString stringWithFormat:@"%@%%", targetValue];
}

+ (NSString *)pk_percentStringWithTidyDigits:(NSNumber *)number {
    /**
     [NSString stringWithFormat:@"%@", number];
     [NSNumberFormatter localizedStringFromNumber:number numberStyle:NSNumberFormatterPercentStyle];
     系统方法四舍五入不准确，有偶数舍，奇数入问题，结果如下：
     0.125 => 12%
     0.135 => 14%
    */
    NSString *numberString = [NSNumber pk_stringWithDigits:number keepPlaces:2];
    NSInteger targetValue = (NSInteger)(numberString.doubleValue * 100);
    return [NSString stringWithFormat:@"%@%%", @(targetValue)];
}

+ (NSNumber *)pk_numberWithPercentString:(NSString *)aString {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterPercentStyle;
    return [formatter numberFromString:aString];
}

+ (NSString *)pk_currencyStringWithDigits:(NSNumber *)number {
    return [NSNumberFormatter localizedStringFromNumber:number numberStyle:NSNumberFormatterCurrencyStyle];
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

- (BOOL)pk_isEqualZero {
    return [self pk_isEqualZeroWithMinimumError:1e-6];
}

- (BOOL)pk_isEqualZeroWithMinimumError:(CGFloat)minimumError {
    if (minimumError < 0) minimumError = 1e-6;
    CGFloat _EPSILON = minimumError;
    return (fabs(self.doubleValue) < _EPSILON);
}

- (BOOL)isFloatNumber:(NSString *)string {
    if (string.length > 0) {
        NSScanner *scan = [NSScanner scannerWithString:string];
        double value;
        return [scan scanDouble:&value] && [scan isAtEnd];
    }
    return NO;
}

- (BOOL)isIntegerNumber:(NSString *)string {
    if (string.length > 0) {
        NSScanner *scan = [NSScanner scannerWithString:string];
        NSInteger val;
        return [scan scanInteger:&val] && [scan isAtEnd];
    }
    return NO;
}

@end
