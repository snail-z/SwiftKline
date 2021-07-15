//
//  UIScreen+zhExtend.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/13.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (zhExtend)

@property (class, nonatomic, assign, readonly) CGSize size;
@property (class, nonatomic, assign, readonly) CGSize swapOfSize;
@property (class, nonatomic, assign, readonly) CGFloat width;
@property (class, nonatomic, assign, readonly) CGFloat height;
@property (class, nonatomic, assign, readonly) CGFloat scale;

@end
