//
//  UIScrollView+zhTopDecorativeView.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/2.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UIScrollView+zhTopDecorativeView.h"
#import <objc/runtime.h>

@implementation UIScrollView (zhTopDecorativeView)

- (UIImageView *)zh_topDecorativeView {
    UIImageView *view = objc_getAssociatedObject(self, _cmd);
    if (!view) {
        view = [[UIImageView alloc] init];
        [self insertSubview:view atIndex:0];
        objc_setAssociatedObject(self, _cmd, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (!self.translatesAutoresizingMaskIntoConstraints) {
        [self.superview layoutIfNeeded];
    }
    CGSize size = self.bounds.size;
    view.frame = CGRectMake(0, -size.height - self.contentInset.top, size.width, size.height);
    return view;
}

@end
