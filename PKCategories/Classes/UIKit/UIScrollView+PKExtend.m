//
//  UIScrollView+PKExtend.m
//  PKCategories
//
//  Created by jiaohong on 2018/10/29.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "UIScrollView+PKExtend.h"
#import "UIView+PKExtend.h"

@implementation UIScrollView (PKExtend)

- (UIImage *)pk_snapshot {
    UIGraphicsBeginImageContextWithOptions(self.contentSize, NO, UIScreen.mainScreen.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect prevFrame = self.frame;
    self.frame = (CGRect){.origin = self.frame.origin, .size = self.contentSize };
    [self.layer renderInContext:ctx];
    self.frame = prevFrame;
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)pk_eatAutomaticallyAdjustsInsets {
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        [self pk_inViewController].automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)pk_scrollToTopAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = 0 - self.contentInset.top;
    [self setContentOffset:off animated:animated];
}

- (void)pk_scrollToBottomAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
    [self setContentOffset:off animated:animated];
}

- (void)pk_scrollToLeftAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = 0 - self.contentInset.left;
    [self setContentOffset:off animated:animated];
}

- (void)pk_scrollToRightAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right;
    [self setContentOffset:off animated:animated];
}

@end
