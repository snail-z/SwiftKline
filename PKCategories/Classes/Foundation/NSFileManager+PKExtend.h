//
//  NSFileManager+PKExtend.h
//  PKCategories
//
//  Created by zhanghao on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (PKExtend)

@property (nonatomic, readonly) NSURL *pk_documentsURL;
@property (nonatomic, readonly) NSString *pk_documentsPath;

@property (nonatomic, readonly) NSURL *pk_cachesURL;
@property (nonatomic, readonly) NSString *pk_cachesPath;

@property (nonatomic, readonly) NSURL *pk_libraryURL;
@property (nonatomic, readonly) NSString *pk_libraryPath;

/** 获取path目录下所有文件总大小 */
- (NSUInteger)pk_filesizeAtPath:(NSString *)path;

/** 获取path目录下的文件数量 */
- (NSUInteger)pk_numberOfFilesAtPath:(NSString *)path;

/** 获取磁盘缓存目录剩余可用空间 */
- (NSUInteger)pk_getFreeDiskSpaceInBytes;

@end

NS_ASSUME_NONNULL_END
