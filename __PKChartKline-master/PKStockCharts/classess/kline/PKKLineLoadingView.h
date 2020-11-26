//
//  PKKLineLoadingView.h
//  PKChartKit
//
//  Created by zhanghao on 2017/12/6.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 加载状态 */
typedef NS_ENUM(NSInteger, PKKLineLoadingState) {
    /** 闲置状态 */
    PKKLineLoadingStateIdle = 0,
    /** 即将刷新 */
    PKKLineLoadingStatePending,
    /** 正在刷新中 */
    PKKLineLoadingStateLoading
};

@protocol PKKLineLoadingViewDelegate;

@interface PKKLineLoadingView : UIView

@property (nonatomic, weak) id<PKKLineLoadingViewDelegate> delegate;

/** 加载状态 */
@property (nonatomic, assign, readonly) PKKLineLoadingState loadState;

/** 加载视图偏移位置 */
@property (nonatomic, assign, readonly) CGFloat loadingInset;

/** 加载视图所在区域，在该范围内居中显示 */
@property (nonatomic, assign) CGRect loadingInRect;

/** 滑动到达边缘偏移位置时是否手动刷新，默认NO */
@property (nonatomic, assign) BOOL dragLoadingEnabled;

/** 菊花或文本颜色，默认[UIColor grayColor] */
@property (nonatomic, strong, nullable) UIColor *themeColor;

/** 普通加载文本 */
@property (nonatomic, strong, nullable) NSString *plainLoadingText;

/** 指示器文本 */
@property (nonatomic, strong, nullable) NSString *indicatorText;

/** 是否正在加载 */
@property (nonatomic, assign, readonly) BOOL isLoading;

/** 开始加载 */
- (void)beginLoading;

/** 停止加载 */
- (void)endLoading;

@end

@protocol PKKLineLoadingViewDelegate <NSObject>
@optional

/** 加载回调 */
- (void)loadingViewDidBeginLoading:(PKKLineLoadingView *)loadingView;

@end

NS_ASSUME_NONNULL_END
