//
//  CALayer+PKExtend.h
//  PKCategories
//
//  Created by zhanghao on 2018/10/30.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (PKFrameAdjust)

@property (nonatomic) CGFloat pk_left;
@property (nonatomic) CGFloat pk_top;
@property (nonatomic) CGFloat pk_right;
@property (nonatomic) CGFloat pk_bottom;
@property (nonatomic) CGFloat pk_width;
@property (nonatomic) CGFloat pk_height;
@property (nonatomic) CGPoint pk_center;
@property (nonatomic) CGFloat pk_centerX;
@property (nonatomic) CGFloat pk_centerY;
@property (nonatomic) CGPoint pk_origin;
@property (nonatomic) CGSize  pk_size;

@end


@interface CALayer (PKExtend)

/** 设置layer边框颜色 */
@property(nonatomic, assign) UIColor *pk_borderColor;

/** 删除layer的所有子图层 */
- (void)pk_removeAllSublayers;

/** 为图层添加阴影效果 */
- (void)pk_addShadow:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;

/** 为图层周围添加阴影效果 */
- (void)pk_addShadow:(UIColor *)color opacity:(CGFloat)opacity radius:(CGFloat)radius;

@end


@interface CALayer (PKAnimation)

/** 在水平方向添加摇晃动画 */
- (void)pk_addHorizontalShakeAnimation;

/** 在垂直方向添加摇晃动画 */
- (void)pk_addVerticalShakeAnimation;

/**
 * @brief 为layer添加摇晃动画，自定义参数
 *
 * @param duration 持续时长
 * @param repeatCount 重复次数
 * @param horizontal 若设置为YES则在水平方向晃动，反之则反
 * @param offset 摇晃偏移量
 */
- (void)pk_addShakeAnimationWithDuration:(NSTimeInterval)duration
                             repeatCount:(float)repeatCount
                              horizontal:(BOOL)horizontal
                                  offset:(CGFloat)offset;

/** 移除对应的摇晃动画(pk_addShakeAnimationWithDuration:...) */
- (void)pk_removePreviousShakeAnimation;

/**
 * @brief 当图层内容变化时，将以淡入淡出动画使内容渐变
 *
 * @param duration 持续时长
 * @param curve 动画曲线
 */
- (void)pk_addFadeAnimationWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve;

/** 移除对应的淡入淡出动画("-addFadeAnimationWithDuration:curve:") */
- (void)pk_removePreviousFadeAnimation;

@end

NS_ASSUME_NONNULL_END
