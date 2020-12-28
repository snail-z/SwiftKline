//
//  UIViewController+PKExtend.m
//  PKCategories
//
//  Created by zhanghao on 2018/10/29.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "UIViewController+PKExtend.h"
#import <objc/runtime.h>

@implementation UIViewController (PKExtend)

- (BOOL)pk_isVisible {
    return [self isViewLoaded] && self.view.window;
}

- (NSString *)pk_hierarchyDescription {
    NSMutableString *description = [NSMutableString stringWithFormat:@"\n"];
    [self pk_addDescriptionToString:description indentLevel:0];
    return description;
}

- (void)pk_addDescriptionToString:(NSMutableString *)string indentLevel:(NSInteger)indentLevel {
    NSString *padding = [@"" stringByPaddingToLength:indentLevel withString:@" " startingAtIndex:0];
    [string appendString:padding];
    [string appendFormat:@"%@, %@",[self debugDescription],NSStringFromCGRect(self.view.frame)];
    for (UIViewController *childController in self.childViewControllers) {
        [string appendFormat:@"\n%@>",padding];
        [childController pk_addDescriptionToString:string indentLevel:indentLevel + 1];
    }
}

@end


@implementation UINavigationController (PKStatusBarStyle)

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

@end

@implementation UIViewController (PKStatusBarStyle)

- (BOOL)prefersStatusBarHidden {
    return self.pk_statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.pk_statusBarStyle;
}

- (BOOL)pk_statusBarHidden {
    id value = objc_getAssociatedObject(self, _cmd);
    return [value boolValue];
}

- (void)setPk_statusBarHidden:(BOOL)pk_statusBarHidden {
    objc_setAssociatedObject(self, @selector(pk_statusBarHidden), @(pk_statusBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self pk_basedStatusBarAppearanceValue]) {
        [self setNeedsStatusBarAppearanceUpdate];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] setStatusBarHidden:pk_statusBarHidden];
#pragma clang diagnostic pop
    }
}

- (UIStatusBarStyle)pk_statusBarStyle {
    id value = objc_getAssociatedObject(self, _cmd);
    return [value integerValue];
}

- (void)setPk_statusBarStyle:(UIStatusBarStyle)pk_statusBarStyle {
    objc_setAssociatedObject(self, @selector(pk_statusBarStyle), @(pk_statusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self pk_basedStatusBarAppearanceValue]) {
        [self setNeedsStatusBarAppearanceUpdate];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] setStatusBarStyle:pk_statusBarStyle];
#pragma clang diagnostic pop
    }
}

- (BOOL)pk_basedStatusBarAppearanceValue {
    NSDictionary *appInfo = [NSBundle mainBundle].infoDictionary;
    if ([appInfo.allKeys containsObject:@"UIViewControllerBasedStatusBarAppearance"]) {
        return [appInfo[@"UIViewControllerBasedStatusBarAppearance"] boolValue];
    }
    return YES;
}

- (void)pk_statusBarRestoreDefaults {
    if ([self pk_basedStatusBarAppearanceValue]) {
        self.pk_statusBarStyle = UIStatusBarStyleDefault;
        self.pk_statusBarHidden = NO;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
#pragma clang diagnostic pop
    }
}

@end
