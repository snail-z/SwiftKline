//
//  PKLandscapeTopTextView.m
//  PKStockCharts
//
//  Created by zhanghao on 2019/8/22.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import "PKLandscapeTopTextView.h"

@interface PKLandscapeTopTextView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *codeLabel;

@end

@implementation PKLandscapeTopTextView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _contentView = [UIView new];
        [self addSubview:_contentView];
        
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:20];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [_contentView addSubview:_nameLabel];
        
        _codeLabel = [UILabel new];
        _codeLabel.textColor = [UIColor blackColor];
        _codeLabel.font = [UIFont systemFontOfSize:18];
        _codeLabel.textAlignment = NSTextAlignmentLeft;
        [_contentView addSubview:_codeLabel];
        
        [self layoutUpdates];
    }
    return self;
}

- (void)layoutUpdates {
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self->_contentView);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(90);
    }];
    
    [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.contentView);
        make.width.mas_equalTo(80);
        make.left.equalTo(self->_nameLabel.mas_right).offset(5);
    }];
}

- (void)setName:(NSString *)name withCode:(NSString *)code {
    _nameLabel.text = name;
    _codeLabel.text = code;
    [self pk_addDefaultEdgeLineByPosition:PKEdgeLinePositionBottom];
}

@end
