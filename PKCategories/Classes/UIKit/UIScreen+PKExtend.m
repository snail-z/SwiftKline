//
//  UIScreen+PKExtend.m
//  PKCategories
//
//  Created by jiaohong on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "UIScreen+PKExtend.h"
#import "UIApplication+PKExtend.h"

@implementation UIScreen (PKExtend)

+ (CGFloat)pk_scale {
    static CGFloat screenScale = 0.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([NSThread isMainThread]) {
            screenScale = [[UIScreen mainScreen] scale];
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                screenScale = [[UIScreen mainScreen] scale];
            });
        }
    });
    return screenScale;
}

+ (CGSize)pk_size {
    return [[UIScreen mainScreen] bounds].size;
}

+ (CGFloat)pk_width {
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)pk_height {
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGSize)pk_swapSize {
    return CGSizeMake(self.pk_size.height, self.pk_size.width);
}

+ (UIEdgeInsets)pk_safeInsets {
    if (@available(iOS 11.0, *)) {
        return UIApplication.pk_keyWindow.safeAreaInsets;
    }
    return UIEdgeInsetsMake(20, 0, 0, 0);
}

+ (CGFloat)pk_statusBarHeight {
    return [self pk_safeInsets].top;
}

+ (CGFloat)pk_totalNavHeight {
    return 44 + [self pk_safeInsets].top;
}

+ (CGFloat)pk_totalTabbarHeight {
    return 49 + [self pk_safeInsets].bottom;
}

@end

typedef NS_ENUM(NSUInteger, PKScreenType) {
    PKScreenTypeUndefined   = 0,
    PKScreenTypeIpadClassic = 1, // iPad 1/2/mini
    PKScreenTypeIpadRetina  = 2, // iPad 3以上/mini2以上
    PKScreenTypeIpadPro     = 3, // iPad Pro
    PKScreenTypeIphone4     = 4, // iphone 4/4s
    PKScreenTypeIphone5     = 5, // iphone 5/5c/5s/SE
    PKScreenTypeIphone6     = 6, // iphone 6/6s/7/8
    PKScreenTypeIphone6Plus = 7, // iphone 6p/6sp/7p/8p
    PKScreenTypeIphoneX     = 8, // iphone 11pro/x/xs
    PKScreenTypeIphoneXR    = 9, // iphone 11/ XR
    PKScreenTypeIphoneXSMax = 10 // iphone 11pro max/xs max
};

@implementation UIScreen (PKScreenType)

+ (PKScreenType)_getType {
    static PKScreenType screenType = PKScreenTypeUndefined;
    
    int scale = [UIScreen mainScreen].scale;
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        if (CGSizeEqualToSize(size, CGSizeMake(1024, 768))) {
            if (scale == 1) {
                screenType = PKScreenTypeIpadClassic;
            } else if (scale == 2) {
                screenType = PKScreenTypeIpadRetina;
            }
        } else if (CGSizeEqualToSize(size, CGSizeMake(1112, 834)) ||
                   CGSizeEqualToSize(size, CGSizeMake(1366, 1024))) {
            screenType = PKScreenTypeIpadPro;
        }
        
        return screenType;
    }
        
    if (CGSizeEqualToSize(size, CGSizeMake(320, 480))) {
        screenType = PKScreenTypeIphone4;
    }
    else if (CGSizeEqualToSize(size, CGSizeMake(320, 568))) {
        screenType = PKScreenTypeIphone5;
    }
    else if (CGSizeEqualToSize(size, CGSizeMake(375, 667))) {
        screenType = PKScreenTypeIphone6;
    }
    else if (CGSizeEqualToSize(size, CGSizeMake(414, 736))) {
        screenType = PKScreenTypeIphone6Plus;
    }
    else if (CGSizeEqualToSize(size, CGSizeMake(375, 812))) {
        screenType = PKScreenTypeIphoneX;
    }
    else if (CGSizeEqualToSize(size, CGSizeMake(414, 896))) {
        
        if ([UIScreen instancesRespondToSelector:@selector(currentMode)]) {
            if (CGSizeEqualToSize(CGSizeMake(828, 1792),
                                  [[UIScreen mainScreen] currentMode].size)) {
                screenType = PKScreenTypeIphoneXR;
            } else if (CGSizeEqualToSize(CGSizeMake(1242, 2688),
                                         [[UIScreen mainScreen] currentMode].size)) {
                screenType = PKScreenTypeIphoneXSMax;
            }
        }
        
    }
    
    return screenType;
}

+ (BOOL)pk_isIphone4 {
    return [self _getType] == PKScreenTypeIphone4;
}

+ (BOOL)pk_isIphone5 {
    return [self _getType] == PKScreenTypeIphone5;
}

+ (BOOL)pk_isIphone6 {
    return [self _getType] == PKScreenTypeIphone6;
}

+ (BOOL)pk_isIphone6p {
    return [self _getType] == PKScreenTypeIphone6Plus;
}

+ (BOOL)pk_isIphoneX {
    return [self _getType] == PKScreenTypeIphoneX;
}

+ (BOOL)pk_isIphoneXR {
    return [self _getType] == PKScreenTypeIphoneXR;
}

+ (BOOL)pk_isIphoneMax {
    return [self _getType] == PKScreenTypeIphoneXSMax;
}

+ (BOOL)pk_isFull {
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safe = UIApplication.pk_keyWindow.safeAreaInsets;
        return safe.bottom > 0 ? YES : NO;
    }
    return NO;
}

@end
