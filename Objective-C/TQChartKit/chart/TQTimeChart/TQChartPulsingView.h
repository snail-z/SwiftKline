//
//  TQChartPulsingView.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/25.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TQChartPulsingView : UIView

/** 内部固定圆点颜色 */
@property (nonatomic, strong) UIColor *standpointColor;

/** 脉冲圆点颜色 (默认为[standpointColor colorWithAlphaComponent:0.5] ) */
@property (nonatomic, strong, nullable) UIColor *pulsingColor;

/** 内部固定圆半径 */
@property (nonatomic, assign) CGFloat standpointRadius;

/** 脉冲圆半径 (若不设置，默认为standpointRadius的3倍) */
@property (nonatomic, assign) CGFloat pulsingRadius;

@property (nonatomic, assign) BOOL isAnimating;
- (void)startAnimating;
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
