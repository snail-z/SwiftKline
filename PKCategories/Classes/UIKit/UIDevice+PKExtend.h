//
//  UIDevice+PKExtend.h
//  PKCategories
//
//  Created by jiaohong on 2018/10/29.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (PKExtend)

/** 获取当前设备的系统版本 */
@property (nonatomic, assign, readonly, class) double pk_systemVersion;

/** 获取当前设备的名称 (e.g. "My iPhone") */
@property (nonatomic, assign, readonly, class) NSString *pk_deviceName;

/** 判断设备是否为模拟器 */
@property (nonatomic, assign, readonly, class) BOOL pk_isSimulator;

/** 判断当前设置是否有摄像头 */
@property (nonatomic, assign, readonly, class) BOOL pk_hasCamera;

/** 获取设备语言 */
@property (nonatomic, readonly, class, nullable) NSString *pk_language;

/** 获取设备的WIFI-IP地址 (e.g. "192.168.1.111") */
@property (nonatomic, readonly, class, nullable) NSString *pk_ipAddressWIFI;

/** 获取设备的单元IP地址 (e.g. "10.2.2.222") */
@property (nonatomic, readonly, class, nullable) NSString *pk_ipAddressCell;

/** 获取手机机型对应名称 */
@property (nonatomic, readonly, class, nullable) NSString *pk_machineName;

/** 获取手机内存总量 (单位：字节数) */
+ (NSUInteger)pk_totalMemoryBytes;

/** 获取手机可用内存 (单位：字节数) */
+ (NSUInteger)pk_freeMemoryBytes;

@end

NS_ASSUME_NONNULL_END
