//
//  UIButton+zhImagePosition.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/2.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UIButton+zhImagePosition.h"
#import <objc/runtime.h>

@implementation UIButton (zhImagePosition)

- (CGFloat)zh_imagePositionSpacing {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)zh_setImagePosition:(zhImagePosition)postion spacing:(CGFloat)spacing {
    objc_setAssociatedObject(self, @selector(zh_imagePositionSpacing), @(spacing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    CGSize imageSize = self.imageView.image.size;
    CGSize labelSize = self.titleLabel.intrinsicContentSize;
    
    switch (postion) {
        case zhImagePositionLeft: {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, - spacing / 2, 0, spacing / 2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing / 2, 0, - spacing / 2);
        } break;
            
        case zhImagePositionRight: {
            CGFloat imageOffset = labelSize.width + spacing / 2;
            CGFloat titleOffset = imageSize.width + spacing / 2;
            self.imageEdgeInsets = UIEdgeInsetsMake(0, imageOffset, 0, - imageOffset);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, - titleOffset, 0, titleOffset);
        } break;
            
        case zhImagePositionTop: {
            self.imageEdgeInsets = UIEdgeInsetsMake(-labelSize.height - spacing, 0, 0, -labelSize.width);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -imageSize.height - spacing, 0);
        } break;
            
        case zhImagePositionBottom: {
            self.imageEdgeInsets = UIEdgeInsetsMake(labelSize.height + spacing, 0, 0, -labelSize.width);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, imageSize.height + spacing, 0);
        } break;
            
        default: break;
    }
}

@end
