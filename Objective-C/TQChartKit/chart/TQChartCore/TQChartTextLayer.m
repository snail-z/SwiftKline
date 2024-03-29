//
//  TQChartTextLayer.m
//  CoreGraphics_demo
//
//  Created by zhanghao on 2018/7/5.
//  Copyright © 2018年 snail-z. All rights reserved.
//

#import "TQChartTextLayer.h"

CGPoint const kCGOffsetRatioTopLeft = (CGPoint){0, 0};
CGPoint const kCGOffsetRatioTopRight = (CGPoint){1, 0};
CGPoint const kCGOffsetRatioTopCenter = (CGPoint){0.5, 0};
CGPoint const kCGOffsetRatioBottomLeft = (CGPoint){0, 1};
CGPoint const kCGOffsetRatioBottomRight = (CGPoint){1, 1};
CGPoint const kCGOffsetRatioBottomCenter = (CGPoint){0.5, 1};
CGPoint const kCGOffsetRatioCenterLeft = (CGPoint){0, 0.5};
CGPoint const kCGOffsetRatioCenterRight = (CGPoint){1, 0.5};
CGPoint const kCGOffsetRatioCenter = (CGPoint){0.5, 0.5};

@implementation TQChartTextRenderer

+ (instancetype)defaultRenderer {
    TQChartTextRenderer *renderer = [TQChartTextRenderer new];
    
    renderer.baseOffset = UIOffsetZero;
    renderer.offsetRatio = kCGOffsetRatioBottomLeft;
    renderer.enlargeInsets = CGPointMake(1, 1);
    
    renderer.maxWidth = CGFLOAT_MAX;
    return renderer;
}

- (UIFont *)font {
    if (_font) return _font;
    return [UIFont systemFontOfSize:11];
}

- (UIColor *)color {
    if (_color) return _color;
    return [UIColor blackColor];
}

- (void)updateTextLayer:(CATextLayer *)layer {
    if (!self.text) return;
    layer.backgroundColor = self.backgroundColor.CGColor;
    layer.cornerRadius = self.cornerRadius;
    layer.borderWidth = self.borderWidth;
    layer.borderColor = self.borderColor.CGColor;
    
    CGFloat (^decimalLimit)(CGFloat) = ^(CGFloat a) {
        return (CGFloat)MIN(1, MAX(0, a));
    };
    CGPoint position = self.positionCenter;
    CGPoint scale = CGPointMake(decimalLimit(self.offsetRatio.x), decimalLimit(self.offsetRatio.y));
    CGFloat baseOffset = -self.enlargeInsets.y * 0.5;
    NSRange range = NSMakeRange(0, self.text.length);
    
    NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attriText addAttribute:NSFontAttributeName value:self.font range:range];
    [attriText addAttribute:NSForegroundColorAttributeName value:self.color range:range];
    [attriText addAttribute:NSBaselineOffsetAttributeName value:@(baseOffset) range:range];
    layer.string = attriText;
    
    CGSize maxSize = CGSizeMake(MIN(self.maxWidth, CGFLOAT_MAX), MAXFLOAT);
    CGSize size = [attriText boundingRectWithSize:maxSize
                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    size.width += self.enlargeInsets.x;
    size.height += self.enlargeInsets.y;
    
    CGPoint origin = CGPointMake(position.x - size.width * scale.x,
                                 position.y - size.height * scale.y);
    origin.x += self.baseOffset.horizontal;
    origin.y += self.baseOffset.vertical;
    
    layer.frame = (CGRect){.origin = origin, .size = size};
}

@end

@interface TQChartTextLayer ()

@property (nonatomic, strong) CALayer *containerLayer;
@property (nonatomic, strong) NSMutableArray<CATextLayer *> *allSublayers;

@end

@implementation TQChartTextLayer

- (instancetype)init {
    if (self = [super init]) {
        _animationDisable = YES;
        _allSublayers = [NSMutableArray array];
        _containerLayer = [CALayer layer];
        [self addSublayer:_containerLayer];
    }
    return self;
}

- (void)updateWithRendererArray:(NSArray<TQChartTextRenderer *> *)rendererArray {
    [self remoTextLayerWithNeeded:rendererArray.count];
    [rendererArray enumerateObjectsUsingBlock:^(TQChartTextRenderer * _Nonnull ren, NSUInteger idx, BOOL * _Nonnull stop) {
        CATextLayer *layer = [self textLayerWithIndex:idx];
        [ren updateTextLayer:layer];
    }];
}

- (void)remoTextLayerWithNeeded:(NSInteger)numberOfNeeded {
    [CATransaction begin];
    [CATransaction setDisableActions:self.animationDisable];
    while (self.containerLayer.sublayers.count > numberOfNeeded) {
        [self.containerLayer.sublayers.lastObject removeFromSuperlayer];
        [self.allSublayers removeLastObject];
    }
    [CATransaction commit];
}

- (CATextLayer *)textLayerWithIndex:(NSInteger)index {
    [CATransaction begin];
    [CATransaction setDisableActions:self.animationDisable];
    CATextLayer *layer = nil;
    if (index < self.allSublayers.count) {
        layer = self.allSublayers[index];
        return layer;
    }
    layer = [CATextLayer layer];
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.alignmentMode = kCAAlignmentCenter;
    [self.containerLayer addSublayer:layer];
    [self.allSublayers addObject:layer];
    [CATransaction commit];
    return layer;
}

@end
