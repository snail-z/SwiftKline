//
//  UIView+zhExtend.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/6.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UIView+zhExtend.h"

@implementation UIView (zhExtend)

- (void)zh_removeAllSubviews {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

- (UIViewController *)zh_inViewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
