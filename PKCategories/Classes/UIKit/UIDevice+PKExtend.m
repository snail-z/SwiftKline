//
//  UIDevice+PKExtend.m
//  PKCategories
//
//  Created by jiaohong on 2018/10/29.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "UIDevice+PKExtend.h"
#import "UIApplication+PKExtend.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/sysctl.h>
#import <mach/mach_host.h>
#import <sys/utsname.h>

@implementation UIDevice (PKExtend)

+ (double)pk_systemVersion {
    static double version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [UIDevice currentDevice].systemVersion.doubleValue;
    });
    return version;
}

+ (NSString *)pk_deviceName {
    return [UIDevice currentDevice].name;
}

+ (BOOL)pk_isSimulator {
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

+ (BOOL)pk_hasCamera {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (NSString *)pk_language {
    return NSBundle.mainBundle.preferredLocalizations[0];
}

+ (NSString *)pk_ipAddressWIFI {
    return [self pk_ipAddressWithIfaName:@"en0"];
}

+ (NSString *)pk_ipAddressCell {
    return [self pk_ipAddressWithIfaName:@"pdp_ip0"];
}

+ (NSString *)pk_ipAddressWithIfaName:(NSString *)name {
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

+ (NSString *)pk_machineName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *machines = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([machines isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([machines isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([machines isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([machines isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([machines isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([machines isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([machines isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([machines isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([machines isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([machines isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([machines isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([machines isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([machines isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([machines isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([machines isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    
    if ([machines isEqualToString:@"iPhone9,1"])    return @"国行、日版、港行iPhone 7";
    if ([machines isEqualToString:@"iPhone9,2"])    return @"港行、国行iPhone 7 Plus";
    if ([machines isEqualToString:@"iPhone9,3"])    return @"美版、台版iPhone 7";
    if ([machines isEqualToString:@"iPhone9,4"])    return @"美版、台版iPhone 7 Plus";
    if ([machines isEqualToString:@"iPhone10,1"])   return @"国行(A1863)、日行(A1906)iPhone 8";
    if ([machines isEqualToString:@"iPhone10,4"])   return @"美版(Global/A1905)iPhone 8";
    if ([machines isEqualToString:@"iPhone10,2"])   return @"国行(A1864)、日行(A1898)iPhone 8 Plus";
    if ([machines isEqualToString:@"iPhone10,5"])   return @"美版(Global/A1897)iPhone 8 Plus";
    if ([machines isEqualToString:@"iPhone10,3"])   return @"国行(A1865)、日行(A1902)iPhone X";
    if ([machines isEqualToString:@"iPhone10,6"])   return @"美版(Global/A1901)iPhone X";
    if ([machines isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([machines isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([machines isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([machines isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    
    if ([machines isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([machines isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([machines isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([machines isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([machines isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([machines isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([machines isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([machines isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([machines isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([machines isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([machines isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([machines isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([machines isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([machines isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([machines isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([machines isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([machines isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([machines isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([machines isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([machines isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([machines isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([machines isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([machines isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([machines isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([machines isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([machines isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([machines isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([machines isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([machines isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([machines isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([machines isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([machines isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([machines isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([machines isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([machines isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([machines isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    if ([machines isEqualToString:@"iPad6,11"])    return @"iPad 5 (WiFi)";
    if ([machines isEqualToString:@"iPad6,12"])    return @"iPad 5 (Cellular)";
    if ([machines isEqualToString:@"iPad7,1"])     return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    if ([machines isEqualToString:@"iPad7,2"])     return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    if ([machines isEqualToString:@"iPad7,3"])     return @"iPad Pro 10.5 inch (WiFi)";
    if ([machines isEqualToString:@"iPad7,4"])     return @"iPad Pro 10.5 inch (Cellular)";
    if ([machines isEqualToString:@"iPad7,5"])     return @"iPad 6th generation";
    if ([machines isEqualToString:@"iPad7,6"])     return @"iPad 6th generation";
    if ([machines isEqualToString:@"iPad8,1"])     return @"iPad Pro (11-inch)";
    if ([machines isEqualToString:@"iPad8,2"])     return @"iPad Pro (11-inch)";
    if ([machines isEqualToString:@"iPad8,3"])     return @"iPad Pro (11-inch)";
    if ([machines isEqualToString:@"iPad8,4"])     return @"iPad Pro (11-inch)";
    if ([machines isEqualToString:@"iPad8,5"])     return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([machines isEqualToString:@"iPad8,6"])     return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([machines isEqualToString:@"iPad8,7"])     return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([machines isEqualToString:@"iPad8,8"])     return @"iPad Pro (12.9-inch) (3rd generation)";
    
    
    if ([machines isEqualToString:@"AppleTV2,1"])    return @"Apple TV 2";
    if ([machines isEqualToString:@"AppleTV3,1"])    return @"Apple TV 3";
    if ([machines isEqualToString:@"AppleTV3,2"])    return @"Apple TV 3";
    if ([machines isEqualToString:@"AppleTV5,3"])    return @"Apple TV 4";
    
    if ([machines isEqualToString:@"i386"])         return @"Simulator";
    if ([machines isEqualToString:@"x86_64"])       return @"Simulator";
    
    return machines;
}

+ (NSUInteger)pk_getSysInfo:(uint)typeSpecifier {
    size_t size = sizeof(int);
    int result;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &result, &size, NULL, 0);
    return (NSUInteger)result;
}

+ (NSUInteger)pk_totalMemoryBytes {
    return [self pk_getSysInfo:HW_PHYSMEM];
}

+ (NSUInteger)pk_freeMemoryBytes {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    host_page_size(host_port, &pagesize);
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        return 0;
    }
    NSUInteger mem_free = vm_stat.free_count * pagesize;
    return mem_free;
}

@end
