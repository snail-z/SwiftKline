//
//  UIBarButtonItem+PKExtend.m
//  PKCategories
//
//  Created by zhanghao on 2018/10/29.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "UIBarButtonItem+PKExtend.h"
#import <objc/runtime.h>

static const void *UIBarButtonItemPKHandlersKey = &UIBarButtonItemPKHandlersKey;

@interface _PKBarButtonItemBlockWrapper : NSObject

@property (nonatomic, copy) void (^block)(id sender);

- (id)initWithBlock:(void (^)(id sender))block;
- (void)invoke:(id)sender;

@end

@implementation _PKBarButtonItemBlockWrapper

- (id)initWithBlock:(void (^)(id sender))block{
    self = [super init];
    if (self) {
        _block = [block copy];
    }
    return self;
}

- (void)invoke:(id)sender {
    if (self.block) self.block(sender);
}

@end

@implementation UIBarButtonItem (PKExtend)

- (id)pk_initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem handler:(void (^)(id _Nonnull))action {
    self = [self initWithBarButtonSystemItem:systemItem target:nil action:nil];
    if (!self) return nil;
    [self pk_addHandler:action];
    return self;
}

- (id)pk_initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style handler:(void (^)(id _Nonnull))action {
    self = [self initWithImage:image style:style target:nil action:nil];
    if (!self) return nil;
    [self pk_addHandler:action];
    return self;
}

- (id)pk_initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style handler:(void (^)(id _Nonnull))action {
    self = [self initWithTitle:title style:style target:nil action:nil];
    if (!self) return nil;
    [self pk_addHandler:action];
    return self;
}

- (void)pk_addHandler:(void (^)(id _Nonnull))block {
    _PKBarButtonItemBlockWrapper *target = [[_PKBarButtonItemBlockWrapper alloc] initWithBlock:block];
    objc_setAssociatedObject(self, &UIBarButtonItemPKHandlersKey, target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setTarget:target];
    [self setAction:@selector(invoke:)];
}

@end

static void *UIBarButtonItemAssociatedPKIndicatorViewKey = &UIBarButtonItemAssociatedPKIndicatorViewKey;
static void *UIBarButtonItemAssociatedPKCustomViewKey = &UIBarButtonItemAssociatedPKCustomViewKey;

@implementation UIBarButtonItem (PKIndicator)

- (BOOL)pk_isIndicatorShowing {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setPk_isIndicatorShowing:(BOOL)pk_isIndicatorShowing {
    objc_setAssociatedObject(self, @selector(pk_isIndicatorShowing), @(pk_isIndicatorShowing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)pk_showIndicatorWithTintColor:(UIColor *)tintColor {
    if (self.pk_isIndicatorShowing) return;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.color = tintColor;
    
    objc_setAssociatedObject(self, UIBarButtonItemAssociatedPKIndicatorViewKey, indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, UIBarButtonItemAssociatedPKCustomViewKey, self.customView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.customView = indicator;
    self.customView.userInteractionEnabled = NO;
    [indicator startAnimating];
    self.pk_isIndicatorShowing = YES;
}

- (void)pk_hideIndicator {
    if (!self.pk_isIndicatorShowing) return;
    
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)objc_getAssociatedObject(self, UIBarButtonItemAssociatedPKIndicatorViewKey);
    if (!indicator) return;
    [indicator stopAnimating];
    [indicator removeFromSuperview];
    
    UIView *customView = objc_getAssociatedObject(self, UIBarButtonItemAssociatedPKCustomViewKey);
    self.customView = customView;
    self.customView.userInteractionEnabled = YES;
    self.pk_isIndicatorShowing = NO;
    
    objc_setAssociatedObject(self, UIBarButtonItemAssociatedPKIndicatorViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, UIBarButtonItemAssociatedPKCustomViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
