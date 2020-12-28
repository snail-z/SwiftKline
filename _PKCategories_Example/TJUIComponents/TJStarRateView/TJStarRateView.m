//
//  TJStarRateView.m
//  TJCategories_Example
//
//  Created by zhanghao on 2020/12/24.
//  Copyright © 2020 gren-beans. All rights reserved.
//

#import "TJStarRateView.h"

@interface TJStarRateView ()

@property(nonatomic, strong) UIView *checkedImageViews;
@property(nonatomic, strong) UIView *uncheckedImageViews;
@property(nonatomic, assign, readonly) NSInteger itemCount;

@end

@implementation TJStarRateView

- (instancetype)initWithItemCount:(NSInteger)count {
    if (self = [super initWithFrame:CGRectZero]) {
        _itemCount = count;
        [self defaultInitialization];
        [self subviewInitialization];
        [self starViewsInitialization];
    }
    return self;
}

- (void)defaultInitialization {
    _rateType = TJStarRateTypeWhole;
    _itemCount = 5;
    _itemSpacing = 10;
    _contentEdgeInsets = UIEdgeInsetsZero;
    _itemSize = CGSizeZero;
    _isTouchEnabled = YES;
    _isSlideEnabled = YES;
    _isSlideOutside = YES;
    _maxScore = 5;
    _defaultScore = 0;
}

- (void)subviewInitialization {
    _uncheckedImageViews = [UIView new];
    [self addSubview:_uncheckedImageViews];
    
    _checkedImageViews = [UIView new];
    _checkedImageViews.userInteractionEnabled = NO;
    _checkedImageViews.clipsToBounds = YES;
    [self addSubview:_checkedImageViews];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizer:)];
    [_uncheckedImageViews addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognizer:)];
    [_uncheckedImageViews addGestureRecognizer:pan];
}

- (void)starViewsInitialization {
    for (NSInteger idx = 0; idx < self.itemCount; idx++) {
        UIImageView *uncheckedImgView = [UIImageView new];
        [_uncheckedImageViews addSubview:uncheckedImgView];
        
        UIImageView *checkedImgView = [UIImageView new];
        [_checkedImageViews addSubview:checkedImgView];
    }
}

- (void)tapRecognizer:(UITapGestureRecognizer *)g {
    if (!self.isTouchEnabled) return;
    CGPoint p = [g locationInView:g.view];
    [self resolveGestureRecognizer:p];
}

- (void)panRecognizer:(UIPanGestureRecognizer *)g {
    if (!self.isSlideEnabled) return;
    CGPoint p = [g locationInView:g.view];
    if (self.isSlideOutside) {
        [self resolveGestureRecognizer:p];
    } else {
        if (CGRectContainsPoint(self.bounds, p)) {
            [self resolveGestureRecognizer:p];
        }
    }
}

- (void)resolveGestureRecognizer:(CGPoint)p {
    NSInteger index = [self nearestIndexToPoint:p];
    CGPoint finalPoint = [self limitPointWithinBoundary:p];
    
    CGFloat itemWidth = self.checkedImageViews.subviews.firstObject.bounds.size.width;
    
    CGFloat checkedViewsWidth = index * self.itemSpacing + (index + 1) * itemWidth;
    checkedViewsWidth += self.contentEdgeInsets.left; // 计算星星容器视图宽度

    CGFloat single = self.maxScore / self.itemCount; // 计算单颗星星的分数
    
    switch (self.rateType) {
        case TJStarRateTypeWhole: {
            [self updateCurrentScore:(index + 1) * single];
        } break;
        case TJStarRateTypeHalf: {
            UIView *currentView = _uncheckedImageViews.subviews[index];
            if (finalPoint.x < currentView.center.x) {
                checkedViewsWidth = currentView.center.x;
                CGFloat _score = (index + 1) * single - single / 2;
                [self updateCurrentScore:_score];
            } else {
                checkedViewsWidth = CGRectGetMaxX(currentView.frame);
                float _score = (index + 1) * single;
                [self updateCurrentScore:_score];
            }
        } break;
        default: {
            checkedViewsWidth = finalPoint.x;
            BOOL isBlindspot = YES;
            float _score = _currentScore;
            for (NSInteger idx = 0; idx < _uncheckedImageViews.subviews.count; idx++) {
                UIView *aView = _uncheckedImageViews.subviews[idx];
                if (finalPoint.x >= aView.frame.origin.x && finalPoint.x <= CGRectGetMaxX(aView.frame)) {
                    isBlindspot = NO;
                    CGFloat minx = finalPoint.x - aView.frame.origin.x;
                    CGFloat ones = (minx / itemWidth) * single; // 当前星上的进度转为对应的分数
                    _score = index * single + ones;
                    break;
                }
            }
            if (isBlindspot) _score = round(_score);
            [self updateCurrentScore:_score];
        } break;
    }
    
    if (finalPoint.x <= CGRectGetMinX(_uncheckedImageViews.subviews.firstObject.frame)) {
        [self updateCurrentScore:0];
    }
    
    if (finalPoint.x >= CGRectGetMaxX(_uncheckedImageViews.subviews.lastObject.frame)) {
        [self updateCurrentScore:self.maxScore];
    }
    
    CGRect _frame = _checkedImageViews.frame;
    _frame.size.width = checkedViewsWidth;
    _checkedImageViews.frame = _frame;
}

- (NSInteger)nearestIndexToPoint:(CGPoint)point {
    NSMutableArray *distances = [NSMutableArray array];
    for (UIView *aView in _uncheckedImageViews.subviews) {
        CGFloat distance = fabs(point.x - aView.center.x);
        [distances addObject:@(distance)];
    }
    return [distances indexOfObject:[distances valueForKeyPath:@"@min.self"]];
}

- (CGPoint)limitPointWithinBoundary:(CGPoint)p {
    if (p.x < _uncheckedImageViews.frame.origin.x) {
        return CGPointMake(_uncheckedImageViews.frame.origin.x, p.y);
    } else if (p.x > CGRectGetMaxX(_uncheckedImageViews.frame)) {
        return CGPointMake(CGRectGetMaxX(_uncheckedImageViews.frame), p.y);
    } else {
        return p;
    }
}

- (void)updateCurrentScore:(float)score {
    if (_currentScore != score) {
        _currentScore = score;
        if ([self.delegate respondsToSelector:@selector(starRateView:currentScoreChanged:)]) {
            [self.delegate starRateView:self currentScoreChanged:score];
        } else {
            if (self.didScoreChanged) self.didScoreChanged(self, score);
        }
    }
}

- (void)needsUpdateLayout {
    _uncheckedImageViews.frame = self.bounds;
    _checkedImageViews.frame = self.bounds;
    if (CGSizeEqualToSize(CGSizeZero, self.bounds.size)) return;
    
    for (NSInteger idx = 0; idx < self.itemCount; idx++) {
        UIImageView *uncheckedImgView = _uncheckedImageViews.subviews[idx];
        UIImageView *checkedImgView = _checkedImageViews.subviews[idx];
        uncheckedImgView.frame = [self elementFrameForIndex:idx];
        checkedImgView.frame = [self elementFrameForIndex:idx];
    }
    
    [self needsUpdaateScore];
}

- (CGRect)elementFrameForIndex:(NSInteger)index {
    CGSize size = self.itemSize;
    if (CGSizeEqualToSize(CGSizeZero, self.itemSize)) {
        size = CGSizeMake(self.bounds.size.height, self.bounds.size.height);
    }
    CGFloat x = (size.width + self.itemSpacing) * index;
    x += self.contentEdgeInsets.left;
    CGFloat y = (self.bounds.size.height - size.height) / 2;
    return CGRectMake(x, y, size.width, size.height);
}

- (void)needsUpdaateScore {
    CGFloat itemWidth = self.checkedImageViews.subviews.firstObject.bounds.size.width;
    
    CGFloat allWidth = self.itemCount * itemWidth; // 计算星星宽度总和

    CGFloat percentage = self.defaultScore / self.maxScore; // 计算当前分数占比
    
    NSInteger intValue = self.itemCount * percentage; // 计算转换到星星上会有几颗整星
    
    CGFloat checkedViewsWidth = allWidth * percentage + intValue * self.itemSpacing;
    checkedViewsWidth += self.contentEdgeInsets.left; // 转换成当前进度
    
    CGRect _frame = _checkedImageViews.frame;
    _frame.size.width = checkedViewsWidth;
    _checkedImageViews.frame = _frame;
}

- (void)setUncheckedImages:(NSArray<UIImage *> *)uncheckedImages {
    NSParameterAssert(uncheckedImages.count == _uncheckedImageViews.subviews.count);
    _uncheckedImages = uncheckedImages;
    for (NSInteger idx = 0; idx < uncheckedImages.count; idx++) {
        UIImageView *imgView = _uncheckedImageViews.subviews[idx];
        imgView.image = uncheckedImages[idx];
    }
}

- (void)setCheckedImages:(NSArray<UIImage *> *)checkedImages {
    NSParameterAssert(checkedImages.count == _checkedImageViews.subviews.count);
    _checkedImages = checkedImages;
    for (NSInteger idx = 0; idx < checkedImages.count; idx++) {
        UIImageView *imgView = _checkedImageViews.subviews[idx];
        imgView.image = checkedImages[idx];
    }
}

- (void)setUncheckedImage:(UIImage *)uncheckedImage {
    _uncheckedImage = uncheckedImage;
    if (uncheckedImage) {
        for (UIImageView *imgView in _uncheckedImageViews.subviews) {
            imgView.image = uncheckedImage;
        }
    }
}

- (void)setCheckedImage:(UIImage *)checkedImage {
    _checkedImage = checkedImage;
    if (checkedImage) {
        for (UIImageView *imgView in _checkedImageViews.subviews) {
            imgView.image = checkedImage;
        }
    }
}

- (void)setItemSpacing:(CGFloat)itemSpacing {
    _itemSpacing = itemSpacing;
    [self needsUpdateLayout];
}

- (void)setItemSize:(CGSize)itemSize {
    _itemSize = itemSize;
    [self needsUpdateLayout];
}

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
    _contentEdgeInsets = contentEdgeInsets;
    [self needsUpdateLayout];
}

- (void)setDefaultScore:(float)defaultScore {
    _defaultScore = defaultScore;
    [self needsUpdateLayout];
}

@end
