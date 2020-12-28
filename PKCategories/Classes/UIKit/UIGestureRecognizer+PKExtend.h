//
//  UIGestureRecognizer+PKExtend.h
//  PKCategories
//
//  Created by zhanghao on 2018/10/29.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIGestureRecognizer (PKExtend)

/** 初始化手势识别器并添加blcok事件 */
+ (instancetype)pk_recognizerWithHandler:(void (^)(UIGestureRecognizer *sender))block;

/** 初始化手势识别器并添加blcok事件 */
- (instancetype)pk_initWithHandler:(void (^)(UIGestureRecognizer *sender))block NS_REPLACES_RECEIVER;

/** 为手势识别器对象添加blcok事件 */
- (void)pk_addHandler:(void (^)(UIGestureRecognizer *sender))block;

/** 移除所有block事件 */
- (void)pk_removeAllEventHandlers;

@end

NS_ASSUME_NONNULL_END
