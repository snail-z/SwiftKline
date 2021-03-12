//
//  TJPickerDateView.h
//  TJCategories_Example
//
//  Created by zhanghao on 2020/12/23.
//  Copyright © 2020 gren-beans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+TJPickerDate.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TJPickerDateViewDelegate;

/// 年月日-日期选择器
@interface TJPickerYMDView : UIView

@property(nonatomic, weak) id<TJPickerDateViewDelegate> delegate;

/// 选中了某一列的某行时的回调 (代理方法优先)
@property(nonatomic, copy) void (^didSelectItem)(TJPickerYMDView *sender, id<TJPickerDataSource> item);

/// 设置每个条目行高，默认44
@property(nonatomic, assign) CGFloat rowHeight;

/// 设置文本字体
@property(nonatomic, strong, nullable) UIFont *textFont;

/// 设置文本颜色
@property(nonatomic, strong, nullable) UIColor *textColor;

/// 设置分隔线颜色
@property(nonatomic, strong, nullable) UIColor *separatorColor;

/// 设置每列分隔线布局宽度 (若该值大于0，则隐藏系统分隔线，使用自定义线段)
@property(nonatomic, assign) CGFloat columnLineMaxLayoutWidth;

/// 当前选中的日期
@property(nonatomic, strong, readonly) NSDate *selectedDate;

/// 设置数据源，包含每列的二维数组 @[@[a, b], @[c, d], @[e]]，数据源必须包含三列，自定义年份如下:
/// NSArray<id<TJPickerDataSource>> *items = [NSDate tj_yearsFrom:2000 toYear:2021];
/// pickerView.columnItems = @[items, [NSDate tj_months], [NSDate tj_daysOfDate:[NSDate date]]];
@property(nonatomic, copy, nullable) NSArray<NSArray<id<TJPickerDataSource>> *> *columnItems;

/// 刷新日期选择器
- (void)reloadComponents:(nullable NSDate *)date;

@end

@protocol TJPickerDateViewDelegate <NSObject>

/// 选中了某一列的某行时的回调
- (void)pickerDateView:(TJPickerYMDView *)sender didSelectItem:(id<TJPickerDataSource>)item;

@end

NS_ASSUME_NONNULL_END

