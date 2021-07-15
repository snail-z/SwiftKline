//
//  UIApplication+zhExtend.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/14.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (zhExtend)

/** 应用程序的包名 */
@property (nullable, nonatomic, readonly) NSString *zh_appBundleName;

/** 应用程序唯一标识符 (如："com.zhang.MyApp") */
@property (nullable, nonatomic, readonly) NSString *zh_appBundleIdentifier;

/** 应用程序的版本号 (如："1.2.0") */
@property (nullable, nonatomic, readonly) NSString *zh_appVersion;

/** 应用程序的构建版本号 (如："11") */
@property (nullable, nonatomic, readonly) NSString *zh_appBuildVersion;

/** 应用程序的名称 */
@property (nullable, nonatomic, readonly) NSString *zh_appDisplayName;

/** 当前语言 (如："en") */
@property (nullable, nonatomic, readonly) NSString *zh_currentLanguage;

@end
