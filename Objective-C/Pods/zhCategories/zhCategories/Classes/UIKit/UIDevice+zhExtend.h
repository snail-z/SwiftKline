//
//  UIDevice+zhExtend.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/13.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, zhDeviceScreenType) {
    zhDeviceScreenTypeIPhone4 = 0,
    zhDeviceScreenTypeIPhone5,
    zhDeviceScreenTypeIPhone6,
    zhDeviceScreenTypeIPhone6Plus,
    zhDeviceScreenTypeIPhoneX,
    zhDeviceScreenTypeUnknown = -1,
    zhDeviceScreenTypeIPad = 100
};

@interface UIDevice (zhExtend)

/**
 根据设备屏幕尺寸确定当前设备型号
 iphone 4/4s => {320, 480}
 iphone 5/5c/5s/SE => {320, 568}
 iphone 6/6s/7/8 => {375, 667}
 iphone 6p/6sp/7p/8p =>  {414, 736}
 iphone X => {375, 812}
 <最新官方设计指南: https://developer.apple.com/ios/human-interface-guidelines/overview/iphone-x/>
 */
@property (class, nonatomic, readonly) zhDeviceScreenType zh_deviceScreenType;
@property (class, nonatomic, readonly) BOOL zh_isIPhone4;
@property (class, nonatomic, readonly) BOOL zh_isIPhone5;
@property (class, nonatomic, readonly) BOOL zh_isIPhone6;
@property (class, nonatomic, readonly) BOOL zh_isIPhone6P;
@property (class, nonatomic, readonly) BOOL zh_isIPhoneX;
@property (class, nonatomic, readonly) BOOL zh_isIpad;

/** 获取当前设备的系统版本 */
@property (nonatomic, assign, readonly, class) double zh_systemVersion;

/** 获取当前设备的名称 (e.g. "My iPhone") */
@property (nonatomic, readonly, class) NSString *zh_deviceName;

/** 判断设备是否为模拟器 */
@property (nonatomic, assign, readonly) BOOL zh_isSimulator;

/** 判断设备是否为iPad */
@property (nonatomic, assign, readonly) BOOL zh_isPad;

/** 获取设备的 WIFI IP地址 (e.g. "192.168.1.111") */
@property (nonatomic, readonly, nullable) NSString *zh_ipAddressWIFI;

/** 获取设备的单元IP地址 (e.g. "10.2.2.222") */
@property (nonatomic, readonly, nullable) NSString *zh_ipAddressCell;

/** 判断当前设置是否有摄像头 */
@property (nonatomic, assign, readonly) BOOL zh_hasCamera;

@end

NS_ASSUME_NONNULL_END
