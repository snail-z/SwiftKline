//
//  UINavigationBar+PKExtend.h
//  PKCategories
//
//  Created by jiaohong on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (PKExtend)

/** 设置导航栏标题字体 */
@property (nonatomic, strong) UIFont *pk_titleFont;

/** 设置导航栏标题颜色 */
@property (nonatomic, strong) UIColor *pk_titleColor;

/** 设置导航栏背景和文本颜色 */
- (void)pk_setBackgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor;

/** 设置tintColor使导航栏透明 */
- (void)pk_makeTransparentWithTintColor:(UIColor *)tintColor;

@end

NS_ASSUME_NONNULL_END
