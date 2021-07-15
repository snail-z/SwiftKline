//
//  NSURL+zhExtend.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/14.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "NSURL+zhExtend.h"

@implementation NSURL (zhExtend)

- (NSDictionary *)zh_parameters {
    NSMutableDictionary *parametersDictionary = [NSMutableDictionary dictionary];
    NSArray *queryComponents = [self.query componentsSeparatedByString:@"&"];
    for (NSString *queryComponent in queryComponents) {
        NSString *key = [queryComponent componentsSeparatedByString:@"="].firstObject;
        NSString *value = [queryComponent substringFromIndex:(key.length + 1)];
        [parametersDictionary setObject:value forKey:key];
    }
    return parametersDictionary;
}

@end
