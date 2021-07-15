//
//  NSFileManager+zhExtend.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/14.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "NSFileManager+zhExtend.h"

@implementation NSFileManager (zhExtend)

- (NSURL *)zh_documentsURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)zh_documentsPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

- (NSURL *)zh_cachesURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)zh_cachesPath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

- (NSURL *)zh_libraryURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)zh_libraryPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

- (BOOL)zh_removeItemAtPath:(NSString *)path {
    if ([NSFileManager.defaultManager fileExistsAtPath:path]) {
        return [NSFileManager.defaultManager removeItemAtPath:path error:nil];
    }
    return YES;
}

- (BOOL)zh_createDirectoryAtPath:(NSString *)path {
    return [NSFileManager.defaultManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

- (NSUInteger)zh_filesizeAtPath:(NSString *)path {
    NSUInteger filesize = 0;
    if ([NSFileManager.defaultManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary<NSFileAttributeKey, id> *attributes = [NSFileManager.defaultManager attributesOfItemAtPath:path error:&error];
        if (!error) filesize = (NSUInteger)attributes.fileSize;
    }
    return filesize;
}

- (NSUInteger)zh_numberOfFilesAtPath:(NSString *)path {
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    return fileEnumerator.allObjects.count;
}

- (NSUInteger)zh_getFreeDiskSpaceInBytes {
    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [NSFileManager.defaultManager attributesOfFileSystemForPath:paths.lastObject error:nil];
    return [dictionary[NSFileSystemFreeSize] unsignedIntegerValue];
}

@end
