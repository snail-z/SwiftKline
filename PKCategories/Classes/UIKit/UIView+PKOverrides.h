//
//  UIView+PKOverrides.h
//  PKCategories
//
//  Created by zhanghao on 2020/9/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// MARK: - PKUIButton

/**
*  提供以下功能：
*  1. 支持设置图片相对于 titleLabel 的位置 (imagePosition)
*  2. 支持设置图片和 titleLabel 之间的间距 (imageAndTitleSpacing)
*  3. 支持自定义图片尺寸大小 (imageSpecifiedSize)
*  4. 支持图片和 titleLabel 同时居中对齐或边缘对齐
*  5. 支持图片和 titleLabel 各自对齐到两端 (.eachEnd)
*  6. 支持调整内容边距 (contentEdgeInsets) 注：不支持titleEdgeInsets/imageEdgeInsets
*  7. 支持调整 cornerRadius 始终保持为高度的 1/2 (adjustsRoundedCornersAutomatically)
*  8. 支持 Auto Layout 以上设置可根据内容自适应
*/

/// 图片与文字布局位置
typedef NS_ENUM(NSInteger, PKUIButtonImagePosition) {
    /// 图片在上，文字在下
    PKUIButtonImagePositionTop = 0,
    /// 图片在左，文字在右
    PKUIButtonImagePositionLeft,
    /// 图片在下，文字在上
    PKUIButtonImagePositionBottom,
    /// 图片在右，文字在左
    PKUIButtonImagePositionRight
};

/// 图片标题分别对齐到左右两端
/// Usage: button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentEachEnd;
UIKIT_EXTERN const UIControlContentHorizontalAlignment UIControlContentHorizontalAlignmentEachEnd;

/// 图片标题分别对齐到顶部和底部
/// Usage: button.contentVerticalAlignment = UIControlContentVerticalAlignmentEachEnd;
UIKIT_EXTERN const UIControlContentVerticalAlignment UIControlContentVerticalAlignmentEachEnd;

@interface PKUIButton : UIButton

/** 设置按图标和文字的相对位置，默认为PKUIButtonImagePositionLeft */
@property (nonatomic, assign) PKUIButtonImagePosition imagePosition;

/** 设置图标和文字之间的间隔，默认为10 (与两端对齐样式冲突时优先级低) */
@property (nonatomic, assign) CGFloat imageAndTitleSpacing;

/** 设置图标大小为指定尺寸，默认为zero使用图片自身尺寸 */
@property (nonatomic, assign) CGSize imageSpecifiedSize;

/** 是否自动调整 `cornerRadius` 使其始终保持为高度的1/2，默认为NO */
@property (nonatomic, assign) BOOL adjustsRoundedCornersAutomatically;

@end


// MARK: - PKUITextField

/**
*  提供以下功能：
*  1. 支持调整左视图边缘留白 (leftViewPadding)
*  2. 支持调整右视图边缘留白 (rightViewPadding)
*  3. 支持调整清除按钮边缘留白 (clearButtonPadding)
*  4. 支持输入框文本边缘留白 (textEdgeInsets)
*  5. 增加键盘删除按钮的响应事件 - PKUITextField.deleteBackward
*/

/// 键盘删除按钮的响应事件
/// Usage: [textField addTarget:self action:@selector(textFieldDeleteBackward:) forControlEvents:UIControlEventDeleteBackward];
UIKIT_EXTERN const NSUInteger UIControlEventDeleteBackward;

@interface PKUITextField : UITextField

/** 左视图边缘留白 */
@property (nonatomic, assign) CGFloat leftViewPadding;

/** 右视图边缘留白 */
@property (nonatomic, assign) CGFloat rightViewPadding;

/** 清除按钮边缘留白 */
@property (nonatomic, assign) CGFloat clearButtonPadding;

/** 文本边缘留白 */
@property (nonatomic, assign) UIEdgeInsets textEdgeInsets;

@end

NS_ASSUME_NONNULL_END
