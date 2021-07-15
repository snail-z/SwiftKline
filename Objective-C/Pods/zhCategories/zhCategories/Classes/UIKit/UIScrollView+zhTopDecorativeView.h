//
//  UIScrollView+zhTopDecorativeView.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/2.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (zhTopDecorativeView)

/** 在当前UIScrollView顶部插入一个UIImageView */
@property (nonatomic, strong, readonly) UIImageView *zh_topDecorativeView;

@end
