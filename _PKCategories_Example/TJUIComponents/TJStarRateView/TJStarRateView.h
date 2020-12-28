//
//  TJStarRateView.h
//  TJCategories_Example
//
//  Created by zhanghao on 2020/12/24.
//  Copyright © 2020 gren-beans. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TJStarRateType) {
    /// 整颗星
    TJStarRateTypeWhole,
    /// 半颗星
    TJStarRateTypeHalf,
    /// 无限制
    TJStarRateTypeUnlimited
};

@protocol TJStarRateViewDelegate;

@interface TJStarRateView : UIView

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

/// 使用指定构造器初始，设置星星数量
- (instancetype)initWithItemCount:(NSInteger)count;

@property(nonatomic, weak) id<TJStarRateViewDelegate> delegate;

/// 当前分数发生改变时的回调 (代理方法优先)
@property(nonatomic, copy) void (^didScoreChanged)(TJStarRateView *sender, float currentScore);

/// 设置未选中星星图片 (分别设置不同图片)
@property(nonatomic, copy) NSArray<UIImage *> *uncheckedImages;

/// 设置已选中星星图片 (分别设置不同图片)
@property(nonatomic, copy) NSArray<UIImage *> *checkedImages;

/// 设置未选中星星图片
@property(nonatomic, nullable) UIImage *uncheckedImage;

/// 设置已选中星星图片
@property(nonatomic, nullable) UIImage *checkedImage;

/// 设置评分类型，默认整颗星类型
@property(nonatomic, assign) TJStarRateType rateType;

/// 设置星星间距，默认10pt
@property(nonatomic, assign) CGFloat itemSpacing;

/// 设置星星大小，默认宽高等于父视图高度
@property(nonatomic, assign) CGSize itemSize;

/// 设置边缘留白，默认0pt
@property(nonatomic, assign) UIEdgeInsets contentEdgeInsets;

/// 是否响应点击事件，默认YES
@property(nonatomic, assign) BOOL isTouchEnabled;

/// 是否响应滑动事件，默认YES
@property(nonatomic, assign) BOOL isSlideEnabled;

/// 超出父视图是否响应滑动事件，默认YES
@property(nonatomic, assign) BOOL isSlideOutside;

/// 设置最大分值，默认5
@property(nonatomic, assign) float maxScore;

/// 设置默认分值，默认0
@property(nonatomic, assign) float defaultScore;

/// 当前评分值
@property(nonatomic, assign, readonly) float currentScore;

@end

@protocol TJStarRateViewDelegate <NSObject>

/// 当前分数发生改变时的回调
- (void)starRateView:(TJStarRateView *)sender currentScoreChanged:(float)currentScore;

@end

NS_ASSUME_NONNULL_END
