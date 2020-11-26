//
//  TQIndexBaseLayer.m
//  TQChartKit
//
//  Created by zhanghao on 2018/8/2.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndexBaseLayer.h"

@implementation TQIndexBaseLayer

- (void)setStyle1:(TQIndexChartStyle *)style1 {
    if (!style1) return;
    _style1 = style1;
    [self updateStyle];
}

- (void)updateStyle {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)updateChartWithRange:(NSRange)range {
    [self doesNotRecognizeSelector:_cmd];
}

- (CGPeakValue)indexChartPeakValueForRange:(NSRange)range {
    [self doesNotRecognizeSelector:_cmd];
    return CGPeakValueZero;
}

- (NSArray<TQChartTextRenderer *> *)indexChartGraphForRange:(NSRange)range gridPath:(UIBezierPath *__autoreleasing *)pathPointer {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (NSAttributedString *)indexChartAttributedStringForIndex:(NSInteger)index {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
