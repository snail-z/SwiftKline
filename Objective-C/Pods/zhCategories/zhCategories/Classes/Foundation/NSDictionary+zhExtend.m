//
//  NSDictionary+zhExtend.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/12.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "NSDictionary+zhExtend.h"

@implementation NSDictionary (zhExtend)

- (NSArray *)zh_allKeysSorted {
    return [[self allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSArray *)zh_allValuesSortedByKeys {
    NSArray *sortedKeys = [self zh_allKeysSorted];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (id key in sortedKeys) {
        [arr addObject:self[key]];
    }
    return [arr copy];
}

- (NSString *)zh_convertToURLString {
    NSMutableString *string = [NSMutableString string];
    for (NSString *key in [self allKeys]) {
        if ([string length]) {
            [string appendString:@"&"];
        }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringRef escaped = CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)[[self objectForKey:key] description],
                                                                      NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                      kCFStringEncodingUTF8);
        [string appendFormat:@"%@=%@", key, escaped];
        CFRelease(escaped);
#pragma clang diagnostic pop
    }
    return string;
}

@end
