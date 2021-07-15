//
//  UIButton+zhIndicator.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/2.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (zhIndicator)

- (void)zh_showIndicator;
- (void)zh_showIndicatorHideSelfWithTintColor:(UIColor *)tintColor;
- (void)zh_showIndicatorText:(NSString *)text;
- (void)zh_hideIndicator;

@property (nonatomic, assign, readonly) BOOL zh_indicatorShowing;

@end
