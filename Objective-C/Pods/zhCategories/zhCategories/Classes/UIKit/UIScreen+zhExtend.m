//
//  UIScreen+zhExtend.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/13.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UIScreen+zhExtend.h"

@implementation UIScreen (zhExtend)

+ (CGSize)size {
    return [[UIScreen mainScreen] bounds].size;
}

+ (CGSize)swapOfSize {
    return CGSizeMake([self size].height, [self size].width);
}

+ (CGFloat)width {
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)height {
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat)scale {
    return [UIScreen mainScreen].scale;
}

@end
