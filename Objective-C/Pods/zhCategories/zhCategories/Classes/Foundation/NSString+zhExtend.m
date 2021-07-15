
//
//  NSString+zhExtend.m
//  zhCategoryKit
//
//  Created by zhanghao on 2016/12/7.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "NSString+zhExtend.h"

@implementation NSString (zhExtend)

- (BOOL)zh_isNotEmpty {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)zh_substringToIndex:(NSUInteger)to {
    if (![self zh_isNotEmpty]) {
        return @"";
    }
    if (to > self.length - 1) {
        return @"";
    }
    return  [self substringToIndex:to];
}

- (NSString *)zh_substringFromIndex:(NSUInteger)from {
    if (![self zh_isNotEmpty]) {
        return @"";
    }
    if (from > self.length - 1) {
        return @"";
    }
    return [self substringFromIndex:from];
}

- (NSString *)zh_deleteFirstCharacter {
    return [self zh_substringFromIndex:1];
}

- (NSString *)zh_deleteLastCharacter {
    return [self zh_substringToIndex:self.length - 1];
}

- (NSString *)zh_stringByEscapingHTML {
    NSUInteger len = self.length;
    if (!len) return self;
    
    unichar *buf = malloc(sizeof(unichar) * len);
    if (!buf) return self;
    [self getCharacters:buf range:NSMakeRange(0, len)];
    
    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < len; i++) {
        unichar c = buf[i];
        NSString *esc = nil;
        switch (c) {
            case 34: esc = @"&quot;"; break;
            case 38: esc = @"&amp;"; break;
            case 39: esc = @"&apos;"; break;
            case 60: esc = @"&lt;"; break;
            case 62: esc = @"&gt;"; break;
            default: break;
        }
        if (esc) {
            [result appendString:esc];
        } else {
            CFStringAppendCharacters((CFMutableStringRef)result, &c, 1);
        }
    }
    free(buf);
    return result;
}

- (NSString *)zh_trimmingWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)zh_trimmingNewlineWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)zh_trimmingAllWhitespace {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)zh_formattedTrimmingWhitespace {
    NSString *aString = [self zh_trimmingWhitespace];
    NSArray<NSString *> *components = [aString componentsSeparatedByCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
    components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
    return [components componentsJoinedByString:@" "];
}

- (BOOL)zh_greaterVersionCompare:(NSString *)aString {
    // NSNumericSearch 按照字符串里的数字为依据，算出顺序. 如 2.txt < 7.txt < 9.25.txt
    NSComparisonResult result = [aString compare:self options:NSNumericSearch];
    return !(result == NSOrderedSame || result == NSOrderedDescending);
}

- (NSString *)zh_unwontedCharacterEncoding {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSDictionary *)zh_JSONToDictionary {
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:self];
    id obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
#ifdef DEBUG
        NSLog(@"fail to get dictioanry from JSON: %@, error: %@", self, error);
#endif
        return nil;
    }
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)obj;
    }
    return nil;
}

- (NSArray *)zh_JSONToArray {
    NSError *error;
    //        NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithContentsOfFile:self];
    id obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
#ifdef DEBUG
        NSLog(@"fail to get array from JSON: %@, error: %@", self, error);
#endif
        return nil;
    }
    
    if ([obj isKindOfClass:[NSArray class]]) {
        return (NSArray *)obj;
    }
    return nil;
}

@end
