//
//  NSSet+PKExtend.m
//  PKCategories
//
//  Created by zhanghao on 2019/4/27.
//

#import "NSSet+PKExtend.h"

@implementation NSSet (PKExtend)

- (NSSet *)pk_unionSet:(NSSet *)set identified:(NSString * _Nonnull (^NS_NOESCAPE)(id _Nonnull))block {
    NSMutableSet *mutableSet = [NSMutableSet set];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:self.count];
    for (id obj in self) {
        [dict setObject:obj forKey:block(obj)];
        [mutableSet addObject:obj];
    }
    
    for (id obj in set) {
        if (![dict objectForKey:block(obj)]) {
            [mutableSet addObject:obj];
        }
    }
    
    return mutableSet.copy;
}

- (NSSet *)pk_intersectSet:(NSSet *)set identified:(NSString * _Nonnull (^NS_NOESCAPE)(id _Nonnull))block {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:self.count];
    for (id obj in self) {
        [dict setObject:obj forKey:block(obj)];
    }
    
    NSMutableSet *mutableSet = [NSMutableSet set];
    for (id obj in set) {
        if ([dict objectForKey:block(obj)]) {
            [mutableSet addObject:obj];
        }
    }
    
    return mutableSet.copy;
}

- (NSSet *)pk_minusSet:(NSSet *)set identified:(NSString * _Nonnull (^NS_NOESCAPE)(id _Nonnull))block {
    NSMutableSet *mutableSet = [NSMutableSet set];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:self.count];
    for (id obj in self) {
        [dict setObject:obj forKey:block(obj)];
        [mutableSet addObject:obj];
    }
    
    for (id obj in set) {
        id value = [dict objectForKey:block(obj)];
        if (value) {
            [mutableSet removeObject:value];
        } else {
            [mutableSet addObject:obj];
        }
    }
    
    return mutableSet.copy;
}

@end
