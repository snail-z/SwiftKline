//
//  NSString+zhMatched.m
//  Pods-zhCategories_Example
//
//  Created by zhanghao on 2018/5/25.
//

#import "NSString+zhMatched.h"

@implementation NSString (zhMatched)

- (BOOL)zh_validateRegex:(NSString *)regex{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)zh_isMobileNumber {
    NSString *mobile = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11) return NO;
    // 号段正则表达式 (2018年01)
    NSString *mobileRegex = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
    return [self zh_validateRegex:mobileRegex];
}

- (BOOL)zh_isEmailAddress {
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self zh_validateRegex:emailRegex];
}

- (BOOL)zh_isPureChinese {
    NSString *chineseRegex = @"^[0-8]\\d{5}(?!\\d)$";
    return [self zh_validateRegex:chineseRegex];
}

- (BOOL)zh_isPostalCode {
    NSString *postalRegex = @"^[0-8]\\d{5}(?!\\d)$";
    return [self zh_validateRegex:postalRegex];
}

@end
