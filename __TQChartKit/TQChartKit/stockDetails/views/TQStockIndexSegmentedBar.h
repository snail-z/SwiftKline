//
//  TQStockIndexSegmentedBar.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/21.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TQStockIndexSegmentedBarDelegate;

@interface TQStockIndexSegmentedBar : UIView

@property (nonatomic, weak) id<TQStockIndexSegmentedBarDelegate> delegate;

/** 选中项文本颜色 */
@property (nonatomic, assign) UIColor *selectedTextColor;

/** 未选中项文本颜色 */
@property (nonatomic, assign) UIColor *unselectedTextColor;

/** 文本字体 */
@property (nonatomic, strong) UIFont *textFont;

/** 可视范围内显示个数 */
@property (nonatomic, assign) NSUInteger numberOfVisual;

/** 分割线颜色 */
@property (nonatomic, strong) UIColor *lineColor;

/** 线边缘留白 */
@property (nonatomic, assign) CGFloat lineEdgePadding;

/** 线宽 */
@property (nonatomic, assign) CGFloat lineWidth;

/** 设置头部选中项 */
@property (nonatomic, assign) NSInteger headerSelectedIndex;

/** 设置选中项 */
@property (nonatomic, assign) NSInteger selectedIndex;

/** 设置数据源 */
@property (nonatomic, strong) NSArray<NSString *> *titles;

/** 设置头部数据源 */
@property (nonatomic, strong) NSArray<NSString *> *headerTitles;

@end

@protocol TQStockIndexSegmentedBarDelegate <NSObject>
@optional

/** 点击了每个item */
- (void)stockIndexSegmentedBar:(TQStockIndexSegmentedBar *)segmentedBar didClickItemAtIndex:(NSInteger)index;

/** 点击了头部每个item */
- (void)stockIndexSegmentedBar:(TQStockIndexSegmentedBar *)segmentedBar didClickHeaderItemAtIndex:(NSInteger)index;

@end
