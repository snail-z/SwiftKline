//
//  NSObject+zhAssociated.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/13.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "NSObject+zhAssociated.h"
#import <objc/runtime.h>

static void *NSObjectAssociatedObjKey = &NSObjectAssociatedObjKey;

@implementation NSObject (zhAssociated)

- (void)zh_setAssociatedValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)zh_setAssociatedWeakValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (void)zh_setCopyValue:(id)value withKey:(SEL)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id)zh_getAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

- (void)zh_removeAssociatedValues {
    objc_removeAssociatedObjects(self);
}

- (id)zh_associatedObj {
    return [self zh_getAssociatedValueForKey:NSObjectAssociatedObjKey];
}

- (void)setZh_associatedObj:(id)zh_associatedObj {
    [self zh_setAssociatedValue:zh_associatedObj withKey:NSObjectAssociatedObjKey];
}

@end
