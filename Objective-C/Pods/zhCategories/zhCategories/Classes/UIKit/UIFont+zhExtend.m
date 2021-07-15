//
//  UIFont+zhExtend.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/13.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UIFont+zhExtend.h"

@implementation UIFont (zhExtend)

+ (CGFloat)zh_pointsByPixel:(CGFloat)px {
    static CGFloat scaleFactor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIUserInterfaceIdiom idiom = [UIDevice currentDevice].userInterfaceIdiom;
        if (idiom == UIUserInterfaceIdiomPad) {
            scaleFactor = 0.5;
        } else if (idiom == UIUserInterfaceIdiomPhone) {
            scaleFactor = 8.0 / 15.0;
        } else {
            scaleFactor = 0.5;
        }
    });
    return scaleFactor * px;
}

+ (UIFont *)zh_fontByPixel:(CGFloat)px {
    return [UIFont systemFontOfSize:[self zh_pointsByPixel:px]];
}

+ (UIFont *)zh_boldFontByPixel:(CGFloat)px {
    return [UIFont boldSystemFontOfSize:[self zh_pointsByPixel:px]];
}

+ (UIFont *)zh_fontWithName:(NSString *)fontName pixel:(CGFloat)px {
    return [UIFont fontWithName:fontName size:[self zh_pointsByPixel:px]];
}

+ (NSArray<NSString *> *)zh_familyNames {
    NSMutableArray *fontNames = [NSMutableArray array];
    for (NSString *family in [UIFont familyNames]) {
        for (NSString *name in [UIFont fontNamesForFamilyName:family]) {
            [fontNames addObject:name];
        }
    }
    return fontNames.copy;
}

@end
