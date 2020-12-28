//
//  NSFileManager+PKExtend.m
//  PKCategories
//
//  Created by zhanghao on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "NSFileManager+PKExtend.h"

@implementation NSFileManager (PKExtend)

- (NSURL *)pk_documentsURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)pk_documentsPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

- (NSURL *)pk_cachesURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)pk_cachesPath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

- (NSURL *)pk_libraryURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)pk_libraryPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

- (NSUInteger)pk_filesizeAtPath:(NSString *)path {
    NSUInteger filesize = 0;
    if ([NSFileManager.defaultManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary<NSFileAttributeKey, id> *attributes = [NSFileManager.defaultManager attributesOfItemAtPath:path error:&error];
        if (!error) filesize = (NSUInteger)attributes.fileSize;
    }
    return filesize;
}

- (NSUInteger)pk_numberOfFilesAtPath:(NSString *)path {
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    return fileEnumerator.allObjects.count;
}

- (NSUInteger)pk_getFreeDiskSpaceInBytes {
    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [NSFileManager.defaultManager attributesOfFileSystemForPath:paths.lastObject error:nil];
    return [dictionary[NSFileSystemFreeSize] unsignedIntegerValue];
}

@end
