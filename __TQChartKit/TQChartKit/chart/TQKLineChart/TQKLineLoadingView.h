//
//  TQKLineLoadingView.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/26.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 加载状态 */
typedef NS_ENUM(NSInteger, TQKLineLoadingState) {
    TQKLineLoadingStateNormal = 0,
    TQKLineLoadingStatePending,   // 即将刷新
    TQKLineLoadingStateLoading    // 正在刷新中
};

@interface TQKLineLoadingView : UIView

/** 加载状态 */
@property (nonatomic, assign, readonly) TQKLineLoadingState loadState;

/** 加载视图偏移位置 */
@property (nonatomic, assign, readonly) CGFloat loadingInset;

/** 加载视图所在区域，在该范围内居中显示 */
@property (nonatomic, assign) CGRect loadingInRect;

/** 滑动到达边缘偏移位置时是否手动刷新，默认NO */
@property (nonatomic, assign) BOOL manualRefresh;

/** 菊花或文本颜色，默认[UIColor grayColor] */
@property (nonatomic, strong, nullable) UIColor *themeColor;

/** 默认为nil只显示菊花，反之只显示文本 */
@property (nonatomic, strong, nullable) NSString *normalText;
@property (nonatomic, strong, nullable) NSString *loadingText;

/** 加载回调 */
@property (nonatomic, copy) void (^loadingCallback)(TQKLineLoadingView *loadingView);

- (void)beginLoading;
- (void)endLoading;

@end

NS_ASSUME_NONNULL_END
