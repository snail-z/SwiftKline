//
//  NSArray+zhExtend.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/12.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "NSArray+zhExtend.h"

@implementation NSArray (zhExtend)

- (NSArray *)zh_subarrayWithFront:(NSInteger)n {
    if (n > self.count) {
        NSLog(@"error : extends beyond bounds. (-%@)", NSStringFromSelector(_cmd));
        return nil;
    }
    return [self subarrayWithRange:NSMakeRange(0, n)];
}

- (NSArray *)zh_subarrayWithBehind:(NSInteger)n {
    if (n < 0 || n > self.count) {
        NSLog(@"error : extends beyond bounds. (-%@)", NSStringFromSelector(_cmd));
        return nil;
    }
    return [self subarrayWithRange:NSMakeRange(self.count - n, n)];
}

- (id)zh_randomObject {
    if (self.count) {
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    return nil;
}

@end

@implementation NSMutableArray (zhExtend)

- (void)zh_removeFirstObject {
    if (self.count) {
        [self removeObjectAtIndex:0];
    }
}

- (void)zh_removeLastObject {
    if (self.count) {
        [self removeObjectAtIndex:self.count - 1];
    }
}


- (id)zh_popFirstObject {
    id obj = nil;
    if (self.count) {
        obj = self.firstObject;
        [self removeObjectAtIndex:0];
    }
    return obj;
}

- (id)zh_popLastObject {
    id obj = nil;
    if (self.count) {
        obj = self.lastObject;
        [self removeLastObject];
    }
    return obj;
}

- (void)zh_insertArray:(NSArray *)array atIndex:(NSUInteger)index {
    if (index <= self.count) { 
        NSUInteger i = index;
        for (id obj in array) {
            [self insertObject:obj atIndex:i++];
        }
    }
}

@end
