//
//  PKChartFlashingView.h
//  PKChartKit
//
//  Created by zhanghao on 2017/11/27.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PKChartFlashingView : UIView

/** 内部固定圆点颜色 */
@property (nonatomic, strong) UIColor *standpointColor;

/** 内部固定圆点半径 */
@property (nonatomic, assign) CGFloat standpointRadius;

/** 脉冲圆点颜色 (默认为[standpointColor colorWithAlphaComponent:0.5]) */
@property (nonatomic, strong, nullable) UIColor *flashingColor;

/** 脉冲圆半径 (默认为standpointRadius的3倍) */
@property (nonatomic, assign) CGFloat flashingRadius;

/** 是否处于动画中 */
@property (nonatomic, assign, readonly) BOOL isAnimating;

/** 开始动画 */
- (void)startAnimating;

/** 停止动画 */
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
