//
//  TQIndicatorKBaseLayer.m
//  TQChartKit
//
//  Created by zhanghao on 2018/9/14.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQKIndicatorBaseLayer.h"

@implementation TQKIndicatorBaseLayer

- (CGPeakValue)KIndicatorPeakValue:(CGPeakValue)peakValue forRange:(NSRange)range {
    return peakValue;
}

- (NSAttributedString *)KIndicatorAttributedTextForIndex:(NSInteger)index {
    return [[NSAttributedString alloc] initWithString:@""];
}

- (NSAttributedString *)KIndicatorAttributedTextForRange:(NSRange)range {
     return [[NSAttributedString alloc] initWithString:@""];
}

@end
