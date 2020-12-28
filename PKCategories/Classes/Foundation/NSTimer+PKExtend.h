//
//  NSTimer+PKExtend.h
//  PKCategories
//
//  Created by jiaohong on 2018/10/27.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (PKExtend)

/** 运行耗时测试(单位:毫秒) */
+ (double)pk_runingTimeConsumingBlock:(void (^)(void))block;

/** 对系统方法增加block回调事件 */
+ (NSTimer *)pk_scheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                                         block:(void (^)(NSTimer *timer))block
                                       repeats:(BOOL)repeats;

/** 对系统方法增加block回调事件 */
+ (NSTimer *)pk_timerWithTimeInterval:(NSTimeInterval)seconds
                                block:(void (^)(NSTimer *timer))block
                              repeats:(BOOL)repeats;

@end

NS_ASSUME_NONNULL_END
