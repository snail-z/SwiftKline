//
//  UIFont+PKExtend.h
//  PKCategories
//
//  Created by jiaohong on 2018/10/28.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (PKExtend)

/** 字体是否为粗体 */
@property (nonatomic, assign, readonly) BOOL pk_isBold;

/** 字体是否为斜体 */
@property (nonatomic, assign, readonly) BOOL pk_isItalic;

/** 将字体样式改为粗体，若无粗体样式则忽略此操作 */
@property (nonatomic, strong, readonly) UIFont *pk_boldFont;

/** 将字体样式改为斜体，若无斜体样式则忽略此操作 */
@property (nonatomic, strong, readonly) UIFont *pk_italicFont;

/** 将字体样式改为粗斜体，同上 */
@property (nonatomic, strong, readonly) UIFont *pk_boldItalicFont;

/** 将字体样式恢复默认样式 (no bold/italic/...) */
@property (nonatomic, strong, readonly) UIFont *pk_normalFont;

/** 通过CGFontRef和指定大小创建UIFont，若遇到错误则返回nil */
+ (nullable UIFont *)pk_fontWithCGFont:(CGFontRef)CGFont size:(CGFloat)size;

/** 根据像素值px来创建系统默认字体 */
+ (nullable UIFont *)pk_systemFontOfPixel:(CGFloat)pixel;

/** 根据像素值px来创建指定字体 */
+ (nullable UIFont *)pk_fontWithName:(NSString *)fontName pixel:(CGFloat)pixel;

/** 通过像素值px调整字体大小 */
- (UIFont *)pk_fontWithPixel:(CGFloat)pixel;

/** 获取字体族所有字体名称 */
+ (NSArray<NSString *> *)pk_entireFamilyNames;

@end

NS_ASSUME_NONNULL_END
