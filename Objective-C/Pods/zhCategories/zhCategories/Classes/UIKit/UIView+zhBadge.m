//
//  UIView+zhBadge.m
//  zhCategories_Example
//
//  Created by zhanghao on 2017/12/21.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UIView+zhBadge.h"
#import <objc/runtime.h>

static void *UIViewAssociatedBadgeLabelKey = &UIViewAssociatedBadgeLabelKey;

@implementation UIView (zhBadge)

- (CGRect)_defaultRect {
    return CGRectMake(0, 0, 18, 18);
}

- (UILabel *)zh_badgeLabel {
    UILabel *badgeLabel = objc_getAssociatedObject(self, UIViewAssociatedBadgeLabelKey);
    if (!badgeLabel) {
        badgeLabel = [[UILabel alloc] init];
        badgeLabel.backgroundColor = [UIColor redColor];
        badgeLabel.textColor = [UIColor whiteColor];
        badgeLabel.font = [UIFont systemFontOfSize:13];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.frame = [self _defaultRect];
        badgeLabel.center = CGPointMake(self.bounds.size.width, 0);
        badgeLabel.layer.cornerRadius = badgeLabel.frame.size.height / 2;
        badgeLabel.layer.masksToBounds = YES;
        badgeLabel.alpha = 0;
        [self addSubview:badgeLabel];
        [self bringSubviewToFront:badgeLabel];
        objc_setAssociatedObject(self, UIViewAssociatedBadgeLabelKey, badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return badgeLabel;
}

- (void)setBadgeText:(NSString *)text {
    self.zh_badgeLabel.transform = CGAffineTransformIdentity;
    self.zh_badgeLabel.text = text;
    
    if (text && text.length) {
        self.zh_badgeLabel.frame = [self _defaultRect];
        CGFloat _width = [self.zh_badgeLabel sizeThatFits:CGSizeMake(MAXFLOAT, self.zh_badgeLabel.frame.size.height)].width;
        CGRect originRect = self.zh_badgeLabel.frame;
        originRect.size.width = _width + 8;
        if (originRect.size.height > originRect.size.width) {
            originRect.size.width = originRect.size.height; // 使宽度>=高度
        }
        self.zh_badgeLabel.frame = originRect;
    }
    
    if ([self zh_badgeAlwaysRound]) {
        CGPoint originCenter = self.zh_badgeLabel.center;
        CGRect originRect = self.zh_badgeLabel.frame;
        originRect.size.height = originRect.size.width;
        self.zh_badgeLabel.frame  = originRect;
        self.zh_badgeLabel.layer.cornerRadius = self.zh_badgeLabel.frame.size.height / 2;
        self.zh_badgeLabel.center = originCenter;
    }
    
    CGFloat transformHeight = [self zh_badgeTransformHeight];
    if (transformHeight > 0) {
        CGFloat scale = transformHeight / self.zh_badgeLabel.frame.size.height;
        CGAffineTransform transform = self.zh_badgeLabel.transform;
        self.zh_badgeLabel.transform = CGAffineTransformScale(transform, scale, scale);
    }
    
    [self zh_badgeOffset:[self zh_badgeOffset]];
}

- (void)zh_badgeShowText:(NSString *)text {
    [self setBadgeText:text];
    if (self.zh_badgeLabel.alpha > 0) return;
    self.zh_badgeLabel.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.zh_badgeLabel.alpha = 1;
    }];
}

- (void)zh_badgeHide {
    if (self.zh_badgeLabel.alpha > 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.zh_badgeLabel.alpha = 0;
        }];
    }
}

- (void)zh_badgeRemove {
    [UIView animateWithDuration:0.25 animations:^{
        self.zh_badgeLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [self.zh_badgeLabel removeFromSuperview];
        objc_setAssociatedObject(self, @selector(zh_badgeAlwaysRound), @(NO), OBJC_ASSOCIATION_ASSIGN);
        objc_setAssociatedObject(self, @selector(zh_badgeOffset), [NSValue valueWithUIOffset:UIOffsetZero], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, UIViewAssociatedBadgeLabelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }];
}

- (UIOffset)zh_badgeOffset {
    NSValue *value = objc_getAssociatedObject(self, _cmd);
    return [value UIOffsetValue];
}

- (void)zh_badgeOffset:(UIOffset)offset {
    NSValue *value = [NSValue valueWithUIOffset:offset];
    objc_setAssociatedObject(self, @selector(zh_badgeOffset), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    CGSize originSize = self.zh_badgeLabel.frame.size;
    CGFloat offsetX = (self.bounds.size.width - self.zh_badgeLabel.frame.size.width / 2) + offset.horizontal;
    CGFloat offsetY = (-self.zh_badgeLabel.frame.size.height / 2) + offset.vertical;
    self.zh_badgeLabel.frame = CGRectMake(offsetX, offsetY, originSize.width, originSize.height);
}

- (BOOL)zh_badgeAlwaysRound {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)zh_badgeAlwaysRound:(BOOL)isRound {
    objc_setAssociatedObject(self, @selector(zh_badgeAlwaysRound), @(isRound), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setBadgeText:self.zh_badgeLabel.text];
}

- (CGFloat)zh_badgeTransformHeight {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)zh_badgeTransformHeight:(CGFloat)height {
    objc_setAssociatedObject(self, @selector(zh_badgeTransformHeight), @(height), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setBadgeText:self.zh_badgeLabel.text];
}

@end
