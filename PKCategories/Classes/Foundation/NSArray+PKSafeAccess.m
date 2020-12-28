//
//  NSArray+PKSafeAccess.m
//  PKCategories
//
//  Created by zhanghao on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "NSArray+PKSafeAccess.h"

@implementation NSArray (PKSafeAccess)

- (id)pk_objectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self objectAtIndex:index];
    }
    return nil;
}

- (id)pk_objectAtIndex:(NSUInteger)index defaultObj:(id)defObj {
    id value = [self pk_objectAtIndex:index];
    if (value) {
        return value;
    }
    return defObj;
}

- (NSUInteger)pk_indexOfObject:(id)anObject {
    if ([self containsObject:anObject]) {
        return [self indexOfObject:anObject];
    }
    return 0;
}

- (NSString *)pk_stringAtIndex:(NSInteger)index {
    id value = [self pk_objectAtIndex:index];
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

- (NSNumber *)pk_numberAtIndex:(NSUInteger)index {
    id value = [self pk_objectAtIndex:index];
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

- (NSArray *)pk_arrayAtIndex:(NSUInteger)index {
    id value = [self pk_objectAtIndex:index];
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return nil;
}

- (NSDictionary *)pk_dictionaryAtIndex:(NSUInteger)index {
    id value = [self pk_objectAtIndex:index];
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return nil;
}

- (NSInteger)pk_integerAtIndex:(NSUInteger)index {
    id value = [self pk_objectAtIndex:index];
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value integerValue];
    }
    return 0;
}

- (BOOL)pk_boolAtIndex:(NSUInteger)index {
    id value = [self pk_objectAtIndex:index];
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

- (CGFloat)pk_CGFloatAtIndex:(NSUInteger)index {
    id value = [self pk_objectAtIndex:index];
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value doubleValue];
    }
    return 0;
}

- (CGPoint)pk_CGPointAtIndex:(NSUInteger)index {
    id value = [self pk_objectAtIndex:index];
    if ([value isKindOfClass:[NSValue class]]) {
        return [value CGPointValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        return CGPointFromString(value);
    }
    return CGPointZero;
}

- (CGSize)pk_CGSizeAtIndex:(NSUInteger)index {
    id value = [self pk_objectAtIndex:index];
    if ([value isKindOfClass:[NSValue class]]) {
        return [value CGSizeValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        return CGSizeFromString(value);
    }
    return CGSizeZero;
}

- (CGRect)pk_CGRectAtIndex:(NSUInteger)index {
    id value = [self pk_objectAtIndex:index];
    if ([value isKindOfClass:[NSValue class]]) {
        return [value CGRectValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        return CGRectFromString(value);
    }
    return CGRectZero;
}

@end


@implementation NSMutableArray (PKSafeAccess)

- (void)pk_addCGPoint:(CGPoint)p {
    [self addObject:[NSValue valueWithCGPoint:p]];
}

- (void)pk_addCGSize:(CGSize)s {
    [self addObject:[NSValue valueWithCGSize:s]];
}

- (void)pk_addCGRect:(CGRect)r {
    [self addObject:[NSValue valueWithCGRect:r]];
}

- (void)pk_addObject:(id)anObject {
    if (!anObject) return;
    [self addObject:anObject];
}

- (void)pk_addObject:(id)anObject defaultObj:(id)aObj {
    if (anObject) {
        return [self addObject:anObject];
    }
    return [self addObject:aObj];
}

- (void)pk_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index > self.count) return;
    [self insertObject:anObject atIndex:index];
}

- (void)pk_insertObjects:(NSArray *)objects atIndex:(NSUInteger)index {
    if (index > self.count) return;
    NSUInteger i = index;
    for (id obj in objects) {
        [self insertObject:obj atIndex:i++];
    }
}

- (void)pk_appendObjects:(NSArray *)objects {
    if (!objects) return;
    [self addObjectsFromArray:objects];
}

- (void)pk_removeObjectAtIndex:(NSUInteger)index {
    if (!self.count) return;
    if (index >= self.count) return;
    [self removeObjectAtIndex:index];
}

- (void)pk_removeObjectsInRange:(NSRange)range {
    if (NSMaxRange(range) > self.count) return;
    [self removeObjectsInRange:range];
}

@end
