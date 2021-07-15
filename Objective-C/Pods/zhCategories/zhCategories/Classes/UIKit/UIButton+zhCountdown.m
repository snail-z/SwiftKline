//
//  UIButton+zhCountdown.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/3.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UIButton+zhCountdown.h"

@implementation UIButton (zhCountdown)

- (void)zh_startCountdown:(NSUInteger)totalSeconds changedHandler:(void (^)(UIButton *, NSString *))changed finishedHandler:(void (^)(UIButton *))finished {
    __block NSUInteger timeout = totalSeconds;
    dispatch_queue_t _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.f * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setUserInteractionEnabled:YES];
                finished(self);
            });
        } else {
            NSUInteger seconds = timeout;
            NSString *timeString = [NSString stringWithFormat:@"%.2lu", (unsigned long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setUserInteractionEnabled:NO];
                changed(self, timeString);
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)zh_startCountdown:(NSUInteger)totalSeconds waitingText:(NSString *)waitingText {
    NSString *currentTitle = self.currentTitle;
    [self zh_startCountdown:totalSeconds changedHandler:^(UIButton *button, NSString *seconds) {
        NSString *title = [NSString stringWithFormat:@"%@%@", seconds, waitingText];
        [button setTitle:title forState:UIControlStateNormal];
    } finishedHandler:^(UIButton *button) {
        [button setTitle:currentTitle forState:UIControlStateNormal];
    }];
}

@end
