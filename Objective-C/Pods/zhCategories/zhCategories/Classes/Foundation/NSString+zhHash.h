//
//  NSString+zhHash.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/14.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (zhHash)

- (nullable NSString *)zh_md2String;
- (nullable NSString *)zh_md4String;
- (nullable NSString *)zh_md5String;
- (nullable NSString *)zh_sha1String;
- (nullable NSString *)zh_sha224String;
- (nullable NSString *)zh_sha256String;
- (nullable NSString *)zh_sha384String;
- (nullable NSString *)zh_sha512String;

@end
