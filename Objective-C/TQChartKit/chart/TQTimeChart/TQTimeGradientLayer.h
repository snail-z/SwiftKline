//
//  TQTimeGradientLayer.h
//  CoreGraphics_demo
//
//  Created by zhanghao on 2018/7/13.
//  Copyright © 2018年 snail-z. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface TQTimeGradientLayer : CALayer

/** 是否关闭隐式动画，默认YES */
@property (nonatomic, assign) BOOL animationDisable;

/** 渐变颜色数组 */
@property (nonatomic, strong) NSArray<UIColor *> *gradientClolors;

/** 设置绘图路径 */
@property (nonatomic, assign) CGPathRef path;

@end
