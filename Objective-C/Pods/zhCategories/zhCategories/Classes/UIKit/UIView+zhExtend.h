//
//  UIView+zhExtend.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/6.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (zhExtend)

/** 删除该视图的所有子视图 */
- (void)zh_removeAllSubviews;

/** 返回该视图所在的控制器 */
@property (nullable, nonatomic, readonly) UIViewController *zh_inViewController;

@end
