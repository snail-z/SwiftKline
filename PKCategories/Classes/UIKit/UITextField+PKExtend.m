//
//  UITextField+PKExtend.m
//  PKCategories
//
//  Created by jiaohong on 2018/10/29.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "UITextField+PKExtend.h"
#import <objc/runtime.h>

static void *UITextFieldAssociatedPKPlaceholderKey = &UITextFieldAssociatedPKPlaceholderKey;

@implementation UITextField (PKExtend)

- (UIColor *)pk_placeholderColor {
    id placeholderColor = objc_getAssociatedObject(self, _cmd);
    if (placeholderColor) return placeholderColor;
    if (@available(iOS 13, *)) {
        return [UIColor placeholderTextColor];
    } else {
        return [UIColor colorWithRed:60 / 255. green:60 / 255. blue:67 / 255. alpha:0.3];
    }
}

- (void)setPk_placeholderColor:(UIColor *)pk_placeholderColor {
    NSString *placeholder = self.placeholder;
    if (placeholder) {
        NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:placeholder];
        [attriText addAttribute:NSForegroundColorAttributeName value:pk_placeholderColor range:NSMakeRange(0, placeholder.length)];
        self.attributedPlaceholder = attriText;
    }
    objc_setAssociatedObject(self, @selector(pk_placeholderColor), pk_placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (NSString *)placeholder {
    NSString *placeholderText = objc_getAssociatedObject(self, UITextFieldAssociatedPKPlaceholderKey);
    if (placeholderText) return placeholderText;
    return self.attributedPlaceholder.string;
}

- (void)setPlaceholder:(NSString *)placeholder {
    objc_setAssociatedObject(self, UITextFieldAssociatedPKPlaceholderKey, placeholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIColor *placeholderClolor = [self pk_placeholderColor];
    if (placeholderClolor && placeholder) {
        self.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:placeholder];
        [self setPk_placeholderColor:placeholderClolor];
    }
}

#pragma clang diagnostic pop

- (void)pk_selectAllText {
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    [self setSelectedTextRange:range];
}

- (void)pk_setSelectedRange:(NSRange)range {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:NSMaxRange(range)];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

- (void)pk_clear {
    self.text = @"";
    self.attributedText = [[NSAttributedString alloc] initWithString:@""];
}

@end


@implementation UITextField (PKEdgeInsets)

+ (void)load {
    SEL selectors[] = {
        @selector(placeholderRectForBounds:),
        @selector(textRectForBounds:),
        @selector(editingRectForBounds:)
    };
    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"_pk_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (CGRect)_pk_placeholderRectForBounds:(CGRect)bounds {
    [self _pk_placeholderRectForBounds:bounds];
    CGRect rect = [self _pk_textRectForBounds:bounds];
    return UIEdgeInsetsInsetRect(rect, self.pk_placeHolderEdgeInsets);
}

- (CGRect)_pk_textRectForBounds:(CGRect)bounds {
    CGRect rect = [self _pk_textRectForBounds:bounds];
    return UIEdgeInsetsInsetRect(rect, self.pk_textEdgeInsets);
}

- (CGRect)_pk_editingRectForBounds:(CGRect)bounds {
    CGRect rect = [self _pk_textRectForBounds:bounds];
    return UIEdgeInsetsInsetRect(rect, self.pk_textEdgeInsets);
}

- (UIEdgeInsets)pk_textEdgeInsets {
    return [objc_getAssociatedObject(self, _cmd) UIEdgeInsetsValue];
}

- (void)setPk_textEdgeInsets:(UIEdgeInsets)pk_textEdgeInsets {
    NSValue *value = [NSValue valueWithUIEdgeInsets:pk_textEdgeInsets];
    objc_setAssociatedObject(self, @selector(pk_textEdgeInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)pk_placeHolderEdgeInsets {
    return [objc_getAssociatedObject(self, _cmd) UIEdgeInsetsValue];
}

- (void)setPk_placeHolderEdgeInsets:(UIEdgeInsets)pk_placeHolderEdgeInsets {
    NSValue *value = [NSValue valueWithUIEdgeInsets:pk_placeHolderEdgeInsets];
    objc_setAssociatedObject(self, @selector(pk_placeHolderEdgeInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
