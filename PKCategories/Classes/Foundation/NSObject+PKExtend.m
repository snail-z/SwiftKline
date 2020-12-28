//
//  NSObject+PKExtend.m
//  PKCategories
//
//  Created by zhanghao on 2018/10/27.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "NSObject+PKExtend.h"
#import <objc/message.h>

@implementation NSObject (PKExtend)

+ (NSString *)pk_className {
    return NSStringFromClass(self);
}

- (NSString *)pk_className {
    return [NSString stringWithUTF8String:class_getName([self class])];
}

- (NSArray<NSString *> *)pk_listOfMethods {
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList([self class], &methodCount);
    NSMutableArray *array = [NSMutableArray array];
    for (unsigned int i = 0; i < methodCount; i++) {
        SEL name = method_getName(methods[i]);
        NSString *strName = [NSString stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
        [array addObject:strName];
    }
    free(methods);
    return [array copy];
}

- (NSDictionary<NSString *,id> *)pk_listOfPropertyAttributes {
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
    return [dictionary copy];
}

@end


static void *NSObjectPKAssociatedObjectKey = &NSObjectPKAssociatedObjectKey;
static void *NSObjectPKAssociatedStringKey = &NSObjectPKAssociatedStringKey;
static void *NSObjectPKAssociatedBOOLKey = &NSObjectPKAssociatedBOOLKey;
@implementation NSObject (PKAssociated)

- (void)pk_setWeakAssociatedValue:(id)value withKey:(void *)key {
    id __weak __weak_object = value;
    id (^_weak_block)(void) = ^{ return __weak_object; };
    objc_setAssociatedObject(self, key, _weak_block, OBJC_ASSOCIATION_COPY);
}

- (id)pk_getWeakAssociatedValueForKey:(void *)key {
    id (^_weak_block)(void) = objc_getAssociatedObject(self, key);
    return _weak_block ? _weak_block() : nil;
}

- (void)pk_setAssociatedValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)pk_setAssociatedAssignValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (void)pk_setCopyValue:(id)value withKey:(SEL)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id)pk_getAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

- (void)pk_removeAssociatedValues {
    objc_removeAssociatedObjects(self);
}

- (id)pk_associatedObject {
    return [self pk_getAssociatedValueForKey:NSObjectPKAssociatedObjectKey];
}

- (void)setPk_associatedObject:(id)pk_associatedObject {
    [self pk_setAssociatedValue:pk_associatedObject withKey:NSObjectPKAssociatedObjectKey];
}

- (NSString *)pk_associatedStringValue {
    return [self pk_getAssociatedValueForKey:NSObjectPKAssociatedStringKey];
}

- (void)setPk_associatedStringValue:(NSString *)pk_associatedStringValue {
    [self pk_setAssociatedValue:pk_associatedStringValue withKey:NSObjectPKAssociatedStringKey];
}

- (BOOL)pk_associatedBoolValue {
    return [[self pk_getAssociatedValueForKey:NSObjectPKAssociatedBOOLKey] boolValue];
}

- (void)setPk_associatedBoolValue:(BOOL)pk_associatedBoolValue {
    [self pk_setAssociatedValue:@(pk_associatedBoolValue) withKey:NSObjectPKAssociatedBOOLKey];
}

@end


@implementation NSObject (PKSwizzle)

+ (BOOL)pk_swizzleInstanceMethod:(SEL)originalSel with:(SEL)swizzledSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSel);
    if (!originalMethod || !swizzledMethod) return NO;
    BOOL didAddMethod = class_addMethod(self, originalSel,
                                        method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(self, swizzledSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    return YES;
}

+ (BOOL)pk_swizzleClassMethod:(SEL)originalSel with:(SEL)swizzledSel {
    Class class = object_getClass(self);
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSel);
    if (!originalMethod || !swizzledMethod) return NO;
    method_exchangeImplementations(originalMethod, swizzledMethod);
    return YES;
}

@end
