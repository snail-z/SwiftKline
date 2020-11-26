//
//  TQTimeChartView.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/22.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQTimeChartView.h"

@interface TQTimeChartView () <TQTimeChartDelegate>

/** 分时区域说明文本 */
@property (nonatomic, strong) CATextLayer *refTimeTextLayer;

/** VOL区域说明文本 */
@property (nonatomic, strong) CATextLayer *refVolumeTextLayer;

@end

@implementation TQTimeChartView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _initialization];
    }
    return self;
}

- (void)_initialization {
    self.delegate = self;
    
    _refTimeTextLayer = [CATextLayer layer];
    _refTimeTextLayer.contentsScale = [UIScreen mainScreen].scale;
//    _refTimeTextLayer.backgroundColor = [UIColor redColor].CGColor;
//    _refTimeTextLayer.frame = CGRectMake(100, 100, 200, 200);
    [self.contentTextLayer addSublayer:_refTimeTextLayer];
    
    _refVolumeTextLayer = [CATextLayer layer];
    _refVolumeTextLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.contentTextLayer addSublayer:_refVolumeTextLayer];
}

- (void)drawChart {
    [super drawChart];
//    self.crosswireView.lineColor = [UIColor redColor];
//    self.crosswireView.textColor = [UIColor blueColor];
//    _refTimeTextLayer.backgroundColor = [UIColor redColor].CGColor;
//    _refTimeTextLayer.frame = self.chartRiverFrame;
}

- (void)stockTimeChart:(TQTimeChart *)timeChart didSingleTapAtRange:(BOOL)isTimeChartRange {
    if (isTimeChartRange) {
        NSLog(@"单击了分时图范围");
    } else {
        NSLog(@"单击了成交量图范围");
    }
}

- (void)stockTimeChart:(TQTimeChart *)timeChart didDoubleTapAtRange:(BOOL)isTimeChartRange {
    if (isTimeChartRange) {
        NSLog(@"双击了分时图范围");
    } else {
        NSLog(@"双击了成交量图范围");
    }
}

- (void)stockTimeChart:(TQTimeChart *)timeChart didLongPressOfIndex:(NSInteger)index {
    id<TQTimeChartProtocol> obj = self.dataArray[index];
    _refTimeTextLayer.string = [NSString stringWithFormat:@"%@", @(obj.tq_timeVolume)];
}

- (NSAttributedString *)makeAttributedStringWithIndex:(NSInteger)index {
    id<TQTimeChartProtocol> currentObj = self.dataArray[index];
    NSString *datestring = nil;
    NSString *prefix = [NSString stringWithFormat:@"均价:%.2f", currentObj.tq_timeAveragePrice];
    NSString *suffix = [NSString stringWithFormat:@"最新:%.2f %.2f %@", currentObj.tq_timePrice, currentObj.tq_timeAveragePrice, datestring];
    NSString *text = [NSString stringWithFormat:@"%@  %@", prefix, suffix];
    NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange textRange = [text rangeOfString:text];
    NSRange prefixRange = [text rangeOfString:prefix];
    NSRange suffixRange = [text rangeOfString:suffix];
    [attriText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Thonburi" size:11] range:textRange];
    [attriText addAttribute:NSForegroundColorAttributeName value:self.style.avgTimeLineColor range:prefixRange];
    [attriText addAttribute:NSForegroundColorAttributeName value:self.style.volumeRiseColor range:suffixRange];
    return attriText;
}

- (void)dealloc {
    NSLog(@"%@~~~~~~dealloc!✈️",NSStringFromClass(self.class));
}

@end
