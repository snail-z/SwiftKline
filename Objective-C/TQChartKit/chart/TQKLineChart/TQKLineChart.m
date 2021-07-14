//
//  TQKLineChart.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/26.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQKLineChart.h"
#import "TQKLineChart+Calculator.h"
#import "TQIndicatorCalculator.h"
#import "TQChartDateManager.h"
#import "TQIndicatorMALayer.h"
#import "TQStockChartConst.h"

@interface TQKLineChart () <UIGestureRecognizerDelegate>

/** 网格水平坐标轴(KLine区域) */
@property (nonatomic, strong) CAShapeLayer *gridKlineLayer;

/** 网格水平坐标轴(Indicator区域) */
@property (nonatomic, strong) CAShapeLayer *gridIndicatorLayer;

/** 网格垂直时间轴(日期线) */
@property (nonatomic, strong) CAShapeLayer *gridDateLayer;

/** 网格边框线 */
@property (nonatomic, strong) CAShapeLayer *gridBorderLayer;

/** 网格水平坐标轴文本(KLine区域) */
@property (nonatomic, strong) TQChartTextLayer *gridKlineTextLayer;

/** 网格水平坐标轴文本(Indicator区域) */
@property (nonatomic, strong) TQChartTextLayer *gridIndicatorTextLayer;

/** 网格垂直时间轴文本(日期文本) */
@property (nonatomic, strong) TQChartTextLayer *gridDateTextLayer;

/** K线蜡烛图涨 */
@property (nonatomic, strong) CAShapeLayer *riseKlineLayer;

/** K线蜡烛图跌 */
@property (nonatomic, strong) CAShapeLayer *fallKlineLayer;

/** K线蜡烛图平 */
@property (nonatomic, strong) CAShapeLayer *flatKlineLayer;

/** 移动平均线 */
@property (nonatomic, strong) TQIndicatorMALayer *KLineMALayer;

/** 最大值标记线 */
@property (nonatomic, strong) CAShapeLayer *peakMaxLineLayer;

/** 最小值标记线 */
@property (nonatomic, strong) CAShapeLayer *peakMinLineLayer;

/** 最大最小值标记文本 */
@property (nonatomic, strong) TQChartTextLayer *peakValueTextLayer;

/** 十字查价框视图 */
@property (nonatomic, strong) TQChartCrossLineView *crossLineView;

/** K线区域说明文本 */
@property (nonatomic, strong) UILabel *refKlineTextLabel;

/** 指标区域说明文本 */
@property (nonatomic, strong) UILabel *refIndicatorTextLabel;

/** 记录加载更多后的数据 */
@property (nonatomic, weak) NSArray *earlierArray;

/** 用于存储所有日期标记的索引集 */
@property (nonatomic, strong) NSMutableIndexSet *allDateFlagIndexSet;

/** 用于计算日期时间的回调 */
@property (nonatomic, copy) NSString *(^dateTextCallback)(id<TQKlineChartProtocol> obj);

/** 用于存储所有指标类型的索引集 */
@property (nonatomic, strong) NSMutableIndexSet *allIndexTypeIndexSet;

/** 用于存储所有指标layer的集合 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, TQIndicatorBaseLayer *> *indicatorLayers;

/** 指标计算器 */
@property (nonatomic, strong) TQIndicatorCalculator *calculator;
@property (nonatomic, copy) CGaxisXConverBlock axisXCallback;
@property (nonatomic, copy) CGaxisYConverBlock axisYCallback;

@end

@implementation TQKLineChart {
    CGFloat _previousScale;
    NSInteger _pinchCenterIndex;
    CGFloat _pinchCenterOffsetOfVisual;
}

- (void)_commonInitialization {
    _previousScale = 1;
    _indicatorIdentifier = TQIndicatorVOL;
    _calculator = [TQIndicatorCalculator new];
    _style = [TQKLineChartStyle defaultStyle];
    _indicatorStyles = [TQIndicatorChartStyle defaultStyle];
}

- (void)_sublayerInitialization {
    _gridKlineLayer = [CAShapeLayer layer];
    [self.contentGridLayer addSublayer:_gridKlineLayer];
    
    _gridIndicatorLayer = [CAShapeLayer layer];
    [self.contentGridLayer addSublayer:_gridIndicatorLayer];
    
    _gridBorderLayer = [CAShapeLayer layer];
    [self.contentGridLayer addSublayer:_gridBorderLayer];
    
    _gridKlineTextLayer = [TQChartTextLayer layer];
    [self.contentTextLayer addSublayer:_gridKlineTextLayer];
    
    _gridIndicatorTextLayer = [TQChartTextLayer layer];
    [self.contentTextLayer addSublayer:_gridIndicatorTextLayer];
    
    _gridDateTextLayer = [TQChartTextLayer layer];
    [self.contentChartLayer addSublayer:_gridDateTextLayer];
    
    _gridDateLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_gridDateLayer];
    
    _riseKlineLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_riseKlineLayer];
    
    _fallKlineLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_fallKlineLayer];
    
    _flatKlineLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_flatKlineLayer];
    
    _KLineMALayer = [TQIndicatorMALayer layer];
    [self.contentChartLayer addSublayer:_KLineMALayer];
    
    _peakValueTextLayer = [TQChartTextLayer layer];
    [self.contentChartLayer addSublayer:_peakValueTextLayer];
    
    _peakMaxLineLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_peakMaxLineLayer];
    
    _peakMinLineLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_peakMinLineLayer];
    
    _refKlineTextLabel = [UILabel new];
    [self addSubview:_refKlineTextLabel];
    
    _refIndicatorTextLabel = [UILabel new];
    [self addSubview:_refIndicatorTextLabel];
    
    _crossLineView = [TQChartCrossLineView new];
    _crossLineView.fadeHidden = YES;
    [self addSubview:_crossLineView];
    
    _loadingView = [TQKLineLoadingView new];
    [self.scrollView addSubview:_loadingView];
}

#pragma mark - UpdateSublayers

- (void)updateStyles {
    _gridKlineLayer.fillColor = [UIColor clearColor].CGColor;
    _gridKlineLayer.strokeColor = self.style.gridLineColor.CGColor;
    _gridKlineLayer.lineWidth = self.style.gridLineWidth;
    
    _gridIndicatorLayer.fillColor = _gridKlineLayer.fillColor;
    _gridIndicatorLayer.strokeColor = _gridKlineLayer.strokeColor;
    _gridIndicatorLayer.lineWidth = _gridKlineLayer.lineWidth;
    
    _gridDateLayer.fillColor = _gridKlineLayer.fillColor;
    _gridDateLayer.strokeColor = _gridKlineLayer.strokeColor;
    _gridDateLayer.lineWidth = _gridKlineLayer.lineWidth;
    
    _gridBorderLayer.fillColor = _gridKlineLayer.fillColor;
    _gridBorderLayer.strokeColor = _gridKlineLayer.strokeColor;
    _gridBorderLayer.lineWidth = _gridKlineLayer.lineWidth;
    
    UIColor *riseFillColor = self.style.shouldRiseSolid ? self.style.riseColor : [UIColor clearColor];
    _riseKlineLayer.fillColor = riseFillColor.CGColor;
    _riseKlineLayer.strokeColor = self.style.riseColor.CGColor;
    _riseKlineLayer.lineWidth = self.style.shapeStrokeWidth;
    
    UIColor *fallFillColor = self.style.shouldFallSolid ? self.style.fallColor : [UIColor clearColor];
    _fallKlineLayer.fillColor = fallFillColor.CGColor;
    _fallKlineLayer.strokeColor = self.style.fallColor.CGColor;
    _fallKlineLayer.lineWidth = self.style.shapeStrokeWidth;
    
    UIColor *flatFillColor = self.style.shouldFlatSolid ? self.style.flatColor : [UIColor clearColor];
    _flatKlineLayer.fillColor = flatFillColor.CGColor;
    _flatKlineLayer.strokeColor = self.style.flatColor.CGColor;
    _flatKlineLayer.lineWidth = self.style.shapeStrokeWidth;
    
    _peakMaxLineLayer.fillColor = self.style.peakTextColor.CGColor;
    _peakMaxLineLayer.strokeColor = self.style.peakTextColor.CGColor;
    _peakMaxLineLayer.lineWidth = self.style.peakLineWidth;
    
    _peakMinLineLayer.fillColor = _peakMaxLineLayer.fillColor;
    _peakMinLineLayer.strokeColor = _peakMaxLineLayer.strokeColor;
    _peakMinLineLayer.lineWidth = _peakMaxLineLayer.lineWidth;
}

- (void)updateLayout {
    UIEdgeInsets insets = self.layout.contentEdgeInset;
    insets.left = 0; insets.right = 0;
    CGRect frame1 = CGRectIntegral(UIEdgeInsetsInsetRect(self.bounds, insets));
    [self.layout setValue:[NSValue valueWithCGRect:frame1] forKey:STRINGSEL(contentFrame)];
    CGRect frame2 = self.layout.contentFrame;
    frame2.size.height = MIN(self.layout.topChartHeight, frame2.size.height);
    [self.layout setValue:[NSValue valueWithCGRect:frame2] forKey:STRINGSEL(topChartFrame)];
    CGRect frame3 = self.layout.contentFrame;
    frame3.origin.y = CGRectGetMaxY(self.layout.topChartFrame);
    frame3.size.height = self.layout.separatedGap;
    [self.layout setValue:[NSValue valueWithCGRect:frame3] forKey:STRINGSEL(separatedFrame)];
    CGRect frame4 = self.layout.contentFrame;
    frame4.origin.y = CGRectGetMaxY(self.layout.separatedFrame);
    frame4.size.height = CGRectGetMaxY(self.layout.contentFrame) - frame4.origin.y;
    [self.layout setValue:[NSValue valueWithCGRect:frame4] forKey:STRINGSEL(bottomChartFrame)];
    _refKlineTextLabel.frame = CGRectMake(0, 0, self.layout.contentFrame.size.width, self.layout.contentEdgeInset.top);
    _refIndicatorTextLabel.frame = self.layout.separatedFrame;
    _crossLineView.frame = self.layout.contentFrame;
    _crossLineView.separationRect = CGRectMake(self.layout.contentFrame.origin.x, self.layout.topChartFrame.size.height, self.layout.topChartFrame.size.width, self.layout.separatedGap);
    CGRect paddingFrame = self.layout.topChartFrame;
    paddingFrame.size.width = 35;
    _loadingView.loadingInRect = paddingFrame;
}

- (void)updateShapeWidthByVisualCount:(NSInteger)visualCount {
    CGFloat allGap = (visualCount - 1) * self.style.shapeGap; // calculate the shapeWidth
    CGFloat shapeWidth = (self.layout.topChartFrame.size.width - allGap) / (CGFloat)visualCount;
    [self.style setValue:@(shapeWidth) forKey:NSStringFromSelector(@selector(shapeWidth))];
    CGFloat contentWidth = (self.style.shapeGap + self.style.shapeWidth) * self.dataArray.count - self.style.shapeGap; // calculate the contentSize. scroll range
    self.scrollView.contentSize = CGSizeMake(contentWidth, self.bounds.size.height);
}

- (void)updateScrollOffsetByDataCount:(NSInteger)dataCount {
    // according to new data. calculate the scroll offset
    CGFloat _offsetX = (self.style.shapeGap + self.style.shapeWidth) * dataCount;
    _offsetX -= self.loadingView.loadingInset;
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.x = _offsetX; // calculate the position offset
    [self.scrollView setContentOffset:contentOffset animated:NO];
}

- (void)setDataArray:(NSArray<id<TQKlineChartProtocol>> *)dataArray {
    if (!dataArray) return;
    _dataArray = dataArray;
    self.calculator.dataArray = _dataArray;
}

- (void)insertEarlierDataArray:(NSArray<id<TQKlineChartProtocol>> *)earlierData {
    if (!earlierData) return;
    _earlierArray = earlierData;
    NSMutableArray *array = [NSMutableArray arrayWithArray:earlierData];
    !self.dataArray ?: [array addObjectsFromArray:self.dataArray];
    self.dataArray = array;
    [self updateScrollOffsetByDataCount:earlierData.count];
}

- (void)drawChart {
    if (!self.dataArray) return;
    [self layoutIfNeeded];
    [self updateStyles];
    [self updateLayout];
    [self updateShapeWidthByVisualCount:self.style.numberOfVisual];
    self.earlierArray ?: [self scrollToRight]; // 使视图滚动到最右边
    [self drawGridBorderLines];
    [self _updateChart];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (!self.crossLineView.fadeHidden) {
        self.crossLineView.fadeHidden = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.scrollView.isDragging && !self.scrollView.isDecelerating) return;
    [self _updateChart];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {}

#pragma mark - Draw charts

- (void)_updateChart {
    // 获取计算范围和绘制范围
    NSRange range = [self getVisualRange];
    NSRange calculatedRange = [self getCalculatedRange];
    // 计算极值
    CGPeakIndexValue _calculated = [self getPeakIndexValueWithRange:calculatedRange];
    CGPeakValue peakValue = CGPeakValueMake(_calculated.max.value, _calculated.min.value);
    // 首先计算顶部区域指标，然后重新确定极值
    [self.calculator parseResultRange:calculatedRange byIndicatorIdentifier:TQIndicatorMA];
    _KLineMALayer.cacheModels = self.calculator.cacheManager.allCache;
    // TODO：获取layer
    peakValue = [_KLineMALayer KIndicatorPeakValue:peakValue forRange:calculatedRange]; // richness?
    CGPeakValue _enlarge = [self getEnlargePeakValue:peakValue];
    // 计算坐标控制系统
    self.axisXCallback = CGaxisXConverMaker(self.style.shapeWidth, self.style.shapeGap);
    self.axisYCallback = CGaxisYConverMaker(_enlarge, self.layout.topChartFrame, self.style.gridLineWidth);
    // 绘制图表框架
    [self drawKlineGridWithPeakValue:_enlarge];
    [self drawKlineChartWithRange:range];
    [self drawPeakFlagLines:_calculated];
    [self drawDateGridWithRange:range];
    // 绘制顶部区域指标
    [self drawTopIndicatorChartWithRange:range calculateRange:calculatedRange];
    // 绘制底部区域指标
    [self drawBottomIndicatorChartWithRange:range calculateRange:calculatedRange];
}

- (void)drawGridBorderLines {
    CGFloat minX = CGRectGetMinX(self.layout.contentFrame) + half(self.style.gridLineWidth);
    CGFloat maxX = CGRectGetMaxX(self.layout.contentFrame) - half(self.style.gridLineWidth);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addVerticalLine:CGPointMake(minX, CGRectGetMinY(self.layout.topChartFrame))
                      len:self.layout.topChartFrame.size.height];
    [path addVerticalLine:CGPointMake(maxX, CGRectGetMinY(self.layout.topChartFrame))
                      len:self.layout.topChartFrame.size.height];
    [path addVerticalLine:CGPointMake(minX, CGRectGetMinY(self.layout.bottomChartFrame))
                      len:self.layout.bottomChartFrame.size.height];
    [path addVerticalLine:CGPointMake(maxX, CGRectGetMinY(self.layout.bottomChartFrame))
                      len:self.layout.bottomChartFrame.size.height];
    _gridBorderLayer.path = path.CGPath;
}

- (void)drawKlineGridWithPeakValue:(CGPeakValue)peakValue {
    NSArray<NSString *> *strings = [NSArray arrayWithPartition:self.style.gridSegments peakValue:peakValue];
    CGFloat gap = self.layout.topChartFrame.size.height / (CGFloat)(strings.count - 1);
    CGFloat originY = self.layout.topChartFrame.origin.y + half(self.style.gridLineWidth);
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSMutableArray<TQChartTextRenderer *> *renders = [NSMutableArray array];
    [strings enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint start = CGPointMake(self.layout.topChartFrame.origin.x, originY + gap * idx);
        [path addHorizontalLine:start len:self.layout.topChartFrame.size.width];
        TQChartTextRenderer *render = [TQChartTextRenderer defaultRendererWithText:text];
        render.color = self.style.plainTextColor;
        render.font = self.style.plainTextFont;
        render.positionCenter = start;
        [renders addObject:render];
    }];
    renders.firstObject.offsetRatio = kCGOffsetRatioTopLeft;
    _gridKlineLayer.path = path.CGPath;
    _gridKlineTextLayer.renders = renders;
}

- (void)drawKlineChartWithRange:(NSRange)range {
    UIBezierPath *risePath = [UIBezierPath bezierPath];
    UIBezierPath *fallPath = [UIBezierPath bezierPath];
    UIBezierPath *flatPath = [UIBezierPath bezierPath];
    [self.dataArray enumerateObjsAtRange:range ceaselessBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx) {
        CGFloat highY = self.axisYCallback(obj.tq_high);
        CGFloat lowY = self.axisYCallback(obj.tq_low);
        CGFloat openY = self.axisYCallback(obj.tq_open);
        CGFloat closeY = self.axisYCallback(obj.tq_close);
        CGFloat centerX = self.axisXCallback(idx);
        CGFloat shapeWidth = self.style.shapeWidth - self.style.shapeStrokeWidth;
        CGFloat originX = centerX - half(shapeWidth);
        CGFloat shapeHeight = fabs(openY - closeY);
        CGPoint top = CGPointMake(centerX, highY);
        CGPoint bottom = CGPointMake(centerX, lowY);
        CGRect shapeRect = CGRectMake(originX, MIN(openY, closeY), shapeWidth, shapeHeight);
        CGCandleShape shape = CGCandleShapeMake(top, shapeRect, bottom);
        if (obj.tq_open < obj.tq_close) [risePath addCandleShape:shape];
        else if (obj.tq_open > obj.tq_close) [fallPath addCandleShape:shape];
        else [flatPath addCandleShape:shape];
    }];
    _riseKlineLayer.path = risePath.CGPath;
    _fallKlineLayer.path = fallPath.CGPath;
    _flatKlineLayer.path = flatPath.CGPath;
}

- (void)drawPeakFlagLines:(CGPeakIndexValue)peakIndexValue {
    if (!self.style.peakTaggedInVisual) return;
    CGFloat maxCenterX = self.axisXCallback(peakIndexValue.max.index);
    CGFloat minCenterX = self.axisXCallback(peakIndexValue.min.index);
    CGFloat maxOriginY = self.axisYCallback(peakIndexValue.max.value) - self.style.peakLineOffset.vertical;
    CGFloat minOriginY = self.axisYCallback(peakIndexValue.min.value) + self.style.peakLineOffset.vertical;
    CGFloat middleX = [self convertPoint:CGPointMake(half(self.layout.topChartFrame.size.width), 0) toView:self.scrollView].x;
    NSMutableArray<TQChartTextRenderer *> *renders = [NSMutableArray array];
    UIBezierPath*(^callback)(CGFloat, CGFloat, CGFloat) = ^(CGFloat centerX, CGFloat originY, CGFloat value) {
        CGFloat lineLength = 0;
        CGPoint positionCenter = CGPointZero, offsetRatio = CGPointZero;
        if (centerX < middleX) {
            lineLength += self.style.peakLineLength;
            centerX += self.style.peakLineOffset.horizontal;
            positionCenter = CGPointMake(centerX + lineLength + self.style.peakLineOffset.horizontal, originY);
            offsetRatio = kCGOffsetRatioCenterLeft;
        } else {
            lineLength -= self.style.peakLineLength;
            centerX -= self.style.peakLineOffset.horizontal;
            positionCenter = CGPointMake(centerX + lineLength - self.style.peakLineOffset.horizontal, originY);
            offsetRatio = kCGOffsetRatioCenterRight;
        }
        TQChartTextRenderer *render = [TQChartTextRenderer defaultRendererWithText:TQPlainTextFormat(value)];
        render.color = self.style.peakTextColor;
        render.font = self.style.peakTextFont;
        render.positionCenter = positionCenter;
        render.offsetRatio = offsetRatio;
        [renders addObject:render];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX + lineLength, originY) radius:self.style.peakVertexRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
        [path addHorizontalLine:CGPointMake(centerX , originY) len:lineLength];
        return path;
    };
    UIBezierPath *path1 = callback(maxCenterX, maxOriginY, peakIndexValue.max.value);
    UIBezierPath *path2 = callback(minCenterX, minOriginY, peakIndexValue.min.value);
    _peakMaxLineLayer.path = path1.CGPath;
    _peakMinLineLayer.path = path2.CGPath;
    _peakValueTextLayer.renders = renders;
}

- (void)drawDateGridWithRange:(NSRange)range {
    [self makeUpdateDateFlagCallback];
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSMutableArray<TQChartTextRenderer *> *renders = [NSMutableArray array];
    [self.allDateFlagIndexSet enumerateIndexesInRange:range options:kNilOptions usingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        id<TQKlineChartProtocol>obj = self.dataArray[idx];
        CGFloat centerX = self.axisXCallback(idx);
        CGPoint p = CGPointMake(centerX,  CGRectGetMaxY(self.layout.contentFrame));
        [path addVerticalLine:CGPointMake(centerX, CGRectGetMinY(self.layout.topChartFrame)) len:self.layout.topChartFrame.size.height];
        [path addVerticalLine:CGPointMake(centerX, CGRectGetMinY(self.layout.bottomChartFrame)) len:self.layout.bottomChartFrame.size.height];
        NSString *text = [TQChartDateManager.sharedManager stringFromDate:obj.tq_date dateFormat:TQPlainDaysKDateFormatter];
        TQChartTextRenderer *render = [TQChartTextRenderer defaultRendererWithText:text];
        render.color = self.style.plainTextColor;
        render.font = self.style.plainTextFont;
        render.offsetRatio = kCGOffsetRatioCenter;
        render.baseOffset = UIOffsetMake(0, self.layout.contentEdgeInset.bottom * 0.5);
        render.positionCenter = p;
        [renders addObject:render];
    }];
    _gridDateLayer.path = path.CGPath;
    _gridDateTextLayer.renders = renders;
}

- (void)drawTopIndicatorChartWithRange:(NSRange)range calculateRange:(NSRange)calculateRange {
    _KLineMALayer.dataArray = self.dataArray;
    _KLineMALayer.plotter = CGChartPlotterMake(self.style.shapeWidth, self.style.shapeGap, self.style.shapeStrokeWidth, self.layout.topChartFrame);
    _KLineMALayer.styles = self.indicatorStyles;
    _KLineMALayer.axisXCallback = self.axisXCallback;
    _KLineMALayer.axisYCallback = self.axisYCallback;
    [_KLineMALayer updateChartInRange:range];
    _refKlineTextLabel.attributedText = [_KLineMALayer KIndicatorAttributedTextForRange:calculateRange];
}

- (void)drawBottomIndicatorChartWithRange:(NSRange)range calculateRange:(NSRange)calculateRange {
    [self.calculator parseResultRange:range byIndicatorIdentifier:self.indicatorIdentifier];
    TQIndicatorBaseLayer *layer = [self indicatorLayerWithIdentifier:self.indicatorIdentifier];
    layer.dataArray = self.dataArray;
    layer.cacheModels = self.calculator.cacheManager.allCache;
    layer.plotter = CGChartPlotterMake(self.style.shapeWidth, self.style.shapeGap, self.style.shapeStrokeWidth, self.layout.bottomChartFrame);
    layer.styles = self.indicatorStyles;
    
    CGPeakValue peakValue = [layer indicatorPeakValueForRange:calculateRange];
    peakValue = CG_CheckPeakValue(peakValue, NSStringFromClass(layer.class));
    layer.axisXCallback = self.axisXCallback;
    layer.axisYCallback = CGaxisYConverMaker(peakValue, self.layout.bottomChartFrame, self.style.gridLineWidth);
    [layer updateChartInRange:range];
    _refIndicatorTextLabel.attributedText = [layer indicatorAttributedTextForRange:calculateRange];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    _gridIndicatorTextLayer.renders = [layer indicatorTrellisForPeakValue:peakValue path:&path];
    _gridIndicatorLayer.path = path.CGPath;
}

#pragma mark - Indicators

- (void)changeIndicatorWithIdentifier:(NSString *)identifier {
    if (!identifier) return;
    NSAssert1([self.indicatorLayers.allKeys containsObject:identifier],
              @"Unregistered identifier [%@]", identifier);
    [self clearIndicatorLayerWithIdentifier:_indicatorIdentifier];
    _indicatorIdentifier = identifier;
    NSRange range = [self getVisualRange];
    NSRange calculatedRange = [self getCalculatedRange];
    [self drawBottomIndicatorChartWithRange:range calculateRange:calculatedRange];
}

- (NSMutableDictionary<NSString *,TQIndicatorBaseLayer *> *)indicatorLayers {
    if (_indicatorLayers) return _indicatorLayers;
    NSArray<NSString *> *array = @[TQIndicatorVOL, TQIndicatorBOLL, TQIndicatorMACD, TQIndicatorKDJ, TQIndicatorOBV, TQIndicatorRSI, TQIndicatorWR, TQIndicatorVR, TQIndicatorCR, TQIndicatorBIAS, TQIndicatorCCI, TQIndicatorDMI, TQIndicatorDMA, TQIndicatorSAR, TQIndicatorPSY];
    _indicatorLayers = [NSMutableDictionary dictionary];
    for (NSString *name in array) {
        [_indicatorLayers setObject:[NSClassFromString(name) layer] forKey:name];
    }
    return _indicatorLayers;
}

- (void)registerClass:(Class)aClass forIndicatorIdentifier:(NSString *)identifier {
    if (!aClass || ![aClass isSubclassOfClass:[TQIndicatorBaseLayer class]]) return;
    [self.indicatorLayers setObject:[aClass layer] forKey:identifier];
}

- (TQIndicatorBaseLayer *)indicatorLayerWithIdentifier:(NSString *)identifier {
    TQIndicatorBaseLayer *layer = [self.indicatorLayers objectForKey:identifier];
    if (!layer.superlayer) {
        [self.contentChartLayer addSublayer:layer];
    }
    return layer;
}

- (void)clearIndicatorLayerWithIdentifier:(NSString *)identifier {
    TQIndicatorBaseLayer *layer = [self.indicatorLayers objectForKey:identifier];
    if (!layer || !layer.superlayer) return;
    [layer removeFromSuperlayer];
}

#pragma mark - Date Flag

- (NSMutableIndexSet *)allDateFlagIndexSet {
    if (!_allDateFlagIndexSet) {
        _allDateFlagIndexSet = [NSMutableIndexSet indexSet];
    }
    return _allDateFlagIndexSet;
}

- (void)makeUpdateDateFlagCallback {
    [self.allDateFlagIndexSet removeAllIndexes];
    switch (self.style.klineType) {
        case TQKLineTypeDay: {
            __block NSInteger dateFlag = 0;
            [self.dataArray enumerateObjectsUsingBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger month = [TQChartDateManager.sharedManager month:obj.tq_date];
                if (month && dateFlag != month) {
                    dateFlag = month;
                    [self.allDateFlagIndexSet addIndex:idx];
                }
            }];
            self.dateTextCallback = ^NSString *(id<TQKlineChartProtocol> obj) {
                return [TQChartDateManager.sharedManager stringFromDate:obj.tq_date dateFormat:TQTouchDaysKDateFormatter];
            };
        } break;
        case TQKLineTypeWeek: { // 6 months apart
            [self.dataArray enumerateObjectsUsingBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
            }];
        } break;
        case TQKLineTypeMonth: {
            [self.dataArray enumerateObjectsUsingBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            }];
        } break;
        default: break;
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
    
    UIPinchGestureRecognizer *pinchScale = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchScale:)];
    pinchScale.delegate = self;
    [self addGestureRecognizer:pinchScale];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (!self.crossLineView.fadeHidden) {
            self.crossLineView.fadeHidden = YES;
            return NO;
        }
    }
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        self.crossLineView.fadeHidden = YES;
        return YES;
    }
    CGPoint p = [gestureRecognizer locationInView:self];
    return CGRectContainsPoint(self.crossLineView.frame, p) && !CGRectContainsPoint(self.layout.separatedFrame, p);
}

#pragma mark - singleTap

- (void)singleTap:(UITapGestureRecognizer *)g {
    CGPoint p = [g locationInView:g.view];
    if (CGRectContainsPoint(self.layout.topChartFrame, p)) {
    }
    if (CGRectContainsPoint(self.layout.bottomChartFrame, p)) {
    }
    if ([self.delegate respondsToSelector:@selector(stockKLineChart:didSingleTapInLocation:)]) {
        [self.delegate stockKLineChart:self didSingleTapInLocation:p];
    }
}

#pragma mark - doubleTap

- (void)doubleTap:(UITapGestureRecognizer *)g {
    CGPoint p = [g locationInView:g.view];
    if ([self.delegate respondsToSelector:@selector(stockKLineChart:didDoubleTapInLocation:)]) {
        [self.delegate stockKLineChart:self didDoubleTapInLocation:p];
    }
}

#pragma mark - longPress

- (void)longPress:(UILongPressGestureRecognizer *)g {
    switch (g.state) {
        case UIGestureRecognizerStateBegan: {
            if ([self.delegate respondsToSelector:@selector(stockKLineChartWillLongPress:)]) {
                [self.delegate stockKLineChartWillLongPress:self];
            }
            self.crossLineView.fadeHidden = NO;
            CGPoint p = [g locationInView:self];
            [self updateCrossLineViewWithPoint:p];
        } break;
        case UIGestureRecognizerStateEnded: {
            [self.crossLineView fadeHiddenDelayed:2];
            if ([self.delegate respondsToSelector:@selector(stockKLineChartEndLongPress:)]) {
                [self.delegate stockKLineChartEndLongPress:self];
            }
        } break;
        case UIGestureRecognizerStateChanged: {
            CGPoint p = [g locationInView:self];
            [self updateCrossLineViewWithPoint:p];
        } break;
        default: break;
    }
}

- (void)updateCrossLineViewWithPoint:(CGPoint)p {
    NSRange range = [self getCalculatedRange];
    if (CGRectContainsPoint(self.layout.topChartFrame, p)) { // chartKLineFrame correspond value
        CGPeakValue peakValue = [self getPeakValueWithRange:range];
        CGPeakValue enlarge = [self getEnlargePeakValue:peakValue];
        CGFloat value = CGaxisYToValueBlock(enlarge, self.layout.topChartFrame, p.y);
        _crossLineView.yaixsText = TQPlainTextFormat(value);
    }
    if (CGRectContainsPoint(self.layout.bottomChartFrame, p)) { // chartVolumeFrame correspond value
        TQIndicatorBaseLayer *layer = [self indicatorLayerWithIdentifier:self.indicatorIdentifier];
        CGPeakValue peakValue = [layer indicatorPeakValueForRange:range];
        CGFloat value = CGaxisYToValueBlock(peakValue, self.layout.bottomChartFrame, p.y);
        NSString *yaixsText = TQPlainTextFormat(value);
        if ([self.indicatorIdentifier isEqualToString:TQIndicatorVOL]) {
            yaixsText = [TQPlainTextFormat(value / 10000.0) stringByAppendingString:@"万"];
        }
        _crossLineView.yaixsText = yaixsText;
    }
    CGPoint point = [self.scrollView convertPoint:p fromView:self]; // correspond date
    NSInteger index = CGaxisXToIndexBlock(point.x, self.style.shapeWidth, self.style.shapeGap, self.dataArray.count);
    _crossLineView.correspondIndexText = self.dateTextCallback(self.dataArray[index]);
    CGFloat centerX = [self getCenterXInRootViewWithIndex:index];
    _crossLineView.spotOfTouched = CGPointMake(p.x, p.y - self.layout.topChartFrame.origin.y);
    [_crossLineView redrawWithCentralPoint:CGPointMake(centerX, p.y - self.layout.topChartFrame.origin.y)];
    if ([self.delegate respondsToSelector:@selector(stockKLineChart:didLongPressAtCorrespondIndex:)]) {
        [self.delegate stockKLineChart:self didLongPressAtCorrespondIndex:index];
    }
}

#pragma mark - pinchScale

- (void)pinchScale:(UIPinchGestureRecognizer *)g {
    switch (g.state) {
        case UIGestureRecognizerStateBegan: {
            self.scrollView.scrollEnabled = NO;
            if (!_previousScale) return;
            g.scale = _previousScale;
            CGPoint p = [g locationInView:self];
            CGPoint pinchCenter = [self.scrollView convertPoint:p fromView:self];
            _pinchCenterIndex = CGaxisXToIndexBlock(pinchCenter.x, self.style.shapeWidth, self.style.shapeGap, self.dataArray.count);
            _pinchCenterOffsetOfVisual = [self getCenterXInRootViewWithIndex:_pinchCenterIndex];
        } break;
        case UIGestureRecognizerStateEnded: {
            self.scrollView.scrollEnabled = YES;
            _previousScale = g.scale;
        } break;
        case UIGestureRecognizerStateChanged: {
            self.scrollView.scrollEnabled = NO;
            if (!_previousScale) return;
            CGFloat factor = g.scale / _previousScale;
            _previousScale = g.scale;
            NSUInteger number = round(self.style.numberOfVisual / factor);
            if (number == self.style.numberOfVisual ||
                number > self.style.maxNumberOfVisual ||
                number < self.style.minNumberOfVisual) return; // avoid repeated drawing
            self.style.numberOfVisual = number;
            [self updateShapeWidthByVisualCount:self.style.numberOfVisual];
            // calculate the offset position, according to '_pinchCenterIndex'
            CGFloat centerX = CGaxisXConverMaker(self.style.shapeWidth, self.style.shapeGap)(_pinchCenterIndex);
            CGFloat offsetX = centerX - _pinchCenterOffsetOfVisual;
            offsetX = MIN(self.maxScrollOffsetX, MAX(self.minScrollOffsetX, offsetX));
            [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
            [self _updateChart];
        } break;
        default: break;
    }
}

@end
