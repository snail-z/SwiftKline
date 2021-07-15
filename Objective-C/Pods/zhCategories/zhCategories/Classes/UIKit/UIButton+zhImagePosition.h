//
//  UIButton+zhImagePosition.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/2.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, zhImagePosition) {
    zhImagePositionLeft = 0,    // 图片在左，文字在右，默认
    zhImagePositionRight,       // 图片在右，文字在左
    zhImagePositionTop,         // 图片在上，文字在下
    zhImagePositionBottom,      // 图片在下，文字在上
};

@interface UIButton (zhImagePosition)

@property (nonatomic, assign, readonly) CGFloat zh_imagePositionSpacing;

/**
 *  调整UIButton的文字和图片之间的位置和间距
 *  注：设置图片和文字后调用才会有效，且button的尺寸要大于 > 图片大小+文字大小+spacing
 */
- (void)zh_setImagePosition:(zhImagePosition)postion spacing:(CGFloat)spacing;

@end
