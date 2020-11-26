//
//  TQStockTypeSegmentedBar.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/21.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQStockTypeSegmentedBar.h"

@interface TQStockTypeSegmentedBar ()

@property (nonatomic, strong, readonly) UIButton *moreItem;
@property (nonatomic, strong, readonly) CAShapeLayer *barLineLayer;

@end

@implementation TQStockTypeSegmentedBar

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self defaultInitialization];
        _items = [NSMutableArray array];
        _contentView = [UIView new];
        _contentView.tag = -1;
        [self addSubview:_contentView];
        
        _barLineLayer = [CAShapeLayer layer];
        [_contentView.layer addSublayer:_barLineLayer];
    }
    return self;
}

- (void)defaultInitialization {
    _selectedTextColor = [UIColor orangeColor];
    _unselectedTextColor = [UIColor blackColor];
    _barLineWidth = 2;
    _textFont = [UIFont systemFontOfSize:13];
    _selectedIndex = -1;
}

- (void)layoutSubviews {
    _contentView.frame = UIEdgeInsetsInsetRect(self.bounds, self.contentInsets);
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    if (!titles.count) return;
    _titles = titles;
    [self layoutIfNeeded];
    
    CGSize shapeSize = CGSizeMake(0, self.barLineWidth);
    CGPoint shapeOrigin = CGPointMake(0, _contentView.bounds.size.height - shapeSize.height);
    _barLineLayer.backgroundColor = self.selectedTextColor.CGColor;
    _barLineLayer.frame = (CGRect){.origin = shapeOrigin, .size = shapeSize};
    _barLineLayer.cornerRadius = self.barLineCornerRadius;
    
    CGFloat width = _contentView.frame.size.width / (double)titles.count;
    CGFloat height = _contentView.frame.size.height;
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull text, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [self buttonWithIndex:idx];
        [button setTitle:text forState:UIControlStateNormal];
        button.tag = idx;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(idx * width, 0, width, height);
    }];

    _moreItem = [self lastButtonWithItems:_items];
    
    self.selectedIndex = self.selectedIndex;
}

- (UIButton *)buttonWithIndex:(NSInteger)index {
    UIButton *button = nil;
    if (index < _items.count) {
        button = _items[index];
        return button;
    }
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:self.unselectedTextColor forState:UIControlStateNormal];
    button.titleLabel.font = self.textFont;
    [button setTitle:nil forState:UIControlStateNormal];
    [_items addObject:button];
    [_contentView addSubview:button];
    return button;
}

- (UIButton *)lastButtonWithItems:(NSArray<UIButton *> *)items {
    UIButton *button = _items.lastObject;
    button.contentMode = UIViewContentModeScaleAspectFill;
    [button setImage:[UIImage imageNamed:@"tq_arrow"] forState:UIControlStateNormal];
    [button zh_setImagePosition:zhImagePositionRight spacing:2];
    return button;
}

- (void)setMoreItemTitle:(NSString *)moreItemTitle {
    _moreItemTitle = moreItemTitle;
    [_moreItem setTitle:moreItemTitle forState:UIControlStateNormal];
    [_moreItem zh_setImagePosition:zhImagePositionRight spacing:2];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    if (selectedIndex >= self.items.count || selectedIndex < 0) return;
    UIButton *responder = _items[selectedIndex];
    [responder layoutIfNeeded];
    
    if (_contentView.tag >= 0) {
        UIButton *previousButton = _items[_contentView.tag];
        [previousButton setTitleColor:self.unselectedTextColor forState:UIControlStateNormal];
    }
    [responder setTitleColor:self.selectedTextColor forState:UIControlStateNormal];
    
    (responder == _moreItem) ?: [self setMoreItemTitle:self.titles[_moreItem.tag]];
    
    _contentView.tag = responder.tag;
    
    CGSize size = [responder.titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGRect frame = _barLineLayer.frame;
    frame.size.width = size.width;
    frame.origin.x = responder.frame.origin.x + responder.titleLabel.center.x - size.width * 0.5;
    _barLineLayer.frame = frame;
}

- (void)buttonClicked:(UIButton *)sender {
    if (sender == _moreItem) {
        if ([self.delegate respondsToSelector:@selector(stockTypeSegmentedBarDidClickMore:)]) {
            [self.delegate stockTypeSegmentedBarDidClickMore:self];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(stockTypeSegmentedBar:didClickItemAtIndex:)]) {
            [self.delegate stockTypeSegmentedBar:self didClickItemAtIndex:sender.tag];
        }
    }
}

- (void)setMoreItemImageTransform:(CGAffineTransform)moreItemImageTransform {
    _moreItemImageTransform = moreItemImageTransform;
    [UIView animateWithDuration:0.25 animations:^{
        self->_moreItem.imageView.transform = moreItemImageTransform;
    } completion:NULL];
}

- (NSInteger)moreSelectedIndex {
    return _moreItem.tag;
}

@end
