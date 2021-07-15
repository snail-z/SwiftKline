//
//  UIButton+zhIndicator.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/2.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UIButton+zhIndicator.h"
#import <objc/runtime.h>

static void *UIButtonAssociatedIndicatorViewKey = &UIButtonAssociatedIndicatorViewKey;
static void *UIButtonAssociatedCurrentTitleKey = &UIButtonAssociatedCurrentTitleKey;
static void *UIButtonAssociatedTitleEdgeInsetsKey = &UIButtonAssociatedTitleEdgeInsetsKey;
static void *UIButtonAssociatedBackgroundColorKey = &UIButtonAssociatedBackgroundColorKey;

@implementation UIButton (zhIndicator)

- (BOOL)zh_indicatorShowing {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setZh_indicatorShowing:(BOOL)zh_indicatorShowing {
    objc_setAssociatedObject(self, @selector(zh_indicatorShowing), @(zh_indicatorShowing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)zh_showIndicator {
    [self zh_showIndicatorWithTintColor:[UIColor whiteColor] hideSelf:NO];
}

- (void)zh_showIndicatorHideSelfWithTintColor:(UIColor *)tintColor {
    [self zh_showIndicatorWithTintColor:tintColor hideSelf:YES];
}

- (void)zh_showIndicatorWithTintColor:(UIColor *)tintColor hideSelf:(BOOL)flag {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    indicator.color = tintColor;
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    indicator.transform = transform;
    objc_setAssociatedObject(self, UIButtonAssociatedIndicatorViewKey, indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (flag) {
        UIColor *currentBackgroundColor = self.backgroundColor;
        objc_setAssociatedObject(self, UIButtonAssociatedBackgroundColorKey, currentBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.backgroundColor = [UIColor clearColor];
    }
    
    NSString *currentButtonTitle = self.currentTitle;
    objc_setAssociatedObject(self, UIButtonAssociatedCurrentTitleKey, currentButtonTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setTitle:@"" forState:UIControlStateNormal];
    self.userInteractionEnabled = NO;
    
    [indicator startAnimating];
    [self addSubview:indicator];
    [self setZh_indicatorShowing:YES];
}

- (void)zh_hideIndicator {
    id object = objc_getAssociatedObject(self, UIButtonAssociatedBackgroundColorKey);
    if (object) {
        self.backgroundColor = (UIColor *)object;
    }
    
    NSValue *value = objc_getAssociatedObject(self, UIButtonAssociatedTitleEdgeInsetsKey);
    if (value) {
        UIEdgeInsets titleEdgeInsets = [value UIEdgeInsetsValue];
        self.titleEdgeInsets = titleEdgeInsets;
    }
    
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)objc_getAssociatedObject(self, UIButtonAssociatedIndicatorViewKey);
    if (!indicator) return;
    [indicator stopAnimating];
    [indicator removeFromSuperview];
    NSString *currentButtonTitle = (NSString *)objc_getAssociatedObject(self, UIButtonAssociatedCurrentTitleKey);
    [self setTitle:currentButtonTitle forState:UIControlStateNormal];
    self.userInteractionEnabled = YES;
    [self setZh_indicatorShowing:NO];
}

- (void)zh_showIndicatorText:(NSString *)text {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.color = [UIColor whiteColor];
    objc_setAssociatedObject(self, UIButtonAssociatedIndicatorViewKey, indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    NSString *currentButtonTitle = self.currentTitle;
    objc_setAssociatedObject(self, UIButtonAssociatedCurrentTitleKey, currentButtonTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setTitle:text forState:UIControlStateNormal];
    
    CGFloat spacing = 15;
    CGSize size = [self.titleLabel sizeThatFits:self.bounds.size];
    CGFloat padding = (self.bounds.size.width - size.width) / 2;
    CGFloat indicatorW = indicator.bounds.size.width;
    CGFloat offset = (self.bounds.size.width - indicatorW - size.width - spacing) / 2;
    indicator.center = CGPointMake(offset + indicatorW / 2, self.bounds.size.height / 2);
    
    NSValue *value = [NSValue valueWithUIEdgeInsets:self.titleEdgeInsets];
    objc_setAssociatedObject(self, UIButtonAssociatedTitleEdgeInsetsKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, padding, 0, -padding + offset * 2);
    
    [indicator startAnimating];
    [self addSubview:indicator];
    self.userInteractionEnabled = NO;
    [self setZh_indicatorShowing:YES];
}

@end
