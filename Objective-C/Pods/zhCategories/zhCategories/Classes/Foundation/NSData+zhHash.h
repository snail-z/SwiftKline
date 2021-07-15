//
//  NSData+zhHash.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/14.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (zhHash)
// <from: https://github.com/ibireme/YYCategories>

/**
 Returns a lowercase NSString for md2 hash.
 */
- (NSString *)zh_md2String;

/**
 Returns an NSData for md2 hash.
 */
- (NSData *)zh_md2Data;

/**
 Returns a lowercase NSString for md4 hash.
 */
- (NSString *)zh_md4String;

/**
 Returns an NSData for md4 hash.
 */
- (NSData *)zh_md4Data;

/**
 Returns a lowercase NSString for md5 hash.
 */
- (NSString *)zh_md5String;

/**
 Returns an NSData for md5 hash.
 */
- (NSData *)zh_md5Data;

/**
 Returns a lowercase NSString for sha1 hash.
 */
- (NSString *)zh_sha1String;

/**
 Returns an NSData for sha1 hash.
 */
- (NSData *)zh_sha1Data;

/**
 Returns a lowercase NSString for sha224 hash.
 */
- (NSString *)zh_sha224String;

/**
 Returns an NSData for sha224 hash.
 */
- (NSData *)zh_sha224Data;

/**
 Returns a lowercase NSString for sha256 hash.
 */
- (NSString *)zh_sha256String;

/**
 Returns an NSData for sha256 hash.
 */
- (NSData *)zh_sha256Data;

/**
 Returns a lowercase NSString for sha384 hash.
 */
- (NSString *)zh_sha384String;

/**
 Returns an NSData for sha384 hash.
 */
- (NSData *)zh_sha384Data;

/**
 Returns a lowercase NSString for sha512 hash.
 */
- (NSString *)zh_sha512String;

/**
 Returns an NSData for sha512 hash.
 */
- (NSData *)zh_sha512Data;

@end
