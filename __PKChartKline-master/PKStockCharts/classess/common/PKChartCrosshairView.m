//
//  PKChartCrosshairView.m
//  PKChartKit
//
//  Created by zhanghao on 2017/11/28.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import "PKChartCrosshairView.h"
#import "UIBezierPath+PKStockChart.h"

@interface PKChartCrosshairView () {
    NSTimer *_delayTimer;
}
@property (nonatomic, assign) CGPoint centralPoint;
@property (nonatomic, assign) CGPoint locationOfTouched;
@property (nonatomic, strong) CAShapeLayer *crosshairLineLayer;
@property (nonatomic, strong) CAShapeLayer *crosshairDotLayer;
@property (nonatomic, strong) UILabel *horizontalLeftLabel;
@property (nonatomic, strong) UILabel *horizontalRightLabel;
@property (nonatomic, strong) UILabel *verticalBottomLabel;

@end

@implementation PKChartCrosshairView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.shadowOffset = CGSizeMake(2, 2);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
        self.userInteractionEnabled = NO;
        [self defaultInitialization];
        [self commonInitialization];
    }
    return self;
}

- (void)defaultInitialization {
    _lineWidth = 1 / [UIScreen mainScreen].scale;
    _lineColor = [UIColor blackColor];
    _dotRadius = 2;
    _dotColor = [UIColor blackColor];
    _textColor = [UIColor colorWithRed:0 green:122 / 255. blue:255 / 255. alpha:1];
    _textFont = [UIFont systemFontOfSize:9];
    _textEdgePadding = UIOffsetMake(9, 2);
}

- (void)commonInitialization {
    _crosshairLineLayer = [CAShapeLayer layer];
    _crosshairLineLayer.fillColor = [UIColor clearColor].CGColor;
    _crosshairLineLayer.strokeColor = self.lineColor.CGColor;
    _crosshairLineLayer.lineWidth = self.lineWidth;
    [self.layer addSublayer:_crosshairLineLayer];
    
    _crosshairDotLayer = [CAShapeLayer layer];
    _crosshairDotLayer.fillColor = self.dotColor.CGColor;
    _crosshairDotLayer.strokeColor = [UIColor clearColor].CGColor;
    _crosshairDotLayer.lineWidth = 0;
    [self.layer addSublayer:_crosshairDotLayer];
    
    _horizontalLeftLabel = [self makeLabel];
    [self addSubview:_horizontalLeftLabel];
    
    _horizontalRightLabel = [self makeLabel];
    [self addSubview:_horizontalRightLabel];
    
    _verticalBottomLabel = [self makeLabel];
    [self addSubview:_verticalBottomLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(concordanceClicked:)];
    [_verticalBottomLabel addGestureRecognizer:tap];
}

- (void)concordanceClicked:(UITapGestureRecognizer *)g {
    if (self.verticalTextClicked) self.verticalTextClicked();
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *aView = self.verticalBottomLabel;
    if (aView.isUserInteractionEnabled && !self.isHidden && self.alpha > 0) {
        if (!CGRectEqualToRect(aView.frame, self.bounds) && CGRectContainsPoint(aView.frame, point)) {
            return aView;
        }
    }
    return [super hitTest:point withEvent:event];
}

- (UILabel *)makeLabel {
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 2;
    label.layer.masksToBounds = YES;
    label.userInteractionEnabled = YES;
    return label;
}

- (CGSize)sizeFitLabel:(UILabel *)label {
    CGSize size = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    size.width += self.textEdgePadding.horizontal;
    size.height += self.textEdgePadding.vertical;
    return size;
}

- (void)updateHorizontalText {
    _horizontalLeftLabel.text = self.horizontalLeftText;
    CGSize _size = [self sizeFitLabel:_horizontalLeftLabel];
    _horizontalLeftLabel.frame = CGRectIntegral((CGRect){.size = _size});
    CGSize _labelSize = _horizontalLeftLabel.frame.size;
    
    CGFloat halfWidth = _labelSize.width * 0.5;
    CGFloat halfHeight = _labelSize.height * 0.5;
    CGFloat positionX = halfWidth;
    CGPoint positionCenter = CGPointMake(positionX, self.centralPoint.y);
    
    if (self.centralPoint.y - halfHeight < self.bounds.origin.y) {
        positionCenter.y = self.bounds.origin.y + halfHeight;
    }
    if (self.centralPoint.y + halfHeight > self.bounds.size.height) {
        positionCenter.y = self.bounds.size.height - halfHeight;
    }
    
    if (self.centralPoint.y <= CGRectGetMinY(self.ignoreZone)) {
        if (self.centralPoint.y + halfHeight >= CGRectGetMinY(self.ignoreZone)) {
            positionCenter.y = CGRectGetMinY(self.ignoreZone) - halfHeight;
        }
    } else if (self.centralPoint.y >= CGRectGetMaxY(self.ignoreZone)) {
        if (self.centralPoint.y - halfHeight <= CGRectGetMaxY(self.ignoreZone)) {
            positionCenter.y = CGRectGetMaxY(self.ignoreZone) + halfHeight;
        }
    }
    
    if (!self.horizontalRightText) {
        _horizontalRightLabel.hidden = YES;
        // if larger than "self.bounds" 1/2, it is displayed on the left side, and vice versa.
        if (self.locationOfTouched.x <= self.bounds.size.width / 2.f) {
            positionCenter.x = self.bounds.size.width - positionX;
        }
    } else {
        _horizontalRightLabel.text = self.horizontalRightText;
        CGSize valueSize1 = [self sizeFitLabel:_horizontalRightLabel];
        _horizontalRightLabel.frame = (CGRect){.size = valueSize1};
        _horizontalRightLabel.center = CGPointMake(self.bounds.size.width - valueSize1.width * 0.5, positionCenter.y);
    }
    
    _horizontalLeftLabel.center = positionCenter;
}

- (void)updateVerticalText {
    _verticalBottomLabel.text = self.verticalBottomText;
    CGSize dateSize = [self sizeFitLabel:_verticalBottomLabel];
    _verticalBottomLabel.frame = (CGRect){.size = dateSize};
    CGFloat dateHalfWidth = dateSize.width * 0.5;
    CGFloat dateHalfHeight = dateSize.height * 0.5;
    CGPoint dateCenter = CGPointMake(self.centralPoint.x, self.bounds.size.height + dateHalfHeight + 2);
    if (self.centralPoint.x - dateHalfWidth < self.bounds.origin.x) {
        dateCenter.x = self.bounds.origin.x + dateHalfWidth;
    }
    if (self.centralPoint.x + dateHalfWidth > self.bounds.size.width) {
        dateCenter.x = self.bounds.size.width - dateHalfWidth;
    }
    _verticalBottomLabel.center = dateCenter;
}

- (void)updateContents {
    [self layoutIfNeeded];
    
    _horizontalLeftLabel.hidden = !CGRectContainsPoint(self.bounds, self.centralPoint) || CGRectContainsPoint(self.ignoreZone, self.centralPoint); // hidden in the separationRect
    _horizontalRightLabel.hidden = _horizontalLeftLabel.hidden;
    _crosshairDotLayer.hidden = (_verticalBottomLabel.hidden || _horizontalLeftLabel.hidden);
    
    [self updateHorizontalText];
    [self updateVerticalText];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (!_verticalBottomLabel.hidden) {
        [path pk_addVerticalLine:CGPointMake(self.centralPoint.x, 0) len:CGRectGetMinY(self.ignoreZone)];
        [path pk_addVerticalLine:CGPointMake(self.centralPoint.x, CGRectGetMaxY(self.ignoreZone)) len:self.bounds.size.height - CGRectGetMaxY(self.ignoreZone)];
    }
    if (!_horizontalLeftLabel.hidden) {
        [path pk_addHorizontalLine:CGPointMake(0, self.centralPoint.y) len:self.bounds.size.width];
    }
    _crosshairLineLayer.path = path.CGPath;
    
    if (_verticalBottomLabel.hidden || _horizontalLeftLabel.hidden || !self.dotRadius) return;
    UIBezierPath *dotPath = [UIBezierPath bezierPathWithArcCenter:self.centralPoint radius:self.dotRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    _crosshairDotLayer.path = dotPath.CGPath;
}

- (void)updateContentsInCenter:(CGPoint)center touched:(CGPoint)locationOfTouched {
    _centralPoint = center;
    _locationOfTouched = locationOfTouched;
    [self updateContents];
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    _crosshairLineLayer.strokeColor = lineColor.CGColor;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    _crosshairLineLayer.lineWidth = lineWidth;
}

- (void)setDotColor:(UIColor *)dotColor {
    _dotColor = dotColor;
    _crosshairDotLayer.fillColor = dotColor.CGColor;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    _horizontalLeftLabel.textColor = textColor;
    _horizontalRightLabel.textColor = textColor;
    _verticalBottomLabel.textColor = textColor;
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    _horizontalLeftLabel.font = textFont;
    _horizontalRightLabel.font = textFont;
    _verticalBottomLabel.font = textFont;
}

- (void)present {
    if (self.isPresenting && _delayTimer) {
        [self delayTimerFreed];
    }
    _isPresenting = YES;
    self.alpha = 1;
    
    if ([self.delegate respondsToSelector:@selector(crosshairViewDidPresent:)]) {
        [self.delegate crosshairViewDidPresent:self];
    }
}

- (void)dismissDelay:(NSTimeInterval)duration {
    if (!self.isPresenting) return;
    
    [_delayTimer invalidate];
    _delayTimer = [NSTimer timerWithTimeInterval:duration target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_delayTimer forMode:NSRunLoopCommonModes];
}

- (void)dismiss {
    if (!self.isPresenting) return;
    
    if (_delayTimer) {
        [self delayTimerFreed];
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self->_isPresenting = NO;
        if ([self.delegate respondsToSelector:@selector(crosshairViewDidDismiss:)]) {
            [self.delegate crosshairViewDidDismiss:self];
        }
    }];
}

- (void)delayTimerFreed {
    [_delayTimer invalidate];
    _delayTimer = nil;
}

- (void)dealloc {
    [self delayTimerFreed];
}

@end
