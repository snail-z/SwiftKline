//
//  TQKLineBaseChart.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/26.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TQKLineBaseChart : UIView

@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) CALayer *contentGridLayer;
@property (nonatomic, strong, readonly) CALayer *contentChartLayer;
@property (nonatomic, strong, readonly) CALayer *contentTextLayer;

/** 滚动视图的最大偏移量 */
@property (nonatomic, assign) CGFloat maxScrollOffsetX;

/** 滚动视图的最小偏移量 */
@property (nonatomic, assign) CGFloat minScrollOffsetX;

/** 将视图滚动到最左边 */
- (void)scrollToLeft;

/** 将视图滚动到最右边 */
- (void)scrollToRight;

@end
