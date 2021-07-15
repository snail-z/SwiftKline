//
//  UIButton+zhCountdown.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/3.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (zhCountdown)

/**
 开始倒计时 (计量单位:秒) (倒计时期间按钮将不可点击，直到倒计时结束恢复可用)
 @param totalSeconds : 倒计时总秒
 @param changed  : 倒计时改变回调
 @param finished : 倒计时结束回调
 */
- (void)zh_startCountdown:(NSUInteger)totalSeconds
           changedHandler:(void (^)(UIButton *button, NSString *seconds))changed
          finishedHandler:(void (^)(UIButton *button))finished;

/** 开始倒计时并设置等待中文本内容 */
- (void)zh_startCountdown:(NSUInteger)totalSeconds waitingText:(NSString *)waitingText;

@end
