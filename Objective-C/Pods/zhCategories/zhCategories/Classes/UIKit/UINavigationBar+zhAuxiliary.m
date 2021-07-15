//
//  UINavigationBar+zhAuxiliary.m
//  zhCategories_Example
//
//  Created by zhanghao on 2017/12/25.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UINavigationBar+zhAuxiliary.h"
#import <objc/runtime.h>

@implementation UINavigationBar (zhAuxiliary)

- (UIFont *)zh_getTitleTextFont {
    NSDictionary *originAttributes = [self titleTextAttributes];
    id value = [originAttributes objectForKey:NSFontAttributeName];
    if ([value isKindOfClass:[UIFont class]]) return (UIFont *)value;
    return nil;
}

- (UIColor *)zh_getTitleTextColor {
    NSDictionary *originAttributes = [self titleTextAttributes];
    id value = [originAttributes objectForKey:NSForegroundColorAttributeName];
    if ([value isKindOfClass:[UIColor class]]) return (UIColor *)value;
    return nil;
}

- (void)zh_setTitleTextFont:(UIFont *)textFont andTextColor:(UIColor *)textColor {
    NSDictionary *originAttributes = [self titleTextAttributes];
    NSMutableDictionary *textAttributes = originAttributes ? originAttributes.mutableCopy : @{}.mutableCopy;
    if (textFont) textAttributes[NSFontAttributeName] = textFont;
    if (textColor) textAttributes[NSForegroundColorAttributeName] = textColor;
    self.titleTextAttributes = textAttributes;
}

- (UIImageView *)zh_backgroundImageView {
    UIImageView *backgroundImgView = objc_getAssociatedObject(self, _cmd);
    if (!backgroundImgView) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        backgroundImgView = [[UIImageView alloc] init];
        CGFloat statusBarHeight = 20;
        if ([NSStringFromCGSize([UIScreen mainScreen].bounds.size) isEqualToString:@"{375, 812}"]) {
            statusBarHeight = 44; // iphone X
        }
        backgroundImgView.frame = CGRectMake(0, 0,
                                          CGRectGetWidth(self.bounds),
                                          CGRectGetHeight(self.bounds) + statusBarHeight);
        backgroundImgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        objc_setAssociatedObject(self, _cmd, backgroundImgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        // _UIBarBackground is first subView for navigationBar
        [self.subviews.firstObject insertSubview:backgroundImgView atIndex:0];
    }
    return backgroundImgView;
}

- (UIColor *)zh_backgroundColor {
    return [self zh_backgroundImageView].backgroundColor;
}

- (void)zh_setBackgroundColor:(UIColor *)zh_backgroundColor {
    [self zh_backgroundImageView].image = nil;
    [self zh_backgroundImageView].backgroundColor = zh_backgroundColor;
}

- (UIImage *)zh_backgroundImage {
    return [self zh_backgroundImageView].image;
}

- (void)zh_setBackgroundImage:(UIImage *)zh_backgroundImage {
    [self zh_backgroundImageView].backgroundColor = [UIColor clearColor];
    [self zh_backgroundImageView].image = zh_backgroundImage;
}

- (CGFloat)zh_backgroundAlpha {
    return [self zh_backgroundImageView].alpha;
}

- (void)zh_setBackgroundAlpha:(CGFloat)zh_backgroundAlpha {
    [self zh_backgroundImageView].alpha = zh_backgroundAlpha;
}

- (void)zh_setItemsAlpha:(CGFloat)alpha excludeBackIndicator:(BOOL)excludeBackIndicator {
    objc_setAssociatedObject(self, @selector(zh_getItemsAlpha), @(alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    void (^callback)(UIView *, CGFloat) = ^(UIView *view, CGFloat alpha){
        Class _UIBarBackgroundClass = NSClassFromString(@"_UIBarBackground");
        if (![view isKindOfClass:_UIBarBackgroundClass]) {
            view.alpha = alpha;
        }
        Class _UINavigationBarBackground = NSClassFromString(@"_UINavigationBarBackground");
        if (![view isKindOfClass:_UINavigationBarBackground]) {
            view.alpha = alpha;
        }
    };
    for (UIView *view in self.subviews) {
        if (excludeBackIndicator) { // 不包括系统的返回按钮
            if (![view isKindOfClass:NSClassFromString(@"_UINavigationBarBackIndicatorView")]) {
                callback(view, alpha);
            }
        } else {
            callback(view, alpha);
        }
    }
}

- (CGFloat)zh_getItemsAlpha {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

@end
