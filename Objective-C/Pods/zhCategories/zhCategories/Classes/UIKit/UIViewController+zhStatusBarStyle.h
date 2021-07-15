//
//  UIViewController+zhStatusBarStyle.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/13.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (zhStatusBarStyle)

@property (nonatomic, assign) BOOL zh_statusBarHidden;
@property (nonatomic, assign) UIStatusBarStyle zh_statusBarStyle;

/** 将状态栏恢复到系统默认值 */
- (void)zh_statusBarRestoreDefaults;

@end
