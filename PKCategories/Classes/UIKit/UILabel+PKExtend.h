//
//  UILabel+PKExtend.h
//  PKCategories
//
//  Created by zhanghao on 2018/10/30.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (PKExtend)

/** 设置文本时显示fade动画 */
- (void)pk_setText:(NSString *)text fadeDuration:(NSTimeInterval)duration;

/** 获取自适应估算大小 */
- (CGSize)pk_estimatedSize;

/** 获取自适应估算宽度 */
- (CGFloat)pk_estimatedWidth;

/** 获取自适应估算高度 */
- (CGFloat)pk_estimatedHeight;

@end

@interface UILabel (PKTextEdge)

/** 调整文本内边距 */
@property (nonatomic, assign) UIEdgeInsets pk_textEdgeInsets;

@end

NS_ASSUME_NONNULL_END
