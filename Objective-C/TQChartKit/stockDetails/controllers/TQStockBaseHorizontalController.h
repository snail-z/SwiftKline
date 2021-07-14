//
//  TQStockBaseHorizontalController.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/21.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TQStockBaseHorizontalController : UIViewController

/** 容器视图，所有自定义视图的父视图 */
@property (nonatomic, strong, readonly) UIView *containerView;

/** 关闭当前页面的按钮 */
@property (nonatomic, strong, readonly) UIButton *closeButton;

@end
