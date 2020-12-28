//
//  UIControl+PKExtend.h
//  PKCategories
//
//  Created by jiaohong on 2018/10/29.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (PKExtend)

/** 为UIControl扩大响应区域 */
@property (nonatomic, assign) UIEdgeInsets pk_enlargeTouchInsets;

@end

@interface UIControl (PKHandler)

/** 添加block事件 */
- (void)pk_addEventHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents;

/** 移除所有block事件 */
- (void)pk_removeEventHandlersForControlEvents:(UIControlEvents)controlEvents;

/** 是否存在对应的block事件 */
- (BOOL)pk_hasEventHandlersForControlEvents:(UIControlEvents)controlEvents;

@end

NS_ASSUME_NONNULL_END
