//
//  TQStockChartLayout.h
//  TQChartKit
//
//  Created by zhanghao on 2018/8/22.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TQStockChartLayout : NSObject

+ (instancetype)layoutWithTopChartHeight:(CGFloat)topHeight;

/** 设置内边距(边缘留白) */
@property (nonatomic, assign) UIEdgeInsets contentEdgeInset;

/** 设置上部分图表高度 */
@property (nonatomic, assign) CGFloat topChartHeight;

/** 设置中间分隔区域大小 */
@property (nonatomic, assign) CGFloat separatedGap;

@property (nonatomic, assign, readonly) CGRect contentFrame;
@property (nonatomic, assign, readonly) CGRect topChartFrame;
@property (nonatomic, assign, readonly) CGRect bottomChartFrame;
@property (nonatomic, assign, readonly) CGRect separatedFrame;

@end

NS_ASSUME_NONNULL_END
