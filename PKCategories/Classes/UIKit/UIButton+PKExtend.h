//
//  UIButton+PKExtend.h
//  PKCategories
//
//  Created by zhanghao on 2018/10/30.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (PKExtend)

/** 设置UIButton背景色 */
- (void)pk_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end


@interface UIButton (PKIndicator)

/** 判断活动指示器是否正在显示中 */
@property (nonatomic, assign, readonly) BOOL pk_isShowingIndicator;

/** 显示活动指示器UIActivityIndicatorView (活动指示器显示时图片标题将置空，指示器消失则恢复) */
- (void)pk_showIndicator;

/**
 *  @brief 显示活动指示器和文本
 *
 *  @param text 自定义文本
 */
- (void)pk_showIndicatorWithText:(NSString *)text;

/**
 *  @brief 显示活动指示器 (背景色将置空，活动指示器消失则恢复)
 *
 *  @param tintColor 设置活动指示器颜色
 */
- (void)pk_showIndicatorClearedWithTintColor:(nullable UIColor *)tintColor;

/** 隐藏活动指示器 */
- (void)pk_hideIndicator;

@end

NS_ASSUME_NONNULL_END
