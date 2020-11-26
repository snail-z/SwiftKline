//
//  TQStockTypePopupBar.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/21.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQStockTypePopupBar.h"

@interface TQStockTypePopupBar ()

@property (nonatomic, assign) CGRect invisibleRect;
@property (nonatomic, assign) CGRect visibleRect;
@property (nonatomic, strong) UIView *popupCover;

@end

@implementation TQStockTypePopupBar

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _currentSelectedIndex = -1;
        [self defaultInitialization];
        _items = [NSMutableArray array];
    }
    return self;
}

- (void)defaultInitialization {
    _textColor = [UIColor darkGrayColor];
    _textFont = [UIFont systemFontOfSize:11];
    _lineColor = [UIColor grayColor];
    _lineEdgePadding = 15;
    _lineWidth = 1 / [UIScreen mainScreen].scale;
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    if (!titles.count) return;
    _titles = titles;
    CGFloat height = self.frame.size.height / (CGFloat)titles.count;
    for (NSInteger idx = 0; idx < titles.count; idx++) {
        UIButton *button = [self buttonWithIndex:idx];
        [button setTitle:titles[idx] forState:UIControlStateNormal];
        button.tag = idx;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, idx * height, self.frame.size.width, height);
        if (idx < 1) continue;
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = self.lineColor.CGColor;
        layer.frame = CGRectMake(self.lineEdgePadding, 0, self.frame.size.width - 2 * self.lineEdgePadding, self.lineWidth);
        [button.layer addSublayer:layer];
    }
}

- (UIButton *)buttonWithIndex:(NSInteger)index {
    UIButton *button = nil;
    if (index < _items.count) {
        button = _items[index];
        return button;
    }
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:self.textColor forState:UIControlStateNormal];
    button.titleLabel.font = self.textFont;
    [button setTitle:nil forState:UIControlStateNormal];
    [_items addObject:button];
    [self addSubview:button];
    return button;
}

- (void)buttonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(stockTypePopupBar:didClickItemAtIndex:)]) {
        [self.delegate stockTypePopupBar:self didClickItemAtIndex:sender.tag];
    }
    _currentSelectedIndex = sender.tag;
}

- (void)present {
    if (self.isPresenting) return;
    if (self.willPresent) {
        self.willPresent();
    }
    [self addPopupCover];
    self.hidden = NO;
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
    } completion:NULL];
}

- (void)presentFromRect:(CGRect)fromRect toRect:(CGRect)toRect {
    if (self.isPresenting) return;
    if (self.willPresent) {
        self.willPresent();
    }
    [self addPopupCover];
    
    _invisibleRect = fromRect;
    _visibleRect = toRect;
    self.hidden = NO;
    self.frame = fromRect;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = toRect;
    } completion:NULL];
}

- (void)dismiss {
    if (!self.isPresenting) return;
    if (self.willDismiss) {
        self.willDismiss();
    }
    [self removePopupCover];
    
    [UIView animateWithDuration:0.25 animations:^{
        if (CGRectEqualToRect(CGRectZero, self->_invisibleRect)) {
            self.alpha = 0;
        } else {
            self.frame = self->_invisibleRect;
        }
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - popupCover

- (UIView *)popupCover {
    if (!_popupCover) {
        _popupCover = [UIView new];
        _popupCover.backgroundColor = [UIColor clearColor];
        [self.superview addSubview:_popupCover];
        [self.superview bringSubviewToFront:_popupCover];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(whenTapCover:)];
        [_popupCover addGestureRecognizer:tap];
    }
    return _popupCover;
}

- (void)whenTapCover:(UITapGestureRecognizer *)g {
    CGPoint p = [g locationInView:self];
    if (!CGRectContainsPoint(self.bounds, p)) {
        [self dismiss];
    } else {
        CGFloat height = self.frame.size.height / (CGFloat)self.items.count;
        NSInteger idx = (NSInteger)(p.y / height);
        [self buttonClicked:self.items[idx]];
    }
}

- (void)addPopupCover {
    if (CGRectIsEmpty(self.popupCoverFrame)) return;
    self.popupCover.frame = self.popupCoverFrame;
}

- (void)removePopupCover {
    if (!_popupCover) return;
    [_popupCover removeFromSuperview];
    _popupCover = nil;
}

- (BOOL)isPresenting {
    return !self.hidden;
}

@end
