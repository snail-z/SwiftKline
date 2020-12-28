//
//  NSString+PKExtend.m
//  PKCategories
//
//  Created by zhanghao on 2018/10/27.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "NSString+PKExtend.h"
#import "NSData+PKExtend.h"

@implementation NSString (PKExtend)

- (BOOL)pk_isNotEmpty {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)pk_frontSubstringToIndex:(NSUInteger)toIndex {
    if (![self pk_isNotEmpty]) {
        return @"";
    }
    if (toIndex > self.length - 1) {
        return @"";
    }
    return  [self substringToIndex:toIndex];
}

- (NSString *)pk_backSubstringFromIndex:(NSUInteger)fromIndex {
    if (![self pk_isNotEmpty]) {
        return @"";
    }
    if (fromIndex > self.length - 1) {
        return @"";
    }
    return [self substringFromIndex:fromIndex];
}

- (NSString *)pk_deleteFirstCharacter {
    return [self pk_backSubstringFromIndex:1];
}

- (NSString *)pk_deleteLastCharacter {
    return [self pk_frontSubstringToIndex:self.length - 1];
}

- (NSString *)pk_trimmingAllWhitespace {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)pk_trimmingWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)pk_trimmingNewlineAndWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)pk_trimmingWithCharactersInString:(NSString *)aString {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:aString];
    return [[self componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
}

- (NSString *)pk_stringByURLQueryAllowedEncode {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)pk_stringByURLEncode {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSString *outputString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                       (__bridge CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
#pragma clang diagnostic pop
    return outputString;
}

- (BOOL)pk_isGreaterThanByNumericSearchCompare:(NSString *)other {
    NSComparisonResult result = [other compare:self options:NSNumericSearch];
    return !(result == NSOrderedSame || result == NSOrderedDescending);
}

- (NSData *)pk_dataValue {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSRange)pk_rangeOfAll {
    return NSMakeRange(0, self.length);
}

- (id)pk_jsonValueDecoded {
    return [self.pk_dataValue pk_jsonValueDecoded];
}

- (CGSize)pk_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if (self.length <= 0 || [self isEqualToString:@""] || [self isEqualToString:@"(null)"]) {
        return CGSizeZero;
    }
    if (!font) font = [UIFont systemFontOfSize:UIFont.systemFontSize];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[NSFontAttributeName] = font;
    if (lineBreakMode != NSLineBreakByWordWrapping) {
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = lineBreakMode;
        dictionary[NSParagraphStyleAttributeName] = paragraphStyle;
    }
    CGRect rect = [self boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:dictionary context:nil];
    CGSize result = rect.size;
    return CGSizeMake(ceil(result.width), ceil(result.height));
}

- (CGSize)pk_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    return [self pk_sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGFloat)pk_heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width {
    return [self pk_sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
}

- (CGFloat)pk_widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height {
    return [self pk_sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping].width;
}

@end


@implementation NSString (PKHash)

- (NSString *)pk_md5String {
    NSData *data =[self dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) return nil;
    return [data pk_md5String];
}

@end



@implementation NSString (PKMatched)

- (BOOL)pk_matchesRegex:(NSString *)regex {
    NSError *error = nil;
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionAnchorsMatchLines error:&error];
    if (error) {
        NSLog(@"NSString(PKMatched) create regex error: %@", error);
        return NO;
    }
    return ([pattern numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)] > 0);
}

- (BOOL)pk_isValidByRegex:(NSString *)regex {
    return [self pk_validateRegex:regex];
}

- (BOOL)pk_validateRegex:(NSString *)regex {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)pk_isAllNumbers {
    NSString *regex = @"(^[0-9]*$)";
    return [self pk_validateRegex:regex];
}

- (BOOL)pk_isAllChineseCharacters {
    NSString *chineseRegex = @"[\u4e00-\u9fa5]+";
    return [self pk_validateRegex:chineseRegex];
}

- (BOOL)pk_isValidEmailAddress {
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self pk_validateRegex:emailRegex];
}

- (BOOL)pk_isValidPostalCode {
    NSString *postalRegex = @"^[0-8]\\d{5}(?!\\d)$";
    return [self pk_validateRegex:postalRegex];
}

- (BOOL)pk_isValidMobileNumber {
    NSString *mobile = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11) return NO;
    NSString *regex = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
    return [self pk_validateRegex:regex];
}

- (BOOL)pk_isValidIDCard {
    NSString *regex = @"(\\d{14}[0-9a-zA-Z])|(\\d{17}[0-9a-zA-Z])";
    return [self pk_validateRegex:regex];
}

- (BOOL)pk_isValidIDCardNumber {
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    return [self pk_validateRegex:regex];
}

- (BOOL)pk_isValidURL {
    NSString *regex = @"^((http)|(https))+:[^\\s]+\\.[^\\s]*$";
    return [self pk_validateRegex:regex];
}

@end
