//
//  NSString+zhTextCalculated.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/17.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (zhTextCalculated)

/** 计算文本 */
- (CGSize)zh_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

/** 计算文本的大小 (约束size) */
- (CGSize)zh_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

/** 计算文本的高度 (约束宽度) */
- (CGFloat)zh_heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;

/** 计算文本的宽度 (约束高度) */
- (CGFloat)zh_widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

@end
