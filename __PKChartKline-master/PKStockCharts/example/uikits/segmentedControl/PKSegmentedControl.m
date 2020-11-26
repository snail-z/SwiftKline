//
//  PKSegmentedControl.m
//  PKOrnaments
//
//  Created by zhanghao on 2019/3/25.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import "PKSegmentedControl.h"

@implementation PKSegmentedItem

@end

@implementation PKSegmentedTextItem

+ (instancetype)itemWithTitles:(NSArray<NSString *> *)titles {
    PKSegmentedTextItem *item = [[PKSegmentedTextItem alloc] init];
    item.titles = titles;
    item.normalTextColor = [UIColor whiteColor];
    item.normalTextFont = [UIFont systemFontOfSize:13.0];
    item.selectedTextFont = [UIFont systemFontOfSize:13.0];
    item.selectedTextColor = [UIColor colorWithRed:0 / 255. green:122 / 255. blue:255 / 255. alpha:1];
    return item;
}

@end

@implementation PKSegmentedIconItem

+ (instancetype)itemWithIcons:(NSArray<UIImage *> *)icons {
    PKSegmentedIconItem *item = [[PKSegmentedIconItem alloc] init];
    item.icons = icons;
    item.iconSzie = CGSizeMake(18, 18);
    item.normalTintColor = [UIColor whiteColor];
    item.selectedTintColor = [UIColor colorWithRed:0 / 255. green:122 / 255. blue:255 / 255. alpha:1];
    return item;
}

@end

@interface PKSegmentedControlIndicator : UIView

@property (nonatomic, strong) UIView *segmentMaskView;
@property (nonatomic, assign) CGFloat cornerRadius;

@end

@implementation PKSegmentedControlIndicator

- (instancetype)init {
    if (self = [super init]) {
        self.layer.masksToBounds = YES;
        _segmentMaskView = [UIView new];
        _segmentMaskView.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.segmentMaskView.frame = frame;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.segmentMaskView.layer.cornerRadius = cornerRadius;
}

@end

@interface PKSegmentedControl () <UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGRect initialIndicatorViewFrame;
@property (nonatomic, assign) NSTimeInterval animationWithBounceDuration;
@property (nonatomic, assign) CGFloat animationWithBounceSpringDamping;
@property (nonatomic, assign) NSTimeInterval animationWithoutBounceDuration;
@property (nonatomic, strong) PKSegmentedControlIndicator *indicatorView;
@property (nonatomic, strong) UIView *normalSegmentsView;
@property (nonatomic, strong) UIView *selectedSegmentsView;
@property (nonatomic, strong) CAShapeLayer *separatorLayer;

@end

@implementation PKSegmentedControl

- (void)defaultValues {
    _index = 0;
    _indicatorViewInset = 2.0;
    _indicatorViewBackgroundColor = [UIColor blackColor];
    _cornerRadius = 0;
    _separatorWidth = 1.0;
    _separatorColor = [UIColor grayColor];
    _bouncesOnChange = YES;
    _announcesValueImmediately = YES;
    _announcesValueChanged = YES;
    _panningDisabled = YES;
    _animateEnabled = YES;
    _animationWithBounceSpringDamping = 0.75;
    _animationWithBounceDuration = 0.3;
    _animationWithoutBounceDuration = 0.2;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithItem:(PKSegmentedItem *)item {
    if (self = [self initWithFrame:CGRectZero]) {
        [self updateSegmentedItem:item];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        
        [self defaultValues];
        
        _normalSegmentsView = [[UIView alloc] init];
        [self addSubview:_normalSegmentsView];
        
        _indicatorView = [[PKSegmentedControlIndicator alloc] init];
        _indicatorView.backgroundColor = self.indicatorViewBackgroundColor;
        [self addSubview:_indicatorView];
        
        _selectedSegmentsView = [[UIView alloc] init];
        [self addSubview:_selectedSegmentsView];
        _selectedSegmentsView.layer.mask = _indicatorView.segmentMaskView.layer;
        
        _separatorLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_separatorLayer];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
        pan.delegate = self;
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSInteger segmentsCount = self.normalSegmentsView.subviews.count;
    if (!segmentsCount) return;
    
    self.normalSegmentsView.frame = self.bounds;
    self.selectedSegmentsView.frame = self.bounds;
    self.indicatorView.frame = [self elementFrameForIndex:self.index];
    
    for (int idx = 0; idx < segmentsCount; idx++) {
        CGRect frame = [self elementFrameForIndex:idx];
        self.normalSegmentsView.subviews[idx].frame = frame;
        self.selectedSegmentsView.subviews[idx].frame = frame;
    }
    
    if (self.separatorWidth > 0) {
        self.separatorLayer.path = [self separatorLinePath].CGPath;
    }
}

- (CGRect)elementFrameForIndex:(NSInteger)index {
    CGFloat totalInsetSize = self.indicatorViewInset * 2.0;
    CGFloat elementWidth = (self.bounds.size.width - totalInsetSize) / (CGFloat)self.normalSegmentsView.subviews.count;
    return (CGRect){.origin.x = ((CGFloat)index) * elementWidth + self.indicatorViewInset,
                    .origin.y = self.indicatorViewInset,
                    .size.width = elementWidth,
                    .size.height = self.bounds.size.height - totalInsetSize};
}

- (UIBezierPath *)separatorLinePath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int idx = 1; idx < self.normalSegmentsView.subviews.count; idx++) {
        CGRect frame = self.normalSegmentsView.subviews[idx].frame;
        [path moveToPoint:frame.origin];
        [path addLineToPoint:CGPointMake(frame.origin.x, self.bounds.size.height)];
    }
    return path;
}

- (void)updateSegmentedItem:(PKSegmentedItem *)item {
    if (item) {
        _item = item;
        
        [self removeAllSubviews];
        
        if ([item isKindOfClass:PKSegmentedTextItem.class]) {
            [self updateTitleItem:(PKSegmentedTextItem *)item];
        } else if ([item isKindOfClass:PKSegmentedIconItem.class]) {
            [self updateImageItem:(PKSegmentedIconItem *)item];
        }
    }
}

- (void)updateTitleItem:(PKSegmentedTextItem *)item {
    if (item.titles) {
        for (int index = 0; index < item.titles.count; index++) {
            UILabel *titleLabel = [UILabel new];
            titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = item.normalTextColor;
            titleLabel.text = item.titles[index];
            titleLabel.font = item.normalTextFont;
            [self.normalSegmentsView addSubview:titleLabel];
            
            UILabel *selectedTitleLabel = [UILabel new];
            selectedTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            selectedTitleLabel.textAlignment = NSTextAlignmentCenter;
            selectedTitleLabel.textColor = item.selectedTextColor;
            selectedTitleLabel.text = item.titles[index];
            selectedTitleLabel.font = item.selectedTextFont;
            [self.selectedSegmentsView addSubview:selectedTitleLabel];
        }
        [self setNeedsLayout];
    }
}

- (void)updateImageItem:(PKSegmentedIconItem *)item {
    if (item.icons) {
        for (int index = 0; index < item.icons.count; index++) {
            UIImage *image = item.icons[index];
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            
            UIImageView *imgView = [self popImageViewInView:self.normalSegmentsView];
            imgView.image = image;
            imgView.tintColor = item.normalTintColor;
            imgView.frame = (CGRect){.origin = imgView.frame.origin, .size = item.iconSzie};
            
            UIImageView *selectedImgView = [self popImageViewInView:self.selectedSegmentsView];
            selectedImgView.image = image;
            selectedImgView.tintColor = item.selectedTintColor;
            selectedImgView.frame = (CGRect){.origin = selectedImgView.frame.origin, .size = item.iconSzie};
        }
        [self setNeedsLayout];
    }
}

- (void)removeAllSubviews {
    while (self.normalSegmentsView.subviews.count) {
        [self.normalSegmentsView.subviews.lastObject removeFromSuperview];
        [self.selectedSegmentsView.subviews.lastObject removeFromSuperview];
    }
}

- (UIImageView *)popImageViewInView:(UIView *)superView {
    UIView *wrapperView = [[UIView alloc] init];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [wrapperView addSubview:imgView];
    [superView addSubview:wrapperView];
    return imgView;
}

- (void)setIndicatorViewBorderWidth:(CGFloat)indicatorViewBorderWidth {
    _indicatorViewBorderWidth = indicatorViewBorderWidth;
    self.indicatorView.layer.borderWidth = indicatorViewBorderWidth;
}

- (void)setIndicatorViewBorderColor:(UIColor *)indicatorViewBorderColor {
    _indicatorViewBorderColor = indicatorViewBorderColor;
    self.indicatorView.layer.borderColor = indicatorViewBorderColor.CGColor;
}

- (void)setIndicatorViewBackgroundColor:(UIColor *)indicatorViewBackgroundColor {
    _indicatorViewBackgroundColor = indicatorViewBackgroundColor;
    self.indicatorView.backgroundColor = indicatorViewBackgroundColor;
}

- (void)setIndicatorViewInset:(CGFloat)indicatorViewInset {
    _indicatorViewInset = indicatorViewInset;
    [self setCornerRadius:self.cornerRadius];
    [self setNeedsLayout];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.indicatorView.cornerRadius = cornerRadius - self.indicatorViewInset;
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    _separatorColor = separatorColor;
    self.separatorLayer.strokeColor = separatorColor.CGColor;
}

- (void)setSeparatorWidth:(CGFloat)separatorWidth {
    _separatorWidth = separatorWidth;
    _separatorLayer.lineWidth = separatorWidth;
    [self setNeedsLayout];
}

- (void)setWithIndex:(NSInteger)index animated:(BOOL)animated {
    if (index < self.normalSegmentsView.subviews.count) {
        NSInteger oldIndex = self.index;
        _index = index;
        [self moveIndicatorViewAnimated:animated shouldSendEvent:((self.index != oldIndex) || !self.announcesValueChanged)];
    }
}

- (void)moveIndicatorViewAnimated:(BOOL)animated shouldSendEvent:(BOOL)shouldSendEvent {
    if (animated) {
        if (shouldSendEvent && self.announcesValueImmediately) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
        
        [UIView animateWithDuration:(self.bouncesOnChange ? self.animationWithBounceDuration : self.animationWithoutBounceDuration)
                              delay:0.0
             usingSpringWithDamping:(self.bouncesOnChange ? self.animationWithBounceSpringDamping : 1.0)
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [self moveIndicatorView];
        } completion:^(BOOL finished) {
            if (finished && shouldSendEvent && !self.announcesValueImmediately) {
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }];
    } else {
        [self moveIndicatorView];
        if (shouldSendEvent) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

- (void)moveIndicatorView {
    self.indicatorView.frame = self.normalSegmentsView.subviews[self.index].frame;
    [self layoutIfNeeded];
}

- (NSInteger)nearestIndexToPoint:(CGPoint)point {
    NSMutableArray *distances = [NSMutableArray array];
    for (UIView *aView in self.normalSegmentsView.subviews) {
        CGFloat distance = fabs(point.x - aView.center.x);
        [distances addObject:@(distance)];
    }
    return [distances indexOfObject:[distances valueForKeyPath:@"@min.self"]];
}

- (void)tapped:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self];
    NSInteger index = [self nearestIndexToPoint:location];
    [self setWithIndex:index animated:self.animateEnabled];
}

- (void)panned:(UIPanGestureRecognizer *)gestureRecognizer {
    if (self.panningDisabled) return;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            _initialIndicatorViewFrame = self.indicatorView.frame;
        } break;
        case UIGestureRecognizerStateChanged: {
            CGRect frame = _initialIndicatorViewFrame;
            frame.origin.x += [gestureRecognizer translationInView:self].x;
            frame.origin.x = MAX(MIN(frame.origin.x, self.bounds.size.width - self.indicatorViewInset - frame.size.width), self.indicatorViewInset);
            self.indicatorView.frame = frame;
        } break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            NSInteger index = [self nearestIndexToPoint:self.indicatorView.center];
            [self setWithIndex:index animated:self.animateEnabled];
        }
        default: break;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint p = [gestureRecognizer locationInView:self];
        return CGRectContainsPoint(self.indicatorView.frame, p);
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

@end
