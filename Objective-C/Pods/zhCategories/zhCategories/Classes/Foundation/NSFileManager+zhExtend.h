//
//  NSFileManager+zhExtend.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/14.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (zhExtend)

@property (nullable, nonatomic, readonly) NSURL *zh_documentsURL;
@property (nullable, nonatomic, readonly) NSString *zh_documentsPath;

@property (nullable, nonatomic, readonly) NSURL *zh_cachesURL;
@property (nullable, nonatomic, readonly) NSString *zh_cachesPath;

@property (nullable, nonatomic, readonly) NSURL *zh_libraryURL;
@property (nullable, nonatomic, readonly) NSString *zh_libraryPath;

- (BOOL)zh_removeItemAtPath:(NSString *)path;
- (BOOL)zh_createDirectoryAtPath:(NSString *)path;

/** 获取path目录下所有文件总大小 */
- (NSUInteger)zh_filesizeAtPath:(NSString *)path;

/** 获取path目录下的文件数量 */
- (NSUInteger)zh_numberOfFilesAtPath:(NSString *)path;

/** 获取磁盘缓存目录剩余可用空间 */
- (NSUInteger)zh_getFreeDiskSpaceInBytes;

@end

NS_ASSUME_NONNULL_END
