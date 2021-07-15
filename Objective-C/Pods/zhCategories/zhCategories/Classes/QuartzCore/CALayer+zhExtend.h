//
//  CALayer+zhExtend.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/6.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (zhExtend)

- (void)zh_removeAllSublayers;
- (void)zh_setLayerShadow:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
