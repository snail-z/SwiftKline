//
//  PKChartCrosshairView.h
//  PKChartKit
//
//  Created by zhanghao on 2017/11/28.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PKChartCrosshairViewDelegate;

@interface PKChartCrosshairView : UIView

@property (nonatomic, weak) id<PKChartCrosshairViewDelegate> delegate;

/** 十字线颜色 */
@property (nonatomic, strong) UIColor *lineColor;

/** 十字线宽度 */
@property (nonatomic, assign) CGFloat lineWidth;

/** 十字圆点颜色 */
@property (nonatomic, strong) UIColor *dotColor;

/** 十字圆点半径 */
@property (nonatomic, assign) CGFloat dotRadius;

/** 文本颜色 */
@property (nonatomic, strong) UIColor *textColor;

/** 文本字体 */
@property (nonatomic, strong) UIFont *textFont;

/** 扩大文本边缘留白 */
@property (nonatomic, assign) UIOffset textEdgePadding;

/** 忽略区域，默认CGRectZero */
@property (nonatomic, assign) CGRect ignoreZone; 

/** 十字横线对应文本 */
@property (nonatomic, copy) NSString *horizontalLeftText;

/** 十字横线右端对应文本 */
@property (nonatomic, copy, nullable) NSString *horizontalRightText;

/** 十字纵线对应文本 */
@property (nonatomic, copy) NSString *verticalBottomText;

/** 点击了十字纵线提示视图 */
@property (nonatomic, copy) void (^verticalTextClicked)(void);

/** 十字线视图是否正在显示 */
@property (nonatomic, assign, readonly) BOOL isPresenting;

/** 显示视图 */
- (void)present;

/** 隐藏视图 */
- (void)dismiss;

/** 在duration秒后隐藏视图 */
- (void)dismissDelay:(NSTimeInterval)duration;

/**
 *  更新十字线位置
 *
 *  @param center 十字线中心点
 *  @param locationOfTouched 当前手指触摸点位置
 */
- (void)updateContentsInCenter:(CGPoint)center touched:(CGPoint)locationOfTouched;

@end

@protocol PKChartCrosshairViewDelegate <NSObject>
@optional

/** 视图已经显示 */
- (void)crosshairViewDidPresent:(PKChartCrosshairView *)crosshairView;

/** 视图已经消失 */
- (void)crosshairViewDidDismiss:(PKChartCrosshairView *)crosshairView;

@end

NS_ASSUME_NONNULL_END
