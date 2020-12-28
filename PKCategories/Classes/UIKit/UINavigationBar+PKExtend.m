//
//  UINavigationBar+PKExtend.m
//  PKCategories
//
//  Created by jiaohong on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "UINavigationBar+PKExtend.h"

@implementation UINavigationBar (PKExtend)

- (UIFont *)pk_titleFont {
    id value = [self.titleTextAttributes objectForKey:NSFontAttributeName];
    if ([value isKindOfClass:[UIFont class]]) return (UIFont *)value;
    return nil;
}

- (void)setPk_titleFont:(UIFont *)pk_titleFont {
    NSDictionary *originAttributes = [self titleTextAttributes];
    NSMutableDictionary *textAttributes = originAttributes ? originAttributes.mutableCopy : @{}.mutableCopy;
    if (pk_titleFont) textAttributes[NSFontAttributeName] = pk_titleFont;
    self.titleTextAttributes = textAttributes;
}

- (UIColor *)pk_titleColor {
    id value = [self.titleTextAttributes objectForKey:NSForegroundColorAttributeName];
    if ([value isKindOfClass:[UIColor class]]) return (UIColor *)value;
    return nil;
}

- (void)setPk_titleColor:(UIColor *)pk_titleColor {
    NSDictionary *originAttributes = [self titleTextAttributes];
    NSMutableDictionary *textAttributes = originAttributes ? originAttributes.mutableCopy : @{}.mutableCopy;
    if (pk_titleColor) textAttributes[NSForegroundColorAttributeName] = pk_titleColor;
    self.titleTextAttributes = textAttributes;
}

- (void)pk_setBackgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor {
    self.translucent = NO;
    self.backgroundColor = backgroundColor;
    self.barTintColor = backgroundColor;
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.tintColor = textColor;
    self.titleTextAttributes = @{NSForegroundColorAttributeName : textColor};
}

- (void)pk_makeTransparentWithTintColor:(UIColor *)tintColor {
    self.translucent = YES;
    self.backgroundColor = [UIColor clearColor];
    self.barTintColor = [UIColor clearColor];
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.tintColor = tintColor;
    self.titleTextAttributes = @{NSForegroundColorAttributeName : tintColor};
    self.shadowImage = [UIImage new];
}

@end
