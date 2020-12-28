//
//  NSTimer+PKExtend.m
//  PKCategories
//
//  Created by jiaohong on 2018/10/27.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "NSTimer+PKExtend.h"

@implementation NSTimer (PKExtend)

+ (double)pk_runingTimeConsumingBlock:(void ( ^)(void))block {
    double a = CFAbsoluteTimeGetCurrent();
    if (block) block();
    double b = CFAbsoluteTimeGetCurrent();
    return (b - a) * 1000.0; // to millisecond
}

+ (void)_pk_ExecBlock:(NSTimer *)timer {
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        if (block) {
            block(timer);
        }
    }
}

+ (NSTimer *)pk_scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer * _Nonnull))block repeats:(BOOL)repeats {
    return [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(_pk_ExecBlock:) userInfo:[block copy] repeats:repeats];
}

+ (NSTimer *)pk_timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer * _Nonnull))block repeats:(BOOL)repeats {
    return [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(_pk_ExecBlock:) userInfo:[block copy] repeats:repeats];
}

@end
