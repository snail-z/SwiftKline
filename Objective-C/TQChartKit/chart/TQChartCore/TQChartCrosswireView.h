//
//  TQCrosswireView.h
//  CoreGraphics_demo
//
//  Created by zhanghao on 2018/6/21.
//  Copyright © 2018年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TQChartCrosswireView : UIView

/** 十字线宽度 */
@property (nonatomic, assign) CGFloat lineWidth;

/** 十字线颜色 */
@property (nonatomic, strong) UIColor *lineColor;

/** 文本颜色 */
@property (nonatomic, strong) UIColor *textColor;

/** 文本字体 */
@property (nonatomic, strong) UIFont *textFont;

/** 扩大文本边缘留白 */
@property (nonatomic, assign) UIOffset textEdgePadding;

/** 映射Y轴的文本 */
@property (nonatomic, strong) NSString *mapYaixsText;

/** 映射Y轴另一端的文本 */
@property (nonatomic, strong, nullable) NSString *mapYaixsSubjoinText;

/** 映射X轴的文本 */
@property (nonatomic, strong) NSString *mapIndexText;

/** 中间分隔区域 */
@property (nonatomic, assign) CGRect separationRect;

/** 当前手指触摸点位置 */
@property (nonatomic, assign) CGPoint spotOfTouched;

/** 实际绘制的交叉点位置 */
@property (nonatomic, assign) CGPoint centralPoint;

/** 隐藏视图(淡入淡出) */
@property (nonatomic, assign) BOOL fadeHidden;

/** 在delay秒后隐藏视图(淡出) */
- (void)fadeHiddenDelayed:(NSTimeInterval)delay;

/** 调用该方法以更新内容 */
- (void)updateContents;

@end

NS_ASSUME_NONNULL_END
