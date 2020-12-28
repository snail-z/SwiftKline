//
//  UIApplication+PKExtend.m
//  PKCategories
//
//  Created by jiaohong on 2018/11/21.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "UIApplication+PKExtend.h"

@implementation UIApplication (PKExtend)

+ (UIWindow *)pk_keyWindow {
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    if (window) return window;
    if (@available(iOS 13.0, *)) {
        return UIApplication.sharedApplication.windows.firstObject;
    } else {
        return UIApplication.sharedApplication.keyWindow;
    }
}

+ (UIWindow *)pk_topWindow:(BOOL)isFirstResponder {
    NSEnumerator *enumerator = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in enumerator) {
        BOOL isVisible = !window.isHidden && window.alpha > 0;
        BOOL isOnMainScreen = (window.screen == [UIScreen mainScreen]);
        if (!isVisible || !isOnMainScreen) continue;
        if (isFirstResponder) {
            return window;
        } else if (window.isKeyWindow) {
            return window;
        }
    }
    return [[UIApplication sharedApplication].delegate window];
}

+ (UIViewController *)pk_topViewController {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *resultViewController = [window rootViewController];
    UIViewController *parent = resultViewController;
    while ((parent = resultViewController.presentedViewController) != nil ) {
        resultViewController = parent;
    }
    while ([resultViewController isKindOfClass:[UINavigationController class]]) {
        resultViewController = [(UINavigationController *)resultViewController topViewController];
    }
    return resultViewController;
}

+ (void)pk_telephone:(NSString *)phoneNumber {
    if (phoneNumber) {
        NSString *phone = [NSString stringWithFormat:@"telprompt://%@", phoneNumber];
        NSURL *phoneURL = [NSURL URLWithString:phone];
        if ([UIApplication.sharedApplication canOpenURL:phoneURL]) {
            if (@available(iOS 10.0, *)) {
                [UIApplication.sharedApplication openURL:phoneURL options:@{} completionHandler:nil];
            } else {
                [UIApplication.sharedApplication openURL:phoneURL];
            }
        }
    }
}

+ (NSString *)pk_appDisplayName {
    return [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+ (NSString *)pk_appBundleName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

+ (NSString *)pk_appBundleID {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

+ (NSString *)pk_appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)pk_appBuildVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

@end
