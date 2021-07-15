//
//  NSString+zhHash.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/14.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "NSString+zhHash.h"
#import "NSData+zhHash.h"

@implementation NSString (zhHash)

- (NSString *)zh_md2String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] zh_md2String];
}

- (NSString *)zh_md4String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] zh_md4String];
}

- (NSString *)zh_md5String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] zh_md5String];
}

- (NSString *)zh_sha1String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] zh_sha1String];
}

- (NSString *)zh_sha224String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] zh_sha224String];
}

- (NSString *)zh_sha256String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] zh_sha256String];
}

- (NSString *)zh_sha384String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] zh_sha384String];
}

- (NSString *)zh_sha512String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] zh_sha512String];
}

@end
