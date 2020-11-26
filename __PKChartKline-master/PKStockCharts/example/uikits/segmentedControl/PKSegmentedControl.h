//
//  PKSegmentedControl.h
//  PKOrnaments
//
//  Created by zhanghao on 2019/3/25.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PKSegmentedItem : NSObject

@end

@interface PKSegmentedTextItem : PKSegmentedItem

/** 默认初始化 */
+ (instancetype)itemWithTitles:(NSArray<NSString *> *)titles;

/** 所有分段标题 */
@property (nonatomic, strong) NSArray<NSString *> *titles;

/** 普通文本颜色 */
@property (nonatomic, strong) UIColor *normalTextColor;

/** 普通文本字体 */
@property (nonatomic, strong) UIFont *normalTextFont;

/** 选中文本颜色 */
@property (nonatomic, strong) UIColor *selectedTextColor;

/** 选中文本字体 */
@property (nonatomic, strong) UIFont *selectedTextFont;

@end

@interface PKSegmentedIconItem : PKSegmentedItem

/** 默认初始化 */
+ (instancetype)itemWithIcons:(NSArray<UIImage *> *)icons;

/** 所有分段图标 */
@property (nonatomic, strong) NSArray<UIImage *> *icons;

/** 设置图标大小 */
@property (nonatomic, assign) CGSize iconSzie;

/** 普通图标线条颜色 */
@property (nonatomic, strong) UIColor *normalTintColor;

/** 选中项图标线条颜色 */
@property (nonatomic, strong) UIColor *selectedTintColor;

@end


@interface PKSegmentedControl : UIControl

/** 通过item初始化PKSegmentedControl */
- (instancetype)initWithItem:(PKSegmentedItem *)item;

/** 当前选择项 */
@property (nonatomic, assign, readonly) NSInteger index;

/** 当前数据源 */
@property (nonatomic, strong, readonly) PKSegmentedItem *item;

/** 子视图内边距，默认2pt */
@property (nonatomic, assign) CGFloat indicatorViewInset;

/** 指示器边框宽度 */
@property (nonatomic, assign) CGFloat indicatorViewBorderWidth;

/** 指示器边框颜色 */
@property (nonatomic, strong) UIColor *indicatorViewBorderColor;

/** 指示器背景色 */
@property (nonatomic, strong) UIColor *indicatorViewBackgroundColor;

/** 视图圆角设置 */
@property (nonatomic, assign) CGFloat cornerRadius;

/** 分割线颜色 */
@property (nonatomic, strong) UIColor *separatorColor;

/** 分割线宽度，默认0pt */
@property (nonatomic, assign) CGFloat separatorWidth;

/** 是否禁用拖动手势，默认YES */
@property (nonatomic, assign) BOOL panningDisabled;

/** 是否开启切换选项动画，默认YES */
@property (nonatomic, assign) BOOL animateEnabled;

/** 是否开启边缘弹性效果，默认YES */
@property (nonatomic, assign) BOOL bouncesOnChange;

/** 是否仅下标改变后发送响应事件，默认YES */
@property (nonatomic, assign) BOOL announcesValueChanged;

/** 是否立即发送响应事件，默认YES */
@property (nonatomic, assign) BOOL announcesValueImmediately;

/** 选中index */
- (void)setWithIndex:(NSInteger)index animated:(BOOL)animated;

/** 更新item */
- (void)updateSegmentedItem:(PKSegmentedItem *)item;

@end

NS_ASSUME_NONNULL_END
