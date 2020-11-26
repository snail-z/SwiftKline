//
//  PKSegmentedSlideControl.h
//  PKOrnaments
//
//  Created by zhanghao on 2019/4/24.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PKSegmentedSlideControl : UIControl

/** 通过item初始化PKSegmentedSlideControl */
- (instancetype)initWithTitles:(NSArray<NSString *> *)titles;

/** 当前选择项 */
@property (nonatomic, assign, readonly) NSInteger index;

/** 当前数据源 */
@property (nonatomic, strong, readonly) NSArray<NSString *> *titles;

/** 是否动画中 */
@property (nonatomic, assign, readonly) BOOL isAnimating;

/** 文本字体 */
@property (nonatomic, strong) UIFont *plainTextFont;

/** 文本颜色 */
@property (nonatomic, strong) UIColor *normalTextColor;

/** 选中项颜色 */
@property (nonatomic, strong) UIColor *selectedTextColor;

/** 边缘留白 */
@property (nonatomic, assign) CGFloat paddingInset;

/** 子视图间距，当设置`numberOfPageItems`后该间距会自动调整 */
@property (nonatomic, assign) CGFloat innerSpacing;

/** 可视区域展示的个数 */
@property (nonatomic, assign) NSInteger numberOfPageItems;

/** 指示条宽度 */
@property (nonatomic, assign) CGFloat indicatorLineWidth;

/** 指示条圆角设置 */
@property (nonatomic, assign) CGFloat indicatorCornerRadius;

/** 边缘弹性效果 */
@property (nonatomic, assign) BOOL allowBounces;

/** 是否立即发送响应事件，默认YES */
@property (nonatomic, assign) BOOL announcesValueImmediately;

/** 选中index */
- (void)setWithIndex:(NSInteger)index animated:(BOOL)animated;

/** 更新数据源 */
- (void)updateSegmentedTitles:(NSArray<NSString *> *)titles;

/** 指示条进度更新 */
- (void)updateWithProgress:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
