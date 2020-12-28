//
//  TJProgressLayer.h
//  TJCategories_Example
//
//  Created by zhanghao on 2020/12/16.
//  Copyright © 2020 gren-beans. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface TJProgressBarLayer : CALayer

/// 设置进度条轨道颜色
@property(nonatomic, nullable) CGColorRef trackTintColor;

/// 设置进度条进度颜色
@property(nonatomic, nullable) CGColorRef progressTintColor;

/// 设置动画时间，默认0.25s
@property(nonatomic, assign) NSTimeInterval animationDuration;

/// 是否自动调整 `cornerRadius` 使其始终保持为高度的 1/2，默认NO
@property(nonatomic, assign) BOOL adjustsRoundedCornersAutomatically;

/// 设置进度百分比 (范围在0~1之间)
@property(nonatomic, assign) float progress;

/// 设置进度值并动画显示
- (void)setProgress:(float)progress animated:(BOOL)animated;

@end


@interface TJProgressArcLayer : CALayer

/// 设置进度条轨道颜色
@property(nonatomic, nullable) CGColorRef trackTintColor;

/// 设置进度条进度颜色
@property(nonatomic, nullable) CGColorRef progressTintColor;

/// 设置动画时间，默认0.25s
@property(nonatomic, assign) NSTimeInterval animationDuration;

/// 设置开始角度
@property(nonatomic, assign) CGFloat startAngle;

/// 设置结束角度 (若不设置此值将自动绕圆闭合)
@property(nonatomic, assign) CGFloat endAngle;

/// 设置是否顺时针绘制轨道，默认YES
@property(nonatomic, assign) BOOL isClockwise;

/// 设置进度条轨道宽度
@property(nonatomic, assign) CGFloat trackWidth;

/// 设置进度百分比 (范围在0~1之间)
@property(nonatomic, assign) float progress;

/// 设置进度值并动画显示
- (void)setProgress:(float)progress animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
