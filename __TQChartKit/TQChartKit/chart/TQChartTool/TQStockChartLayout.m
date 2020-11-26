//
//  TQStockChartLayout.m
//  TQChartKit
//
//  Created by zhanghao on 2018/8/22.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQStockChartLayout.h"

@implementation TQStockChartLayout

+ (instancetype)layoutWithTopChartHeight:(CGFloat)topHeight {
    TQStockChartLayout *layout = [TQStockChartLayout new];
    layout.topChartHeight = topHeight;
    return layout;
}

- (void)setContentFrame:(CGRect)contentFrame {
    _contentFrame = contentFrame;
}

@end
