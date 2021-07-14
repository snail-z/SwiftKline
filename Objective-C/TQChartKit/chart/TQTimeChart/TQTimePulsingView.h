//
//  TQTimePulsingView.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/28.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TQTimePulsingView : UIView

/** 内部固定圆点颜色 */
@property (nonatomic, strong) UIColor *standpointColor;

/** 脉冲圆点颜色 (默认为[standpointColor colorWithAlphaComponent:0.5]) */
@property (nonatomic, strong, nullable) UIColor *pulsingColor;

/** 内部固定圆半径 */
@property (nonatomic, assign) CGFloat standpointRadius;

/** 脉冲圆半径 (默认为standpointRadius的3倍) */
@property (nonatomic, assign) CGFloat pulsingRadius;

/** 是否处于动画中 */
@property (nonatomic, assign, readonly) BOOL isAnimating;

- (void)startAnimating;
- (void)stopAnimating;

@end
