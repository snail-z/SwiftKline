//
//  UIApplication+zhExtend.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/14.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UIApplication+zhExtend.h"

@implementation UIApplication (zhExtend)

- (NSString *)zh_appBundleName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

- (NSString *)zh_appBundleIdentifier {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

- (NSString *)zh_appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)zh_appBuildVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

- (NSString *)zh_appDisplayName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

- (NSString *)zh_currentLanguage {
    NSArray<NSString *> *languages = [NSLocale preferredLanguages];
    return [NSString stringWithString:languages.firstObject];
}

@end
