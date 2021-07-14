//
//  TQIndicatorBaseLayer.m
//  TQChartKit
//
//  Created by zhanghao on 2018/8/2.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndicatorBaseLayer.h"

@implementation TQIndicatorBaseLayer

- (CGPeakValue)indicatorPeakValueForRange:(NSRange)range {
    [self doesNotRecognizeSelector:_cmd];
    return CGPeakValueZero;
}

- (NSArray<TQChartTextRenderer *> *)indicatorTrellisForPeakValue:(CGPeakValue)peakValue path:(UIBezierPath *__autoreleasing *)pathPointer {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (NSAttributedString *)indicatorAttributedTextForIndex:(NSInteger)index {
    return [[NSAttributedString alloc] initWithString:@""];
}

- (NSAttributedString *)indicatorAttributedTextForRange:(NSRange)range {
    return [[NSAttributedString alloc] initWithString:@""];
}

@end
