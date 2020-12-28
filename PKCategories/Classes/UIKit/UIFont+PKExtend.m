//
//  UIFont+PKExtend.m
//  PKCategories
//
//  Created by jiaohong on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import "UIFont+PKExtend.h"

@implementation UIFont (PKExtend)

- (BOOL)pk_isBold {
    if (![self respondsToSelector:@selector(fontDescriptor)]) return NO;
    return (self.fontDescriptor.symbolicTraits & UIFontDescriptorTraitBold) > 0;
}

- (BOOL)pk_isItalic {
    if (![self respondsToSelector:@selector(fontDescriptor)]) return NO;
    return (self.fontDescriptor.symbolicTraits & UIFontDescriptorTraitItalic) > 0;
}


- (UIFont *)pk_boldFont {
    UIFontDescriptor *descriptor = [self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    if (descriptor) {
        return [UIFont fontWithDescriptor:descriptor size:self.pointSize];
    }
    return self;
}

- (UIFont *)pk_italicFont {
    UIFontDescriptor *descriptor = [self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
    if (descriptor) {
        return [UIFont fontWithDescriptor:descriptor size:self.pointSize];
    }
    return self;
}

- (UIFont *)pk_boldItalicFont {
    UIFontDescriptor *descriptor = [self.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold | UIFontDescriptorTraitItalic];
    if (descriptor) {
        return [UIFont fontWithDescriptor:descriptor size:self.pointSize];
    }
    return self;
}

- (UIFont *)pk_normalFont {
    UIFontDescriptor *descriptor = [self.fontDescriptor fontDescriptorWithSymbolicTraits:0];
    if (descriptor) {
        return [UIFont fontWithDescriptor:descriptor size:self.pointSize];
    }
    return self;
}

+ (UIFont *)pk_fontWithCGFont:(CGFontRef)CGFont size:(CGFloat)size {
    if (!CGFont) return nil;
    CFStringRef name = CGFontCopyPostScriptName(CGFont);
    if (!name) return nil;
    UIFont *font = [self fontWithName:(__bridge NSString *)(name) size:size];
    CFRelease(name);
    return font;
}

+ (CGFloat)pk_pointsByPixel:(CGFloat)px {
    static CGFloat scaleFactor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIUserInterfaceIdiom idiom = [UIDevice currentDevice].userInterfaceIdiom;
        if (idiom == UIUserInterfaceIdiomPad) {
            scaleFactor = 0.5;
        } else if (idiom == UIUserInterfaceIdiomPhone) {
            scaleFactor = 8.0 / 15.0;
        } else {
            scaleFactor = 0.5;
        }
    });
    return scaleFactor * px;
}

+ (UIFont *)pk_systemFontOfPixel:(CGFloat)pixel {
    return [UIFont systemFontOfSize:[self pk_pointsByPixel:pixel]];
}

+ (UIFont *)pk_fontWithName:(NSString *)fontName pixel:(CGFloat)pixel {
    return [UIFont fontWithName:fontName size:[self pk_pointsByPixel:pixel]];
}

- (UIFont *)pk_fontWithPixel:(CGFloat)pixel {
    return [self fontWithSize:[UIFont pk_pointsByPixel:pixel]];
}

+ (NSArray<NSString *> *)pk_entireFamilyNames {
    NSMutableArray *fontNames = [NSMutableArray array];
    for (NSString *family in [UIFont familyNames]) {
        for (NSString *name in [UIFont fontNamesForFamilyName:family]) {
            [fontNames addObject:name];
        }
    }
    return [fontNames sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
}

@end
