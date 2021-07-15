//
//  NSObject+zhSwizzle.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/13.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (zhSwizzle)

+ (BOOL)zh_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;
+ (BOOL)zh_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;

@end
