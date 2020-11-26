//
//  PKChartGradientLayer2.h
//  PKStockCharts
//
//  Created by zhanghao on 2017/8/9.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface PKChartGradientLayer : CALayer

/** 是否关闭隐式动画，默认YES */
@property (nonatomic, assign) BOOL animationDisabled;

/** 渐变颜色数组 */
@property (nonatomic, strong) NSArray<UIColor *> *gradientClolors;

/** 设置绘图路径 */
@property (nonatomic, assign, nullable) CGPathRef path;

@end

NS_ASSUME_NONNULL_END
