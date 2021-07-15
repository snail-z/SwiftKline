//
//  UITextField+zhContentInsets.m
//  zhCategories_Example
//
//  Created by zhanghao on 2016/12/25.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UITextField+zhContentInsets.h"
#import <objc/runtime.h>

@implementation UITextField (zhContentInsets)

+ (void)load {
    SEL selectors[] = {
        @selector(placeholderRectForBounds:),
        @selector(textRectForBounds:),
        @selector(editingRectForBounds:)
    };
    
    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"zh_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (CGRect)zh_placeholderRectForBounds:(CGRect)bounds {
    [self zh_placeholderRectForBounds:bounds];
    return UIEdgeInsetsInsetRect(bounds, self.zh_placeHolderInsets);
}

- (CGRect)zh_textRectForBounds:(CGRect)bounds {
    CGRect rect = [self zh_textRectForBounds:bounds];
    return UIEdgeInsetsInsetRect(rect, self.zh_textInsets);
}

- (CGRect)zh_editingRectForBounds:(CGRect)bounds {
    CGRect rect = [self zh_textRectForBounds:bounds];
    return UIEdgeInsetsInsetRect(rect, self.zh_textInsets);
}

- (UIEdgeInsets)zh_textInsets {
    NSValue *value = objc_getAssociatedObject(self, _cmd);
    return [value UIEdgeInsetsValue];
}

- (void)setZh_textInsets:(UIEdgeInsets)zh_textInsets {
    NSValue *value = [NSValue valueWithUIEdgeInsets:zh_textInsets];
    objc_setAssociatedObject(self, @selector(zh_textInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)zh_placeHolderInsets {
    NSValue *value = objc_getAssociatedObject(self, _cmd);
    return [value UIEdgeInsetsValue];
}

- (void)setZh_placeHolderInsets:(UIEdgeInsets)zh_placeHolderInsets {
    NSValue *value = [NSValue valueWithUIEdgeInsets:zh_placeHolderInsets];
    objc_setAssociatedObject(self, @selector(zh_placeHolderInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
