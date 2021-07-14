//
//  TQStockTypeSegmentedBar.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/21.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TQStockTypeSegmentedBarDelegate;

@interface TQStockTypeSegmentedBar : UIView

@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong, readonly) NSMutableArray<UIButton *> *items;
@property (nonatomic, assign, readonly) NSInteger moreSelectedIndex;

@property (nonatomic, weak) id<TQStockTypeSegmentedBarDelegate> delegate;

/** 内边距 */
@property (nonatomic, assign) UIEdgeInsets contentInsets;

/** 设置选中项 */
@property (nonatomic, assign) NSInteger selectedIndex;

/** 选中项文本颜色 */
@property (nonatomic, assign) UIColor *selectedTextColor;

/** 未选中项文本颜色 */
@property (nonatomic, assign) UIColor *unselectedTextColor;

/** 文本字体 */
@property (nonatomic, strong) UIFont *textFont;

/** 底部滑动条高度 */
@property (nonatomic, assign) CGFloat barLineWidth;

/** 底部滑动条圆角 */
@property (nonatomic, assign) CGFloat barLineCornerRadius;

/** 用于旋转更多按钮的图标 */
@property (nonatomic, assign) CGAffineTransform moreItemImageTransform;

/** 更新更多按钮的标题 */
@property (nonatomic, strong) NSString *moreItemTitle;

/** 设置数据源 */
@property (nonatomic, strong) NSArray<NSString *> *titles;

@end

@protocol TQStockTypeSegmentedBarDelegate <NSObject>
@optional

/** 点击了每个item */
- (void)stockTypeSegmentedBar:(TQStockTypeSegmentedBar *)segmentedBar  didClickItemAtIndex:(NSInteger)index;

/** 点击了更多 */
- (void)stockTypeSegmentedBarDidClickMore:(TQStockTypeSegmentedBar *)segmentedBar;

@end
