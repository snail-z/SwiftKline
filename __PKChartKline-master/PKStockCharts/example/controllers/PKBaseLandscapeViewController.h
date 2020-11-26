//
//  PKBaseLandscapeViewController.h
//  PKStockCharts
//
//  Created by zhanghao on 2019/8/22.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PKBaseLandscapeViewController : UIViewController

/** 容器视图，所有自定义视图的父视图 */
@property (nonatomic, strong, readonly) UIView *containerView;

/** 关闭当前页面的按钮 */
@property (nonatomic, strong, readonly) UIButton *closeButton;

@end

NS_ASSUME_NONNULL_END
