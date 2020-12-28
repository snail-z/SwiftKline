//
//  UIScreen+PKExtend.h
//  PKCategories
//
//  Created by jiaohong on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScreen (PKExtend)

/** 获取屏幕缩放比例 */
@property (class, nonatomic, assign, readonly) CGFloat pk_scale;

/** 获取屏幕尺寸 */
@property (class, nonatomic, assign, readonly) CGSize pk_size;

/** 获取屏幕尺寸宽度 */
@property (class, nonatomic, assign, readonly) CGFloat pk_width;

/** 获取屏幕尺寸高度 */
@property (class, nonatomic, assign, readonly) CGFloat pk_height;

/** 交换屏幕尺寸宽高 */
@property (class, nonatomic, assign, readonly) CGSize pk_swapSize;

/** 获取当前屏幕的安全区域 (竖屏模式下) */
@property (class, nonatomic, assign, readonly) UIEdgeInsets pk_safeInsets;

/** 获取当前屏幕状态栏高度 */
@property (class, nonatomic, assign, readonly) CGFloat pk_statusBarHeight;

/** 获取导航栏+状态栏高度 */
@property (class, nonatomic, assign, readonly) CGFloat pk_totalNavHeight;

/** 获取TabBar+底部安全区高度 */
@property (class, nonatomic, assign, readonly) CGFloat pk_totalTabbarHeight;

@end

@interface UIScreen (PKScreenType)

/** 当前屏幕是否为iphone4/4s尺寸屏 */
@property (class, nonatomic, assign, readonly) BOOL pk_isIphone4;

/** iphone 5/5c/5s/se */
@property (class, nonatomic, assign, readonly) BOOL pk_isIphone5;

/** iphone 6/6s/7/8 */
@property (class, nonatomic, assign, readonly) BOOL pk_isIphone6;

/** iphone 6p/6sp/7p/8p */
@property (class, nonatomic, assign, readonly) BOOL pk_isIphone6p;

/** iphone x/xs/11pro */
@property (class, nonatomic, assign, readonly) BOOL pk_isIphoneX;

/** iphone xr/11 */
@property (class, nonatomic, assign, readonly) BOOL pk_isIphoneXR;

/** iphone xs max/11pro max */
@property (class, nonatomic, assign, readonly) BOOL pk_isIphoneMax;

/** 当前设备是否为全面屏 (iphone 11/11pro/11pro max/x/xs/xs max/xr) */
@property (class, nonatomic, assign, readonly) BOOL pk_isFull;

@end

NS_ASSUME_NONNULL_END
