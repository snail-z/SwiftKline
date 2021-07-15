//
//  UIView+zhBadge.h
//  zhCategories_Example
//
//  Created by zhanghao on 2017/12/21.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (zhBadge)

@property (nonatomic, strong, readonly) UILabel *zh_badgeLabel;

/** 给视图添加badge并设置文本 */
- (void)zh_badgeShowText:(nullable NSString *)text;

/** 隐藏badge */
- (void)zh_badgeHide;

/** 将从父视图上移除badge并恢复其它默认值 */
- (void)zh_badgeRemove;

/**
 设置badge的偏移位置, 其中心点默认为父视图的右上角
 offset.horizontal > 0，向右偏移，反之向左偏移
 offset.vertical > 0，向下偏移，反之向上偏移
 */
- (void)zh_badgeOffset:(UIOffset)offset;

/** 是否将badge设置为圆角，默认NO */
- (void)zh_badgeAlwaysRound:(BOOL)isRound;

/**
 用于等比例调整badge的大小
 注意：若需要同时设置圆角，应在调用`-zh_badgeAlwaysRound`该方法后再调用，否则该方法将无效!!!
 */
- (void)zh_badgeTransformHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
