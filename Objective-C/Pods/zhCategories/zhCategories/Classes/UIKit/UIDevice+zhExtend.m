//
//  UIDevice+zhExtend.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/13.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UIDevice+zhExtend.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/param.h>
#include <sys/mount.h>

@implementation UIDevice (zhExtend)

+ (zhDeviceScreenType)zh_deviceScreenType {
    static zhDeviceScreenType type;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIUserInterfaceIdiom idiom = [UIDevice currentDevice].userInterfaceIdiom;
        if (idiom == UIUserInterfaceIdiomPhone) {
            NSString *sizeString = NSStringFromCGSize([UIScreen mainScreen].bounds.size);
            if ([sizeString isEqualToString:@"{320, 480}"]) { // iphone 4/4s
                type = zhDeviceScreenTypeIPhone4;
            } else if ([sizeString isEqualToString:@"{320, 568}"]) { // iphone 5/5c/5s/SE
                type = zhDeviceScreenTypeIPhone5;
            } else if ([sizeString isEqualToString:@"{375, 667}"]) { // iphone 6/6s/7/8
                type = zhDeviceScreenTypeIPhone6;
            } else if ([sizeString isEqualToString:@"{414, 736}"]) { // iphone 6p/6sp/7p/8p
                type = zhDeviceScreenTypeIPhone6Plus;
            } else if ([sizeString isEqualToString:@"{375, 812}"]) { // iphone X
                type = zhDeviceScreenTypeIPhoneX;
            } else {
                type = zhDeviceScreenTypeUnknown;
            }
        } else if (idiom == UIUserInterfaceIdiomPad) {
            type = zhDeviceScreenTypeIPad;
        } else {
            type = zhDeviceScreenTypeUnknown;
        }
    });
    return type;
}

+ (BOOL)zh_isIPhone4 {
    return [self zh_deviceScreenType] == zhDeviceScreenTypeIPhone4;
}

+ (BOOL)zh_isIPhone5 {
    return [self zh_deviceScreenType] == zhDeviceScreenTypeIPhone5;
}

+ (BOOL)zh_isIPhone6 {
    return [self zh_deviceScreenType] == zhDeviceScreenTypeIPhone6;
}

+ (BOOL)zh_isIPhone6P {
    return [self zh_deviceScreenType] == zhDeviceScreenTypeIPhone6Plus;
}

+ (BOOL)zh_isIPhoneX {
    return [self zh_deviceScreenType] == zhDeviceScreenTypeIPhoneX;
}

+ (BOOL)zh_isIpad {
    return [self zh_deviceScreenType] == zhDeviceScreenTypeIPad;
}

+ (double)zh_systemVersion {
    static double version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [UIDevice currentDevice].systemVersion.doubleValue;
    });
    return version;
}

- (BOOL)zh_isSimulator {
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

- (BOOL)zh_isPad {
    static dispatch_once_t one;
    static BOOL pad;
    dispatch_once(&one, ^{
        pad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    });
    return pad;
}

- (NSString *)zh_ipAddressWIFI {
    return [self zh_ipAddressWithIfaName:@"en0"];
}

- (NSString *)zh_ipAddressCell {
    return [self zh_ipAddressWithIfaName:@"pdp_ip0"];
}

- (NSString *)zh_ipAddressWithIfaName:(NSString *)name {
    if (name.length == 0) return nil;
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs;
        while (addr) {
            if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:name]) {
                sa_family_t family = addr->ifa_addr->sa_family;
                switch (family) {
                    case AF_INET: { // IPv4
                        char str[INET_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in *)addr->ifa_addr)->sin_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    } break;
                        
                    case AF_INET6: { // IPv6
                        char str[INET6_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in6 *)addr->ifa_addr)->sin6_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    }
                        
                    default: break;
                }
                if (address) break;
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    return address;
}

- (BOOL)zh_hasCamera {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (NSString *)zh_deviceName {
    return [UIDevice currentDevice].name;
}

@end
