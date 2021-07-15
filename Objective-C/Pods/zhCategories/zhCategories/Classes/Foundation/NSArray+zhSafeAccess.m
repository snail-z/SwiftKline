//
//  NSArray+zhSafeAccess.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/12.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "NSArray+zhSafeAccess.h"

@implementation NSArray (zhSafeAccess)

- (id)zh_objectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return self[index];
    }else{
        return nil;
    }
}

- (NSString *)zh_stringAtIndex:(NSInteger)index {
    id value = [self zh_objectAtIndex:index];
    if (value == nil || value == [NSNull null] || [[value description] isEqualToString:@"<null>"]) {
        return nil;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString*)value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    return nil;
}

- (NSNumber *)zh_numberAtIndex:(NSUInteger)index {
    id value = [self zh_objectAtIndex:index];
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)value;
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

- (NSArray *)zh_arrayAtIndex:(NSUInteger)index {
    id value = [self zh_objectAtIndex:index];
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return nil;
}

- (NSDictionary *)zh_dictionaryAtIndex:(NSUInteger)index {
    id value = [self zh_objectAtIndex:index];
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return nil;
}

- (NSInteger)zh_integerAtIndex:(NSUInteger)index {
    id value = [self zh_objectAtIndex:index];
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value integerValue];
    }
    return 0;
}

- (BOOL)zh_boolAtIndex:(NSUInteger)index {
    id value = [self zh_objectAtIndex:index];
    if (value == nil || value == [NSNull null]) {
        return NO;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [value boolValue];
    }
    return NO;
}

- (int)zh_intAtIndex:(NSUInteger)index {
    id value = [self zh_objectAtIndex:index];
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value intValue];
    }
    return 0;
}

- (double)zh_doubleAtIndex:(NSUInteger)index {
    id value = [self zh_objectAtIndex:index];
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value doubleValue];
    }
    return 0;
}

- (int64_t)zh_longLongAtIndex:(NSUInteger)index {
    id value = [self zh_objectAtIndex:index];
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value longLongValue];
    }
    return 0;
}

- (CGFloat)zh_CGFloatAtIndex:(NSUInteger)index {
    return [self zh_doubleAtIndex:index];
}

- (CGPoint)zh_CGPointAtIndex:(NSUInteger)index {
    id value = [self zh_objectAtIndex:index];
    if ([value isKindOfClass:[NSString class]]) {
        return CGPointFromString(value);
    }
    return CGPointZero;
}

- (CGSize)zh_CGSizeAtIndex:(NSUInteger)index {
    id value = [self zh_objectAtIndex:index];
    if ([value isKindOfClass:[NSString class]]) {
        return CGSizeFromString(value);
    }
    return CGSizeZero;
}

- (CGRect)zh_CGRectAtIndex:(NSUInteger)index {
    id value = [self zh_objectAtIndex:index];
    if ([value isKindOfClass:[NSString class]]) {
        return CGRectFromString(value);
    }
    return CGRectZero;
}

- (NSUInteger)zh_indexOfObject:(id)anObject {
    NSParameterAssert(self.count);
    if ([self containsObject:anObject]) {
        return [self indexOfObject:anObject];
    }
    return 0;
}

@end

#pragma mark - NSMutableArray

@implementation NSMutableArray (zhSafeAccess)

- (void)zh_addObject:(id)anObj {
    if (anObj != nil) {
        [self addObject:anObj];
    }
}

- (void)zh_addObject:(id)anObj defaults:(NSString *)def {
    if (anObj == nil || anObj == [NSNull null] || [[anObj description] isEqualToString:@"<null>"]) {
        [self addObject:def];
    } else {
        [self addObject:anObj];
    }
}

- (void)zh_addCGPoint:(CGPoint)p {
    [self addObject:NSStringFromCGPoint(p)];
}

- (void)zh_addCGSize:(CGSize)s {
    [self addObject:NSStringFromCGSize(s)];
}

- (void)zh_addRect:(CGRect)r {
    [self addObject:NSStringFromCGRect(r)];
}

- (void)zh_addObjectsFromArray:(NSArray *)otherArray {
    if (otherArray == nil) return;
    [self addObjectsFromArray:otherArray];
}

@end
