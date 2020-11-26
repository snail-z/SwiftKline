//
//  PKSegmentedSlideControl.m
//  PKOrnaments
//
//  Created by zhanghao on 2019/4/24.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import "PKSegmentedSlideControl.h"

@interface PKSegmentedSlideControl ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *textLabelsView;
@property (nonatomic, strong) UIView *indicatorView;

@end

@implementation PKSegmentedSlideControl

- (void)defaultValues {
    _isAnimating = NO;
    _index = 0;
    _plainTextFont = [UIFont boldSystemFontOfSize:15];
    _normalTextColor = [UIColor blackColor];
    _selectedTextColor = [UIColor colorWithRed:0 / 255.f green:122 / 255.f blue:255 / 255.f alpha:1.f];
    _paddingInset = 10;
    _innerSpacing = 10;
    _indicatorLineWidth = 3;
    _indicatorCornerRadius = 1;
    _allowBounces = YES;
    _announcesValueImmediately = YES;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles {
    if (self = [self initWithFrame:CGRectZero]) {
        [self updateSegmentedTitles:titles];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        
        [self defaultValues];
        
        _scrollView = [UIScrollView new];
        _scrollView.scrollEnabled = YES;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = self.allowBounces;
        [self addSubview:_scrollView];
        
        _textLabelsView = [UIView new];
        [_scrollView addSubview:_textLabelsView];
        
        _indicatorView = [UIView new];
        _indicatorView.backgroundColor = self.selectedTextColor;
        [_scrollView addSubview:_indicatorView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self.scrollView addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSInteger pageCount = self.numberOfPageItems;
    pageCount = pageCount > self.titles.count ? self.titles.count : pageCount;
    
    CGFloat sumWidth = [self elementWidthForIndex:0];;
    for (int idx = 1; idx < pageCount; idx++) {
        sumWidth += [self elementWidthForIndex:idx];
    }
    
    CGFloat sumSpacing = self.bounds.size.width - self.paddingInset * 2 - sumWidth;
    _innerSpacing = sumSpacing / (pageCount - 1);
    for (int idx = 0; idx < self.textLabelsView.subviews.count; idx++) {
        CGRect frame = [self elementFrameForIndex:idx];
        self.textLabelsView.subviews[idx].frame = frame;
    }
    
    if (CGRectGetMaxX(self.textLabelsView.subviews.lastObject.frame) < self.bounds.size.width) {
        _innerSpacing = sumSpacing / (self.textLabelsView.subviews.count - 1);
        for (int idx = 0; idx < self.textLabelsView.subviews.count; idx++) {
            CGRect frame = [self elementFrameForIndex:idx];
            self.textLabelsView.subviews[idx].frame = frame;
        }
    }
    
    [self moveIndicatorView];
    
    self.scrollView.frame = self.bounds;
    CGFloat contentWidth = CGRectGetMaxX(self.textLabelsView.subviews.lastObject.frame) + self.paddingInset;
    self.scrollView.contentSize = CGSizeMake(contentWidth, self.bounds.size.height);
    self.textLabelsView.frame = (CGRect){.size.width = contentWidth, .size.height = self.bounds.size.height};
}

- (CGFloat)elementWidthForIndex:(NSInteger)index {
    UILabel *label = self.textLabelsView.subviews[index];
    return [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, self.bounds.size.height)].width;
}

- (CGRect)elementFrameForIndex:(NSInteger)index {
    CGFloat elementWidth = [self elementWidthForIndex:index];
    CGFloat originX = self.paddingInset;
    if (index > 0) {
        originX = CGRectGetMaxX(self.textLabelsView.subviews[index - 1].frame) + self.innerSpacing;
    }
    return (CGRect){.origin.x = originX, .size = CGSizeMake(elementWidth, self.bounds.size.height)};
}

- (void)moveIndicatorView {
    CGFloat textWidth = [self elementWidthForIndex:self.index];
    CGRect frame = [self elementFrameForIndex:self.index];
    frame.origin.x = frame.origin.x + (frame.size.width - textWidth) / 2;
    frame.origin.y = self.bounds.size.height - self.indicatorLineWidth;
    frame.size.width = textWidth;
    frame.size.height = self.indicatorLineWidth;
    self.indicatorView.frame = frame;
}

- (void)contentOffsetUpdates {
    UILabel *selectedLabel = self.textLabelsView.subviews[self.index];
    CGFloat centerX = self.bounds.size.width / 2;
    CGPoint p2 = [self.scrollView convertPoint:selectedLabel.center fromView:selectedLabel.superview];
    if (!(p2.x < centerX || (p2.x > self.scrollView.contentSize.width - centerX))) {
        [self.scrollView setContentOffset:CGPointMake(p2.x - centerX, 0) animated:YES];
    } else {
        if (p2.x - self.paddingInset < centerX) {
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        } else if ((p2.x + selectedLabel.bounds.size.width + self.paddingInset) > centerX) {
            CGFloat offx = self.scrollView.contentSize.width - self.scrollView.bounds.size.width + self.scrollView.contentInset.right;
            [self.scrollView setContentOffset:CGPointMake(offx, 0) animated:YES];
        }
    }
}

- (void)removeAllSubviews {
    while (self.textLabelsView.subviews.count) {
        [self.textLabelsView.subviews.lastObject removeFromSuperview];
    }
}

- (void)updateSegmentedTitles:(NSArray<NSString *> *)titles {
    if (titles.count) {
        _titles = titles;
        [self removeAllSubviews];
        
        for (int index = 0; index < titles.count; index++) {
            UILabel *titleLabel = [UILabel new];
            titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = self.normalTextColor;
            titleLabel.font = self.plainTextFont;
            titleLabel.text = titles[index];
            titleLabel.tag = index;
            titleLabel.userInteractionEnabled = YES;
            [self.textLabelsView addSubview:titleLabel];
        }
        
        [self setNeedsLayout];
    }
}

- (NSInteger)nearestIndexToPoint:(CGPoint)point {
    NSInteger index = 0;
    CGFloat gap = self.innerSpacing / 2;
    NSInteger lastIndex = self.textLabelsView.subviews.count - 1;
    for (UIView *aView in self.textLabelsView.subviews) {
        CGFloat left = CGRectGetMinX(aView.frame);
        CGFloat right = CGRectGetMaxX(aView.frame);
        left -= (index == 0 ? self.paddingInset : gap);
        right += (index == lastIndex ? self.paddingInset : gap);
        if (point.x >= left && point.x <= right) break; index++;
    }
    return index;
}

- (void)tapped:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self.scrollView];
    NSInteger index = [self nearestIndexToPoint:location];
    [self setWithIndex:index animated:YES];
}

- (void)setWithIndex:(NSInteger)index animated:(BOOL)animated {
    [self setWithIndex:index animated:animated sendEvent:YES];
}

- (void)setWithIndex:(NSInteger)index animated:(BOOL)animated sendEvent:(BOOL)shouldSendEvent {
    if (index < self.textLabelsView.subviews.count) {
        if (index != self.index) {
            _index = index;
            [self moveIndicatorViewAnimated:animated shouldSendEvent:shouldSendEvent];
        }
    }
}

- (void)moveIndicatorViewAnimated:(BOOL)animated shouldSendEvent:(BOOL)shouldSendEvent {
    _isAnimating = YES;
    if (animated) {
        if (shouldSendEvent && self.announcesValueImmediately) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            [self moveIndicatorView];
            [self textLabelsColorUpdates];
        } completion:^(BOOL finished) {
            self->_isAnimating = NO;
            if (finished && shouldSendEvent && !self.announcesValueImmediately) {
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }];
    } else {
        [self moveIndicatorView];
        [self textLabelsColorUpdates];
        if (shouldSendEvent) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
        _isAnimating = NO;
    }
    
    [self contentOffsetUpdates];
}

- (void)textLabelsColorUpdates {
    for (UILabel *label in self.textLabelsView.subviews) {
        label.textColor = self.normalTextColor;
    }
    UILabel *selectedLabel = self.textLabelsView.subviews[self.index];
    selectedLabel.textColor = self.selectedTextColor;
    self.indicatorView.backgroundColor = self.selectedTextColor;
}

- (void)setAllowBounces:(BOOL)allowBounces {
    _allowBounces = allowBounces;
    self.scrollView.bounces = allowBounces;
}

- (void)setPlainTextFont:(UIFont *)plainTextFont {
    _plainTextFont = plainTextFont;
    for (UILabel *label in self.textLabelsView.subviews) {
        label.font = plainTextFont;
    }
}

- (void)setNormalTextColor:(UIColor *)normalTextColor {
    _normalTextColor = normalTextColor;
    [self textLabelsColorUpdates];
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor {
    _selectedTextColor = selectedTextColor;
    [self textLabelsColorUpdates];
}

- (void)setPaddingInset:(CGFloat)paddingInset {
    _paddingInset = paddingInset;
    [self setNeedsLayout];
}

- (void)setInnerSpacing:(CGFloat)innerSpacing {
    _innerSpacing = innerSpacing;
    [self setNeedsLayout];
}

- (void)setIndicatorLineWidth:(CGFloat)indicatorLineWidth {
    _indicatorLineWidth = indicatorLineWidth;
    [self setIndicatorCornerRadius:self.indicatorCornerRadius];
}

- (void)setIndicatorCornerRadius:(CGFloat)indicatorCornerRadius {
    _indicatorCornerRadius = indicatorCornerRadius;
    self.indicatorView.layer.cornerRadius = indicatorCornerRadius;
    [self setNeedsLayout];
}

- (void)setNumberOfPageItems:(NSInteger)numberOfPageItems {
    _numberOfPageItems = numberOfPageItems;
    [self setNeedsLayout];
}

#pragma mark - Update Progress

- (NSInteger)currentIndex:(CGFloat)progress {
    NSInteger page = progress + 0.5;
    if (page >= self.titles.count) page = (NSInteger)self.titles.count - 1;
    if (page < 0) page = 0;
    return page;
}

- (void)updateWithProgress:(CGFloat)progress {
    NSInteger currentIndex = [self currentIndex:progress];
    if (_index != currentIndex) {
        _index = currentIndex;
        [self contentOffsetUpdates];
    }
    
    progress = progress < 0 ? 0 : progress;
    NSInteger leftIndex = (NSInteger)(progress);
    NSInteger rightIndex= leftIndex + 1;
    
    rightIndex = rightIndex > self.titles.count - 1 ? self.titles.count - 1 : rightIndex;
    
    CGFloat factor = (progress - leftIndex) / (rightIndex - leftIndex);
    factor = leftIndex == rightIndex ? 0 : factor;
    CGFloat leftFactor = 1 - factor;
    
    UILabel *leftLabel = self.textLabelsView.subviews[leftIndex];
    UILabel *rightLabel = self.textLabelsView.subviews[rightIndex];
    CGFloat leftTextWidth = [leftLabel sizeThatFits:leftLabel.bounds.size].width;
    CGFloat rightTextWidth = [rightLabel sizeThatFits:rightLabel.bounds.size].width;
    
    CGFloat currentWidth = leftTextWidth + (rightTextWidth - leftTextWidth) * factor;
    CGFloat offsetX = (CGRectGetMidX(rightLabel.frame) - CGRectGetMidX(leftLabel.frame)) * factor;
    CGFloat originX  = CGRectGetMidX(leftLabel.frame) + offsetX - currentWidth / 2;
    self.indicatorView.frame = CGRectMake(originX, self.indicatorView.frame.origin.y, currentWidth, self.indicatorView.frame.size.height);
    
    if (leftIndex != rightIndex) {
        NSArray<NSNumber *>* (^callbackRGBAValues)(UIColor*) = ^(UIColor*color) {
            CGFloat r = 0.0, g = 0.0, b = 0.0, a = 0.0;
            [color getRed:&r green:&g blue:&b alpha:&a];
            return @[@(r), @(g), @(b), @(a)];
        };
        
        CGFloat normalColorR = 0, normalColorG = 0, normalColorB = 0, normalColorA = 0;
        
        NSArray<NSNumber *> *normalRgbaValues = callbackRGBAValues(self.normalTextColor);
        normalColorR = normalRgbaValues[0].floatValue;
        normalColorG = normalRgbaValues[1].floatValue;
        normalColorB = normalRgbaValues[2].floatValue;
        normalColorA = normalRgbaValues[3].floatValue;
        
        NSArray<NSNumber *> *selectRgbaValues = callbackRGBAValues(self.selectedTextColor);
        CGFloat difR = selectRgbaValues[0].floatValue - normalColorR;
        CGFloat difG = selectRgbaValues[1].floatValue - normalColorG;
        CGFloat difB = selectRgbaValues[2].floatValue - normalColorB;
        CGFloat difA = selectRgbaValues[3].floatValue - normalColorA;
        
        leftLabel.textColor = [UIColor colorWithRed:normalColorR + leftFactor * difR
                                              green:normalColorG + leftFactor * difG
                                               blue:normalColorB + leftFactor * difB
                                              alpha:normalColorA + leftFactor * difA];
        
        rightLabel.textColor = [UIColor colorWithRed:normalColorR + factor * difR
                                               green:normalColorG + factor * difG
                                                blue:normalColorB + factor * difB
                                               alpha:normalColorA + factor * difA];
    }
}

@end
