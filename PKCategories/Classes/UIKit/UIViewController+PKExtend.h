//
//  UIViewController+PKExtend.h
//  PKCategories
//
//  Created by zhanghao on 2018/10/29.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (PKExtend)

/** 判断当前控制器是否正在显示 */
- (BOOL)pk_isVisible;

/**
 *  @brief  视图层级 (childViewControllers)
 *
 *  @return 视图层级字符串
 */
- (NSString *)pk_hierarchyDescription;

@end


@interface UIViewController (PKStatusBarStyle)

/** 是否隐藏状态栏 */
@property (nonatomic, assign) BOOL pk_statusBarHidden;

/** 修改状态栏样式 */
@property (nonatomic, assign) UIStatusBarStyle pk_statusBarStyle;

/** 恢复状态栏默认值 */
- (void)pk_statusBarRestoreDefaults;;

@end

NS_ASSUME_NONNULL_END
