//
//  TJWKWebViewTabController.h
//  TJWKWebViewController
//
//  Created by zhanghao on 2020/12/29.
//  Copyright © 2020 gren-beans. All rights reserved.
//

#import "TJWKWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TJWKWebViewTabController : TJWKWebViewController

/** 设置底部标签栏高度 */
@property (nonatomic, assign) CGFloat pageTabBarHeight;

/** 底部标签栏颜色，默认[UIColor blackColor] */
@property (nonatomic, strong) UIColor *pageTabBarTintColor;

@end

NS_ASSUME_NONNULL_END
