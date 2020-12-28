//
//  UIScrollView+PKExtend.h
//  PKCategories
//
//  Created by jiaohong on 2018/10/29.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (PKExtend)

/** 获取整个滚动视图快照 (UIScrollView滚动内容区) */
- (UIImage *)pk_snapshot;

/** 吃掉滚动视图自动调整的Insets */
- (void)pk_eatAutomaticallyAdjustsInsets;

/** 使视图滚动到顶部 */
- (void)pk_scrollToTopAnimated:(BOOL)animated;

/** 使视图滚动到底部 */
- (void)pk_scrollToBottomAnimated:(BOOL)animated;

/** 使视图滚动到左部 */
- (void)pk_scrollToLeftAnimated:(BOOL)animated;

/** 使视图滚动到右部 */
- (void)pk_scrollToRightAnimated:(BOOL)animated;


@end

NS_ASSUME_NONNULL_END
