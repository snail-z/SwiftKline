
//
//  TJPickerViewCell.m
//  PKCategories_Example
//
//  Created by zhanghao on 2021/1/8.
//  Copyright © 2021 gren-beans. All rights reserved.
//

#import "TJPickerViewCell.h"
#import <Masonry/Masonry.h>

@interface TJPickerLineCell ()

@property(nonatomic, strong) UIView *topLine;
@property(nonatomic, strong) UIView *bottomLine;
@property(nonatomic, strong) UILabel *label;

@end

@implementation TJPickerLineCell

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInitialization];
        [self layoutInitialization];
    }
    return self;
}

- (void)commonInitialization {
    _topLine = [UIView new];
    _topLine.backgroundColor = [UIColor blackColor];
    [self addSubview:_topLine];
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = _topLine.backgroundColor;
    [self addSubview:_bottomLine];
    
    _label = [UILabel new];
    _label.font = [UIFont boldSystemFontOfSize:15];
    _label.textColor = [UIColor blackColor];
    [self addSubview:_label];
}

- (void)layoutInitialization {
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.equalTo(self);
    }];
    
//    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(60);
//        make.top.equalTo(self);
//        make.height.mas_equalTo(2);
//    }];
//    
//    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(60);
//        make.bottom.equalTo(self);
//        make.height.mas_equalTo(2);
//    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _label.text = title;
}

- (void)setLineEdgeInsets:(UIEdgeInsets)lineEdgeInsets {
    _lineEdgeInsets = lineEdgeInsets;
}

@end


@interface TJPickerShowyCell ()

@end

@implementation TJPickerShowyCell

@end
