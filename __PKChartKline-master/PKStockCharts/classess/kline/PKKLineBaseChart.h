//
//  PKKLineBaseChart.h
//  PKChartKit
//
//  Created by zhanghao on 2017/12/06.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PKKLineBaseChart : UIView

@property (nonatomic, strong, readonly) UIView *containerView;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) CALayer *contentGridLayer;
@property (nonatomic, strong, readonly) CALayer *contentChartLayer;
@property (nonatomic, strong, readonly) CALayer *contentTopCahrtLayer;
@property (nonatomic, strong, readonly) CALayer *contentTextLayer;

/** 滚动视图的最大偏移量 */
@property (nonatomic, assign, readonly) CGFloat maxScrollOffsetX;

/** 滚动视图的最小偏移量 */
@property (nonatomic, assign, readonly) CGFloat minScrollOffsetX;

/** 将视图滚动到最左边 */
- (void)scrollToLeft;

/** 将视图滚动到最右边 */
- (void)scrollToRight;

@end

NS_ASSUME_NONNULL_END
