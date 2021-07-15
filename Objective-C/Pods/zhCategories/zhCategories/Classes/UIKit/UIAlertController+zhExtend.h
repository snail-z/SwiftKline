//
//  UIAlertController+zhExtend.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/13.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (zhExtend)

+ (void)zh_testAlert:(NSString *)text;
+ (void)zh_testAlert:(NSString *)message inVC:(UIViewController *)vc;

@end
