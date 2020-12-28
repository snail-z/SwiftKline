//
//  UIControl+PKExtend.m
//  PKCategories
//
//  Created by jiaohong on 2018/10/29.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "UIControl+PKExtend.h"
#import <objc/runtime.h>

static void *UIControlAssociatedPKEnlargeTouchAreaKey = &UIControlAssociatedPKEnlargeTouchAreaKey;

@implementation UIControl (PKExtend)

- (UIEdgeInsets)pk_enlargeTouchInsets {
    NSValue *value = objc_getAssociatedObject(self, UIControlAssociatedPKEnlargeTouchAreaKey);
    return [value UIEdgeInsetsValue];
}

- (void)setPk_enlargeTouchInsets:(UIEdgeInsets)pk_enlargeTouchInsets {
    objc_setAssociatedObject(self, UIControlAssociatedPKEnlargeTouchAreaKey, [NSValue valueWithUIEdgeInsets:pk_enlargeTouchInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)pk_getEnlargedRect {
    UIEdgeInsets insets = self.pk_enlargeTouchInsets;
    if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, insets)) {
        return self.bounds;
    }
    return CGRectMake(self.bounds.origin.x - insets.left,
                      self.bounds.origin.y - insets.top,
                      self.bounds.size.width + insets.left + insets.right,
                      self.bounds.size.height + insets.top + insets.bottom);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isUserInteractionEnabled && !self.isHidden && self.alpha > 0) {
        CGRect rect = [self pk_getEnlargedRect];
        if (CGRectEqualToRect(rect, self.bounds)) {
            return [super hitTest:point withEvent:event];
        }
        return CGRectContainsPoint(rect, point) ? self : nil;
    }
    return nil;
}

@end

static const void *UIControlPKHandlersKey = &UIControlPKHandlersKey;

@interface _PKControlWrapper : NSObject <NSCopying>

- (id)initWithHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents;

@property (nonatomic) UIControlEvents controlEvents;
@property (nonatomic, copy) void (^handler)(id sender);

@end

@implementation _PKControlWrapper

- (id)initWithHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents {
    self = [super init];
    if (!self) return nil;
    self.handler = handler;
    self.controlEvents = controlEvents;
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[_PKControlWrapper alloc] initWithHandler:self.handler forControlEvents:self.controlEvents];
}

- (void)invoke:(id)sender {
    if (self.handler) self.handler(sender);
}

@end

@implementation UIControl (PKHandler)

- (void)pk_addEventHandler:(void (^)(id _Nonnull))handler forControlEvents:(UIControlEvents)controlEvents {
    NSParameterAssert(handler);
    NSMutableDictionary *events = objc_getAssociatedObject(self, UIControlPKHandlersKey);
    if (!events) {
        events = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, UIControlPKHandlersKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSNumber *key = @(controlEvents);
    NSMutableSet *handlers = events[key];
    if (!handlers) {
        handlers = [NSMutableSet set];
        events[key] = handlers;
    }
    _PKControlWrapper *target = [[_PKControlWrapper alloc] initWithHandler:handler forControlEvents:controlEvents];
    [handlers addObject:target];
    [self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
}

- (void)pk_removeEventHandlersForControlEvents:(UIControlEvents)controlEvents {
    NSMutableDictionary *events = objc_getAssociatedObject(self, UIControlPKHandlersKey);
    if (!events) {
        events = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, UIControlPKHandlersKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSNumber *key = @(controlEvents);
    NSSet *handlers = events[key];
    
    if (!handlers) return;
    
    [handlers enumerateObjectsUsingBlock:^(id sender, BOOL *stop) {
        [self removeTarget:sender action:NULL forControlEvents:controlEvents];
    }];
    
    [events removeObjectForKey:key];
}

- (BOOL)pk_hasEventHandlersForControlEvents:(UIControlEvents)controlEvents {
    NSMutableDictionary *events = objc_getAssociatedObject(self, UIControlPKHandlersKey);
    if (!events) {
        events = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, UIControlPKHandlersKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSNumber *key = @(controlEvents);
    NSSet *handlers = events[key];
    
    if (!handlers) return NO;
    return !!handlers.count;
}

@end
