//
//  UIBarButtonItem+PKExtend.h
//  PKCategories
//
//  Created by zhanghao on 2018/10/29.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (PKExtend)

/** 初始化UIBarButtonItem并添加blcok事件 */
- (id)pk_initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem handler:(void (^)(id sender))action NS_REPLACES_RECEIVER;

/** 初始化UIBarButtonItem并添加blcok事件 */
- (id)pk_initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style handler:(void (^)(id sender))action NS_REPLACES_RECEIVER;

/** 初始化UIBarButtonItem并添加blcok事件 */
- (id)pk_initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style handler:(void (^)(id sender))action NS_REPLACES_RECEIVER;

/** 为UIBarButtonItem添加blcok事件 */
- (void)pk_addHandler:(void (^)(id sender))block;

@end


@interface UIBarButtonItem (PKIndicator)

/**
*  @brief 显示活动指示器UIActivityIndicatorView (活动指示器显示时图片标题将置空，指示器消失则恢复)
*
*  @param tintColor 设置活动指示器颜色
*/
- (void)pk_showIndicatorWithTintColor:(nullable UIColor *)tintColor;

/** 隐藏活动指示器 */
- (void)pk_hideIndicator;

/** 判断活动指示器是否正在显示 */
@property (nonatomic, assign, readonly) BOOL pk_isIndicatorShowing;

@end

NS_ASSUME_NONNULL_END
