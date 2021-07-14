//
//  NSTimer+Extend.h
//  CoreGraphics_demo
//
//  Created by zhanghao on 2018/6/6.
//  Copyright © 2018年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Extend)

+ (double)tq_runningTimeBlock:(void (^)(void))block;
+ (double)tq_runningTimeBlock:(void (^)(void))block withPrefix:(NSString *)prefix;

@end
