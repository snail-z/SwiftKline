//
//  UIButton+zhEnlargeTouchArea.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/2.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UIButton+zhEnlargeTouchArea.h"
#import <objc/runtime.h>

static void *UIButtonAssociatedEnlargeTouchAreaKey = &UIButtonAssociatedEnlargeTouchAreaKey;

@implementation UIButton (zhEnlargeTouchArea)

- (UIEdgeInsets)zh_enlargeTouchEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, UIButtonAssociatedEnlargeTouchAreaKey);
    return [value UIEdgeInsetsValue];
}

- (void)setZh_enlargeTouchEdgeInsets:(UIEdgeInsets)zh_enlargeTouchEdgeInsets {
    objc_setAssociatedObject(self, UIButtonAssociatedEnlargeTouchAreaKey, [NSValue valueWithUIEdgeInsets:zh_enlargeTouchEdgeInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)zh_enlargedRect {
    UIEdgeInsets insets = self.zh_enlargeTouchEdgeInsets;
    if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, insets)) {
        return self.bounds;
    }
    return CGRectMake(self.bounds.origin.x - insets.left,
                      self.bounds.origin.y - insets.top,
                      self.bounds.size.width + insets.left + insets.right,
                      self.bounds.size.height + insets.top + insets.bottom);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // 取消pointInside函数的检测
    if (self.isUserInteractionEnabled && !self.isHidden && self.alpha > 0) {
        CGRect rect = [self zh_enlargedRect];
        if (CGRectEqualToRect(rect, self.bounds)) {
            return [super hitTest:point withEvent:event];
        }
        return CGRectContainsPoint(rect, point) ? self : nil;
    }
    return nil;
}

@end
