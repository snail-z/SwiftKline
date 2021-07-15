//
//  UITextField+zhExtend.h
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/6.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (zhExtend)

/** 选定所有文本 */
- (void)zh_selectAllText;

/** 选定某范围内的文本 */
- (void)zh_setSelectedRange:(NSRange)range;

@end
