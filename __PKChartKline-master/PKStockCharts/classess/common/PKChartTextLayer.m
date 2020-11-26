//
//  PKChartTextLayer.m
//  PKChartKit
//
//  Created by zhanghao on 2017/11/28.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import "PKChartTextLayer.h"

CGPoint const kCGOffsetRatioTopLeft = (CGPoint){0, 0};
CGPoint const kCGOffsetRatioTopRight = (CGPoint){1, 0};
CGPoint const kCGOffsetRatioTopCenter = (CGPoint){0.5, 0};
CGPoint const kCGOffsetRatioBottomLeft = (CGPoint){0, 1};
CGPoint const kCGOffsetRatioBottomRight = (CGPoint){1, 1};
CGPoint const kCGOffsetRatioBottomCenter = (CGPoint){0.5, 1};
CGPoint const kCGOffsetRatioCenterLeft = (CGPoint){0, 0.5};
CGPoint const kCGOffsetRatioCenterRight = (CGPoint){1, 0.5};
CGPoint const kCGOffsetRatioCenter = (CGPoint){0.5, 0.5};

@implementation PKChartTextRenderer

+ (instancetype)defaultRenderer {
    PKChartTextRenderer *renderer = [PKChartTextRenderer new];
    renderer.baseOffset = UIOffsetZero;
    renderer.offsetRatio = kCGOffsetRatioBottomLeft;
    renderer.textEdgePadding = UIOffsetMake(2, 1);
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
    if (!self.text || !layer) return;
    
    layer.backgroundColor = self.backgroundColor.CGColor;
    layer.cornerRadius = self.cornerRadius;
    layer.borderWidth = self.borderWidth;
    layer.borderColor = self.borderColor.CGColor;
    
    CGFloat (^decimalLimit)(CGFloat) = ^(CGFloat a) {return (CGFloat)MIN(1, MAX(0, a));};
    CGPoint position = self.positionCenter;
    CGPoint scale = CGPointMake(decimalLimit(self.offsetRatio.x), decimalLimit(self.offsetRatio.y));
    CGFloat baseOffset = -self.textEdgePadding.vertical;
    NSRange range = NSMakeRange(0, self.text.length);
    
    NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attriText addAttribute:NSFontAttributeName value:self.font range:range];
    [attriText addAttribute:NSForegroundColorAttributeName value:self.color range:range];
    [attriText addAttribute:NSBaselineOffsetAttributeName value:@(baseOffset) range:range];
    layer.string = attriText;
    
    CGSize maxSize = CGSizeMake(MIN(self.maxWidth, CGFLOAT_MAX), MAXFLOAT);
    CGSize size = [attriText boundingRectWithSize:maxSize
                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    size.width += self.textEdgePadding.horizontal;
    size.height += self.textEdgePadding.vertical;
    
    CGPoint origin = CGPointMake(position.x - size.width * scale.x,
                                 position.y - size.height * scale.y);
    origin.x += self.baseOffset.horizontal;
    origin.y += self.baseOffset.vertical;
    
    if (isnan(origin.x) || isnan(origin.y)) return;
    layer.frame = (CGRect){.origin = origin, .size = size};
}

@end

@interface PKChartTextLayer ()

@property (nonatomic, strong) CALayer *containerLayer;
@property (nonatomic, strong) NSMutableArray<CATextLayer *> *allSublayers;

@end

@implementation PKChartTextLayer

- (instancetype)init {
    if (self = [super init]) {
        _allSublayers = [NSMutableArray array];
        _containerLayer = [CALayer layer];
        [self addSublayer:_containerLayer];
    }
    return self;
}

- (void)setRenders:(NSArray<PKChartTextRenderer *> *)renders {
    _renders = renders;
    if (!renders || !renders.count) {
        return [self clearTextLayerOfNeeded:0];
    }
    [self layoutIfNeeded];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self clearTextLayerOfNeeded:renders.count];
    [renders enumerateObjectsUsingBlock:^(PKChartTextRenderer * _Nonnull ren, NSUInteger idx, BOOL * _Nonnull stop) {
        CATextLayer *layer = [self textLayerWithIndex:idx];
        [ren updateTextLayer:layer];
    }];
    [CATransaction commit];
}

- (void)clearTextLayerOfNeeded:(NSInteger)numberOfNeeded {
    while (self.containerLayer.sublayers.count > numberOfNeeded) {
        [self.containerLayer.sublayers.lastObject removeFromSuperlayer];
        [self.allSublayers removeLastObject];
    }
}

- (CATextLayer *)textLayerWithIndex:(NSInteger)index {
    CATextLayer *layer = nil;
    if (index < self.allSublayers.count) {
        layer = self.allSublayers[index];
        return layer;
    }
    layer = [CATextLayer layer];
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.alignmentMode = kCAAlignmentCenter;
    // set 'contents' key for in order to prevent the crossfade on updated drawing.
    NSDictionary *actions = [NSDictionary dictionaryWithObjectsAndKeys:[NSNull null], @"contents", nil];
    // https://stackoverflow.com/questions/2244147/disabling-implicit-animations-in-calayer-setneedsdisplayinrect
    layer.actions = actions;
    [self.containerLayer addSublayer:layer];
    [self.allSublayers addObject:layer];
    return layer;
}

@end
