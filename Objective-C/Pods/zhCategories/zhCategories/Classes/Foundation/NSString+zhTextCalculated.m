//
//  NSString+zhTextCalculated.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/17.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "NSString+zhTextCalculated.h"

@implementation NSString (zhTextCalculated)

- (CGSize)zh_sizeWithFont:(UIFont *)font
        constrainedToSize:(CGSize)size
            lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if (!font) font = [UIFont systemFontOfSize:UIFont.systemFontSize];

    CGSize result = CGSizeZero;
    
    if (self == nil || self.length <= 0 || [self isEqualToString:@""] || [self isEqualToString:@"(null)"]) {
        return result;
    }
    
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return CGSizeMake(ceil(result.width), ceil(result.height));
}

- (CGSize)zh_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    return [self zh_sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGFloat)zh_heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width {
    CGSize size = [self zh_sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height;
}

- (CGFloat)zh_widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height {
    CGSize size = [self zh_sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, height) lineBreakMode:NSLineBreakByWordWrapping];
    return size.width;
}

@end
