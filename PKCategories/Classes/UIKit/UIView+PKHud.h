//
//  UIView+PKHud.h
//  PKCategories
//
//  Created by corgi on 2020/6/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PKHudStyle : NSObject

+ (instancetype)sharedInstance;

/** 背景色 */
@property (nonatomic, strong) UIColor *backgroundColor;

/** 文本颜色 */
@property (nonatomic, strong) UIColor *messageColor;

/** 图片颜色 (若为nil则使用原图片) */
@property (nonatomic, strong) UIColor *imageColor;

/** 文本字体 */
@property (nonatomic, strong) UIFont *messageFont;

/** 文本对齐样式 */
@property (nonatomic, assign) NSTextAlignment messageAlignment;

/** 文本最大行数 (默认无限制) */
@property (nonatomic, assign) NSInteger messageNumberOfLines;

/** 文本最大宽度限制 */
@property (nonatomic, assign) CGFloat messageLayoutMaxWidth;

/** 文本最大高度限制 */
@property (nonatomic, assign) CGFloat messageLayoutMaxHeight;

/** 图片尺寸 */
@property (nonatomic, assign) CGSize imageSize;

/** 淡入淡出动画时间 */
@property (nonatomic, assign) NSTimeInterval fadeDuration;

/** 圆角半径 */
@property (nonatomic, assign) CGFloat cornerRadius;

/** 子视图间距 */
@property (nonatomic, assign) CGFloat lineSpacing;

/** 位置偏移 */
@property (nonatomic, assign) CGFloat positionOffset;

/** 内容边缘留白 */
@property (nonatomic, assign) UIEdgeInsets paddingInsets;

@end

/// HUD子视图布局
typedef NS_ENUM(NSInteger, PKHudLayout) {
    PKHudLayoutLeft = 0,    // 图片在左，文字在右
    PKHudLayoutRight,       // 图片在右，文字在左
    PKHudLayoutTop,         // 图片在上，文字在下
    PKHudLayoutBottom,      // 图片在下，文字在上
};

/// HUD显示位置
typedef NS_ENUM(NSInteger, PKHudPosition) {
    PKHudPositionTop = 0,   // 在父视图顶部显示
    PKHudPositionCenter,    // 在父视中间部显示
    PKHudPositionBottom     // 在父视底顶部显示
};

@interface UIView (PKHud)

/** 仅文本样式HUD */
- (void)pk_showHudText:(NSString *)message;

- (void)pk_showHudText:(NSString *)message position:(PKHudPosition)position style:(PKHudStyle *)style;

/** 仅图片样式HUD */
- (void)pk_showHudImage:(UIImage *)image;

- (void)pk_showHudImage:(UIImage *)image spin:(BOOL)isSpin;

- (void)showHudImage:(UIImage *)image spin:(BOOL)isSpin
            position:(PKHudPosition)position
               style:(PKHudStyle *)style;

/** 图片文本样式HUD */
- (void)pk_showHud:(NSString *)message image:(UIImage *)image;

- (void)pk_showHud:(NSString *)message image:(UIImage *)image spin:(BOOL)isSpin;

- (void)pk_showHud:(NSString *)message image:(UIImage *)image layout:(PKHudLayout)layout;

- (void)pk_showHud:(NSString *)message
             image:(UIImage *)image
              spin:(BOOL)isSpin
            layout:(PKHudLayout)layout;

- (void)pk_showHud:(NSString *)message
             image:(UIImage *)image
              spin:(BOOL)isSpin
            layout:(PKHudLayout)layout
          position:(PKHudPosition)position
             style:(PKHudStyle *)style;

/** 隐藏HUD */
- (void)pk_hideHud;

- (void)pk_hideAllHuds;

@end

NS_ASSUME_NONNULL_END
