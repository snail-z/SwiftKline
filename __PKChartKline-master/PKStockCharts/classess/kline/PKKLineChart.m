//
//  PKKLineChart.m
//  PKChartKit
//
//  Created by zhanghao on 2017/12/6.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import <objc/runtime.h>
#import "PKKLineChart.h"
#import "PKChartCrosshairView.h"
#import "PKKLineLoadingView.h"
#import "PKChartTextLayer.h"
#import "PKIndicatorBaseLayer.h"
#import "PKChartCategories.h"
#import "PKChartConst.h"
#import "PKIndicatorCacheCalculator.h"
#import "PKKLineChart+Frame.h"

@interface PKKLineChart () <UIGestureRecognizerDelegate, PKKLineLoadingViewDelegate, PKChartCrosshairViewDelegate>

/** 横向网格线(主图区域) */
@property (nonatomic, strong) CAShapeLayer *majorGridLayer;
/** 横向网格线(副图区域) */
@property (nonatomic, strong) CAShapeLayer *minorGridLayer;
/** 日期标记线 */
@property (nonatomic, strong) CAShapeLayer *dateLineGridLayer;
/** 网格两端边框线 */
@property (nonatomic, strong) CAShapeLayer *borderLineGridLayer;
/** 横轴文本(主图区域) */
@property (nonatomic, strong) PKChartTextLayer *majorTextLayer;
/** 横轴文本(副图区域) */
@property (nonatomic, strong) PKChartTextLayer *minorTextLayer;
/** 日期线文本 */
@property (nonatomic, strong) PKChartTextLayer *dateLineTextLayer;
/** K线蜡烛图涨 */
@property (nonatomic, strong) CAShapeLayer *KLineRiseLayer;
/** K线蜡烛图跌 */
@property (nonatomic, strong) CAShapeLayer *KLineFallLayer;
/** K线蜡烛图平 */
@property (nonatomic, strong) CAShapeLayer *KLineFlatLayer;
/** K线图折线走势 */
@property (nonatomic, strong) CAShapeLayer *KBrokenLineLayer;
/** 最大值标记线 */
@property (nonatomic, strong) CAShapeLayer *peakMaxLineLayer;
/** 最小值标记线 */
@property (nonatomic, strong) CAShapeLayer *peakMinLineLayer;
/** 最大最小值标记文本 */
@property (nonatomic, strong) PKChartTextLayer *peakValueTextLayer;
/** 十字线查价图 */
@property (nonatomic, strong) PKChartCrosshairView *crosshairView;
/** 加载提示视图 */
@property (nonatomic, strong) PKKLineLoadingView *pullLoadingView;
/** 主图说明文本 */
@property (nonatomic, strong) UILabel *majorLegendLabel;
/** 副图说明文本 */
@property (nonatomic, strong) UILabel *minorLegendLabel;

/** 存储所有时间线的索引集 */
@property (nonatomic, strong) NSMutableIndexSet *allTimelineIndexSets;
/** 用于存储所有指标layer的集合 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, PKIndicatorBaseLayer *> *allIndicatorLayers;
/** 指标缓存计算管理者 */
@property (nonatomic, strong) PKIndicatorCacheCalculator *cacheCalculator;
/** 记录插入的数据列表 */
@property (nonatomic, weak) NSArray<id<PKKLineChartProtocol>> *dataInsertsList;

/** 横轴坐标转换器 */
@property (nonatomic, copy) CGMakeXaxisBlock axisXCallback;
/** 纵轴坐标转换器 */
@property (nonatomic, copy) CGMakeYaxisBlock axisYCallback;

@end

@implementation PKKLineChart {
    CGFloat _previousScale;
    NSInteger _pinchCenterIndex;
    CGFloat _pinchCenterOffsetOfVisual;
    BOOL _pinchBrokenLineEnabling;
    NSString* _clearMajorIndicatorIdentifier;
}

- (void)_defaultInitialization {
    _previousScale = 1;
    _pinchBrokenLineEnabling = NO;
    _set = [PKKLineChartSet defaultSet];
    _indicatorSet = [PKIndicatorChartSet defaultSet];
    _allTimelineIndexSets = [NSMutableIndexSet indexSet];
    _cacheCalculator = [PKIndicatorCacheCalculator new];
    _axisXCallback = CGMakeXaxisBlockCreator(self.set.shapeWidth, self.set.shapeGap);
    _axisYCallback = CGMakeYaxisBlockCreator(CGPeakValueZero, self.majorChartFrame);
}

#pragma mark - Initial sublayers

- (void)_sublayerInitialization {
    _majorGridLayer = [CAShapeLayer layer];
    [self.contentGridLayer addSublayer:_majorGridLayer];
    
    _minorGridLayer = [CAShapeLayer layer];
    [self.contentGridLayer addSublayer:_minorGridLayer];
    
    _borderLineGridLayer = [CAShapeLayer layer];
    [self.contentGridLayer addSublayer:_borderLineGridLayer];
    
    _majorTextLayer = [PKChartTextLayer layer];
    [self.contentTextLayer addSublayer:_majorTextLayer];
    
    _minorTextLayer = [PKChartTextLayer layer];
    [self.contentTextLayer addSublayer:_minorTextLayer];
    
    _dateLineGridLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_dateLineGridLayer];
    
    _dateLineTextLayer = [PKChartTextLayer layer];
    [self.contentChartLayer addSublayer:_dateLineTextLayer];
    
    _KLineRiseLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_KLineRiseLayer];
    
    _KLineFallLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_KLineFallLayer];
    
    _KLineFlatLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_KLineFlatLayer];
    
    _KBrokenLineLayer = [CAShapeLayer layer];
    _KBrokenLineLayer.lineJoin = kCALineJoinRound;
    _KBrokenLineLayer.lineCap = kCALineCapRound;
    [self.contentChartLayer addSublayer:_KBrokenLineLayer];
    
    _peakValueTextLayer = [PKChartTextLayer layer];
    [self.contentTopCahrtLayer addSublayer:_peakValueTextLayer];
    
    _peakMaxLineLayer = [CAShapeLayer layer];
    [self.contentTopCahrtLayer addSublayer:_peakMaxLineLayer];
    
    _peakMinLineLayer = [CAShapeLayer layer];
    [self.contentTopCahrtLayer addSublayer:_peakMinLineLayer];
    
    _majorLegendLabel = [UILabel new];
    _majorLegendLabel.font = [UIFont systemFontOfSize:10];
    [self.containerView addSubview:_majorLegendLabel];
    
    _minorLegendLabel = [UILabel new];
    _minorLegendLabel.font = [UIFont systemFontOfSize:10];
    [self.containerView addSubview:_minorLegendLabel];
    
    _crosshairView = [PKChartCrosshairView new];
    _crosshairView.delegate = self;
    [self.containerView addSubview:_crosshairView];
    
    _pullLoadingView = [PKKLineLoadingView new];
    _pullLoadingView.delegate = self;
    [self.scrollView addSubview:self.pullLoadingView];
}

#pragma mark - Update sublayers

- (void)sublayerStyleUpdates {
    _majorGridLayer.fillColor = [UIColor clearColor].CGColor;
    _majorGridLayer.strokeColor = self.set.gridLineColor.CGColor;
    _majorGridLayer.lineWidth = self.set.gridLineWidth;
    
    _minorGridLayer.fillColor = _majorGridLayer.fillColor;
    _minorGridLayer.strokeColor = _majorGridLayer.strokeColor;
    _minorGridLayer.lineWidth = _majorGridLayer.lineWidth;
    
    _dateLineGridLayer.fillColor = _majorGridLayer.fillColor;
    _dateLineGridLayer.strokeColor = _majorGridLayer.strokeColor;
    _dateLineGridLayer.lineWidth = _majorGridLayer.lineWidth;
    
    _borderLineGridLayer.fillColor = _majorGridLayer.fillColor;
    _borderLineGridLayer.strokeColor = _majorGridLayer.strokeColor;
    _borderLineGridLayer.lineWidth = _majorGridLayer.lineWidth;
    
    UIColor *fillRiseColor = self.set.shouldRiseSolid ? self.set.KRiseColor : [UIColor clearColor];
    _KLineRiseLayer.fillColor = fillRiseColor.CGColor;
    _KLineRiseLayer.strokeColor = self.set.KRiseColor.CGColor;
    _KLineRiseLayer.lineWidth = self.set.shapeStrokeWidth;
    
    UIColor *fillFallColor = self.set.shouldFallSolid ? self.set.KFallColor : [UIColor clearColor];
    _KLineFallLayer.fillColor = fillFallColor.CGColor;
    _KLineFallLayer.strokeColor = self.set.KFallColor.CGColor;
    _KLineFallLayer.lineWidth = self.set.shapeStrokeWidth;
    
    UIColor *fillFlatColor = self.set.shouldFlatSolid ? self.set.KFlatColor : [UIColor clearColor];
    _KLineFlatLayer.fillColor = fillFlatColor.CGColor;
    _KLineFlatLayer.strokeColor = self.set.KFlatColor.CGColor;
    _KLineFlatLayer.lineWidth = self.set.shapeStrokeWidth;
    
    _KBrokenLineLayer.fillColor = [UIColor clearColor].CGColor;
    _KBrokenLineLayer.strokeColor = self.set.pinchIntoLineColor.CGColor;
    _KBrokenLineLayer.lineWidth = self.set.pinchIntoLineWidth;
    
    _peakMaxLineLayer.fillColor = self.set.peakTaggedTextColor.CGColor;
    _peakMaxLineLayer.strokeColor = self.set.peakTaggedTextColor.CGColor;
    _peakMaxLineLayer.lineWidth = self.set.peakTaggedLineWidth;
    
    _peakMinLineLayer.fillColor = _peakMaxLineLayer.fillColor;
    _peakMinLineLayer.strokeColor = _peakMaxLineLayer.strokeColor;
    _peakMinLineLayer.lineWidth = _peakMaxLineLayer.lineWidth;
    
    _pullLoadingView.themeColor = self.set.pullLoadingTintColor;
    _crosshairView.textFont = [self.set.plainTextFont fontWithSize:self.set.plainTextFont.pointSize + 1];
    _crosshairView.textColor = self.set.crossTextColor;
    _crosshairView.lineWidth = self.set.crossLineWidth;
    _crosshairView.lineColor = self.set.crossLineColor;
    _crosshairView.dotRadius = self.set.crossDotRadius;
    _crosshairView.dotColor = self.set.crossDotColor;
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
    
    _crosshairView.frame = _contentChartFrame;
    _crosshairView.ignoreZone = CGRectMake(_origin.x, _majorChartFrame.size.height, _majorChartFrame.size.width, self.set.minorLegendGap + midGap);
    
    CGRect paddingFrame = self.majorChartFrame;
    paddingFrame.size.width = self.set.pullLoadingInset;
    _pullLoadingView.loadingInRect = paddingFrame;
}

- (void)shapeWidthUpdate:(NSInteger)numbers {
    CGFloat shapeWidth = [self shapeWidthLoop:numbers shapeGap:self.set.shapeGap];
    [self.set setValue:@(shapeWidth) forKey:NSStringFromSelector(@selector(shapeWidth))];
    CGFloat contentWidth = (self.set.shapeGap + self.set.shapeWidth) * self.dataList.count - self.set.shapeGap;
    self.scrollView.contentSize = CGSizeMake(contentWidth, self.bounds.size.height);
    self.scrollView.scrollEnabled = (self.scrollView.contentSize.width > self.contentChartFrame.size.width);
}

- (CGFloat)shapeWidthLoop:(NSInteger)numbers shapeGap:(CGFloat)changeGap {
    CGFloat allGap = (numbers - 1) * changeGap;
    CGFloat allWidth = (self.majorChartFrame.size.width - allGap);
    CGFloat shapeWidth = allWidth / (CGFloat)numbers; // if (!auto) return shapeWidth;
    CGFloat minWidth = self.set.shapeStrokeWidth * 2;
    if (shapeWidth < minWidth) { // oneWidth least greater than or equal to minWidth
        changeGap *= 0.75;
        if (changeGap < 1) return shapeWidth; // shapeGap least greater than or equal to 1
        return [self shapeWidthLoop:numbers shapeGap:changeGap];
    }
    self.set.shapeGap = changeGap;
    return shapeWidth;
}

- (void)scrollToAdjust:(NSInteger)dataCount {
    CGFloat _offsetX = (self.set.shapeGap + self.set.shapeWidth) * (CGFloat)dataCount;
    _offsetX -= self.set.pullLoadingInset;
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.x = _offsetX; // calculate the position offset
    [self.scrollView setContentOffset:contentOffset animated:NO];
}

- (void)setDataList:(NSArray<id<PKKLineChartProtocol>> *)dataList {
    _dataList = dataList;
    if (!dataList || !dataList.count) return;
    [self.cacheCalculator updateCacheForDataList:dataList];
}

- (void)insertDataList:(NSArray<id<PKKLineChartProtocol>> *)dataList {
    if (!dataList || !dataList.count) return;
    if (self.dataList.count) {
        _dataInsertsList = dataList;
        NSMutableArray *objs = [NSMutableArray arrayWithArray:dataList];
        !self.dataList ?: [objs addObjectsFromArray:self.dataList];
        self.dataList = objs;
    } else {
        self.dataList = dataList;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.crosshairView dismiss];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!scrollView.isDragging && !scrollView.isDecelerating) return;
    if (scrollView.scrollEnabled) {
        [self _updateChart];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {}

#pragma mark - PKKLineLoadingViewDelegate

- (void)loadingViewDidBeginLoading:(PKKLineLoadingView *)loadingView {
    if ([self.delegate respondsToSelector:@selector(klineChartDidBeginPullLoading:)]) {
        [self.delegate klineChartDidBeginPullLoading:self];
    }
}

#pragma mark - PKChartCrosshairViewDelegate

- (void)crosshairViewDidDismiss:(PKChartCrosshairView *)crosshairView {
    [self _updateChart];
    if ([self.delegate respondsToSelector:@selector(klineChartCrossLineDidDismiss:)]) {
        [self.delegate klineChartCrossLineDidDismiss:self];
    }
}

#pragma mark - Draw charts

- (void)drawChart {
    self.scrollView.scrollEnabled = YES;
    if (self.dataList.count) {
        id obj = self.dataList.firstObject;
        NSParameterAssert([obj conformsToProtocol:@protocol(PKKLineChartProtocol)]);
        NSParameterAssert([obj respondsToSelector:@selector(pk_kOpenPrice)]);
        NSParameterAssert([obj respondsToSelector:@selector(pk_kHighPrice)]);
        NSParameterAssert([obj respondsToSelector:@selector(pk_kLowPrice)]);
        NSParameterAssert([obj respondsToSelector:@selector(pk_kClosePrice)]);
        NSParameterAssert([obj respondsToSelector:@selector(pk_kVolume)]);
        NSParameterAssert([obj respondsToSelector:@selector(pk_kDateTime)]);
    }

    disable_animations(^{
        [self.crosshairView dismiss];
        [self.pullLoadingView endLoading];
        [self sublayerStyleUpdates];
        [self sublayerLayoutUpdates];
        [self shapeWidthUpdate:self.set.numberOfVisible];
        if (self.dataInsertsList.count) {
            [self scrollToAdjust:self.dataInsertsList.count];
        } else {
            [self scrollToRight];
        }
        [self drawGridBorderLines];
        [self _updateChart];
    });
}

- (void)clearChart {
    self.scrollView.scrollEnabled = NO;
    disable_animations(^{
        for (PKIndicatorBaseLayer *layer in self.allIndicatorLayers.allValues) {
            [self clearForSublayers:layer.sublayers];
        }
        [self clearForSublayers:self.contentGridLayer.sublayers];
        [self clearForSublayers:self.contentTopCahrtLayer.sublayers];
        [self clearForSublayers:self.contentChartLayer.sublayers];
        [self clearForSublayers:self.contentTextLayer.sublayers];
        self.majorLegendLabel.attributedText = nil;
        self.minorLegendLabel.attributedText = nil;
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

- (void)_updateChart {
    // 获取绘制范围和计算范围
    NSRange drawRange = [self shouldDrawRange];
    NSRange calculatedRange = [self shouldCalculatedRange];
    // 绘制主图表
    [self drawMajorIndicatorChartWithRange:drawRange calculateRange:calculatedRange];
    // 绘制副图表
    [self drawMinorIndicatorChartWithRange:drawRange calculateRange:calculatedRange];
}

- (void)drawMajorIndicatorChartWithRange:(NSRange)range calculateRange:(NSRange)calculatedRange {
    // 计算主图区域内的指标缓存值
    [self.cacheCalculator parseResultRange:calculatedRange byIndicatorIdentifier:self.currentMajorIndicatorIdentifier];
    
    // 赋值缓存值
    PKIndicatorBaseLayer *baseLayer = [self getIndicatorLayerWithIdentifier:self.currentMajorIndicatorIdentifier];
    PKIndicatorBaseLayer<PKIndicatorMajorProtocol> *layer = (id)baseLayer;
    [layer setValueForCacheList:self.cacheCalculator.allCache];
    [layer setValueForDataList:self.dataList];
    [layer setValueForSet:self.indicatorSet];
    [layer setValueForScaler:CGChartScalerMake(self.set.shapeWidth, self.set.shapeGap, self.majorChartFrame)];
    
    // 计算主图区域极值
    CGIndexPeakValue _pathValue = [self getIndexPeakValueAtRange:calculatedRange];
    CGPeakValue peakValue = CGPeakValueMake(_pathValue.max.value, _pathValue.min.value);
    
    // 更新主图区域内极值
    CGPeakValue peak = [layer majorChartPeakValue:peakValue forRange:calculatedRange];
    if (!CGPeakValueEqualToPeakValue(peak, CGPeakValueZero)) peakValue = peak;
    if (layer && self.dataList.count) { // 检测极值的合法性
        if (CGPeakValueEqualToPeakValue(peak, CGPeakValueZero)) {
            PKChartLog(@"Draw failure, peak value is empty!【%@】", NSStringFromClass(layer.class));
        }
        if (CGFloatEqualZero(CGPeakValueGetDistance(peak))) {
            PKChartLog(@"Draw failure, peak value is equal!【%@】", NSStringFromClass(layer.class));
        }
    }
    
    // 扩大范围后的极值
    CGPeakValue enlargedPeakValue = [self peakValueEnlarged:peakValue];
    
    // 生成坐标转换系统
    self.axisXCallback = CGMakeXaxisBlockCreator(self.set.shapeWidth, self.set.shapeGap);
    self.axisYCallback = CGMakeYaxisBlockCreator(enlargedPeakValue, self.majorChartFrame);
    
    // 赋值坐标系统
    [layer setValueForAxisXCallback:self.axisXCallback];
    [layer setValueForAxisYCallback:self.axisYCallback];
    
    // 绘制主图区域指标
    [layer drawMajorChartInRange:range];
    
    // 绘制主图区域说明文本
    if (_majorLegendLabel.frame.size.height > 0 &&
        [layer respondsToSelector:@selector(majorChartAttributedTextForRange:)]) {
        _majorLegendLabel.attributedText = [layer majorChartAttributedTextForRange:calculatedRange];
    } else {
        _majorLegendLabel.attributedText = nil;
    }
    
    // 绘制主图区域内基础图表
    [self drawMajorChartWithRange:range];
    [self drawMajorGridWithPeakValue:enlargedPeakValue];
    [self drawPeakTaggedLines:_pathValue];
    [self drawGridTimelinesWithRange:range];
}

- (void)drawMinorIndicatorChartWithRange:(NSRange)range calculateRange:(NSRange)calculatedRange {
    // 计算副图区域内的指标缓存值
    [self.cacheCalculator parseResultRange:calculatedRange byIndicatorIdentifier:self.currentMinorIndicatorIdentifier];
    
    // 赋值缓存值
    PKIndicatorBaseLayer *baseLayer = [self getIndicatorLayerWithIdentifier:self.currentMinorIndicatorIdentifier];
    PKIndicatorBaseLayer<PKIndicatorMinorProtocol> *layer = (id)baseLayer;
    [layer setValueForCacheList:self.cacheCalculator.allCache];
    [layer setValueForDataList:self.dataList];
    [layer setValueForSet:self.indicatorSet];
    [layer setValueForScaler:CGChartScalerMake(self.set.shapeWidth, self.set.shapeGap, self.minorChartFrame)];
    
    // 计算副图区域极值
    CGPeakValue peakValue = [layer minorChartPeakValueForRange:calculatedRange];
    if (layer && self.dataList.count) { // 检测极值的合法性
        if (CGPeakValueEqualToPeakValue(peakValue, CGPeakValueZero)) {
            PKChartLog(@"Draw failure, peak value is empty!【%@】", NSStringFromClass(layer.class));
        }
        if (CGFloatEqualZero(CGPeakValueGetDistance(peakValue))) {
            PKChartLog(@"Draw failure, peak value is equal!【%@】", NSStringFromClass(layer.class));
        }
    }
    
    // 生成坐标转换系统
    CGMakeXaxisBlock axisXCallback = CGMakeXaxisBlockCreator(self.set.shapeWidth, self.set.shapeGap);
    CGMakeYaxisBlock axisYCallback = CGMakeYaxisBlockCreator(peakValue, self.minorChartFrame);
    
    // 赋值坐标系统
    [layer setValueForAxisXCallback:axisXCallback];
    [layer setValueForAxisYCallback:axisYCallback];
    
    // 绘制副图区域指标
    [layer drawMinorChartInRange:range];
    
    // 绘制副图区域说明文本
    if (CGRectGetHeight(_minorLegendLabel.frame) &&
        [layer respondsToSelector:@selector(minorChartAttributedTextForRange:)]) {
        _minorLegendLabel.attributedText = [layer minorChartAttributedTextForRange:calculatedRange];
    } else {
        _minorLegendLabel.attributedText = nil;
    }
    
    // 绘制副图区域内基础图表
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSArray<PKChartTextRenderer *> *renders = [layer minorChartTrellisForPeakValue:peakValue path:&path];
    
    // 封闭副图说明文本区域
    if (_minorLegendLabel.attributedText.length > 0 && self.set.datePosition == PKChartDatePositionMiddle) {
        UIEdgeInsets inset = UIEdgeInsetsMake(0, half(self.set.gridLineWidth), 0, half(self.set.gridLineWidth));
        [path pk_addRect:UIEdgeInsetsInsetRect(self.minorLegendLabel.frame, inset)];
    }
    
    _minorGridLayer.path = path.CGPath;
    _minorTextLayer.renders = renders;
}

- (void)drawMajorGridWithPeakValue:(CGPeakValue)peakValue {
    NSArray<NSString *> *strings = [NSArray pk_arrayWithParagraphs:self.set.majorNumberOfLines
                                                         peakValue:peakValue
                                                       resultBlock:^NSString * _Nonnull(CGFloat floatValue, NSUInteger index) {
                                                           return [NSNumber pk_stringWithDigits:@(floatValue) keepPlaces:self.set.decimalKeepPlace];
                                                       }];
    
    CGFloat gap = self.majorChartFrame.size.height / (CGFloat)(strings.count - 1);
    CGFloat originY = self.majorChartFrame.origin.y + half(self.set.gridLineWidth);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSMutableArray<PKChartTextRenderer *> *renders = [NSMutableArray arrayWithCapacity:strings.count];
    [strings enumerateObjectsUsingBlock:^(NSString * _Nonnull text, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint start = CGPointMake(self.majorChartFrame.origin.x, originY + gap * idx);
        [path pk_addHorizontalLine:start len:self.majorChartFrame.size.width];
        
        PKChartTextRenderer *render = [PKChartTextRenderer defaultRenderer];
        render.text = text;
        render.color = self.set.plainTextColor;
        render.font = self.set.plainTextFont;
        render.positionCenter = start;
        [renders addObject:render];
    }];
    renders.firstObject.offsetRatio = kCGOffsetRatioTopLeft;
    
    _majorGridLayer.path = path.CGPath;
    _majorTextLayer.renders = renders;
}

- (void)drawMajorChartWithRange:(NSRange)range {
    if (_pinchBrokenLineEnabling) {
        return [self drawMajorBrokenLineWithRange:range];
    }
    
    UIBezierPath *risePath = [UIBezierPath bezierPath];
    UIBezierPath *fallPath = [UIBezierPath bezierPath];
    UIBezierPath *flatPath = [UIBezierPath bezierPath];
    
    [self.dataList pk_enumerateObjsAtRange:range ceaselessBlock:^(id<PKKLineChartProtocol>  _Nonnull obj, NSUInteger idx) {
        CGFloat highY = self.axisYCallback(obj.pk_kHighPrice);
        CGFloat lowY = self.axisYCallback(obj.pk_kLowPrice);
        CGFloat openY = self.axisYCallback(obj.pk_kOpenPrice);
        CGFloat closeY = self.axisYCallback(obj.pk_kClosePrice);
        CGFloat centerX = self.axisXCallback(idx);
        
        CGFloat shapeWidth = self.set.shapeWidth - self.set.shapeStrokeWidth;
        CGFloat originX = centerX - half(shapeWidth);
        CGFloat originY = MIN(openY, closeY);
        CGFloat shapeHeight = fabs(openY - closeY);
        
        CGPoint top = CGPointMake(centerX, highY);
        CGPoint bottom = CGPointMake(centerX, lowY);
        CGRect rect = CGRectMake(originX, originY, shapeWidth, shapeHeight);
        CGCandleShape shape = CGCandleShapeMake(top, rect, bottom);
        
        if (obj.pk_kOpenPrice < obj.pk_kClosePrice) [risePath pk_addCandleShape:shape];
        else if (obj.pk_kOpenPrice > obj.pk_kClosePrice) [fallPath pk_addCandleShape:shape];
        else [flatPath pk_addCandleShape:shape];
    }];
    
    _KLineRiseLayer.path = risePath.CGPath;
    _KLineFallLayer.path = fallPath.CGPath;
    _KLineFlatLayer.path = flatPath.CGPath;
}

- (void)drawMajorBrokenLineWithRange:(NSRange)range {
    UIBezierPath *path = [UIBezierPath bezierPath];
    id<PKKLineChartProtocol>obj = [self.dataList pk_firstObjAtRange:range];
    CGPoint p = CGPointMake(self.axisXCallback(range.location), self.axisYCallback(obj.pk_kClosePrice));
    [path moveToPoint:p];
    
    [self.dataList pk_enumerateObjsAtRange:NS_RangeOffset1(range) ceaselessBlock:^(id<PKKLineChartProtocol>  _Nonnull obj, NSUInteger idx) {
        CGFloat closeY = self.axisYCallback(obj.pk_kClosePrice);
        CGFloat centerX = self.axisXCallback(idx);
        [path addLineToPoint:CGPointMake(centerX, closeY)];
    }];
    
    _KBrokenLineLayer.path = path.CGPath;
}

- (void)drawPeakTaggedLines:(CGIndexPeakValue)pathValue {
    if (self.set.peakTaggedHidden) return;
    
    CGFloat alignX = [self convertPoint:CGPointMake(half(self.majorChartFrame.size.width), 0) toView:self.scrollView].x;
    
    NSMutableArray<PKChartTextRenderer *> *renders = [NSMutableArray arrayWithCapacity:2];
    UIBezierPath*(^makeTagged)(CGFloat, CGFloat, CGFloat) = ^(CGFloat centerX, CGFloat originY, CGFloat value) {
        CGFloat lineLength = 0;
        CGPoint positionCenter = CGPointZero, offsetRatio = CGPointZero;
        
        if (centerX < alignX) {
            lineLength += self.set.peakTaggedLineLength;
            centerX += self.set.peakTaggedLineOffset.horizontal;
            positionCenter = CGPointMake(centerX + lineLength + self.set.peakTaggedLineOffset.horizontal, originY);
            offsetRatio = kCGOffsetRatioCenterLeft;
        } else {
            lineLength -= self.set.peakTaggedLineLength;
            centerX -= self.set.peakTaggedLineOffset.horizontal;
            positionCenter = CGPointMake(centerX + lineLength - self.set.peakTaggedLineOffset.horizontal, originY);
            offsetRatio = kCGOffsetRatioCenterRight;
        }
        
        PKChartTextRenderer *render = [PKChartTextRenderer defaultRenderer];
        render.text = [NSNumber pk_stringWithDigits:@(value) keepPlaces:self.set.decimalKeepPlace];
        render.color = self.set.peakTaggedTextColor;
        render.font = self.set.peakTaggedTextFont;
        render.positionCenter = positionCenter;
        render.offsetRatio = offsetRatio;
        [renders addObject:render];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX + lineLength, originY) radius:self.set.peakTaggedVertexRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
        [path pk_addHorizontalLine:CGPointMake(centerX , originY) len:lineLength];
        return path;
    };
    
    CGFloat topCenterX = self.axisXCallback(pathValue.max.index);
    CGFloat botCenterX = self.axisXCallback(pathValue.min.index);
    CGFloat topOriginY = self.axisYCallback(pathValue.max.value) - self.set.peakTaggedLineOffset.vertical;
    CGFloat botOriginY = self.axisYCallback(pathValue.min.value) + self.set.peakTaggedLineOffset.vertical;
    UIBezierPath *topPath = makeTagged(topCenterX, topOriginY, pathValue.max.value);
    UIBezierPath *botPath = makeTagged(botCenterX, botOriginY, pathValue.min.value);
    
    _peakMaxLineLayer.path = topPath.CGPath;
    _peakMinLineLayer.path = botPath.CGPath;
    _peakValueTextLayer.renders = renders;
}

- (void)drawGridTimelinesWithRange:(NSRange)range {
    [self doTimelinesSeparated:range];
    
    CGFloat positionCenterY; CGFloat baseOffsetVertical;
    [self makeDateRenderer:&positionCenterY baseOffsetVertical:&baseOffsetVertical];

    __block CGFloat previousRightX = 0; // avoid text overlap
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSMutableArray<PKChartTextRenderer *> *renders = [NSMutableArray array];
    [self.allTimelineIndexSets enumerateIndexesInRange:range options:kNilOptions usingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool {
            id<PKKLineChartProtocol>obj = self.dataList[idx];
            
            CGFloat centerX = self.axisXCallback(idx);
            CGFloat rootCenterX = [self getCenterXInBaseViewForIndex:idx];
        
            NSString *text = self.makeDateTextCallback(obj, NO);
            CGFloat textWidth = [text sizeWithAttributes:@{NSFontAttributeName:self.set.plainTextFont}].width;
            CGFloat leftX = centerX - half(textWidth);
            CGFloat lessGap = self.set.avoidOverlapDatelineGap;
            
            if (rootCenterX > self.majorChartFrame.size.width ||
                leftX < 0 || leftX < (previousRightX + lessGap)) {} else {
                
                [path pk_addVerticalLine:CGPointMake(centerX, CGRectGetMinY(self.majorChartFrame)) len:self.majorChartFrame.size.height];
                [path pk_addVerticalLine:CGPointMake(centerX, CGRectGetMinY(self.minorChartFrame)) len:self.minorChartFrame.size.height];
                
                PKChartTextRenderer *render = [PKChartTextRenderer defaultRenderer];
                render.text = text;
                render.color = self.set.dateTextColor;
                render.font = self.set.dateTextFont;
                render.offsetRatio = kCGOffsetRatioCenter;
                render.baseOffset = UIOffsetMake(0, baseOffsetVertical);
                render.positionCenter = CGPointMake(centerX, positionCenterY);
                [renders addObject:render];
                
                previousRightX = centerX + half(textWidth);
            }
        }
    }];
    
    _dateLineGridLayer.path = path.CGPath;
    _dateLineTextLayer.renders = renders;
}

- (void)drawGridBorderLines {
    CGFloat minX = CGRectGetMinX(self.contentChartFrame) + half(self.set.gridLineWidth);
    CGFloat maxX = CGRectGetMaxX(self.contentChartFrame) - half(self.set.gridLineWidth);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path pk_addVerticalLine:CGPointMake(minX, CGRectGetMinY(self.majorChartFrame)) len:self.majorChartFrame.size.height];
    [path pk_addVerticalLine:CGPointMake(maxX, CGRectGetMinY(self.majorChartFrame)) len:self.majorChartFrame.size.height];
    [path pk_addVerticalLine:CGPointMake(minX, CGRectGetMinY(self.minorChartFrame)) len:self.minorChartFrame.size.height];
    [path pk_addVerticalLine:CGPointMake(maxX, CGRectGetMinY(self.minorChartFrame)) len:self.minorChartFrame.size.height];
    _borderLineGridLayer.path = path.CGPath;
}

#pragma mark - Indicators management

- (void)setDefaultMajorIndicatorIdentifier:(NSString *)defaultMajorIndicatorIdentifier {
    if (!defaultMajorIndicatorIdentifier) return;
    NSAssert1([self.allIndicatorLayers.allKeys containsObject:defaultMajorIndicatorIdentifier],
              @"Unregistered identifier [%@]", defaultMajorIndicatorIdentifier);
    PKIndicatorBaseLayer *layer = [self getIndicatorLayerWithIdentifier:defaultMajorIndicatorIdentifier];
    NSParameterAssert([layer conformsToProtocol:@protocol(PKIndicatorMajorProtocol)]);
    _defaultMajorIndicatorIdentifier = defaultMajorIndicatorIdentifier;
    _currentMajorIndicatorIdentifier = defaultMajorIndicatorIdentifier;
}

- (void)setDefaultMinorIndicatorIdentifier:(NSString *)defaultMinorIndicatorIdentifier {
    if (!defaultMinorIndicatorIdentifier) return;
    NSAssert1([self.allIndicatorLayers.allKeys containsObject:defaultMinorIndicatorIdentifier],
              @"Unregistered identifier [%@]", defaultMinorIndicatorIdentifier);
    PKIndicatorBaseLayer *layer = [self getIndicatorLayerWithIdentifier:defaultMinorIndicatorIdentifier];
    NSParameterAssert([layer conformsToProtocol:@protocol(PKIndicatorMinorProtocol)]);
    _defaultMinorIndicatorIdentifier = defaultMinorIndicatorIdentifier;
    _currentMinorIndicatorIdentifier = defaultMinorIndicatorIdentifier;
}

- (void)changeIndicatorWithIdentifier:(NSString *)identifier {
    if (!identifier) return;
    NSAssert1([self.allIndicatorLayers.allKeys containsObject:identifier],
              @"Unregistered identifier [%@]", identifier);
    
    NSRange range = [self shouldDrawRange];
    NSRange calculatedRange = [self shouldCalculatedRange];
    
    PKIndicatorBaseLayer *layer = [self getIndicatorLayerWithIdentifier:identifier];
    if ([layer conformsToProtocol:@protocol(PKIndicatorMajorProtocol)]) {
        if (self.set.pinchIntoLineCleared && _pinchBrokenLineEnabling) {
            return [layer removeFromSuperlayer];
        }
        if ([identifier isEqualToString:self.currentMajorIndicatorIdentifier]) return;
        [self clearIndicatorLayerWithIdentifier:self.currentMajorIndicatorIdentifier];
        _currentMajorIndicatorIdentifier = identifier;
        [self drawMajorIndicatorChartWithRange:range calculateRange:calculatedRange];
    }
    
    if ([layer conformsToProtocol:@protocol(PKIndicatorMinorProtocol)]) {
        if ([identifier isEqualToString:self.currentMinorIndicatorIdentifier]) return;
        [self clearIndicatorLayerWithIdentifier:self.currentMinorIndicatorIdentifier];
        _currentMinorIndicatorIdentifier = identifier;
        [self drawMinorIndicatorChartWithRange:range calculateRange:calculatedRange];
    }
}

- (void)clearIndicatorWithIdentifier:(NSString *)identifier {
    if (!identifier) return;
    NSAssert1([self.allIndicatorLayers.allKeys containsObject:identifier],
              @"Unregistered identifier [%@]", identifier);
    
    if (![identifier isEqualToString:self.currentMinorIndicatorIdentifier] &&
        ![identifier isEqualToString:self.currentMajorIndicatorIdentifier]) return;
        
    PKIndicatorBaseLayer *layer = [self getIndicatorLayerWithIdentifier:identifier];
    if ([layer conformsToProtocol:@protocol(PKIndicatorMajorProtocol)]) {
        [self clearIndicatorLayerWithIdentifier:_currentMajorIndicatorIdentifier];
        _currentMajorIndicatorIdentifier = nil;
    }
    
    if ([layer conformsToProtocol:@protocol(PKIndicatorMinorProtocol)]) {
        [self clearIndicatorLayerWithIdentifier:_currentMinorIndicatorIdentifier];
        _currentMinorIndicatorIdentifier = nil;
    }
    
    [self _updateChart];
}

- (void)registerClass:(Class)aClass forIndicatorIdentifier:(NSString *)identifier {
    if (!aClass || !identifier) return;
    NSParameterAssert([aClass isSubclassOfClass:[PKIndicatorBaseLayer class]]);

    NSAssert2([aClass conformsToProtocol:@protocol(PKIndicatorMajorProtocol)] ||
              [aClass conformsToProtocol:@protocol(PKIndicatorMinorProtocol)],
              @"Invalid parameter not satisfying: [%@ conformsToProtocol:@protocol(PKIndicatorMajorProtocol)] || [%@ conformsToProtocol:@protocol(PKIndicatorMinorProtocol)]", NSStringFromClass(aClass), NSStringFromClass(aClass));
    
    NSAssert1(!([aClass conformsToProtocol:@protocol(PKIndicatorMinorProtocol)] &&
                [aClass conformsToProtocol:@protocol(PKIndicatorMajorProtocol)]), @"[%@ <PKIndicatorMajorProtocol, PKIndicatorMinorProtocol>] You should choose one of the protocols to use!!!", NSStringFromClass(aClass));
    
    if ([aClass conformsToProtocol:@protocol(PKIndicatorMajorProtocol)]) {
        NSParameterAssert([aClass instancesRespondToSelector:@selector(drawMajorChartInRange:)]);
        NSParameterAssert([aClass instancesRespondToSelector:@selector(majorChartPeakValue:forRange:)]);
    }
    
    if ([aClass conformsToProtocol:@protocol(PKIndicatorMinorProtocol)]) {
        NSParameterAssert([aClass instancesRespondToSelector:@selector(drawMinorChartInRange:)]);
        NSParameterAssert([aClass instancesRespondToSelector:@selector(minorChartPeakValueForRange:)]);
        NSParameterAssert([aClass instancesRespondToSelector:@selector(minorChartTrellisForPeakValue:path:)]);
    }
    
    [self.allIndicatorLayers setObject:[aClass layer] forKey:identifier];
}

- (nullable PKIndicatorBaseLayer *)getIndicatorLayerWithIdentifier:(NSString *)identifier {
    PKIndicatorBaseLayer *layer = [self.allIndicatorLayers objectForKey:identifier];
    if (layer && !layer.superlayer) {
        [self.contentChartLayer addSublayer:layer];
    }
    return layer;
}

- (void)clearIndicatorLayerWithIdentifier:(NSString *)identifier {
    PKIndicatorBaseLayer *layer = [self.allIndicatorLayers objectForKey:identifier];
    if (!layer || !layer.superlayer) return;
    [layer removeFromSuperlayer];
}

- (NSMutableDictionary<NSString *,PKIndicatorBaseLayer *> *)allIndicatorLayers {
    if (!_allIndicatorLayers) {
        _allIndicatorLayers = [NSMutableDictionary dictionary];
    }
    return _allIndicatorLayers;
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
    
    UIPinchGestureRecognizer *pinchScale = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchScale:)];
    pinchScale.delegate = self;
    [self addGestureRecognizer:pinchScale];
}

- (void)singleTap:(UITapGestureRecognizer *)g {
    CGPoint p = [g locationInView:g.view];
    if (CGRectContainsPoint(self.majorChartFrame, p)) {
        if ([self.delegate respondsToSelector:@selector(klineChart:didSingleTapAtRegionType:)]) {
            [self.delegate klineChart:self didSingleTapAtRegionType:PKChartRegionTypeMajor];
        }
    }
    if (CGRectContainsPoint(self.minorChartFrame, p)) {
        if ([self.delegate respondsToSelector:@selector(klineChart:didSingleTapAtRegionType:)]) {
            [self.delegate klineChart:self didSingleTapAtRegionType:PKChartRegionTypeMinor];
        }
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)g {
    CGPoint p = [g locationInView:g.view];
    if (CGRectContainsPoint(self.majorChartFrame, p)) {
        if ([self.delegate respondsToSelector:@selector(klineChart:didDoubleTapAtRegionType:)]) {
            [self.delegate klineChart:self didDoubleTapAtRegionType:PKChartRegionTypeMajor];
        }
    }
    if (CGRectContainsPoint(self.minorChartFrame, p)) {
        if ([self.delegate respondsToSelector:@selector(klineChart:didDoubleTapAtRegionType:)]) {
            [self.delegate klineChart:self didDoubleTapAtRegionType:PKChartRegionTypeMinor];
        }
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)g {
    if (!self.dataList.count) return;
    switch (g.state) {
        case UIGestureRecognizerStateBegan: {
            if ([self.delegate respondsToSelector:@selector(klineChartWillLongPress:)]) {
                [self.delegate klineChartWillLongPress:self];
            }
            [self.crosshairView present];
            CGPoint p = [g locationInView:self];
            [self crosshairLocationUpdated:p];
        } break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            [self.crosshairView dismissDelay:self.set.crossLineHiddenDuration];
            
            if ([self.delegate respondsToSelector:@selector(klineChartEndLongPress:)]) {
                [self.delegate klineChartEndLongPress:self];
            }
        } break;
        case UIGestureRecognizerStateChanged: {
            CGPoint p = [g locationInView:self];
            [self crosshairLocationUpdated:p];
        } break;
        default: break;
    }
}

- (void)crosshairLocationUpdated:(CGPoint)location {
    CGPoint p = CGPointMake(location.x - self.contentChartFrame.origin.x,
                            location.y - self.contentChartFrame.origin.y);
    CGPoint point = [self.scrollView convertPoint:p fromView:self];
    NSInteger index = CGMakeXindexBlock(self.set.shapeWidth, self.set.shapeGap, self.dataList.count, point.x);
    NSRange rangg = [self shouldCalculatedRange];
    index = MIN(NSMaxRange(rangg) - 1, MAX(index, rangg.location));
    if ([self.delegate respondsToSelector:@selector(klineChart:didLongPressAtCorrespondIndex:)]) {
        [self.delegate klineChart:self didLongPressAtCorrespondIndex:index];
    }
    
    if (!self.set.showCrossLineOnLongPress) return;
    
    id<PKKLineChartProtocol>obj = self.dataList[index];
    NSString *concordanceText = self.makeDateTextCallback(obj, YES);
    _crosshairView.verticalBottomText = [concordanceText stringByAppendingString:self.set.crossSuffixText?:@""];
    
    NSRange calculatedRange = [self shouldCalculatedRange];
    CGPeakValue peakValue = [self getPeakValueAtRange:calculatedRange];
    PKIndicatorBaseLayer *baseLayer = [self getIndicatorLayerWithIdentifier:self.currentMajorIndicatorIdentifier];
    PKIndicatorBaseLayer<PKIndicatorMajorProtocol> *layer = (id)baseLayer;
    CGPeakValue peak = [layer majorChartPeakValue:peakValue forRange:calculatedRange];
    if (!CGPeakValueEqualToPeakValue(CGPeakValueZero, peak)) peakValue = peak;
    CGPeakValue enlargedPeakValue = [self peakValueEnlarged:peakValue];
    
    PKIndicatorBaseLayer *baseLayer1 = [self getIndicatorLayerWithIdentifier:self.currentMinorIndicatorIdentifier];
    PKIndicatorBaseLayer<PKIndicatorMinorProtocol> *layer1 = (id)baseLayer1;
    
    CGFloat centerX = [self getCenterXInBaseViewForIndex:index];
    if (self.set.crossLineConstrained) {
        CGMakeYaxisBlock originYCallback = CGMakeYaxisBlockCreator(enlargedPeakValue, self.majorChartFrame);
        CGFloat centerY = originYCallback(obj.pk_kClosePrice) - self.contentChartFrame.origin.y;
        _crosshairView.horizontalLeftText = [NSNumber pk_stringWithDigits:@(obj.pk_kClosePrice) keepPlaces:self.set.decimalKeepPlace];
       
        [_crosshairView updateContentsInCenter:CGPointMake(centerX, centerY) touched:p];
    } else {
        if (CGRectContainsPoint(self.majorChartFrame, location)) {
            CGFloat value = CGMakeYnumberBlock(enlargedPeakValue, self.majorChartFrame, location.y);
            _crosshairView.horizontalLeftText = [NSNumber pk_trillionStringWithDigits:@(value) keepPlaces:self.set.decimalKeepPlace];
        }
        
        if (CGRectContainsPoint(self.minorChartFrame, location)) {
            CGPeakValue peakValue = [layer1 minorChartPeakValueForRange:calculatedRange];
            CGFloat value = CGMakeYnumberBlock(peakValue, self.minorChartFrame, location.y);
            if ([self.currentMinorIndicatorIdentifier isEqualToString:PKIndicatorVOL]) {
                _crosshairView.horizontalLeftText = [NSNumber pk_trillionStringWithDigits:@(value) keepPlaces:self.set.decimalKeepPlace];
            } else {
                _crosshairView.horizontalLeftText = [NSNumber pk_stringWithDigits:@(value) keepPlaces:self.set.decimalKeepPlace];
            }
        }
        
        [_crosshairView updateContentsInCenter:CGPointMake(centerX, p.y) touched:p];
    }
    
    if ([self.delegate respondsToSelector:@selector(klineChart:didTapTipAtCorrespondIndex:)]) {
        __weak typeof(self) _wself = self;
        _crosshairView.verticalTextClicked = ^(void) {
            __strong typeof(self) _sself = _wself;
            [_sself.delegate klineChart:_sself didTapTipAtCorrespondIndex:index];
        };
    }
    
    if ([layer respondsToSelector:@selector(majorChartAttributedTextForIndex:)]) {
        NSAttributedString *attributedText = [layer majorChartAttributedTextForIndex:index];
        _majorLegendLabel.attributedText = attributedText;
    }
    
    if ([layer1 respondsToSelector:@selector(minorChartAttributedTextForIndex:)]) {
        NSAttributedString *attributedText = [layer1 minorChartAttributedTextForIndex:index];
        _minorLegendLabel.attributedText = attributedText;
    }
}

- (void)pinchScale:(UIPinchGestureRecognizer *)g {
    switch (g.state) {
        case UIGestureRecognizerStateBegan: {
            self.scrollView.scrollEnabled = NO;
            if (!_previousScale) return;
            if ([self.delegate respondsToSelector:@selector(klineChartWillPinch:)]) {
                [self.delegate klineChartWillPinch:self];
            }
            g.scale = _previousScale;
            CGPoint p = [g locationInView:self];
            CGPoint pinchCenter = [self.scrollView convertPoint:p fromView:self];
            _pinchCenterIndex = CGMakeXindexBlock(self.set.shapeWidth, self.set.shapeGap, self.dataList.count, pinchCenter.x);
            _pinchCenterOffsetOfVisual = [self getCenterXInBaseViewForIndex:_pinchCenterIndex];
        } break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            self.scrollView.scrollEnabled = (self.scrollView.contentSize.width > self.contentChartFrame.size.width);
            _previousScale = g.scale;
            
            if ([self.delegate respondsToSelector:@selector(klineChartEndPinch:)]) {
                [self.delegate klineChartEndPinch:self];
            }
        } break;
        case UIGestureRecognizerStateChanged: {
            self.scrollView.scrollEnabled = NO;
            if (!_previousScale) return;
            CGFloat factor = g.scale / _previousScale;
            _previousScale = g.scale;
            NSUInteger number = round(self.set.numberOfVisible / factor);
            [self updateChartForPinchScaleVisible:number];
        } break;
        default: break;
    }
}

- (void)updateChartForPinchScaleVisible:(NSUInteger)number {
    if (self.set.pinchIntoLineEnabled && number > self.set.maxNumberOfVisible) { // into linear state
        NSInteger maxVisible = self.set.maxNumberOfVisible + self.set.pinchIntoNumberOfScale;
        if (number == self.set.numberOfVisible || number > maxVisible) return;
        
        if (!_pinchBrokenLineEnabling) {
            [self pinchBrokenLineEnabled:YES];
        }
        _pinchBrokenLineEnabling = YES;
        [self pinchScaleUpdateChart:number];
    } else {
        if (_pinchBrokenLineEnabling) {
            [self pinchBrokenLineEnabled:NO];
        }
        _pinchBrokenLineEnabling = NO;
    }
    
    if (number == self.set.numberOfVisible ||
        number > self.set.maxNumberOfVisible ||
        number < self.set.minNumberOfVisible) return; // avoid repeated drawing
    [self pinchScaleUpdateChart:number];
}

- (void)pinchScaleUpdateChart:(NSInteger)number {
    self.set.numberOfVisible = number;
    [self shapeWidthUpdate:self.set.numberOfVisible];
    // calculate the offset position, according to '_pinchCenterIndex'
    CGFloat centerX = CGMakeXaxisBlockCreator(self.set.shapeWidth, self.set.shapeGap)(_pinchCenterIndex);
    CGFloat offsetX = centerX - _pinchCenterOffsetOfVisual;
    offsetX = MIN(self.maxScrollOffsetX, MAX(self.minScrollOffsetX, offsetX));
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
    NSRange calculatedRange = [self shouldCalculatedRange];
    NSInteger index = MAX(0, NSMaxRange(calculatedRange) - 1);
    if ([self.delegate respondsToSelector:@selector(klineChart:didPinchAtVisibleLatestIndex:)]) {
        [self.delegate klineChart:self didPinchAtVisibleLatestIndex:index];
    }
    [self _updateChart];
}

- (void)pinchBrokenLineEnabled:(BOOL)enabled {
    disable_animations(^{
        self.KLineRiseLayer.hidden = enabled;
        self.KLineFallLayer.hidden = enabled;
        self.KLineFlatLayer.hidden = enabled;
        self.KBrokenLineLayer.hidden = !enabled;

        if (self.set.pinchIntoLineCleared) {
            if (enabled) {
                self->_clearMajorIndicatorIdentifier = self.currentMajorIndicatorIdentifier;
                [self clearIndicatorLayerWithIdentifier:self->_currentMajorIndicatorIdentifier]; // clear
                self->_currentMajorIndicatorIdentifier = nil;
            } else {
                self->_currentMajorIndicatorIdentifier = self->_clearMajorIndicatorIdentifier; // restore
                [self _updateChart];
            }
        }
    });
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (self.crosshairView.isPresenting) {
            [self.crosshairView dismiss];
            return NO;
        }
    }
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        [self.crosshairView dismiss];
        return YES;
    }
    CGPoint p = [gestureRecognizer locationInView:self];
    return CGRectContainsPoint(self.crosshairView.frame, p) && !CGRectContainsPoint(self.separatedFrame, p) && !CGRectContainsPoint(self.minorLegendLabel.frame, p);
}

#pragma mark - Timelines separated

- (void)doTimelinesSeparated:(NSRange)range {
    _makeDateTextCallback = NULL;
    [self.allTimelineIndexSets removeAllIndexes];
    
    if (self.makeTimelineIndexSets && self.makeTimelineIndexSets(self.set.period, range)) {
        [self.allTimelineIndexSets addIndexes:self.makeTimelineIndexSets(self.set.period, range)];
        NSAssert(self.makeDateTextCallback,
                 @"Implementing the '-makeTimelineIndexSets' must also implement the '-makeDateTextCallback'!");
        return;
    }
    
    switch (self.set.period) {
        case PKKLineChartPeriodDay: {
            id<PKKLineChartProtocol>obj = [self.dataList pk_firstObjAtRange:range];
            __block NSInteger marked = obj.pk_kDateTime.pk_month;
            [self.dataList pk_enumerateObjsAtRange:range ceaselessBlock:^(id<PKKLineChartProtocol>  _Nonnull obj, NSUInteger idx) {
                NSInteger month = obj.pk_kDateTime.pk_month;
                if (month && marked != month) { marked = month;
                    [self.allTimelineIndexSets addIndex:idx];
                }
            }];
            
            self.makeDateTextCallback = ^NSString *(id<PKKLineChartProtocol> obj, BOOL isPressed) {
                NSString *formatter = isPressed ? PKChartDateFormat_yMd : PKChartDateFormat_yM;
                return [NSDate pk_stringFromDate:obj.pk_kDateTime formatter:formatter];
            };
        } break;
            
        case PKKLineChartPeriodWeek:
        case PKKLineChartPeriodMonth: {
            id<PKKLineChartProtocol>obj = [self.dataList pk_firstObjAtRange:range];
            __block NSInteger marked = obj.pk_kDateTime.pk_quarter;
            [self.dataList pk_enumerateObjsAtRange:range ceaselessBlock:^(id<PKKLineChartProtocol>  _Nonnull obj, NSUInteger idx) {
                NSInteger quarter = obj.pk_kDateTime.pk_quarter;
                if (quarter && marked != quarter) { marked = quarter;
                    [self.allTimelineIndexSets addIndex:idx];
                }
            }];
            
            self.makeDateTextCallback = ^NSString *(id<PKKLineChartProtocol> obj, BOOL isPressed) {
                NSString *formatter = isPressed ? PKChartDateFormat_yMd : PKChartDateFormat_yM;
                return [NSDate pk_stringFromDate:obj.pk_kDateTime formatter:formatter];
            };
        } break;
            
        case PKKLineChartPeriodQuarter:
        case PKKLineChartPeriodYear: {
            id<PKKLineChartProtocol>obj = [self.dataList pk_firstObjAtRange:range];
            __block NSInteger marked = obj.pk_kDateTime.pk_year;
            [self.dataList pk_enumerateObjsAtRange:range ceaselessBlock:^(id<PKKLineChartProtocol>  _Nonnull obj, NSUInteger idx) {
                NSInteger year = obj.pk_kDateTime.pk_year;
                if (year && marked != year) { marked = year;
                    [self.allTimelineIndexSets addIndex:idx];
                }
            }];
            
            self.makeDateTextCallback = ^NSString *(id<PKKLineChartProtocol> obj, BOOL isPressed) {
                NSString *formatter = isPressed ? PKChartDateFormat_yMd : PKChartDateFormat_y;
                return [NSDate pk_stringFromDate:obj.pk_kDateTime formatter:formatter];
            };
        } break;
            
        case PKKLineChartPeriodMin1: {
            [self doTimelineSets:range interval:15];
        } break;
            
        case PKKLineChartPeriodMin5: {
            [self doTimelineSets:range interval:12];
        } break;
            
        case PKKLineChartPeriodMin15: {
            [self doTimelineSets:range interval:11];
        } break;
            
        case PKKLineChartPeriodMin30:
        case PKKLineChartPeriodMin60:
        case PKKLineChartPeriodMin120: {
            id<PKKLineChartProtocol>obj = [self.dataList pk_firstObjAtRange:range];
            __block NSInteger marked = obj.pk_kDateTime.pk_day;
            [self.dataList pk_enumerateObjsAtRange:range ceaselessBlock:^(id<PKKLineChartProtocol>  _Nonnull obj, NSUInteger idx) {
                NSInteger day = obj.pk_kDateTime.pk_day;
                if (day && marked != day) { marked = day;
                    [self.allTimelineIndexSets addIndex:idx];
                }
            }];
            
            self.makeDateTextCallback = ^NSString *(id<PKKLineChartProtocol> obj, BOOL isPressed) {
                NSString *formatter = isPressed ? PKChartDateFormat_MdHm : PKChartDateFormat_Md;
                return [NSDate pk_stringFromDate:obj.pk_kDateTime formatter:formatter];
            };
        } break;

        default: break;
    }
}

static const void *PKObjectAssociatedDateSepKey = &PKObjectAssociatedDateSepKey;

- (void)doTimelineSets:(NSRange)range interval:(NSInteger)interval {
    if (!interval) return;
    NSInteger length = NSMaxRange(range);
    for (NSInteger idx = range.location + interval/2; idx < length; idx+=interval) {
        [self.allTimelineIndexSets addIndex:idx];
    }
    
    id<PKKLineChartProtocol>obj = [self.dataList pk_firstObjAtRange:range];
    __block NSInteger marked = obj.pk_kDateTime.pk_day;
    [self.dataList pk_enumerateObjsAtRange:range ceaselessBlock:^(id<PKKLineChartProtocol>  _Nonnull obj, NSUInteger idx) {
        NSInteger day = obj.pk_kDateTime.pk_day;
        if (day && marked != day) { marked = day;
            objc_setAssociatedObject(obj, PKObjectAssociatedDateSepKey, @(day), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self.allTimelineIndexSets addIndex:idx];
        }
    }];
    
    self.makeDateTextCallback = ^NSString *(id<PKKLineChartProtocol> obj, BOOL isPressed) {
        if (objc_getAssociatedObject(obj, PKObjectAssociatedDateSepKey)) {
            NSString *formatter = isPressed ? PKChartDateFormat_MdHm : PKChartDateFormat_Md;
            return [NSDate pk_stringFromDate:obj.pk_kDateTime formatter:formatter];
        }
        NSString *formatter = isPressed ? PKChartDateFormat_MdHm : PKChartDateFormat_Hm;
        return [NSDate pk_stringFromDate:obj.pk_kDateTime formatter:formatter];
    };
}

#pragma mark - Utilities

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

- (CGFloat)getCenterXInBaseViewForIndex:(NSInteger)index {
    CGFloat centerX = CGMakeXaxisBlockCreator(self.set.shapeWidth, self.set.shapeGap)(index);
    centerX -= self.scrollView.contentOffset.x;
    return centerX;
}

- (NSRange)shouldDrawRange {
    CGFloat currentOffsetX = self.scrollView.contentOffset.x - self.scrollView.frame.origin.x;
    CGFloat gapAndWidth = self.set.shapeWidth + self.set.shapeGap;
    NSInteger index = (NSInteger)round(currentOffsetX / gapAndWidth);
    NSUInteger length = self.set.numberOfVisible;
    index -= 1; length += 2; // draw two more lines for a smooth transition.
    NSUInteger dataCount = self.dataList.count;
    index = MIN(dataCount, MAX(0, index));
    NSRange range = NSMakeRange(index, length);
    if (NSMaxRange(range) > dataCount) range.length = dataCount - range.location;
    return range;
}

- (NSRange)shouldCalculatedRange {
    CGFloat currentOffsetX = self.scrollView.contentOffset.x - self.scrollView.frame.origin.x;
    CGFloat gapAndWidth = self.set.shapeWidth + self.set.shapeGap;
    NSInteger index = (NSInteger)round(currentOffsetX / gapAndWidth);
    NSUInteger dataCount = self.dataList.count;
    index = MIN(dataCount, MAX(0, index));
    NSRange range = NSMakeRange(index, self.set.numberOfVisible);
    if (NSMaxRange(range) > dataCount) range.length = dataCount - range.location;
    if (self.scrollView.contentOffset.x < 0 &&
        self.scrollView.contentSize.width > self.contentChartFrame.size.width) {
        range.length -= (NSInteger)round(fabs(self.scrollView.contentOffset.x) / gapAndWidth);
    }
    return range;
}

- (CGIndexPeakValue)getIndexPeakValueAtRange:(NSRange)range {
    if (self.dataList.count) {
        __block CGIndexValue min = CGIndexValueMake(0, CGFLOAT_MAX);
        __block CGIndexValue max = CGIndexValueMake(0, -CGFLOAT_MAX);
        if (_pinchBrokenLineEnabling) {
            [self.dataList pk_enumerateObjsAtRange:range ceaselessBlock:^(id<PKKLineChartProtocol>  _Nonnull obj, NSUInteger idx) {
                if (obj.pk_kClosePrice > max.value) max = CGIndexValueMake(idx, obj.pk_kClosePrice);
                if (obj.pk_kClosePrice < min.value) min = CGIndexValueMake(idx, obj.pk_kClosePrice);
            }];
        } else {
            [self.dataList pk_enumerateObjsAtRange:range ceaselessBlock:^(id<PKKLineChartProtocol>  _Nonnull obj, NSUInteger idx) {
                if (obj.pk_kHighPrice > max.value) max = CGIndexValueMake(idx, obj.pk_kHighPrice);
                if (obj.pk_kLowPrice < min.value) min = CGIndexValueMake(idx, obj.pk_kLowPrice);
            }];
        }
        return CGIndexPeakValueMake(max, min);
    }
    return CGIndexPeakValueZero;
}

- (CGPeakValue)getPeakValueAtRange:(NSRange)range {
    CGIndexPeakValue _pathValue = [self getIndexPeakValueAtRange:range];
    return CGPeakValueMake(_pathValue.max.value, _pathValue.min.value);
}

- (CGPeakValue)peakValueEnlarged:(CGPeakValue)peakValue {
    if (self.dataList.count) {
        CGFloat factor = CGPeakValueGetDistance(peakValue) / self.majorChartFrame.size.height;
        CGFloat enlarged = self.set.peakTaggedEdgePadding * factor;
        return CGPeakValueMake(peakValue.max + enlarged, peakValue.min - enlarged);
    }
    return CGPeakValueZero;
}

@end

@implementation PKKLineChart (SlideOperation)

- (BOOL)canSlideToLeftOnce {
    NSRange visibleRange = [self shouldCalculatedRange];
    return visibleRange.location > 0 ? YES : NO;
}

- (BOOL)canSlideToRightOnce {
    NSRange visibleRange = [self shouldCalculatedRange];
    return NSMaxRange(visibleRange) < self.dataList.count ? YES : NO;
}

- (void)slideToLeftOnce {
    if ([self canSlideToLeftOnce]) {
        NSRange visibleRange = [self shouldCalculatedRange];
        NSInteger nextIndex = visibleRange.location - 1;
        CGMakeXaxisBlock axisXBlock = CGMakeXaxisBlockCreator(self.set.shapeWidth, self.set.shapeGap);
        CGFloat origixX = axisXBlock(nextIndex) - half(self.set.shapeWidth);
        [self.scrollView setContentOffset:CGPointMake(origixX, 0) animated:NO];
        [self _updateChart];
    }
}

- (void)slideToRightOnce {
    if ([self canSlideToRightOnce]) {
        NSRange visibleRange = [self shouldCalculatedRange];
        NSInteger nextIndex = visibleRange.location + 1;
        CGMakeXaxisBlock axisXBlock = CGMakeXaxisBlockCreator(self.set.shapeWidth, self.set.shapeGap);
        CGFloat origixX = axisXBlock(nextIndex) - half(self.set.shapeWidth);
        [self.scrollView setContentOffset:CGPointMake(origixX, 0) animated:NO];
        [self _updateChart];
    }
}

@end

@implementation PKKLineChart (ScaleOperation)

- (BOOL)canSmallOnce {
    NSInteger maxVisibleCount = self.set.maxNumberOfVisible;
    if (self.set.pinchIntoLineEnabled) { // 允许进入折线状态
        maxVisibleCount += self.set.pinchIntoNumberOfScale; // 折线状态最大数量
    }
    return self.set.numberOfVisible < maxVisibleCount ? YES : NO;
}

- (BOOL)canLargeOnce {
    return (self.set.numberOfVisible > self.set.minNumberOfVisible) ? YES : NO;
}

- (void)doSmallScaleOnce {
    if ([self canSmallOnce]) {
        [self.crosshairView dismiss];
        CGPoint p = [self.scrollView convertPoint:self.center fromView:self];
        _pinchCenterIndex = CGMakeXindexBlock(self.set.shapeWidth, self.set.shapeGap, self.dataList.count, p.x);
        _pinchCenterOffsetOfVisual = [self getCenterXInBaseViewForIndex:_pinchCenterIndex];
        NSInteger number = self.set.numberOfVisible + 1;
        [self updateChartForPinchScaleVisible:number];
    }
}

- (void)doLargeScaleOnce {
    if ([self canLargeOnce]) {
        [self.crosshairView dismiss];
        CGPoint p = [self.scrollView convertPoint:self.center fromView:self];
        _pinchCenterIndex = CGMakeXindexBlock(self.set.shapeWidth, self.set.shapeGap, self.dataList.count, p.x);
        _pinchCenterOffsetOfVisual = [self getCenterXInBaseViewForIndex:_pinchCenterIndex];
        NSInteger number = self.set.numberOfVisible - 1;
        [self updateChartForPinchScaleVisible:number];
    }
}

@end

@implementation PKKLineChart (LoadingOperation)

- (void)endPullLoading {
    self.pullLoadingView.loadingInRect = CGRectZero;
    [self.pullLoadingView endLoading];
}

@end
