//
//  UITableView+zhAddAnimations.m
//  ThemeManager
//
//  Created by zhanghao on 2017/9/17.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UITableView+zhAddAnimations.h"
#import <objc/runtime.h>

@implementation UITableView (zhAddAnimations)

- (zhTableViewAnimationType)zh_reloadAnimationType {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

-(void)setZh_reloadAnimationType:(zhTableViewAnimationType)zh_reloadAnimationType {
    objc_setAssociatedObject(self, @selector(zh_reloadAnimationType), @(zh_reloadAnimationType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    SEL selectors[] = {
        @selector(reloadData),
    };
    
    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"zh_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)zh_reloadData {
    zhTableViewAnimationType type = self.zh_reloadAnimationType;
    
    if (type != zhTableViewAnimationTypenNone) {
        [self setContentOffset:self.contentOffset animated:YES];
        NSArray<NSString *> *selNames = [self animationNames];
        NSString *selName = [NSString stringWithFormat:@"zh_animation%@", selNames[type - 1]];
        SEL sel = NSSelectorFromString(selName);
        if ([self respondsToSelector:sel]) {
            [self performSelector:sel withObject:nil afterDelay:0];
        }
    }
    
    [self zh_reloadData];
}

- (NSArray<NSString *> *)animationNames { // zhReloadAnimationType
    NSMutableArray *array = @[].mutableCopy;
    [array addObject:@"SlideFromLeft"];
    [array addObject:@"SlideFromRight"];
    [array addObject:@"Fade"];
    [array addObject:@"Fall"];
    [array addObject:@"Vallum"];
    [array addObject:@"Shake"];
    [array addObject:@"Flip"];
    [array addObject:@"FlipX"];
    [array addObject:@"Balloon"];
    [array addObject:@"BalloonTop"];
    return array.copy;
}

- (void)_finished {
    CGFloat maxContentOffsetY = (self.contentSize.height - self.bounds.size.height);
    if (self.contentOffset.y > maxContentOffsetY) {
        CGPoint p = self.contentOffset;
        p.y = maxContentOffsetY;
        [self setContentOffset:p animated:YES];
    }
}

- (void)zh_animationSlideFromLeft {
    [self zh_animationSlideFromLeft:YES];
}

- (void)zh_animationSlideFromRight {
    [self zh_animationSlideFromLeft:NO];
}

- (void)zh_animationSlideFromLeft:(BOOL)isLeft {
    NSArray<UITableViewCell *> *visibleCells = self.visibleCells;
    [visibleCells enumerateObjectsUsingBlock:^(UITableViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat transTx = isLeft ? -self.frame.size.width :self.frame.size.width;
        cell.transform = CGAffineTransformMakeTranslation(transTx, 0);
        NSTimeInterval delay = idx * (0.4 / visibleCells.count);
        [UIView animateWithDuration:0.75 delay:delay usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            cell.transform = CGAffineTransformIdentity;
            
        } completion:NULL];
    }];
}

- (void)zh_animationFade {
    NSArray<UITableViewCell *> *visibleCells = self.visibleCells;
    [visibleCells enumerateObjectsUsingBlock:^(UITableViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        cell.alpha = 0.0;
        NSTimeInterval delay = idx * 0.1;
        [UIView animateWithDuration:0.25 delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
            cell.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }];
}

- (void)zh_animationVallum {
    NSArray<UITableViewCell *> *visibleCells = self.visibleCells;
    [visibleCells enumerateObjectsUsingBlock:^(UITableViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat transTy = self.frame.size.height;
        cell.transform = CGAffineTransformMakeTranslation(0, transTy);
        NSTimeInterval delay = idx * (0.4 / visibleCells.count);
        [UIView animateWithDuration:0.55 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)zh_animationFall {
    NSArray<UITableViewCell *> *visibleCells = self.visibleCells;
    [visibleCells enumerateObjectsUsingBlock:^(UITableViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat transTy = -self.frame.size.height;
        cell.transform = CGAffineTransformMakeTranslation(0, transTy);
        NSTimeInterval delay = (visibleCells.count - idx) * (0.4 / visibleCells.count);
        [UIView animateWithDuration:0.55 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)zh_animationShake {
    NSArray<UITableViewCell *> *visibleCells = self.visibleCells;
    [visibleCells enumerateObjectsUsingBlock:^(UITableViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat transTy = idx % 2 ? -self.bounds.size.height : self.bounds.size.height;
        cell.transform = CGAffineTransformMakeTranslation(transTy, 0);
        
        //        CGFloat delay = idx * (0.4 / visibleCells.count);
        NSTimeInterval delay = idx * 0.025;
        
        [UIView animateWithDuration:0.75 delay:delay usingSpringWithDamping:0.75 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            cell.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)zh_animationFlip:(BOOL)isX {
    NSArray<UITableViewCell *> *visibleCells = self.visibleCells;
    [visibleCells enumerateObjectsUsingBlock:^(UITableViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        cell.layer.opacity = 0.0;
        cell.layer.transform = isX ? CATransform3DMakeRotation(M_PI, 1, 0, 0) : CATransform3DMakeRotation(M_PI, 0, 1, 0);
        NSTimeInterval delay = idx * (0.4 / visibleCells.count);
        [UIView animateWithDuration:0.55 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.layer.opacity = 1.0;
            cell.layer.transform = CATransform3DIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)zh_animationFlip {
    [self zh_animationFlip:NO];
}

- (void)zh_animationFlipX {
    [self zh_animationFlip:YES];
}

- (void)zh_animationBalloon:(BOOL)isToTop {
    NSArray<UITableViewCell *> *visibleCells = self.visibleCells;
    [visibleCells enumerateObjectsUsingBlock:^(UITableViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        cell.layer.opacity = 0.0;
        cell.transform = CGAffineTransformMakeScale(0.0, 0.0);
        
        NSTimeInterval delay = 0;
        if (isToTop) {
            delay = (visibleCells.count - idx) * (0.4 / visibleCells.count);
        } else {
            delay = idx * (0.4 / visibleCells.count);
        }
        
        BOOL isUsingSpring = YES;
        
        if (isUsingSpring) {
            [UIView animateWithDuration:0.75 delay:delay usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                cell.layer.opacity = 1.0;
                cell.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        } else {
            [UIView animateWithDuration:0.45 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                cell.layer.opacity = 1.0;
                cell.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        }
    }];
}

- (void)zh_animationBalloon {
    [self zh_animationBalloon:NO];
}

- (void)zh_animationBalloonTop {
    [self zh_animationBalloon:YES];
}

@end
