//
//  PKTimeChart.m
//  PKChartKit
//
//  Created by zhanghao on 2017/11/27.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import "PKTimeChart.h"
#import "PKChartFlashingView.h"
#import "PKChartGradientLayer.h"
#import "PKChartCrosshairView.h"
#import "PKChartTextLayer.h"
#import "PKChartCategories.h"
#import "PKTimeChart+Frame.h"

@interface PKTimeChart () <UIGestureRecognizerDelegate, PKChartCrosshairViewDelegate>

/** 横向网格线(主图区域) */
@property (nonatomic, strong) CAShapeLayer *majorGridLayer;
/** 横向网格线(副图区域) */
@property (nonatomic, strong) CAShapeLayer *minorGridLayer;
/** 横向参考线(主图区域) */
@property (nonatomic, strong) CAShapeLayer *majorDashGridLayer;
/** 网格两端边框线 */
@property (nonatomic, strong) CAShapeLayer *borderLineGridLayer;
/** 时间标记线 */
@property (nonatomic, strong) CAShapeLayer *dateLineGridLayer;
/** 分时走势线 */
@property (nonatomic, strong) CAShapeLayer *trendLineLayer;
/** 走势线填充 */
@property (nonatomic, strong) PKChartGradientLayer *trendFillLayer;
/** 走势均线 */
@property (nonatomic, strong) CAShapeLayer *avgTrendLineLayer;
/** 成交量条形图涨 */
@property (nonatomic, strong) CAShapeLayer *VOLRiseLayer;
/** 成交量条形图跌 */
@property (nonatomic, strong) CAShapeLayer *VOLFallLayer;
/** 成交量条形图平 */
@property (nonatomic, strong) CAShapeLayer *VOLFlatLayer;
/** 横轴文本(主图区域) */
@property (nonatomic, strong) PKChartTextLayer *majorTextLayer;
/** 横轴文本(副图区域) */
@property (nonatomic, strong) PKChartTextLayer *minorTextLayer;
/** 时间线文本 */
@property (nonatomic, strong) PKChartTextLayer *dateLineTextLayer;
/** 走势闪动点 */
@property (nonatomic, strong) PKChartFlashingView *flashingView;
/** 十字线查价图 */
@property (nonatomic, strong) PKChartCrosshairView *crosshairView;
/** 主图说明文本 */
@property (nonatomic, strong) UILabel *majorLegendLabel;
/** 副图说明文本 */
@property (nonatomic, strong) UILabel *minorLegendLabel;
/** 叠加layer集合 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, PKTimePileBaseLayer *> *pileLayers;

@end

@implementation PKTimeChart {
    // 避免长按时重复计算极值
    CGPeakValue _lazyPricePeakValue;
    CGPeakValue _lazyChangeRatePeakValue;
    CGPeakValue _lazyVolumePeakValue;
}

- (void)_defaultInitialization {
    _set = [PKTimeChartSet defaultSet];
}

#pragma mark - Initial sublayers

- (void)_sublayerInitialization {
    _majorGridLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_majorGridLayer];
    
    _majorDashGridLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_majorDashGridLayer];
    
    _minorGridLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_minorGridLayer];
    
    _dateLineGridLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_dateLineGridLayer];
    
    _borderLineGridLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_borderLineGridLayer];
    
    _trendLineLayer = [CAShapeLayer layer];
    _trendLineLayer.lineJoin = kCALineJoinRound;
    _trendLineLayer.lineCap = kCALineCapRound;
    [self.contentChartLayer addSublayer:_trendLineLayer];
    
    _trendFillLayer = [PKChartGradientLayer layer];
    [self.contentChartLayer insertSublayer:_trendFillLayer atIndex:0];
    
    _avgTrendLineLayer = [CAShapeLayer layer];
    _avgTrendLineLayer.lineJoin = kCALineJoinRound;
    _avgTrendLineLayer.lineCap = kCALineCapRound;
    [self.contentChartLayer addSublayer:_avgTrendLineLayer];
    
    _VOLRiseLayer = [CAShapeLayer layer];
    _VOLRiseLayer.lineWidth = 0;
    [self.contentChartLayer addSublayer:_VOLRiseLayer];
    
    _VOLFallLayer = [CAShapeLayer layer];
    _VOLFallLayer.lineWidth = 0;
    [self.contentChartLayer addSublayer:_VOLFallLayer];
    
    _VOLFlatLayer = [CAShapeLayer layer];
    _VOLFlatLayer.lineWidth = 0;
    [self.contentChartLayer addSublayer:_VOLFlatLayer];
    
    _majorTextLayer = [PKChartTextLayer layer];
    [self.contentTextLayer addSublayer:_majorTextLayer];
    
    _minorTextLayer = [PKChartTextLayer layer];
    [self.contentTextLayer addSublayer:_minorTextLayer];
    
    _dateLineTextLayer = [PKChartTextLayer layer];
    [self.contentTextLayer addSublayer:_dateLineTextLayer];
    
    _majorLegendLabel = [UILabel new];
    _majorLegendLabel.font = [UIFont systemFontOfSize:10];
    [self.containerView addSubview:_majorLegendLabel];
    
    _minorLegendLabel = [UILabel new];
    _minorLegendLabel.font = [UIFont systemFontOfSize:10];
    [self.containerView addSubview:_minorLegendLabel];
    
    _crosshairView = [[PKChartCrosshairView alloc] init];
    _crosshairView.delegate = self;
    [self.containerView addSubview:_crosshairView];
}

- (PKChartFlashingView *)flashingView {
    if (!_flashingView || !_flashingView.superview) {
        _flashingView = [[PKChartFlashingView alloc] init];
        _flashingView.standpointColor = self.set.timeLineColor;
        [self.containerView addSubview:_flashingView];
    }
    return _flashingView;
}

#pragma mark - Update sublayers

- (void)sublayerStyleUpdates {
    _majorGridLayer.fillColor = [UIColor clearColor].CGColor;
    _majorGridLayer.strokeColor = self.set.gridLineColor.CGColor;
    _majorGridLayer.lineWidth = self.set.gridLineWidth;
    
    _minorGridLayer.fillColor = _majorGridLayer.fillColor;
    _minorGridLayer.strokeColor = _majorGridLayer.strokeColor;
    _minorGridLayer.lineWidth = _majorGridLayer.lineWidth;
    
    _majorDashGridLayer.fillColor = [UIColor clearColor].CGColor;
    _majorDashGridLayer.strokeColor = self.set.dashLineColor.CGColor;
    _majorDashGridLayer.lineWidth = self.set.dashLineWidth;
    _majorDashGridLayer.lineDashPattern = self.set.dashLinePattern;
    
    _dateLineGridLayer.fillColor = _majorGridLayer.fillColor;
    _dateLineGridLayer.strokeColor = _majorGridLayer.strokeColor;
    _dateLineGridLayer.lineWidth = _majorGridLayer.lineWidth;
    
    _borderLineGridLayer.fillColor = _majorGridLayer.fillColor;
    _borderLineGridLayer.strokeColor = _majorGridLayer.strokeColor;
    _borderLineGridLayer.lineWidth = _majorGridLayer.lineWidth;
    
    _trendLineLayer.fillColor = [UIColor clearColor].CGColor;
    _trendLineLayer.strokeColor = self.set.timeLineColor.CGColor;
    _trendLineLayer.lineWidth = self.set.timeLineWidth;
    _trendFillLayer.gradientClolors = self.set.timeLineFillGradientClolors;
    
    _avgTrendLineLayer.fillColor = [UIColor clearColor].CGColor;
    _avgTrendLineLayer.strokeColor = self.set.avgTimeLineColor.CGColor;
    _avgTrendLineLayer.lineWidth = self.set.avgTimeLineWidth;
    
    _VOLRiseLayer.fillColor = self.set.riseColor.CGColor;
    _VOLFallLayer.fillColor = self.set.fallColor.CGColor;
    _VOLFlatLayer.fillColor = self.set.flatColor.CGColor;
    
    _crosshairView.textFont = self.set.plainTextFont;
    _crosshairView.textColor = self.set.crossLineTextColor;
    _crosshairView.lineWidth = self.set.crossLineWidth;
    _crosshairView.lineColor = self.set.crossLineColor;
    _crosshairView.dotColor = self.set.crossLineDotColor;
    _crosshairView.dotRadius = self.set.crossLineDotRadius;
}

- (void)sublayerLayoutUpdates {
    [self layoutIfNeeded];
    
    CGFloat topGap = 0, lowGap = 0, midGap = 0;
    if (self.set.datePosition == PKChartDatePositionTop) { topGap = self.set.dateSeparatedGap; }
    else if (self.set.datePosition == PKChartDatePositionBottom) { lowGap = self.set.dateSeparatedGap; }
    else { midGap = self.set.dateSeparatedGap; }
    UIEdgeInsets insets = UIEdgeInsetsMake(self.set.majorLegendGap + topGap, 0, lowGap, 0);
    _contentChartFrame = CGRectIntegral(UIEdgeInsetsInsetRect(self.bounds, insets));
    
    CGPoint _origin = _contentChartFrame.origin;
    CGSize _size = _contentChartFrame.size;
    
    CGFloat _majorHeight = self.bounds.size.height * self.set.majorChartRatio;
    _majorChartFrame = (CGRect){.origin = _origin, .size = {_size.width, MIN(_majorHeight, _size.height)}};
    
    CGRect _separFrame = _contentChartFrame;
    _separFrame.origin.y = CGRectGetMaxY(_majorChartFrame);
    _separFrame.size.height = midGap;
    _separatedFrame = _separFrame;
    
    CGRect _majorLegendFrame = _contentChartFrame;
    _majorLegendFrame.origin.y = topGap;
    _majorLegendFrame.size.height = self.set.majorLegendGap;
    
    CGRect _minorLegendFrame = _contentChartFrame;
    _minorLegendFrame.origin.y = CGRectGetMaxY(_separatedFrame);
    _minorLegendFrame.size.height = self.set.minorLegendGap;
    
    CGRect _minorFrame = _contentChartFrame;
    _minorFrame.origin.y = CGRectGetMaxY(_minorLegendFrame);
    _minorFrame.size.height = CGRectGetMaxY(_contentChartFrame) - _minorFrame.origin.y;
    _minorChartFrame = _minorFrame;

    _majorLegendLabel.frame = _majorLegendFrame;
    _minorLegendLabel.frame = _minorLegendFrame;

    _trendFillLayer.frame = (CGRect){.size.width = _size.width, .size.height = CGRectGetMaxY(_majorChartFrame)};
    
    _crosshairView.frame = _contentChartFrame;
    _crosshairView.ignoreZone = CGRectMake(_origin.x, _majorChartFrame.size.height, _majorChartFrame.size.width, self.set.minorLegendGap + midGap);
    
    CGFloat allGap = (self.set.maxDataCount - 1) * self.set.shapeGap;
    CGFloat shapeWidth = (_majorChartFrame.size.width - allGap) / (CGFloat)self.set.maxDataCount;
    [self.set setValue:@(shapeWidth) forKey:NSStringFromSelector(@selector(shapeWidth))];
}

#pragma mark - Draw charts

- (void)drawChart {
    if (self.dataList.count) {
        id obj = self.dataList.firstObject;
        NSParameterAssert([obj conformsToProtocol:@protocol(PKTimeChartProtocol)]);
        NSParameterAssert([obj respondsToSelector:@selector(pk_latestPrice)]);
        NSParameterAssert([obj respondsToSelector:@selector(pk_averagePrice)]);
        NSParameterAssert([obj respondsToSelector:@selector(pk_volume)]);
        NSParameterAssert([obj respondsToSelector:@selector(pk_dateTime)]);
    }
    
    disable_animations(^{
        [self sublayerLayoutUpdates];
        [self sublayerStyleUpdates];
        [self _updateChart];
    });
}

- (void)_updateChart {
    [self drawPileChart];
    [self drawLegendText];
    [self drawGridBorderLines];
    [self drawMinorGridLines:_lazyVolumePeakValue];
    [self drawMinorChart:_lazyVolumePeakValue];
    [self drawMajorGridLines:_lazyPricePeakValue changeRatePeakValue:_lazyChangeRatePeakValue];
    if (self.set.chartType == PKTimeChartTypeFiveDays) {
        [self drawFiveMajorChart:_lazyPricePeakValue];
    } else {
        [self drawOneMajorChart:_lazyPricePeakValue];
    }
}

- (void)clearChart {
    disable_animations(^{
        [self clearForSublayers:self.contentChartLayer.sublayers];
        [self clearForSublayers:self.contentTextLayer.sublayers];
        self.majorLegendLabel.attributedText = nil;
        self.minorLegendLabel.attributedText = nil;
        [self.flashingView removeFromSuperview];
        [self.crosshairView dismiss];
    });
}

- (void)clearForSublayers:(NSArray<CALayer *> *)sublayers {
    NSString *pathKey = @"path"; NSString *rendersKey = @"renders";
    for (CALayer *layer in sublayers) {
        if ([layer respondsToSelector:NSSelectorFromString(pathKey)]) [layer setValue:nil forKey:pathKey];
        if ([layer respondsToSelector:NSSelectorFromString(rendersKey)]) [layer setValue:nil forKey:rendersKey];
    }
}

#pragma mark - Pile charts

- (NSMutableDictionary<NSString *,PKTimePileBaseLayer *> *)pileLayers {
    if (!_pileLayers) {
        _pileLayers = [NSMutableDictionary dictionary];
    }
    return _pileLayers;
}

- (void)pileChartLayer:(__kindof PKTimePileBaseLayer *)layer forIdentifier:(NSString *)identifier {
    if (![layer isKindOfClass:[PKTimePileBaseLayer class]] || !identifier) return;
    if (!self.pileLayers[identifier]) {
        self.pileLayers[identifier] = layer;
        [self.contentChartLayer addSublayer:layer];
    }
}

- (void)clearPileChartForIdentifier:(NSString *)identifier {
    if (identifier.length > 0) {
        CALayer *layer = [self.pileLayers objectForKey:identifier];
        [layer removeFromSuperlayer];
        [self.pileLayers removeObjectForKey:identifier];
    }
}

- (void)clearPileChart {
    for (CALayer *layer in self.pileLayers.allValues) {
        [layer removeFromSuperlayer];
    }
    [self.pileLayers removeAllObjects];
}

// 绘制叠加图表
- (void)drawPileChart {
    _lazyVolumePeakValue = [self getVolumePeakValue];
    _lazyPricePeakValue = [self getPricePeakValue];
    _lazyChangeRatePeakValue = [self getChangeRatePeakValue];
    
    PKTimePileBaseLayer<PKTimeChartPileProtocol> *layer;
    NSArray<PKTimePileBaseLayer *> *pileLayers = self.pileLayers.allValues;
    for (layer in pileLayers) { // 计算极值
        if ([layer pileChartRegionType] == PKChartRegionTypeMinor) {
            _lazyVolumePeakValue = [layer pileChartPeakValue:_lazyVolumePeakValue];
        } else {
            _lazyPricePeakValue = [layer pileChartPeakValue:_lazyPricePeakValue];
        }
    }
    
    for (layer in pileLayers) { // 叠加图表
        if ([layer pileChartRegionType] == PKChartRegionTypeMinor) {
            CGChartScaler scaler = CGChartScalerMake(self.set.shapeWidth, self.set.shapeGap, self.minorChartFrame);
            [layer setValueForScaler:scaler];
            CGMakeYaxisBlock axisYCallback = CGMakeYaxisBlockCreator(_lazyVolumePeakValue, self.minorChartFrame);
            [layer setValueForAxisYCallback:axisYCallback];
        } else {
            CGChartScaler scaler = CGChartScalerMake(self.set.shapeWidth, self.set.shapeGap, self.majorChartFrame);
            [layer setValueForScaler:scaler];
            CGMakeYaxisBlock axisYCallback = CGMakeYaxisBlockCreator(_lazyPricePeakValue, self.majorChartFrame);
            [layer setValueForAxisYCallback:axisYCallback];
        }
        CGMakeXaxisBlock axisXCallback = CGMakeXaxisBlockCreator(self.set.shapeWidth, self.set.shapeGap);
        [layer setValueForAxisXCallback:axisXCallback];
        [layer setValueForDataList:self.dataList];
        [layer pileChart];
    }
}

// 绘制说明文本
- (void)drawLegendText {
    if (_majorLegendLabel.frame.size.height > 0) {
        if ([self.legendSource respondsToSelector:@selector(timeChartMajorAttributedText)]) {
            _majorLegendLabel.attributedText = [self.legendSource timeChartMajorAttributedText];
        } else {
            _majorLegendLabel.attributedText = [self makeMajorLegendTextIndex:self.dataList.pk_lastIndex];
        }
    }
    if (_minorLegendLabel.frame.size.height > 0) {
        if ([self.legendSource respondsToSelector:@selector(timeChartMinorAttributedText)]) {
            _minorLegendLabel.attributedText = [self.legendSource timeChartMinorAttributedText];
        } else {
            _minorLegendLabel.attributedText = [self makeMinorLegendTextIndex:self.dataList.pk_lastIndex];
        }
    }
}

// 绘制网格左右两端边框线
- (void)drawGridBorderLines {
    CGFloat minX = CGRectGetMinX(self.contentChartFrame) + half(self.set.gridLineWidth);
    CGFloat maxX = CGRectGetMaxX(self.contentChartFrame) - half(self.set.gridLineWidth);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path pk_addVerticalLine:CGPointMake(minX, CGRectGetMinY(self.majorChartFrame))
                         len:self.majorChartFrame.size.height];
    [path pk_addVerticalLine:CGPointMake(maxX, CGRectGetMinY(self.majorChartFrame))
                         len:self.majorChartFrame.size.height];
    [path pk_addVerticalLine:CGPointMake(minX, CGRectGetMinY(self.minorChartFrame))
                         len:self.minorChartFrame.size.height];
    [path pk_addVerticalLine:CGPointMake(maxX, CGRectGetMinY(self.minorChartFrame))
                         len:self.minorChartFrame.size.height];
    if (_minorLegendLabel.attributedText.length > 0 && self.set.datePosition == PKChartDatePositionMiddle) {
        UIEdgeInsets inset = UIEdgeInsetsMake(0, half(self.set.gridLineWidth), 0, half(self.set.gridLineWidth));
        [path pk_addRect:UIEdgeInsetsInsetRect(self.minorLegendLabel.frame, inset)];
    }
    _borderLineGridLayer.path = path.CGPath;
}

// 绘制副图横向网格线及坐标文本
- (void)drawMinorGridLines:(CGPeakValue)peakValue {
    NSArray<NSString *> *texts = [NSArray pk_arrayWithParagraphs:self.set.minorNumberOfLines
                                                       peakValue:peakValue
                                                     resultBlock:^NSString * _Nonnull(CGFloat floatValue, NSUInteger index) {
                                                         return [NSNumber pk_trillionStringWithDigits:@(floatValue) keepPlaces:self.set.decimalKeepPlace];
                                                     }];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat gap = self.minorChartFrame.size.height / CGValidDivisor(texts.count - 1);
    [texts pk_enumerateIndexsCeaselessBlock:^(NSUInteger idx) {
        CGPoint start = CGPointMake(self.minorChartFrame.origin.x, self.minorChartFrame.origin.y + gap * idx);
        [path pk_addHorizontalLine:start len:self.minorChartFrame.size.width];
    }];
    
    NSMutableArray<PKChartTextRenderer *> *renders = [NSMutableArray array];
    PKChartTextRenderer *renderer = [PKChartTextRenderer defaultRenderer];
    renderer.text = texts.firstObject;
    renderer.font = self.set.plainTextFont;
    renderer.color = self.set.plainTextColor;
    renderer.positionCenter = self.minorChartFrame.origin;
    renderer.offsetRatio = kCGOffsetRatioTopLeft;
    [renders addObject:renderer];
    
    _minorGridLayer.path = path.CGPath;
    _minorTextLayer.renders = renders;
}

// 绘制副图图表
- (void)drawMinorChart:(CGPeakValue)peakValue {
    CGMakeYaxisBlock originYCallback = CGMakeYaxisBlockCreator(peakValue, self.minorChartFrame);
    __block CGFloat preClosePrice = [self getVaildPreClosePrice];
    
    UIBezierPath *risePath = [UIBezierPath bezierPath];
    UIBezierPath *fallPath = [UIBezierPath bezierPath];
    UIBezierPath *flatPath = [UIBezierPath bezierPath];
    [self.dataList enumerateObjectsUsingBlock:^(id<PKTimeChartProtocol>  _Nonnull obj, NSUInteger idx, BOOL *stop) {
        CGFloat originX = [self getOriginXWithIndex:idx];
        CGFloat pointY = originYCallback(obj.pk_volume);
        CGRect rect = CGRectMake(originX, pointY, self.set.shapeWidth, CGRectGetMaxY(self.minorChartFrame) - pointY);
        CGFloat currentPrice = obj.pk_latestPrice;
        if (currentPrice > preClosePrice) [risePath pk_addRect:rect];
        else if (currentPrice < preClosePrice) [fallPath pk_addRect:rect];
        else [flatPath pk_addRect:rect];
        preClosePrice = currentPrice;
    }];
    
    _VOLRiseLayer.path = risePath.CGPath;
    _VOLFallLayer.path = fallPath.CGPath;
    _VOLFlatLayer.path = flatPath.CGPath;
}

// 绘制主图横向网格线及坐标文本
- (void)drawMajorGridLines:(CGPeakValue)peakValue changeRatePeakValue:(CGPeakValue)ratePeakValue {
    NSArray<NSString *> *leftTexts = [NSArray pk_arrayWithParagraphs:self.set.majorNumberOfLines
                                                           peakValue:peakValue
                                                         resultBlock:^NSString *(CGFloat floatValue, NSUInteger index) {
                                                             return [NSNumber pk_stringWithDigits:@(floatValue) keepPlaces:self.set.decimalKeepPlace];
                                                         }];
    NSArray<NSString *> *rightTexts = [NSArray pk_arrayWithParagraphs:self.set.majorNumberOfLines
                                                            peakValue:ratePeakValue
                                                          resultBlock:^NSString *(CGFloat floatValue, NSUInteger index) {
                                                              return [NSNumber pk_stringWithDigits:@(floatValue) keepPlaces:6];
                                                          }];
    
    CGFloat gap = self.majorChartFrame.size.height / CGValidDivisor(leftTexts.count - 1);
    CGFloat originY = self.majorChartFrame.origin.y + half(self.set.gridLineWidth);
    CGFloat peakDistance = CGPeakValueGetDistance(ratePeakValue);
    CGFloat dashY = originY + ratePeakValue.max / CGValidDivisor(peakDistance)  * self.majorChartFrame.size.height;
    
    UIColor *(^makeRenderColor)(CGFloat) = ^(CGFloat y) {
        if (y < dashY) return self.set.riseColor;
        else if (y > dashY) return self.set.fallColor;
        else return self.set.plainTextColor;
    };
    
    UIBezierPath *dash = [UIBezierPath bezierPath];
    [dash pk_addHorizontalLine:CGPointMake(self.majorChartFrame.origin.x, dashY) len:self.majorChartFrame.size.width];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    __block NSMutableArray<PKChartTextRenderer *> *renders = [NSMutableArray array];
    [leftTexts enumerateObjectsUsingBlock:^(NSString * _Nonnull text, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint start = CGPointMake(self.majorChartFrame.origin.x, originY + gap * idx);
        [path pk_addHorizontalLine:start len:self.majorChartFrame.size.width];
        
        PKChartTextRenderer *leftRen = [PKChartTextRenderer defaultRenderer];
        leftRen.text = text;
        leftRen.font = self.set.plainTextFont;
        leftRen.color = makeRenderColor(start.y);
        leftRen.positionCenter = start;
        leftRen.offsetRatio = (CGPoint){.x = 0, .y = (!idx ? 0 : 1)};
        [renders addObject:leftRen];
        
        PKChartTextRenderer *rightRen = [PKChartTextRenderer defaultRenderer];
        rightRen.text = [NSNumber pk_percentStringWithDoubleDigits:@(rightTexts[idx].doubleValue)];
        rightRen.font = self.set.plainTextFont;
        rightRen.color = makeRenderColor(start.y);
        rightRen.positionCenter = (CGPoint){.x = start.x + self.majorChartFrame.size.width, .y = start.y};
        rightRen.offsetRatio = (CGPoint){.x = 1, .y = (!idx ? 0 : 1)};
        [renders addObject:rightRen];
    }];
    
    _majorDashGridLayer.path = dash.CGPath;
    _majorGridLayer.path = path.CGPath;
    _majorTextLayer.renders = renders;
}

#pragma mark - One day chart

// 绘制主图图表 (一日分时图)
- (void)drawOneMajorChart:(CGPeakValue)peakValue {
    [self drawOneTimelines];
    
    CGMakeYaxisBlock originYCallback = CGMakeYaxisBlockCreator(peakValue, self.majorChartFrame);
    id<PKTimeChartProtocol>firstObj = self.dataList.firstObject;
    CGFloat preClosePrice = [self getVaildPreClosePrice];
    CGFloat startPointY = originYCallback(CGPeakLimit(peakValue, preClosePrice)) ;
    CGFloat avgStartPointY = originYCallback(CGPeakLimit(peakValue, firstObj.pk_averagePrice));
    
    CAShapeLayer *rgbbarLayer = [CAShapeLayer layer];
    rgbbarLayer.fillColor = [UIColor redColor].CGColor;
    rgbbarLayer.strokeColor = [UIColor clearColor].CGColor;
    rgbbarLayer.lineWidth = 0;
    [self.contentChartLayer insertSublayer:rgbbarLayer atIndex:0];
    CGFloat originY = self.majorChartFrame.origin.y + half(self.set.gridLineWidth);
    CGFloat dashY = originY + self.majorChartFrame.size.height * 0.5;
    
    CGFloat maxxx = [self getLeadVolumePeakValue].max;
    
    UIBezierPath *rgbarPath = [UIBezierPath bezierPath];
    UIBezierPath *timePath = [UIBezierPath bezierPath];
    UIBezierPath *avgPath = [UIBezierPath bezierPath];
    [timePath moveToPoint:CGPointMake(self.majorChartFrame.origin.x, startPointY)];
    [avgPath moveToPoint:CGPointMake(self.majorChartFrame.origin.x, avgStartPointY)];
    [self.dataList pk_enumerateObjsCeaselessBlock:^(id<PKTimeChartProtocol>  _Nonnull obj, NSUInteger idx) {
        CGFloat centerX = [self getCenterXWithIndex:idx];
        CGFloat latestValue = CGPeakLimit(peakValue, obj.pk_latestPrice);
        CGFloat avgValue = CGPeakLimit(peakValue, obj.pk_averagePrice);
        CGFloat originY = originYCallback(latestValue);
        CGFloat avgOriginY = originYCallback(avgValue);
        [timePath addLineToPoint:CGPointMake(centerX, originY)];
        [avgPath addLineToPoint:CGPointMake(centerX, avgOriginY)];
        
        // 不超过主图表高度的1/6
        CGFloat height = self.majorChartFrame.size.height / 6 * (obj.pk_leadRGBarVolume / maxxx);
        CGFloat originX = [self getOriginXWithIndex:idx];
        CGRect rect = CGRectMake(originX, dashY, self.set.shapeWidth, height);
        if (obj.pk_isLeadRGBarUpward) {
            rect = CGRectMake(originX, dashY, self.set.shapeWidth, -height);
        }
        [rgbarPath pk_addRect:rect];
    }];
    
    rgbbarLayer.path = rgbarPath.CGPath;
    _trendLineLayer.path = timePath.CGPath;
    _avgTrendLineLayer.path = avgPath.CGPath;

    CGFloat endCenterX = [self getCenterXWithIndex:self.dataList.count - 1];
    UIBezierPath *fillPath = [UIBezierPath bezierPathWithCGPath:timePath.CGPath];
    [fillPath addLineToPoint:CGPointMake(endCenterX, CGRectGetMaxY(self.majorChartFrame))];
    [fillPath addLineToPoint:CGPointMake(self.majorChartFrame.origin.x, CGRectGetMaxY(self.majorChartFrame))];
    [fillPath closePath];
    _trendFillLayer.path = fillPath.CGPath;

    [self _updateFlashingView:originYCallback];
}

// 绘制日期线 (一日分时图)
- (void)drawOneTimelines {
    if (!self.set.timelineDisplayTexts.count) return;
    
    if (self.set.timelineAllMinutes && self.set.timelineDisplayMinutes) {
        return [self drawCustomOneTimelines];
    }
        
    CGFloat positionCenterY; CGFloat baseOffsetVertical;
    [self makeDateRenderer:&positionCenterY baseOffsetVertical:&baseOffsetVertical];
    
    NSMutableArray<PKChartTextRenderer *> *renders = [NSMutableArray array];
    void (^makeRenderer)(NSString *, CGPoint, CGFloat) = ^(NSString *text, CGPoint ratio, CGFloat centerX) {
        PKChartTextRenderer *render = [PKChartTextRenderer defaultRenderer];
        render.text = text;
        render.font = self.set.plainTextFont;
        render.color = self.set.plainTextColor;
        render.baseOffset = UIOffsetMake(0, baseOffsetVertical);
        render.offsetRatio = ratio;
        render.positionCenter = CGPointMake(centerX, positionCenterY);
        [renders addObject:render];
    };
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (self.set.timelineDisplayTexts.count > 1) {
        NSRange range = NSMakeRange(1, self.set.timelineDisplayTexts.count - 2);
        NSInteger section = self.set.maxDataCount / MAX(1, self.set.timelineDisplayTexts.count - 1);
        
        makeRenderer(self.set.timelineDisplayTexts.firstObject, kCGOffsetRatioCenterLeft, CGRectGetMinX(self.contentChartFrame));
        [self.set.timelineDisplayTexts pk_enumerateObjsAtRange:range ceaselessBlock:^(NSString * _Nonnull text, NSUInteger idx) {
            CGFloat centerX = [self getCenterXWithIndex:(idx * section)];
            [path pk_addVerticalLine:CGPointMake(centerX, CGRectGetMinY(self.majorChartFrame)) len:self.majorChartFrame.size.height];
            [path pk_addVerticalLine:CGPointMake(centerX, CGRectGetMinY(self.minorChartFrame)) len:self.minorChartFrame.size.height];
            makeRenderer(text, kCGOffsetRatioCenter, centerX);
        }];
        makeRenderer(self.set.timelineDisplayTexts.lastObject, kCGOffsetRatioCenterRight, CGRectGetMaxX(self.contentChartFrame));
    } else {
        CGFloat centerX = CGRectGetMidX(self.contentChartFrame);
        [path pk_addVerticalLine:CGPointMake(centerX, CGRectGetMinY(self.majorChartFrame)) len:self.majorChartFrame.size.height];
        [path pk_addVerticalLine:CGPointMake(centerX, CGRectGetMinY(self.minorChartFrame)) len:self.minorChartFrame.size.height];
        makeRenderer(self.set.timelineDisplayTexts.firstObject, kCGOffsetRatioCenter, CGRectGetMidX(self.contentChartFrame));
    }
    
    _dateLineGridLayer.path = path.CGPath;
    _dateLineTextLayer.renders = renders;
}

// 绘制自定义日期线 (一日分时图)
- (void)drawCustomOneTimelines {
    NSParameterAssert(self.set.timelineDisplayTexts.count == self.set.timelineDisplayMinutes.count);
    
    NSMutableIndexSet *indexSets = [NSMutableIndexSet indexSet];
    for (NSNumber *value in self.set.timelineDisplayMinutes) {
        NSInteger index = [self.set.timelineAllMinutes indexOfObject:value];
        [indexSets addIndex:index];
    }
    
    CGFloat positionCenterY; CGFloat baseOffsetVertical;
    [self makeDateRenderer:&positionCenterY baseOffsetVertical:&baseOffsetVertical];
    
    __block CGFloat previousLeftX = 0;
    __block NSInteger index = indexSets.count - 1;
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSMutableArray<PKChartTextRenderer *> *renders = [NSMutableArray array];
    [indexSets enumerateIndexesWithOptions:NSEnumerationReverse usingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat centerX = [self getCenterXWithIndex:idx];
        [path pk_addVerticalLine:CGPointMake(centerX, CGRectGetMinY(self.majorChartFrame)) len:self.majorChartFrame.size.height];
        [path pk_addVerticalLine:CGPointMake(centerX, CGRectGetMinY(self.minorChartFrame)) len:self.minorChartFrame.size.height];
        
        id value = self.set.timelineDisplayTexts[index];
        if ([value isKindOfClass:[NSString class]]) {
            CGFloat textWidth = [value sizeWithAttributes:@{NSFontAttributeName:self.set.plainTextFont}].width;
            CGFloat rightX = centerX + half(textWidth);
            CGFloat leftX = centerX - half(textWidth);
            
            CGPoint ratio = kCGOffsetRatioCenter;
            if (rightX >= previousLeftX) {
                ratio = kCGOffsetRatioCenterRight;
            }
            
            if (leftX < CGRectGetMinX(self.contentChartFrame)) {
                ratio = kCGOffsetRatioCenterLeft;
            }
            
            previousLeftX = centerX - half(textWidth);
            if (rightX > CGRectGetMaxX(self.contentChartFrame)) {
                ratio = kCGOffsetRatioCenterRight;
                previousLeftX = centerX - textWidth;
            }
            
            PKChartTextRenderer *render = [PKChartTextRenderer defaultRenderer];
            render.text = value;
            render.font = self.set.plainTextFont;
            render.color = self.set.plainTextColor;
            render.baseOffset = UIOffsetMake(0, baseOffsetVertical);
            render.offsetRatio = ratio;
            render.positionCenter = CGPointMake(centerX, positionCenterY);
            [renders addObject:render];
        }
        index--;
    }];
    
    _dateLineGridLayer.path = path.CGPath;
    _dateLineTextLayer.renders = renders;
}

#pragma mark - Five day chart

// 绘制主图图表 (五日分时图)
- (void)drawFiveMajorChart:(CGPeakValue)peakValue {
    NSMutableIndexSet *allTimelineIndexSets = [NSMutableIndexSet indexSet]; // 存储所有时间线的索引集
    __block NSInteger tagged = 0;
    [self.dataList pk_enumerateObjsCeaselessBlock:^(id<PKTimeChartProtocol>  _Nonnull obj, NSUInteger idx) {
        NSInteger day = obj.pk_dateTime.pk_day;
        if (day && tagged != day) { tagged = day;
            [allTimelineIndexSets addIndex:idx];
        }
    }];
    
    [self drawFiveTimelinesWithIndexSet:allTimelineIndexSets];
    
    CGMakeYaxisBlock originYCallback = CGMakeYaxisBlockCreator(peakValue, self.majorChartFrame);
    CGFloat halfLineWidth = half(self.set.timeLineWidth);
    
    id<PKTimeChartProtocol>firstObj = self.dataList.firstObject;
    CGFloat preClosePrice = [self getVaildPreClosePrice];
    CGFloat startPointY = originYCallback(CGPeakLimit(peakValue, preClosePrice)) + halfLineWidth;
    CGFloat avgStartPointY = originYCallback(CGPeakLimit(peakValue, firstObj.pk_averagePrice)) + halfLineWidth;
    
    UIBezierPath *fillPath = [UIBezierPath bezierPath];
    UIBezierPath *timePath = [UIBezierPath bezierPath];
    UIBezierPath *avgPath = [UIBezierPath bezierPath];
    [timePath moveToPoint:CGPointMake(self.majorChartFrame.origin.x, startPointY)];
    [fillPath moveToPoint:CGPointMake(self.majorChartFrame.origin.x, startPointY)];
    [avgPath moveToPoint:CGPointMake(self.majorChartFrame.origin.x, avgStartPointY)];
    
    [self.dataList enumerateObjectsUsingBlock:^(id<PKTimeChartProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat centerX = [self getCenterXWithIndex:idx];
        CGFloat latestValue = CGPeakLimit(peakValue, obj.pk_latestPrice);
        CGFloat avgValue = CGPeakLimit(peakValue, obj.pk_averagePrice);
        CGFloat pointY = originYCallback(latestValue) + halfLineWidth;
        CGFloat avgPointY = originYCallback(avgValue) + halfLineWidth;
        if ([allTimelineIndexSets containsIndex:idx]) {
            [timePath moveToPoint:CGPointMake(centerX, pointY)];
            [avgPath moveToPoint:CGPointMake(centerX, avgPointY)];
        } else {
            [timePath addLineToPoint:CGPointMake(centerX, pointY)];
            [avgPath addLineToPoint:CGPointMake(centerX, avgPointY)];
        }
        [fillPath addLineToPoint:CGPointMake(centerX, pointY)];
    }];
    
    _trendLineLayer.path = timePath.CGPath;
    _avgTrendLineLayer.path = avgPath.CGPath;
    
    CGFloat endCenterX = [self getCenterXWithIndex:self.dataList.pk_lastIndex];
    [fillPath addLineToPoint:CGPointMake(endCenterX, CGRectGetMaxY(self.majorChartFrame))];
    [fillPath addLineToPoint:CGPointMake(self.majorChartFrame.origin.x, CGRectGetMaxY(self.majorChartFrame))];
    [fillPath closePath];
    _trendFillLayer.path = fillPath.CGPath;

    [self _updateFlashingView:originYCallback];
}

// 绘制日期线 (五日分时图)
- (void)drawFiveTimelinesWithIndexSet:(NSIndexSet *)allTimelineIndexSets {
    if (!self.dataList.count || !allTimelineIndexSets.count) return;
    CGFloat positionCenterY; CGFloat baseOffsetVertical;
    [self makeDateRenderer:&positionCenterY baseOffsetVertical:&baseOffsetVertical];
    
    CGFloat gap = self.majorChartFrame.size.width / (CGFloat)(allTimelineIndexSets.count);

    UIBezierPath *path = [UIBezierPath bezierPath];
    __block CGFloat originX = self.contentChartFrame.origin.x;
    __block NSMutableArray<PKChartTextRenderer *> *renders = [NSMutableArray array];
    
    [allTimelineIndexSets enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat centerX = originX + half(gap);
        originX += gap;
        [path pk_addVerticalLine:CGPointMake(originX, CGRectGetMinY(self.majorChartFrame)) len:self.majorChartFrame.size.height];
        [path pk_addVerticalLine:CGPointMake(originX, CGRectGetMinY(self.minorChartFrame)) len:self.minorChartFrame.size.height];
        
        PKChartTextRenderer *render = [PKChartTextRenderer defaultRenderer];
        render.text = [NSDate pk_stringFromDate:self.dataList[idx].pk_dateTime formatter:self.set.dateFormatter];
        render.font = self.set.plainTextFont;
        render.color = self.set.plainTextColor;
        render.baseOffset = UIOffsetMake(0, baseOffsetVertical);
        render.positionCenter = CGPointMake(centerX, positionCenterY);
        render.offsetRatio = kCGOffsetRatioCenter;
        [renders addObject:render];
    }];
    
    _dateLineGridLayer.path = path.CGPath;
    _dateLineTextLayer.renders = renders;
}

// 绘制闪动点
- (void)_updateFlashingView:(CGMakeYaxisBlock)originYCallback {
    BOOL hidden = !self.set.showFlashing || !self.dataList.count;
    if (!hidden) {
        hidden = (self.dataList.count == self.set.maxDataCount);
        if (self.set.flashingClosedMinutes.count > 0) {
            NSInteger minutes = [NSDate pk_minutesFromDate:self.dataList.lastObject.pk_dateTime];
            hidden = [self.set.flashingClosedMinutes containsObject:@(minutes)];
        }
    }
    
    if (hidden) {
        [self.flashingView stopAnimating];
        [self.flashingView removeFromSuperview];
    } else {
        id<PKTimeChartProtocol>lastObj = self.dataList.lastObject;
        CGFloat endCenterX = [self getCenterXWithIndex:self.dataList.pk_lastIndex];
        CGFloat halfWidth = half(self.set.timeLineWidth);
        CGFloat endOriginY = self.majorChartFrame.origin.y + half(self.majorChartFrame.size.height);
        endOriginY = originYCallback(lastObj.pk_latestPrice) + halfWidth;
        self.flashingView.center = CGPointMake(endCenterX, endOriginY);
        [self.flashingView startAnimating];
    }
}

#pragma mark - Gestures management

- (void)_gestureInitialization {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.delegate = self;
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.delegate = self;
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.delegate = self;
    [self addGestureRecognizer:longPress];
}

- (void)singleTap:(UITapGestureRecognizer *)g {
    CGPoint p = [g locationInView:g.view];
    BOOL isMajorRange = CGRectContainsPoint(self.majorChartFrame, p);
    if ([self.delegate respondsToSelector:@selector(timeChart:didSingleTapAtRegionType:)]) {
        [self.delegate timeChart:self didSingleTapAtRegionType:isMajorRange];
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)g {
    CGPoint p = [g locationInView:g.view];
    BOOL isMajorRange = CGRectContainsPoint(self.majorChartFrame, p);
    if ([self.delegate respondsToSelector:@selector(timeChart:didDoubleTapAtRegionType:)]) {
        [self.delegate timeChart:self didDoubleTapAtRegionType:isMajorRange];
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)g {
    if (!self.dataList.count) return;
    switch (g.state) {
        case UIGestureRecognizerStateBegan: {
            if ([self.delegate respondsToSelector:@selector(timeChartWillLongPress:)]) {
                [self.delegate timeChartWillLongPress:self];
            }
            [self.crosshairView present];
            CGPoint p = [g locationInView:self];
            [self crosslineLocationUpdated:p];
        } break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            [self.crosshairView dismissDelay:self.set.crossLineHiddenDuration];
            if ([self.delegate respondsToSelector:@selector(timeChartEndLongPress:)]) {
                [self.delegate timeChartEndLongPress:self];
            }
        } break;
        case UIGestureRecognizerStateChanged: {
            CGPoint p = [g locationInView:self];
            [self crosslineLocationUpdated:p];
        } break;
        default: break;
    }
}

- (void)crosslineLocationUpdated:(CGPoint)location {
    CGPoint p = CGPointMake(location.x - self.contentChartFrame.origin.x,
                            location.y - self.contentChartFrame.origin.y);
    NSInteger index = CGMakeXindexBlock(self.set.shapeWidth, self.set.shapeGap, self.dataList.count, p.x);
    if ([self.delegate respondsToSelector:@selector(timeChart:didLongPressAtCorrespondIndex:)]) {
        [self.delegate timeChart:self didLongPressAtCorrespondIndex:index];
    }
    
    if (!self.set.showCrossLineOnLongPress) return;
    
    id<PKTimeChartProtocol>obj = self.dataList[index];
    NSString *dateFormatter = self.set.crossDateFormatter;
    _crosshairView.verticalBottomText = [NSDate pk_stringFromDate:obj.pk_dateTime formatter:dateFormatter];
    
    CGFloat centerX = [self getCenterXWithIndex:index];
    if (self.set.crossLineConstrained) {
        CGMakeYaxisBlock originYCallback = CGMakeYaxisBlockCreator(_lazyPricePeakValue, self.majorChartFrame);
        CGFloat centerY = originYCallback(obj.pk_latestPrice) - self.contentChartFrame.origin.y;
        CGFloat subValue = CGMakeYnumberBlock(_lazyChangeRatePeakValue, self.majorChartFrame, centerY);
        _crosshairView.horizontalLeftText = [NSNumber pk_stringWithDigits:@(obj.pk_latestPrice) keepPlaces:self.set.decimalKeepPlace];
        _crosshairView.horizontalRightText = [NSNumber pk_stringWithDigits:@(subValue) keepPlaces:self.set.decimalKeepPlace];
        [_crosshairView updateContentsInCenter:CGPointMake(centerX, centerY) touched:p];
    } else {
        if (CGRectContainsPoint(self.majorChartFrame, location)) {
            CGFloat value = CGMakeYnumberBlock(_lazyPricePeakValue, self.majorChartFrame, location.y);
            CGFloat subValue = CGMakeYnumberBlock(_lazyChangeRatePeakValue, self.majorChartFrame, location.y);
            _crosshairView.horizontalLeftText = [NSNumber pk_stringWithDigits:@(value) keepPlaces:self.set.decimalKeepPlace];
            _crosshairView.horizontalRightText = [NSNumber pk_percentStringWithDoubleDigits:@(subValue)];
        }
        
        if (CGRectContainsPoint(self.minorChartFrame, location)) {
            CGFloat value = CGMakeYnumberBlock(_lazyVolumePeakValue, self.minorChartFrame, location.y);
            _crosshairView.horizontalLeftText =[NSNumber pk_trillionStringWithDigits:@(value) keepPlaces:self.set.decimalKeepPlace];
            _crosshairView.horizontalRightText = nil;
        }
        
        [_crosshairView updateContentsInCenter:CGPointMake(centerX, p.y) touched:p];
    }
    
    if ([self.legendSource respondsToSelector:@selector(timeChart:attributedTextForMajorAtIndex:)]) {
        _majorLegendLabel.attributedText = [self.legendSource timeChart:self attributedTextForMajorAtIndex:index];
    } else {
        _majorLegendLabel.attributedText = [self makeMajorLegendTextIndex:index];
    }
    
    if ([self.legendSource respondsToSelector:@selector(timeChart:attributedTextForMinorAtIndex:)]) {
        _minorLegendLabel.attributedText = [self.legendSource timeChart:self attributedTextForMinorAtIndex:index];
    } else {
        _minorLegendLabel.attributedText = [self makeMinorLegendTextIndex:index];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (self.crosshairView.isPresenting) {
            [self.crosshairView dismiss];
            return NO;
        }
    }
    CGPoint p = [gestureRecognizer locationInView:self];
    return CGRectContainsPoint(self.contentChartFrame, p) && !CGRectContainsPoint(self.separatedFrame, p);
}

#pragma mark - PKChartCrosshairViewDelegate

- (void)crosshairViewDidDismiss:(PKChartCrosshairView *)crosshairView {
    [self drawLegendText];
    if ([self.delegate respondsToSelector:@selector(timeChartCrossLineDidDismiss:)]) {
        [self.delegate timeChartCrossLineDidDismiss:self];
    }
}

#pragma mark - Utilities

- (NSAttributedString *)makeMajorLegendTextIndex:(NSInteger)index {
    id<PKTimeChartProtocol>obj = [self.dataList pk_objAtIndex:index];
    CGFloat preClosePrice = obj.pk_latestPrice;
    if ([self.coordObj respondsToSelector:@selector(pk_referenceValue)]) {
        preClosePrice = self.coordObj.pk_referenceValue;
    }
    
    UIColor *(^legendTextColor)(void) = ^(void) {
        if (obj.pk_latestPrice > preClosePrice) return self.set.riseColor;
        else if (obj.pk_latestPrice < preClosePrice) return self.set.fallColor;
        else return self.set.flatColor;
    };
    
    NSString *prefix = @" 最新 ";
    NSString *priceText =[NSNumber pk_stringWithDoubleDigits:@(obj.pk_latestPrice)];
    CGFloat change = (obj.pk_latestPrice - preClosePrice) / CGValidDivisor(preClosePrice);
    NSString *changeText = [NSNumber pk_stringWithDoubleDigits:@(change)];
    NSString *symbol = @"";
    if (obj.pk_latestPrice > preClosePrice) symbol = @"+";
    else if (obj.pk_latestPrice < preClosePrice) symbol = @"-";
    NSString *part = [NSString stringWithFormat:@"%@  %@%@", priceText, symbol, changeText];
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    NSMutableAttributedString *prefixText = [NSMutableAttributedString pk_attributedWithString:prefix];
    [prefixText pk_setForegroundColor:self.set.plainTextColor];
    [text appendAttributedString:prefixText];
    NSMutableAttributedString *partText = [NSMutableAttributedString pk_attributedWithString:part];
    [partText pk_setForegroundColor:legendTextColor()];
    [text appendAttributedString:partText];
    [text pk_setFont:PKCHART_LEGEND_FONTSIZE(10)];
    return text;
}

- (NSAttributedString *)makeMinorLegendTextIndex:(NSInteger)index {
    id<PKTimeChartProtocol>obj = [self.dataList pk_objAtIndex:index];
    NSString *volume = [NSNumber pk_trillionStringWithDoubleDigits:@(obj.pk_volume)];
    NSString *volText = [NSString stringWithFormat:@" 成交量 %@手", volume];
    NSMutableAttributedString *text = [NSMutableAttributedString pk_attributedWithString:volText];
    [text pk_setFont:PKCHART_LEGEND_FONTSIZE(10)];
    [text pk_setForegroundColor:self.set.plainTextColor];
    return text;
}

- (CGFloat)getCenterXWithIndex:(NSInteger)index {
    CGFloat centerX = (self.set.shapeWidth + self.set.shapeGap) * index + half(self.set.shapeWidth);
    return centerX + self.contentChartFrame.origin.x;
}

- (CGFloat)getOriginXWithIndex:(NSInteger)index {
    CGFloat centerX = [self getCenterXWithIndex:index];
    return centerX - half(self.set.shapeWidth);
}

- (void)makeDateRenderer:(CGFloat *)positionY baseOffsetVertical:(CGFloat *)vertical {
    CGFloat positionCenterY; CGFloat baseOffsetVertical;
    if (self.set.datePosition == PKChartDatePositionBottom) {
        positionCenterY = CGRectGetMaxY(self.minorChartFrame);
        baseOffsetVertical = half(self.set.dateSeparatedGap);
    } else if (self.set.datePosition == PKChartDatePositionTop) {
        positionCenterY = 0;
        baseOffsetVertical = half(self.set.dateSeparatedGap);
    } else {
        positionCenterY = CGRectGetMaxY(self.majorChartFrame);
        baseOffsetVertical = half(self.set.dateSeparatedGap);
    }
    *positionY = positionCenterY; *vertical = baseOffsetVertical;
}

#pragma mark -  Reference Value

- (CGFloat)getVaildPreClosePrice {
    if ([self.coordObj respondsToSelector:@selector(pk_referenceValue)]) {
        return self.coordObj.pk_referenceValue;
    }
    return self.dataList.firstObject.pk_latestPrice;
}

- (CGPeakValue)getPricePeakValue {
    CGFloat defaultChangeRate = self.set.defaultChange;
    CGFloat preClosePrice = [self getVaildPreClosePrice];
    CGPeakValue peakValue = CGPeakValueZero;
    if (![self.coordObj respondsToSelector:@selector(pk_maxPrice)] ||
        ![self.coordObj respondsToSelector:@selector(pk_minPrice)]) {
        CGFloat spanValue = [self.dataList pk_spanValueWithReferenceValue:preClosePrice
                                                           evaluatedBlock:^CGFloat(id<PKTimeChartProtocol>  _Nonnull evaluatedObject) {
                                                               return evaluatedObject.pk_latestPrice;
        }];
        
        CGFloat avgSpanValue = [self.dataList pk_spanValueWithReferenceValue:preClosePrice
                                                              evaluatedBlock:^CGFloat(id<PKTimeChartProtocol>  _Nonnull evaluatedObject) {
                                                                  return evaluatedObject.pk_averagePrice;
        }];

        spanValue = MAX(avgSpanValue, spanValue); // 获取较大跨度
        
        if (CGFloatEqualZero(spanValue)) { // 若跨度为0，或极值无效，则使用默认比率
            spanValue = defaultChangeRate / 100.0 * preClosePrice;
        }
        
        peakValue = CGPeakValueMake(preClosePrice + spanValue, preClosePrice - spanValue);
    } else {
        peakValue = CGPeakValueMake(self.coordObj.pk_maxPrice, self.coordObj.pk_minPrice);
    }
    return peakValue;
}

- (CGPeakValue)getChangeRatePeakValue {
    CGFloat defaultChangeRate = self.set.defaultChange;
    CGFloat preClosePrice = [self getVaildPreClosePrice];
    CGPeakValue pricePeakValue = [self getPricePeakValue];
    
    CGPeakValue peakValue = CGPeakValueZero;
    if (![self.coordObj respondsToSelector:@selector(pk_maxChangeRate)] ||
        ![self.coordObj respondsToSelector:@selector(pk_minChangeRate)]) {
        if(preClosePrice <= 0) {
            peakValue.max = defaultChangeRate / 100.0;
            peakValue.min = -defaultChangeRate / 100.0;
        } else {
            peakValue.max = (pricePeakValue.max - preClosePrice) / preClosePrice;
            peakValue.min = (pricePeakValue.min - preClosePrice) / preClosePrice;
        }
    } else {
        peakValue = CGPeakValueMake(self.coordObj.pk_maxChangeRate, self.coordObj.pk_minChangeRate);
    }
    return peakValue;
}

- (CGPeakValue)getVolumePeakValue {
    CGPeakValue peakValue = CGPeakValueZero;
    if (![self.coordObj respondsToSelector:@selector(pk_maxVolume)] ||
        ![self.coordObj respondsToSelector:@selector(pk_minVolume)]) {
        peakValue = [self.dataList pk_peakValueWithEvaluatedBlock:^CGFloat(id<PKTimeChartProtocol>  _Nonnull evaluatedObject) {
            return evaluatedObject.pk_volume;
        }];
    } else {
        peakValue = CGPeakValueMake(self.coordObj.pk_maxVolume, self.coordObj.pk_minVolume);
    }
    return peakValue;
}

- (CGPeakValue)getLeadVolumePeakValue {
    CGPeakValue peakValue = CGPeakValueZero;
    if ([self.dataList.firstObject respondsToSelector:@selector(pk_leadRGBarVolume)]) {
        peakValue = [self.dataList pk_peakValueWithEvaluatedBlock:^CGFloat(id<PKTimeChartProtocol>  _Nonnull evaluatedObject) {
            return evaluatedObject.pk_leadRGBarVolume;
        }];
    }
    return peakValue;
}

@end
