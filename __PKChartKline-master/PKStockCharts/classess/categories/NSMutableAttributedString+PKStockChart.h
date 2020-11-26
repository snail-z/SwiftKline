//
//  NSMutableAttributedString+PKStockChart.h
//  PKChartKit
//
//  Created by zhanghao on 2017/12/28.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (PKStockChart)

/** 返回属性信息 */
@property (nullable, nonatomic, copy, readonly) NSDictionary<NSString *, id> *pk_attributes;

/** 文本字体 */
@property (nullable, nonatomic, strong, readonly) UIFont *pk_font;

/** 文本前景色 */
@property (nullable, nonatomic, strong, readonly) UIColor *pk_foregroundColor;

/** 文本背景色 */
@property (nullable, nonatomic, strong, readonly) UIColor *pk_backgroundColor;

/** 文本字距调整 */
@property (nullable, nonatomic, strong, readonly) NSNumber *pk_kern;

/** 文本基线偏移调整 */
@property (nullable, nonatomic, strong, readonly) NSNumber *pk_baselineOffset;

/** 文本描边宽度 */
@property (nullable, nonatomic, strong, readonly) NSNumber *pk_strokeWidth;

/** 文本描边颜色 */
@property (nullable, nonatomic, strong, readonly) UIColor *pk_strokeColor;

/** 文本阴影 */
@property (nullable, nonatomic, strong, readonly) NSShadow *pk_shadow;

- (void)pk_setFont:(UIFont *)font;
- (void)pk_setForegroundColor:(UIColor *)foregroundColor;
- (void)pk_setBackgroundColor:(UIColor *)backgroundColor;
- (void)pk_setKern:(NSNumber *)kern;
- (void)pk_setBaselineOffset:(NSNumber *)baselineOffset;
- (void)pk_setStrokeWidth:(NSNumber *)strokeWidth;
- (void)pk_setStrokeColor:(UIColor *)strokeColor;
- (void)pk_setShadow:(NSShadow *)shadow;
- (void)pk_setParagraphStyle:(NSParagraphStyle *)paragraphStyle;
- (void)pk_setFont:(UIFont *)font range:(NSRange)range;
- (void)pk_setForegroundColor:(UIColor *)color range:(NSRange)range;
- (void)pk_setBackgroundColor:(UIColor *)backgroundColor range:(NSRange)range;
- (void)pk_setKern:(NSNumber *)kern range:(NSRange)range;
- (void)pk_setBaselineOffset:(NSNumber *)baselineOffset range:(NSRange)range;
- (void)pk_setStrokeWidth:(NSNumber *)strokeWidth range:(NSRange)range;
- (void)pk_setStrokeColor:(UIColor *)strokeColor range:(NSRange)range;
- (void)pk_setShadow:(NSShadow *)shadow range:(NSRange)range;
- (void)pk_setParagraphStyle:(NSParagraphStyle *)paragraphStyle range:(NSRange)range;

+ (instancetype)pk_attributedWithString:(NSString *)aString;

@end

NS_ASSUME_NONNULL_END
