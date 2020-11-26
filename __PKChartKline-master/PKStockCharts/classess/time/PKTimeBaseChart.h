//
//  PKTimeBaseChart.h
//  PKChartKit
//
//  Created by zhanghao on 2017/11/27.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PKTimeBaseChart : UIView

@property (nonatomic, strong, readonly) UIView *containerView;
@property (nonatomic, strong, readonly) CALayer *contentChartLayer;
@property (nonatomic, strong, readonly) CALayer *contentTextLayer;

@end

NS_ASSUME_NONNULL_END
