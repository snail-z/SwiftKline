//
//  NSArray+PKExtend.m
//  PKCategories
//
//  Created by zhanghao on 2018/10/25.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "NSArray+PKExtend.h"

@implementation NSArray (PKExtend)

- (BOOL)pk_containsIndex:(NSInteger)index {
    return (self.count && index < self.count && index >= 0);
}

- (id)pk_randomObject {
    if (self.count) {
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    return nil;
}

- (NSArray *)pk_subarrayWithFrontCount:(NSUInteger)count {
    if (count > self.count) {
        return nil;
    }
    return [self subarrayWithRange:NSMakeRange(0, count)];
}

- (NSArray *)pk_subarrayWithBackCount:(NSUInteger)count {
    if (count > self.count) {
        return nil;
    }
    return [self subarrayWithRange:NSMakeRange(self.count - count, count)];
}

- (NSArray<NSArray *> *)pk_subarraysSeparated:(NSInteger)group {
    NSInteger count = [self count];
    if (group >= count || group < 1) return self.copy;
    
    NSMutableArray *mud = [NSMutableArray array];
    for (NSInteger i = 0; i < count - group; i+=group) {
        NSArray *result = [self subarrayWithRange:NSMakeRange(i, group)];
        [mud addObject:result];
    }
    
    NSInteger p = (NSInteger)(count % group);
    if (p > 0) {
        NSArray *result = [self subarrayWithRange:NSMakeRange(count - p, p)];
        [mud addObject:result];
    } else {
        NSArray *result = [self subarrayWithRange:NSMakeRange(count - group, group)];
        [mud addObject:result];
    }
    return mud.copy;
}

- (id)pk_objectGreaterThanObject:(id)anObject {
    if ([self containsObject:anObject]) {
        NSUInteger index = [self indexOfObject:anObject];
        index += 1;
        if (index < self.count) return self[index];
        return self.firstObject;
    }
    return nil;
}

- (id)pk_objectLessThanObject:(id)anObject {
    if ([self containsObject:anObject]) {
        NSUInteger index = [self indexOfObject:anObject];
        if (index) return self[index - 1];
        return self.lastObject;
    }
    return nil;
}

- (id)pk_objectGreaterThanOrEqualToObject:(id)anObject {
    if ([self containsObject:anObject]) {
        NSUInteger index = [self indexOfObject:anObject];
        index += 1;
        if (index < self.count) return self[index];
        return self.lastObject;
    }
    return nil;
}

- (id)pk_objectLessThanOrEqualToObject:(id)anObject {
    if ([self containsObject:anObject]) {
        NSUInteger index = [self indexOfObject:anObject];
        if (index) return self[index - 1];
        return self.firstObject;
    }
    return nil;
}

- (NSArray<id> *)pk_map:(id _Nonnull (^NS_NOESCAPE)(id _Nonnull))block {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    for (id obj in self) {
        [array addObject:block(obj)];
    }
    return array.copy;
}

- (NSArray *)pk_filer:(BOOL (^NS_NOESCAPE)(id _Nonnull))block {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    for (id obj in self) {
        if (block(obj)) [array addObject:obj];
    }
    return array.copy;
}

- (NSString *)pk_JSONString {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}

- (NSString *)pk_JSONPrettyString {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}

+ (NSArray *)pk_arrayWithJSONString:(NSString *)jsonString {
    if (jsonString) {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        id value = [NSJSONSerialization JSONObjectWithData:jsonData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&error];
        if (!error && [value isKindOfClass:[NSArray class]]) return (NSArray *)value;
    }
    return nil;
}

@end


@implementation NSMutableArray (PKExtend)

- (void)pk_removeFirstObject {
    if (self.count) {
        [self removeObjectAtIndex:0];
    }
}

- (void)pk_removeLastObject {
    if (self.count) {
        [self removeObjectAtIndex:self.count - 1];
    }
}

- (id)pk_popFirstObject {
    id obj = nil;
    if (self.count) {
        obj = self.firstObject;
        [self removeObjectAtIndex:0];
    }
    return obj;
}

- (id)pk_popLastObject {
    id obj = nil;
    if (self.count) {
        obj = self.lastObject;
        [self removeLastObject];
    }
    return obj;
}

- (void)pk_shuffleAllObjects {
    for (NSUInteger i = self.count; i > 1; i--) {
        [self exchangeObjectAtIndex:(i - 1) withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
}

@end
