//
//  TJPickerView.h
//  TJCategories_Example
//
//  Created by zhanghao on 2020/12/22.
//  Copyright © 2020 gren-beans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJPickerDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TJPickerViewDelegate;

@interface TJPickerView : UIView

@property(nonatomic, weak) id<TJPickerViewDelegate> delegate;

/// 选中了某一列的某行时的回调 (代理方法优先)
@property(nonatomic, copy) void (^didSelectItem)(TJPickerView *sender, id<TJPickerDataSource> item);

/// 设置每个条目行高，默认44
@property(nonatomic, assign) CGFloat rowHeight;

/// 设置文本字体
@property(nonatomic, strong, nullable) UIFont *textFont;

/// 设置文本颜色
@property(nonatomic, strong, nullable) UIColor *textColor;

/// 设置分隔线颜色
@property(nonatomic, strong, nullable) UIColor *separatorColor;

/// 当前选中的条目
@property(nonatomic, copy, readonly) NSArray<id<TJPickerDataSource>> *selectedItems;

/// 设置单列数据源，仅一列时可通过该属性设置
@property(nonatomic, copy, nullable) NSArray<id<TJPickerDataSource>> *oneColumnItems;

/// 设置多列数据源，包含每列的二维数组 @[@[a, b], @[c, d], @[e, f, g]]
@property(nonatomic, copy) NSArray<NSArray<id<TJPickerDataSource>> *> *columnItems;

/// 更新某列的数据源
- (void)updateItems:(NSArray<id<TJPickerDataSource>> *)items inColumn:(NSInteger)column;

/// 设置需要选中的项
- (void)setSelectItems:(NSArray<id<TJPickerDataSource>> *)items;

/// 通过唯一标识码设置需要选中的项
- (void)setSelectIdentifiers:(NSArray<NSNumber *> *)identifiers;

@end

@protocol TJPickerViewDelegate <NSObject>

/// 选中了某一列的某行时的回调
- (void)pickerView:(TJPickerView *)pickerView didSelectItem:(id<TJPickerDataSource>)item;

@end

NS_ASSUME_NONNULL_END
