//
//  TQChartTextLayer.h
//  CoreGraphics_demo
//
//  Created by zhanghao on 2018/7/5.
//  Copyright © 2018年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TQChartTextRenderer : NSObject

/** 需要绘制的文本 */
@property (nonatomic, strong) NSString *text;

/** 文本颜色 */
@property (nonatomic, strong) UIColor *color;

/** 文本字体 */
@property (nonatomic, strong) UIFont *font;

/** 文本位置中心点 */
@property (nonatomic, assign) CGPoint positionCenter;

/** 文本区域背景色 */
@property (nonatomic, strong, nullable) UIColor *backgroundColor;

/** 文本区域边框线宽 */
@property (nonatomic, assign) CGFloat borderWidth;

/** 文本区域边框颜色 */
@property (nonatomic, strong, nullable) UIColor *borderColor;

/** 文本区域圆角 */
@property (nonatomic, assign) CGFloat cornerRadius;

/** 扩充文本区域 */
@property (nonatomic, assign) CGPoint enlargeInsets;

/** 文本区域宽度限制 (由于仅支持单行文本，暂不考虑换行限制) */
@property (nonatomic, assign) CGFloat maxWidth;

/**
 * 文字偏移比例 (取值范围0~1，默认值{0,1}) (基于position偏移) 如:
 * {0.5, 0.5} 则表示文本区域的中心点与文本位置中心点重叠;
 * {0, 0} 则表示文本区域左上点与文本位置中心点重叠;
 * {1, 0} 则表示文本区域右上点与文本位置中心点重叠
 *
 * {0, 0} 左上, {0.5, 0.5} 中心, {1, 1} 右下
 *
 * {0,   0}, {0.5,   0}, {1,   0},
 * {0, 0.5}, {0.5, 0.5}, {1, 0.5},
 * {0,   1}, {0.5,   1}, {1,   1}
 */
@property (nonatomic, assign) CGPoint offsetRatio;

/** 基于文本中心位置偏移 (默认UIOffsetZero)*/
@property (nonatomic, assign) UIOffset baseOffset;

+ (instancetype)defaultRenderer;

@end

@interface TQChartTextLayer : CALayer

@property (nonatomic, assign) BOOL animationDisable;

- (void)updateWithRendererArray:(NSArray<TQChartTextRenderer *> *)rendererArray;

@end

/* Offset ratio. */

CG_EXTERN CGPoint const kCGOffsetRatioTopLeft;
CG_EXTERN CGPoint const kCGOffsetRatioTopRight;
CG_EXTERN CGPoint const kCGOffsetRatioTopCenter;
CG_EXTERN CGPoint const kCGOffsetRatioBottomLeft;
CG_EXTERN CGPoint const kCGOffsetRatioBottomRight;
CG_EXTERN CGPoint const kCGOffsetRatioBottomCenter;
CG_EXTERN CGPoint const kCGOffsetRatioCenterLeft;
CG_EXTERN CGPoint const kCGOffsetRatioCenterRight;
CG_EXTERN CGPoint const kCGOffsetRatioCenter;

NS_ASSUME_NONNULL_END
