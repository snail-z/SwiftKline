//
//  NSBundle+PKExtend.m
//  PKCategories
//
//  Created by jiaohong on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "NSBundle+PKExtend.h"

@implementation NSBundle (PKExtend)

+ (NSString *)pk_bundleName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

+ (NSString *)pk_bundleIdentifier {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

+ (NSString *)pk_bundleShortVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)pk_buildVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

+ (NSString *)pk_appDisplayName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+ (NSString *)pk_mainBundleWithName:(NSString *)fileName {
    NSString *path = [[NSBundle.mainBundle resourcePath] stringByAppendingPathComponent:fileName];
    return [NSFileManager.defaultManager fileExistsAtPath:path] ? path : nil;
}

@end
