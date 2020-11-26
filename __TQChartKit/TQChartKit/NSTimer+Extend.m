//
//  NSTimer+Extend.m
//  CoreGraphics_demo
//
//  Created by zhanghao on 2018/6/6.
//  Copyright © 2018年 snail-z. All rights reserved.
//

#import "NSTimer+Extend.h"

@implementation NSTimer (Extend)

+ (double)tq_runningTimeBlock:(void (^)(void))block {
    double a = CFAbsoluteTimeGetCurrent();
    block();
    double b = CFAbsoluteTimeGetCurrent();
    return (b - a) * 1000.f; // to millisecond
}

+ (double)tq_runningTimeBlock:(void (^)(void))block withPrefix:(NSString *)prefix {
    double ms = [self tq_runningTimeBlock:block];
    NSString *string = [NSString stringWithFormat:@" Takes %@ ms.", @(ms)];
    NSString *logString = [prefix stringByAppendingString:string];
    NSLog(@"%@", logString);
    return ms;
}

@end
