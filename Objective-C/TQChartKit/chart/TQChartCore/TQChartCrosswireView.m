//
//  TQCrosswireView.m
//  CoreGraphics_demo
//
//  Created by zhanghao on 2018/6/21.
//  Copyright © 2018年 snail-z. All rights reserved.
//

#import "TQChartCrosswireView.h"
#import "UIBezierPath+TQChart.h"

@interface TQChartCrosswireView ()

@property (nonatomic, strong) CAShapeLayer *crosswireLayer;
@property (nonatomic, strong) UILabel *mapYaixsLabel;
@property (nonatomic, strong) UILabel *mapYaixsSubjoinLabel;
@property (nonatomic, strong) UILabel *mapIndexLabel;
@property (nonatomic, strong) NSTimer *delayTimer;

@end

@implementation TQChartCrosswireView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.shadowOffset = CGSizeMake(2, 2);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 1.0f;
        self.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
        [self defaultInitialization];
        [self commonInitialization];
    }
    return self;
}

- (void)defaultInitialization {
    _lineWidth = 1.f / [UIScreen mainScreen].scale;
    _lineColor = [UIColor grayColor];
    _textFont = [UIFont systemFontOfSize:11];
    _textColor = [UIColor darkGrayColor];
    _textEdgePadding = UIOffsetMake(9, 3);
}

- (void)commonInitialization {
    _crosswireLayer = [CAShapeLayer layer];
    _crosswireLayer.fillColor = [UIColor clearColor].CGColor;
    _crosswireLayer.strokeColor = self.lineColor.CGColor;
    _crosswireLayer.lineWidth = self.lineWidth;
    [self.layer addSublayer:_crosswireLayer];
    
    _mapYaixsLabel = [UILabel new];
    _mapYaixsLabel.backgroundColor = [UIColor whiteColor];
    _mapYaixsLabel.textAlignment = NSTextAlignmentCenter;
    _mapYaixsLabel.layer.cornerRadius = 2;
    _mapYaixsLabel.layer.masksToBounds = YES;
    [self addSubview:_mapYaixsLabel];
    
    _mapYaixsSubjoinLabel = [UILabel new];
    _mapYaixsSubjoinLabel.backgroundColor = [UIColor whiteColor];
    _mapYaixsSubjoinLabel.textAlignment = NSTextAlignmentCenter;
    _mapYaixsSubjoinLabel.layer.cornerRadius = 2;
    _mapYaixsSubjoinLabel.layer.masksToBounds = YES;
    [self addSubview:_mapYaixsSubjoinLabel];
    
    _mapIndexLabel = [UILabel new];
    _mapIndexLabel.backgroundColor = [UIColor whiteColor];
    _mapIndexLabel.textAlignment = NSTextAlignmentCenter;
    _mapIndexLabel.layer.cornerRadius = 2;
    _mapIndexLabel.layer.masksToBounds = YES;
    [self addSubview:_mapIndexLabel];
}

- (CGSize)sizeFit:(UILabel *)label {
    CGSize size = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    return CGSizeMake(size.width += self.textEdgePadding.horizontal,
                      size.height += self.textEdgePadding.vertical);
}

- (void)updateYaixsText {
    _mapYaixsLabel.text = self.mapYaixsText;
    CGSize valueSize = [self sizeFit:_mapYaixsLabel];
    _mapYaixsLabel.frame = (CGRect){.size = valueSize};
    CGFloat valueHalfWidth = valueSize.width * 0.5;
    CGFloat valueHalfHeight = valueSize.height * 0.5;
    CGFloat positionX = valueHalfWidth;
    CGPoint valueCenter = CGPointMake(positionX, self.centralPoint.y);
    if (self.centralPoint.y - valueHalfHeight < self.bounds.origin.y) {
        valueCenter.y = self.bounds.origin.x + valueHalfHeight;
    }
    if (self.centralPoint.y + valueHalfHeight > self.bounds.size.height) {
        valueCenter.y = self.bounds.size.height - valueHalfHeight;
    }
    if (self.centralPoint.y < CGRectGetMinY(self.separationRect)) {
        if (self.centralPoint.y + valueHalfHeight > CGRectGetMinY(self.separationRect)) {
            valueCenter.y = CGRectGetMinY(self.separationRect) - valueHalfHeight;
        }
    } else if (self.centralPoint.y > CGRectGetMaxY(self.separationRect)) {
        if (self.centralPoint.y - valueHalfHeight < CGRectGetMaxY(self.separationRect)) {
            valueCenter.y = CGRectGetMaxY(self.separationRect) + valueHalfHeight;
        }
    }
    
    if (!self.mapYaixsSubjoinText) {
        _mapYaixsSubjoinLabel.hidden = YES;
        // if larger than "self.bounds" 1/4, it is displayed on the left side, and vice versa.
        if (self.spotOfTouched.x <= self.bounds.size.width / 4.f) {
            valueCenter.x = self.bounds.size.width - positionX;
        }
    } else {
        _mapYaixsSubjoinLabel.text = self.mapYaixsSubjoinText;
        CGSize valueSize1 = [self sizeFit:_mapYaixsSubjoinLabel];
        _mapYaixsSubjoinLabel.frame = (CGRect){.size = valueSize1};
        _mapYaixsSubjoinLabel.center = CGPointMake(self.bounds.size.width - valueSize1.width * 0.5, valueCenter.y);
    }
    
    _mapYaixsLabel.center = valueCenter;
}

- (void)updateIndexText {
    _mapIndexLabel.text = self.mapIndexText;
    CGSize dateSize = [self sizeFit:_mapIndexLabel];
    _mapIndexLabel.frame = (CGRect){.size = dateSize};
    CGFloat dateHalfWidth = dateSize.width * 0.5;
    CGFloat dateHalfHeight = dateSize.height * 0.5;
    CGPoint dateCenter = CGPointMake(self.centralPoint.x, self.bounds.size.height + dateHalfHeight);
    dateCenter.y += 2; // move down 2pt
    if (self.centralPoint.x - dateHalfWidth < self.bounds.origin.x) {
        dateCenter.x = self.bounds.origin.x + dateHalfWidth;
    }
    if (self.centralPoint.x + dateHalfWidth > self.bounds.size.width) {
        dateCenter.x = self.bounds.size.width - dateHalfWidth;
    }
    _mapIndexLabel.center = dateCenter;
}

- (void)updateContents {
    _crosswireLayer.strokeColor = self.lineColor.CGColor;
    _crosswireLayer.lineWidth = self.lineWidth;
    _mapYaixsLabel.font = self.textFont;
    _mapYaixsLabel.textColor = self.textColor;
    _mapYaixsSubjoinLabel.font = self.textFont;
    _mapYaixsSubjoinLabel.textColor = self.textColor;
    _mapIndexLabel.font = self.textFont;
    _mapIndexLabel.textColor = self.textColor;
    
    _mapIndexLabel.hidden = !CGRectContainsPoint(self.bounds, self.centralPoint) || !CGRectContainsPoint(self.bounds, self.spotOfTouched);
    _mapYaixsLabel.hidden = !CGRectContainsPoint(self.bounds, self.centralPoint) || CGRectContainsPoint(self.separationRect, self.centralPoint); // hidden in the `separationRect'
    _mapYaixsSubjoinLabel.hidden = _mapYaixsLabel.hidden;
    
    [self updateYaixsText];
    [self updateIndexText];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (!_mapIndexLabel.hidden) {
        [path addVerticalLine:CGPointMake(self.centralPoint.x, 0) len:CGRectGetMinY(self.separationRect)];
        [path addVerticalLine:CGPointMake(self.centralPoint.x, CGRectGetMaxY(self.separationRect)) len:self.bounds.size.height - CGRectGetMaxY(self.separationRect)];
    }
    if (!_mapYaixsLabel.hidden) {
        [path addHorizontalLine:CGPointMake(0, self.centralPoint.y) len:self.bounds.size.width];
    }
    _crosswireLayer.path = path.CGPath;
}

- (void)setFadeHidden:(BOOL)fadeHidden {
    if (!fadeHidden && _delayTimer) {
        [self delayTimerFreed];
    }
    _fadeHidden = fadeHidden;
    self.hidden = fadeHidden;
    [UIView animateWithDuration:0.15 animations:^{
        self.alpha = fadeHidden ? 0 : 1;
    }];
}

- (void)fadeHiddenDelayed:(NSTimeInterval)delay {
    [_delayTimer invalidate];
    _delayTimer = [NSTimer timerWithTimeInterval:delay target:self selector:@selector(delayTimerFired) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_delayTimer forMode:NSRunLoopCommonModes];
}

- (void)delayTimerFired {
    self.fadeHidden = YES;
}

- (void)delayTimerFreed {
    [_delayTimer invalidate];
    _delayTimer = nil;
}

- (void)dealloc {
    [self delayTimerFreed];
}

@end
