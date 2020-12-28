//
//  NSData+PKExtend.h
//  PKCategories
//
//  Created by jiaohong on 2018/10/27.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (PKExtend)

/**
 *  返回一个json格式的对象(NSDictionary或NSArray)，如果出现错误则返回nil
 *
 *  @return json对象或nil
 */
- (nullable id)pk_jsonValueDecoded;

/**
 *  将NSData转换UTF8格式的字符串，如果出现错误则返回nil
 *
 *  @return UTF8格式的字符串或nil
 */
- (nullable NSString *)pk_UTF8StringEncoded;

@end

@interface NSData (PKHash)

/**
 Returns a lowercase NSString for md2 hash.
 */
- (NSString *)pk_md2String;

/**
 Returns an NSData for md2 hash.
 */
- (NSData *)pk_md2Data;

/**
 Returns a lowercase NSString for md4 hash.
 */
- (NSString *)pk_md4String;

/**
 Returns an NSData for md4 hash.
 */
- (NSData *)pk_md4Data;

/**
 Returns a lowercase NSString for md5 hash.
 */
- (NSString *)pk_md5String;

/**
 Returns an NSData for md5 hash.
 */
- (NSData *)pk_md5Data;

/**
 Returns a lowercase NSString for sha1 hash.
 */
- (NSString *)pk_sha1String;

/**
 Returns an NSData for sha1 hash.
 */
- (NSData *)pk_sha1Data;

/**
 Returns a lowercase NSString for sha224 hash.
 */
- (NSString *)pk_sha224String;

/**
 Returns an NSData for sha224 hash.
 */
- (NSData *)pk_sha224Data;

/**
 Returns a lowercase NSString for sha256 hash.
 */
- (NSString *)pk_sha256String;

/**
 Returns an NSData for sha256 hash.
 */
- (NSData *)pk_sha256Data;

/**
 Returns a lowercase NSString for sha384 hash.
 */
- (NSString *)pk_sha384String;

/**
 Returns an NSData for sha384 hash.
 */
- (NSData *)pk_sha384Data;

/**
 Returns a lowercase NSString for sha512 hash.
 */
- (NSString *)pk_sha512String;

/**
 Returns an NSData for sha512 hash.
 */
- (NSData *)pk_sha512Data;

@end 

NS_ASSUME_NONNULL_END
