//
//  TQStockFiedLabel.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/22.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQStockFiedLabel.h"

@implementation TQStockFiedRenderer

+ (instancetype)defaultRenderer {
    TQStockFiedRenderer *ren = [TQStockFiedRenderer new];
    ren.prefixColor = [UIColor blackColor];
    ren.suffixColor = [UIColor darkGrayColor];
    ren.prefixFont = [UIFont fontWithName:@"Thonburi-Bold" size:16];
    ren.suffixFont = [UIFont fontWithName:@"Thonburi-Bold" size:16];
    return ren;
}

@end

@interface TQStockFiedLabel ()

@property (nonatomic, strong) UILabel *prefixLabel;
@property (nonatomic, strong) UILabel *suffixLabel;

@end

@implementation TQStockFiedLabel

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _prefixLabel = [UILabel new];
        _prefixLabel.textAlignment = NSTextAlignmentLeft;
        _prefixLabel.numberOfLines = 1;
        [self addSubview:_prefixLabel];
        
        _suffixLabel = [UILabel new];
        _suffixLabel.textAlignment = NSTextAlignmentRight;
        _suffixLabel.numberOfLines = 1;
        [self addSubview:_suffixLabel];
    }
    return self;
}

- (void)layoutSubviews {
    _prefixLabel.frame = self.bounds;
    _suffixLabel.frame = self.bounds;
}

- (void)setRenderer:(TQStockFiedRenderer *)renderer {
    _renderer = renderer;
    [self layoutIfNeeded];

    _prefixLabel.text = renderer.prefixText;
    _prefixLabel.textColor = renderer.prefixColor;
    _prefixLabel.font = renderer.prefixFont;
    
    _suffixLabel.text = renderer.suffixText;
    _suffixLabel.textColor = renderer.suffixColor;
    _suffixLabel.font = renderer.suffixFont;
}

@end
