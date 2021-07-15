//
//  UINavigationBar+zhAuxiliary.h
//  zhCategories_Example
//
//  Created by zhanghao on 2017/12/25.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (zhAuxiliary)

- (nullable UIFont *)zh_getTitleTextFont;
- (nullable UIColor *)zh_getTitleTextColor;

/** 设置导航栏标题字体和颜色 */
- (void)zh_setTitleTextFont:(nullable UIFont *)textFont andTextColor:(nullable UIColor *)textColor;

/** 为导航栏设置背景颜色 */
@property (nonatomic, strong, nullable, setter=zh_setBackgroundColor:) UIColor *zh_backgroundColor;

/** 为导航栏设置背景图片 */
@property (nonatomic, strong, nullable, setter=zh_setBackgroundImage:) UIImage *zh_backgroundImage;

/** 设置导航栏的背景透明度 */
@property (nonatomic, assign, setter=zh_setBackgroundAlpha:) CGFloat zh_backgroundAlpha;

/** 设置导航栏上所有item的透明度 (是否包括系统的返回按钮) */
- (void)zh_setItemsAlpha:(CGFloat)alpha excludeBackIndicator:(BOOL)excludeBackIndicator;

/** 获取对应的`zh_setItemsAlpha:`透明度值 */
- (CGFloat)zh_getItemsAlpha;

@end

NS_ASSUME_NONNULL_END
