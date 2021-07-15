//
//  TQStockDetailTextView.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/21.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQStockDetailTextView.h"
#import "TQStockFiedLabel.h"

@interface TQStockDetailTextView ()

@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *freshLabel;
@property (nonatomic, strong, readonly) NSMutableArray<TQStockFiedLabel *> *items;

@end

@implementation TQStockDetailTextView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _items = [NSMutableArray array];
        _contentView = [UIView new];
        [self addSubview:_contentView];
        
        _nameLabel = [UILabel new];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [_contentView addSubview:_nameLabel];
        
        _freshLabel = [UILabel new];
        _freshLabel.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:_freshLabel];
    }
    return self;
}

- (void)layoutSubviews {
    _contentView.frame = UIEdgeInsetsInsetRect(self.bounds, self.contentInsets);
}

- (void)setDetailData:(TQStockDetailsModel *)detailData {
    _detailData = detailData;
    [self layoutIfNeeded];
    [self _updateLabel];
    [self _updateItems];
}

- (void)_updateLabel {
    CGSize _size = CGSizeMake(_contentView.frame.size.width / 6.0, _contentView.frame.size.height);
    
    CGFloat left = 10;
    _nameLabel.size = CGSizeMake(_size.width - left, _size.height);
    _nameLabel.left = left;
    _nameLabel.text = _detailData.stockName;
    
    _freshLabel.size = _size;
    _freshLabel.left = _size.width;
    _freshLabel.text = _detailData.stockCode;
}

- (void)_updateItems {
    UIColor *riseColor = [UIColor brownColor];
    UIColor *fallColor = [UIColor orangeColor];
    
    NSMutableArray<TQStockFiedRenderer *> *mudArray = [NSMutableArray array];
    
    NSString *high = [NSString stringWithFormat:@"%.2f", _detailData.price_highest];
    TQStockFiedRenderer *ren1 = [TQStockFiedRenderer defaultRenderer];
    ren1.prefixText = @"高";
    ren1.suffixText = high;
    ren1.prefixColor = riseColor;
    ren1.suffixColor = fallColor;
    [mudArray addObject:ren1];
    
    NSString *low = [NSString stringWithFormat:@"%.2f", _detailData.price_lowest];
    TQStockFiedRenderer *ren2 = [TQStockFiedRenderer defaultRenderer];
    ren2.prefixText = @"低";
    ren2.suffixText = low;
    ren2.prefixColor = riseColor;
    ren2.suffixColor = fallColor;
    [mudArray addObject:ren2];
    
    NSString *open = [NSString stringWithFormat:@"%.2f", _detailData.price_open];
    TQStockFiedRenderer *ren3 = [TQStockFiedRenderer defaultRenderer];
    ren3.prefixText = @"开";
    ren3.suffixText = open;
    ren3.prefixColor = riseColor;
    ren3.suffixColor = fallColor;
    [mudArray addObject:ren3];
    
    NSString *ratio = [NSString stringWithFormat:@"%.2f%%", _detailData.price_changeRatio];
    TQStockFiedRenderer *ren4 = [TQStockFiedRenderer defaultRenderer];
    ren4.prefixText = @"换";
    ren4.suffixText = ratio;
    ren4.prefixColor = [UIColor darkGrayColor];
    ren4.suffixColor = fallColor;
    [mudArray addObject:ren4];
    
    CGFloat _gap = 30;
    CGFloat _allGap = _gap * mudArray.count;
    CGFloat _sizeW = (_contentView.frame.size.width - _nameLabel.width - _freshLabel.width - _allGap) / (CGFloat)mudArray.count;
    CGSize _size = CGSizeMake(_sizeW, _contentView.frame.size.height);
    
    for (NSInteger i = 0; i < mudArray.count; i++) {
        TQStockFiedLabel *label = [self labelWithIndex:i];
        label.size = _size;
        label.left = (i + 2) * (_size.width + _gap) + _gap/2;
//        label.backgroundColor = [UIColor zh_randomColor];
        label.renderer = mudArray[i];
    }
}

- (TQStockFiedLabel *)labelWithIndex:(NSInteger)index {
    TQStockFiedLabel *label = nil;
    if (index < _items.count) {
        label = _items[index];
        return label;
    }
    label = [TQStockFiedLabel new];
    [_items addObject:label];
    [_contentView addSubview:label];
    return label;
}

@end
