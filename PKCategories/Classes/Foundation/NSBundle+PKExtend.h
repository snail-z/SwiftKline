//
//  NSBundle+PKExtend.h
//  PKCategories
//
//  Created by jiaohong on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (PKExtend)

/** 获取应用程序的包名 */
@property (nullable, nonatomic, class, readonly) NSString *pk_bundleName;

/** 获取应用程序的唯一标识符. 如"com.PsychokinesisTeam.pkApp" */
@property (nullable, nonatomic, class, readonly) NSString *pk_bundleIdentifier;

/** 获取应用程序的版本号 */
@property (nullable, nonatomic, class, readonly) NSString *pk_bundleShortVersion;

/** 获取应用程序的构建版本. 如"123" */
@property (nullable, nonatomic, class, readonly) NSString *pk_buildVersion;

/** 获取应用程序的名称 */
@property (nullable, nonatomic, class, readonly) NSString *pk_appDisplayName;

/** 从mainbundle路径下读取文件 */
+ (nullable NSString *)pk_mainBundleWithName:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
