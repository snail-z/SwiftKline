//
//  CALayer+zhLayout.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/17.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (zhLayout)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGPoint center;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

@end
