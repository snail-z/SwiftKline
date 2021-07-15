//
//  NSObject+zhExtend.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/6.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "NSObject+zhExtend.h"
#import <objc/runtime.h>

@implementation NSObject (zhExtend)

- (NSString *)zh_className {
//    return NSStringFromClass([self class]);
    return [NSString stringWithUTF8String:class_getName([self class])];
}

- (NSString *)zh_superClassName {
    return [NSString stringWithUTF8String:class_getName([self superclass])];
}

- (NSDictionary *)zh_propertyListDictionary {
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for(unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        id propValue = [self valueForKey:propertyName];
        [dictionary setObject:propValue?:[NSNull null] forKey:propertyName];
    }
    free(properties);
    return dictionary;
}

- (NSArray *)zh_methodListArray {
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList([self class], &methodCount);
    NSMutableArray *array = [NSMutableArray array];
    for (unsigned int i = 0; i < methodCount; i++) {
        SEL name = method_getName(methods[i]);
        NSString *strName = [NSString stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
        [array addObject:strName];
    }
    free(methods);
    return array;
}

- (NSData *)zh_JSONData {
    if ([self isKindOfClass:[NSData class]]) {
        return (NSData *)self;
    } else if ([self isKindOfClass:[NSString class]]) {
        return [((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding];
    }  else {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
        if (!error) {
            return data;
        } else {
#ifdef DEBUG
            NSLog(@"fail to get JSON from object: %@, error: %@", self, error);
#endif
            return nil;
        }
    }
}

- (NSString *)zh_JSONString {
    return [[NSString alloc] initWithData:[self zh_JSONData] encoding:NSUTF8StringEncoding];
}

@end
