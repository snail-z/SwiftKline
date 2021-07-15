//
//  NSDictionary+zhSafeAccess.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/12.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "NSDictionary+zhSafeAccess.h"

@implementation NSDictionary (zhSafeAccess)

- (BOOL)zh_hasKey:(NSString *)aKey {
    if (aKey == nil) {
        return NO;
    }
    return [self objectForKey:aKey] != nil;
}

- (id)zh_objectForKey:(id)aKey {
    if (aKey == nil) {
        return nil;
    }
    id value = [self objectForKey:aKey];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

- (NSArray *)zh_arrayForKey:(id)aKey {
    id value = [self zh_objectForKey:aKey];
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return nil;
}

- (NSDictionary *)zh_dictionaryForKey:(id)aKey {
    id value = [self zh_objectForKey:aKey];
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return nil;
}

- (NSString *)zh_stringForKey:(id)aKey {
    id value = [self zh_objectForKey:aKey];
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString *)value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    return nil;
}

- (NSNumber *)zh_numberForKey:(id)aKey {
    id value = [self zh_objectForKey:aKey];
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)value;
    }
    if ([value isKindOfClass:[NSString class]]) {
        static NSNumberFormatter *f;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
        });
        return [f numberFromString:(NSString*)value];
    }
    return nil;
}

- (int)zh_intValueForKey:(id)aKey {
    return [self zh_numberForKey:aKey].intValue;
}

- (double)zh_doubleValueForKey:(id)aKey {
    return [self zh_numberForKey:aKey].doubleValue;
}

- (int64_t)zh_longLongValueForKey:(id)aKey {
    return [self zh_numberForKey:aKey].longLongValue;
}

- (BOOL)zh_boolValueForKey:(id)aKey {
    return [self zh_numberForKey:aKey].boolValue;
}

- (NSInteger)zh_integerValueForKey:(id)aKey {
    return [self zh_numberForKey:aKey].integerValue;
}

- (CGFloat)zh_CGFloatValueForKey:(id)aKey {
    return [self zh_numberForKey:aKey].doubleValue;
}

- (CGPoint)zh_CGPointForKey:(id)aKey {
    return CGPointFromString([self zh_stringForKey:aKey]);
}

- (CGSize)zh_CGSizeForKey:(id)aKey {
    return CGSizeFromString([self zh_stringForKey:aKey]);
}

- (CGRect)zh_CGRectForKey:(id)aKey {
    return CGRectFromString([self zh_stringForKey:aKey]);
}

@end

#pragma mark - NSMutableDictionary

@implementation NSMutableDictionary (zhSafeAccess)

- (void)zh_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject != nil) {
        self[aKey] = anObject;
    }
}

- (void)zh_setCGPoint:(CGPoint)p forKey:(id<NSCopying>)aKey {
    self[aKey] = NSStringFromCGPoint(p);
}

- (void)zh_setCGSize:(CGSize)s forKey:(id<NSCopying>)aKey {
    self[aKey] = NSStringFromCGSize(s);
}

- (void)zh_setCGRect:(CGRect)r forKey:(id<NSCopying>)aKey {
    self[aKey] = NSStringFromCGRect(r);
}

@end
