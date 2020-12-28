//
//  UIGestureRecognizer+PKExtend.m
//  PKCategories
//
//  Created by zhanghao on 2018/10/29.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "UIGestureRecognizer+PKExtend.h"
#import <objc/runtime.h>

static const void *UIGestureRecognizerPKHandlersKey = &UIGestureRecognizerPKHandlersKey;

@interface _PKGestureRecognizerBlockWrapper : NSObject

@property (nonatomic, copy) void (^block)(id sender);

- (id)initWithBlock:(void (^)(UIGestureRecognizer *sender))block;
- (void)invoke:(id)sender;

@end

@implementation _PKGestureRecognizerBlockWrapper

- (id)initWithBlock:(void (^)(UIGestureRecognizer *))block {
    self = [super init];
    if (self) {
        _block = [block copy];
    }
    return self;
}

- (void)invoke:(id)sender {
    if (_block) _block(sender);
}

@end

@implementation UIGestureRecognizer (PKExtend)

+ (instancetype)pk_recognizerWithHandler:(void (^)(UIGestureRecognizer * _Nonnull))block {
    return [[[self class] alloc] pk_initWithHandler:block];
}

- (instancetype)pk_initWithHandler:(void (^)(UIGestureRecognizer * _Nonnull))block {
    self = [self init];
    [self pk_addHandler:block];
    return self;
}

- (void)pk_addHandler:(void (^)(UIGestureRecognizer * _Nonnull))block {
    _PKGestureRecognizerBlockWrapper *target = [[_PKGestureRecognizerBlockWrapper alloc] initWithBlock:block];
    [self addTarget:target action:@selector(invoke:)];
    NSMutableArray *targets = [self _pk_allUIGestureRecognizerBlockTargets];
    [targets addObject:target];
}

- (void)pk_removeAllEventHandlers {
    NSMutableArray *targets = [self _pk_allUIGestureRecognizerBlockTargets];
    [targets enumerateObjectsUsingBlock:^(id target, NSUInteger idx, BOOL *stop) {
        [self removeTarget:target action:@selector(invoke:)];
    }];
    [targets removeAllObjects];
}

- (NSMutableArray *)_pk_allUIGestureRecognizerBlockTargets {
    NSMutableArray *targets = objc_getAssociatedObject(self, UIGestureRecognizerPKHandlersKey);
    if (!targets) {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, UIGestureRecognizerPKHandlersKey, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end
