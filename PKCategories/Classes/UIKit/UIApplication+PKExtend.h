//
//  UIApplication+PKExtend.h
//  PKCategories
//
//  Created by jiaohong on 2018/11/21.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (PKExtend)

/** 获取应用程序的主窗口 */
+ (nullable UIWindow *)pk_keyWindow;

/** 获取应用程序顶层窗口 (设为YES，则包含键盘window) */
+ (nullable UIWindow *)pk_topWindow:(BOOL)isFirstResponder;

/** 获取顶层视图控制器 */
+ (nullable UIViewController *)pk_topViewController;

/** 调起拨打电话 */
+ (void)pk_telephone:(NSString *)phoneNumber;

/** 获取显示名称 */
+ (nullable NSString *)pk_appDisplayName;

/** 获取应用名称 */
+ (nullable NSString *)pk_appBundleName;

/** 获取应用唯一标识 */
+ (nullable NSString *)pk_appBundleID;

/** 获取应用当前版本号(发布版本号) */
+ (nullable NSString *)pk_appVersion;

/** 获取应用构建版本号(包括发布与未发布) */
+ (nullable NSString *)pk_appBuildVersion;

@end

NS_ASSUME_NONNULL_END
