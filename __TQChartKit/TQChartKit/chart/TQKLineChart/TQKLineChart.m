//
//  TQKLineChart.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/26.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQKLineChart.h"
#import "TQChartTextLayer.h"
#import "TQChartCrossLineView.h"
#import "TQKLineLoadingView.h"
#import "TQStockChart+Categories.h"
#import "UIBezierPath+TQChart.h"
#import "TQKLineChart+Calculator.h"
#import "TQChartDateManager.h"
#import "TQIndexBaseLayer.h"
#import "TQIndexVOLLayer.h"
#import "TQIndexOBVLayer.h"

@interface TQKLineChart () <UIGestureRecognizerDelegate>

/** 横向网格线(KLine区域) */
@property (nonatomic, strong) CAShapeLayer *kLineGridLayer;

/** 横向网格线(VOL区域区域) */
@property (nonatomic, strong) CAShapeLayer *volumeGridLayer;

/** 纵向网格线(日期线) */
@property (nonatomic, strong) CAShapeLayer *dateGridLayer;

/** 两端边网格框线 */
@property (nonatomic, strong) CAShapeLayer *borderGridLayer;

/** K线区域y轴文本 */
@property (nonatomic, strong) TQChartTextLayer *kLineGridTextLayer;

/** 成交量区域y轴文本 */
@property (nonatomic, strong) TQChartTextLayer *volumeGridTextLayer;

/** 时间线文本 */
@property (nonatomic, strong) TQChartTextLayer *dateGridTextLayer;

/** 最大最小值标记文本 */
@property (nonatomic, strong) TQChartTextLayer *peakTextLayer;

/** 最大值标记线 */
@property (nonatomic, strong) CAShapeLayer *peakMaxLineLayer;

/** 最小值标记线 */
@property (nonatomic, strong) CAShapeLayer *peakMinLineLayer;

/** K线蜡烛图涨 */
@property (nonatomic, strong) CAShapeLayer *riseKlineLayer;

/** K线蜡烛图跌 */
@property (nonatomic, strong) CAShapeLayer *fallKlineLayer;

/** K线蜡烛图平 */
@property (nonatomic, strong) CAShapeLayer *flatKlineLayer;


/** 用于计算日期时间的回调 */
@property (nonatomic, copy) NSString *(^dateTextCallback)(id<TQKlineChartProtocol> obj);

/** 用于存储所有日期标记的索引集 */
@property (nonatomic, strong) NSMutableIndexSet *allDateFlagIndexSet;

/** 用于存储所有指标layer的集合 */
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, TQIndexBaseLayer *> *allIndexLayers;

// 应在调用'-drawChart'方法后使用以下frame
@property (nonatomic, assign, readonly) CGRect chartFrame;
@property (nonatomic, assign, readonly) CGRect chartKLineFrame;
@property (nonatomic, assign, readonly) CGRect chartVolumeFrame;
@property (nonatomic, assign, readonly) CGRect chartSeparatedFrame;

/** 设置内边距(边缘留白) */
@property (nonatomic, assign) UIEdgeInsets contentEdgeInset;

/** 设置分时图表高度 */
@property (nonatomic, assign) CGFloat chartKLineHeight;

/** 设置中间分隔区域 */
@property (nonatomic, assign) CGFloat chartSeparatedGap;

@end

@implementation TQKLineChart {
    NSMutableIndexSet *_allDateFlagIndexSet;
    NSMutableIndexSet *_allIndexTypeIndexSet;
    CGFloat _previousScale;
    NSInteger _pinchCenterIndex;
    CGFloat _pinchCenterOffsetOfVisual;
}

- (void)sublayerInitialization {
    _kLineGridLayer = [CAShapeLayer layer];
    [self.contentGridLayer addSublayer:_kLineGridLayer];
    
    _volumeGridLayer = [CAShapeLayer layer];
    [self.contentGridLayer addSublayer:_volumeGridLayer];
    
    _borderGridLayer = [CAShapeLayer layer];
    [self.contentGridLayer addSublayer:_borderGridLayer];
    
    _kLineGridTextLayer = [TQChartTextLayer layer];
    [self.contentTextLayer addSublayer:_kLineGridTextLayer];
    
    _volumeGridTextLayer = [TQChartTextLayer layer];
    [self.contentTextLayer addSublayer:_volumeGridTextLayer];
    
    _dateGridTextLayer = [TQChartTextLayer layer];
    [self.contentChartLayer addSublayer:_dateGridTextLayer];
    
    _dateGridLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_dateGridLayer];
    
    _peakTextLayer = [TQChartTextLayer layer];
    [self.contentChartLayer addSublayer:_peakTextLayer];
    
    _peakMaxLineLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_peakMaxLineLayer];
    
    _peakMinLineLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_peakMinLineLayer];
    
    _riseKlineLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_riseKlineLayer];
    
    _fallKlineLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_fallKlineLayer];
    
    _flatKlineLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_flatKlineLayer];
    
    _crossLineView = [TQChartCrossLineView new];
    _crossLineView.fadeHidden = YES;
    [self addSubview:_crossLineView];
    
    _loadingView = [TQKLineLoadingView new];
    [self.scrollView addSubview:_loadingView];
    
    _previousScale = 1;
}

#pragma mark - UpdateSublayers

- (void)updateAppearance {
    _kLineGridLayer.fillColor = [UIColor clearColor].CGColor;
    _kLineGridLayer.strokeColor = self.style.gridLineColor.CGColor;
    _kLineGridLayer.lineWidth = self.style.gridLineWidth;
    
    _volumeGridLayer.fillColor = _kLineGridLayer.fillColor;
    _volumeGridLayer.strokeColor = _kLineGridLayer.strokeColor;
    _volumeGridLayer.lineWidth = _kLineGridLayer.lineWidth;
    
    _dateGridLayer.fillColor = _kLineGridLayer.fillColor;
    _dateGridLayer.strokeColor = _kLineGridLayer.strokeColor;
    _dateGridLayer.lineWidth = _kLineGridLayer.lineWidth;
    
    _borderGridLayer.fillColor = _kLineGridLayer.fillColor;
    _borderGridLayer.strokeColor = _kLineGridLayer.strokeColor;
    _borderGridLayer.lineWidth = _kLineGridLayer.lineWidth;
    
    UIColor *riseFillColor = self.style.shouldRiseSolid ? self.style.riseColor : [UIColor clearColor];
    _riseKlineLayer.fillColor = riseFillColor.CGColor;
    _riseKlineLayer.strokeColor = self.style.riseColor.CGColor;
    _riseKlineLayer.lineWidth = self.style.shapeLineWidth;
    
    UIColor *fallFillColor = self.style.shouldFallSolid ? self.style.fallColor : [UIColor clearColor];
    _fallKlineLayer.fillColor = fallFillColor.CGColor;
    _fallKlineLayer.strokeColor = self.style.fallColor.CGColor;
    _fallKlineLayer.lineWidth = self.style.shapeLineWidth;
    
    UIColor *flatFillColor = self.style.shouldFlatSolid ? self.style.flatColor : [UIColor clearColor];
    _flatKlineLayer.fillColor = flatFillColor.CGColor;
    _flatKlineLayer.strokeColor = self.style.flatColor.CGColor;
    _flatKlineLayer.lineWidth = self.style.shapeLineWidth;
    
    _peakMaxLineLayer.fillColor = self.style.peakTextColor.CGColor;
    _peakMaxLineLayer.strokeColor = self.style.peakTextColor.CGColor;
    _peakMaxLineLayer.lineWidth = self.style.peakLineWidth;
    
    _peakMinLineLayer.fillColor = _peakMaxLineLayer.fillColor;
    _peakMinLineLayer.strokeColor = _peakMaxLineLayer.strokeColor;
    _peakMinLineLayer.lineWidth = _peakMaxLineLayer.lineWidth;
}

- (void)updateLayout {
    _chartFrame = CGRectIntegral(UIEdgeInsetsInsetRect(self.bounds, self.layout.contentEdgeInset));
    _chartKLineFrame = self.chartFrame;
    _chartKLineFrame.size.height = MIN(self.layout.topChartHeight, self.chartFrame.size.height);
    
    _chartSeparatedFrame = self.chartFrame;
    _chartSeparatedFrame.origin.y = CGRectGetMaxY(self.chartKLineFrame);
    _chartSeparatedFrame.size.height = self.layout.separatedGap;
    
    _chartVolumeFrame = self.chartFrame;
    _chartVolumeFrame.origin.y = CGRectGetMaxY(self.chartSeparatedFrame);
    _chartVolumeFrame.size.height = CGRectGetMaxY(self.chartFrame) - self.chartVolumeFrame.origin.y;
    
    _crossLineView.frame = self.chartFrame;
    _crossLineView.separationRect = CGRectMake(self.chartFrame.origin.x, self.chartKLineFrame.size.height, self.chartKLineFrame.size.width, self.chartSeparatedGap);
    CGRect paddingFrame = self.chartKLineFrame;
    paddingFrame.size.width = 35;
    _loadingView.loadingInRect = paddingFrame;
}

/// 更新设置K线图宽度及滚动范围
- (void)updateShapeWidthByVisualCount:(NSInteger)visualCount {
    // calculate the shapeWidth
    CGFloat allGap = (visualCount - 1) * self.style.shapeGap;
    CGFloat shapeWidth = (self.chartKLineFrame.size.width - allGap) / (CGFloat)visualCount;
    [self.style setValue:@(shapeWidth) forKey:NSStringFromSelector(@selector(shapeWidth))];
    // calculate the contentSize. scroll range
    CGFloat contentWidth = (self.style.shapeGap + self.style.shapeWidth) * self.dataArray.count - self.style.shapeGap;
    self.scrollView.contentSize = CGSizeMake(contentWidth, self.bounds.size.height);
}

- (TQChartTextRenderer *)renderWithText:(NSString *)text {
    TQChartTextRenderer *render = [TQChartTextRenderer defaultRendererWithText:text];
    render.color = self.style.peakTextColor;
    render.font = self.style.peakTextFont;
    return render;
}

- (void)setAppendDataArray:(NSArray<id<TQKlineChartProtocol>> *)appendDataArray {
    if (!appendDataArray) return;
    _appendDataArray = appendDataArray;
    NSLog(@"appendDataArray is: %@", @(self.appendDataArray.count));
    NSMutableArray *array = [NSMutableArray arrayWithArray:appendDataArray];
    !self.dataArray ?: [array addObjectsFromArray:self.dataArray];
    self.dataArray = array;
    NSLog(@"count2 is: %@", @(self.dataArray.count));
    [self updateScrollOffsetWithDataCount:appendDataArray.count];
}

/** 加载更多数据后需重新计算偏移的位置 */
- (void)updateScrollOffsetWithDataCount:(NSInteger)dataCount {
    CGFloat _offsetX = (self.style.shapeGap + self.style.shapeWidth) * dataCount;
    _offsetX -= self.loadingView.loadingInset;
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.x = _offsetX;
    [self.scrollView setContentOffset:contentOffset animated:NO];
}

- (void)drawChart {
    if (!self.dataArray) return;
    [self layoutIfNeeded];
    [self updateAppearance];
    [self updateLayout];
    [self updateShapeWidthByVisualCount:self.style.numberOfVisual];
    self.appendDataArray ?: [self scrollToRight]; // 使视图滚动到最右边
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

- (void)_updateChart {
    NSRange range = [self getVisualRange];
    NSRange calculatedRange = [self getCalculatedRange];
    CGPeakIndexValue _calculated = [self getPeakIndexValueWithRange:calculatedRange];
    CGPeakValue peakValue = CGPeakValueMake(_calculated.max.value, _calculated.min.value);
    CGPeakValue _enlarge = [self getEnlargePeakValue:peakValue];
    [self drawKlineGridWithPeakValue:_enlarge];
    CGpYFromValueCallback pYCallback = CGpYConverterMake(_enlarge, self.chartKLineFrame, self.style.gridLineWidth);
    [self drawKlineChartWithRange:range pYCallback:pYCallback];
    [self drawPeakFlagLines:_calculated pYCallback:pYCallback];
    [self drawVolumeChartWithRange:range];
    [self makeUpdateDateFlagCallback];
    [self drawDateGridWithRange:range];
}

/** 绘制K线区域蜡烛图 */
- (void)drawKlineChartWithRange:(NSRange)range pYCallback:(CGFloat(^)(CGFloat))pYCallback {
    UIBezierPath *risePath = [UIBezierPath bezierPath];
    UIBezierPath *fallPath = [UIBezierPath bezierPath];
    UIBezierPath *flatPath = [UIBezierPath bezierPath];
    [self.dataArray tq_enumerateObjectsAtRange:range usingBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat highY = pYCallback(obj.tq_high);
        CGFloat lowY = pYCallback(obj.tq_low);
        CGFloat openY = pYCallback(obj.tq_open);
        CGFloat closeY = pYCallback(obj.tq_close);
        CGFloat centerX = [self getCenterXInScrollViewWithIndex:idx];
        CGFloat realWidth = self.style.shapeWidth - self.style.shapeLineWidth;
        CGFloat originX = centerX - realWidth * 0.5;
        CGFloat originY = MIN(openY, closeY);
        CGFloat realHeight = fabs(openY - closeY);
        CGPoint top = CGPointMake(centerX, highY);
        CGPoint bottom = CGPointMake(centerX, lowY);
        CGRect shapeRect = CGRectMake(originX, originY, realWidth, realHeight);
        CGCandleShape shape = CGCandleShapeMake(top, shapeRect, bottom);
        if (obj.tq_open > obj.tq_close) [risePath addCandleShape:shape];
        else if (obj.tq_open < obj.tq_close) [fallPath addCandleShape:shape];
        else [flatPath addCandleShape:shape];
    }];
    _riseKlineLayer.path = risePath.CGPath;
    _fallKlineLayer.path = fallPath.CGPath;
    _flatKlineLayer.path = flatPath.CGPath;
}

/** 绘制K线区域的极值及文本 */
- (void)drawPeakFlagLines:(CGPeakIndexValue)peakIndexValue pYCallback:(CGFloat(^)(CGFloat))pYCallback {
    if (!self.style.peakTaggedInVisual) return;
    CGFloat maxCenterX = [self getCenterXInScrollViewWithIndex:peakIndexValue.max.index];
    CGFloat minCenterX = [self getCenterXInScrollViewWithIndex:peakIndexValue.min.index];
    CGFloat maxOriginY = pYCallback(peakIndexValue.max.value) - self.style.peakLineOffset.vertical;
    CGFloat minOriginY = pYCallback(peakIndexValue.min.value) + self.style.peakLineOffset.vertical;
    CGFloat middleX = [self convertPoint:CGPointMake(half(self.chartKLineFrame.size.width), 0) toView:self.scrollView].x;
    NSMutableArray<TQChartTextRenderer *> *renders = [NSMutableArray array];
    UIBezierPath*(^callback)(CGFloat, CGFloat, CGFloat) = ^(CGFloat centerX, CGFloat originY, CGFloat value) {
        CGFloat lineLength = 0;
        CGPoint positionCenter = CGPointZero;
        CGPoint offsetRatio = CGPointZero;
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
        TQChartTextRenderer *render = [self renderWithText:NS_StringFromFloat(CG_RoundFloatKeep2(value))];
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
    _peakTextLayer.renders = renders;
}

/** 绘制K线区域网格线及文本 */
- (void)drawKlineGridWithPeakValue:(CGPeakValue)peakValue {
    NSArray<NSString *> *strings = [NSArray tq_segmentedGrid:self.style.gridSegments peakValue:peakValue];
    CGFloat gap = (self.chartKLineFrame.size.height - self.style.gridLineWidth) / (CGFloat)(strings.count - 1);
    CGFloat originY = self.chartKLineFrame.origin.y + self.style.gridLineWidth * 0.5;
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSMutableArray<TQChartTextRenderer *> *renders = [NSMutableArray array];
    [strings enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint start = CGPointMake(self.chartKLineFrame.origin.x, originY + gap * idx);
        [path addHorizontalLine:start len:self.chartKLineFrame.size.width];
        TQChartTextRenderer *render = [self renderWithText:text];
        render.positionCenter = start;
        [renders addObject:render];
    }];
    renders.firstObject.offsetRatio = kCGOffsetRatioTopLeft;
    _kLineGridLayer.path = path.CGPath;
    _kLineGridTextLayer.renders = renders;
}

/** 绘制网格边框线 */
- (void)drawGridBorderLines {
    CGFloat minX = CGRectGetMinX(self.chartFrame) + half(self.style.gridLineWidth);
    CGFloat maxX = CGRectGetMaxX(self.chartFrame) - half(self.style.gridLineWidth);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addVerticalLine:CGPointMake(minX, CGRectGetMinY(self.chartKLineFrame)) len:self.chartKLineFrame.size.height];
    [path addVerticalLine:CGPointMake(maxX, CGRectGetMinY(self.chartKLineFrame)) len:self.chartKLineFrame.size.height];
    [path addVerticalLine:CGPointMake(minX, CGRectGetMinY(self.chartVolumeFrame)) len:self.chartVolumeFrame.size.height];
    [path addVerticalLine:CGPointMake(maxX, CGRectGetMinY(self.chartVolumeFrame)) len:self.chartVolumeFrame.size.height];
    _borderGridLayer.path = path.CGPath;
}

/** 绘制成交量区域图表/网格线及文本 */
- (void)drawVolumeChartWithRange:(NSRange)range {
    TQIndexBaseLayer *layer = [self indexLayerWithType:1];
    layer.plotter = CGChartPlotterMake(self.style.shapeWidth, self.style.shapeGap, self.chartVolumeFrame, self.style.gridLineWidth);
    layer.style1 = [TQIndexChartStyle defaultStyle];
    layer.dataArray = self.dataArray;
    [layer updateChartWithRange:range];
    UIBezierPath *path = [UIBezierPath bezierPath];
    _volumeGridTextLayer.renders = [layer indexChartGraphForRange:range gridPath:&path];
    _volumeGridLayer.path = path.CGPath;
}

/** 绘制日期线及对应的文本 */
- (void)drawDateGridWithRange:(NSRange)range {
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSMutableArray<TQChartTextRenderer *> *renders = [NSMutableArray array];
    [self.allDateFlagIndexSet enumerateIndexesInRange:range options:kNilOptions usingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        id<TQKlineChartProtocol>obj = self.dataArray[idx];
        CGFloat centerX = [self getCenterXInScrollViewWithIndex:idx];
        CGPoint p = CGPointMake(centerX,  CGRectGetMaxY(self.chartFrame));
        [path addVerticalLine:CGPointMake(centerX, CGRectGetMinY(self.chartKLineFrame)) len:self.chartKLineFrame.size.height];
        [path addVerticalLine:CGPointMake(centerX, CGRectGetMinY(self.chartVolumeFrame)) len:self.chartVolumeFrame.size.height];
        TQChartTextRenderer *render = [self renderWithText:self.dateTextCallback(obj)];
        render.font = [UIFont fontWithName:TQChartThonburiFontName size:11];
        render.offsetRatio = kCGOffsetRatioCenter;
        render.baseOffset = UIOffsetMake(0, self.contentEdgeInset.bottom * 0.5);
        render.positionCenter = p;
        [renders addObject:render];
    }];
    _dateGridLayer.path = path.CGPath;
    _dateGridTextLayer.renders = renders;
}

#pragma mark - other

- (NSMutableIndexSet *)allDateFlagIndexSet {
    if (!_allDateFlagIndexSet) {
        _allDateFlagIndexSet = [NSMutableIndexSet indexSet];
    }
    return _allDateFlagIndexSet;
}

- (NSMutableDictionary<NSNumber *,TQIndexBaseLayer *> *)allIndexLayers {
    if (!_allIndexLayers) {
        _allIndexLayers = [NSMutableDictionary dictionary];
    }
    return _allIndexLayers;
}

- (TQIndexBaseLayer *)indexLayerWithType:(TQIndexType)type {
    BOOL condition = type > TQIndexTypeBEIGIN && type < TQIndexTypeEND;
    NSParameterAssert(condition);
    TQIndexBaseLayer *layer = [self.allIndexLayers objectForKey:@(type)];
    if (!layer) {
        layer = [self makeIndexLayerWithType:type];
        [self.allIndexLayers setObject:layer forKey:@(type)];
    }
    layer.superlayer ?: [self.contentChartLayer addSublayer:layer];
    return layer;
}

- (void)removeIndexLayerWithType:(TQIndexType)type {
    TQIndexBaseLayer *layer = [self.allIndexLayers objectForKey:@(type)];
    if (!layer || !layer.superlayer) return;
    [layer removeFromSuperlayer];
}

- (TQIndexBaseLayer *)makeIndexLayerWithType:(TQIndexType)type {
    switch (type) {
        case TQIndexTypeVOL:
            return [TQIndexVOLLayer layer];
        case TQIndexTypeOBV:
            return [TQIndexVOLLayer layer];
        case TQIndexTypeBOLL:
            return [TQIndexOBVLayer layer];
        case TQIndexTypeMACD:
            return [TQIndexVOLLayer layer];
        case TQIndexTypeKDJ:
            return [TQIndexVOLLayer layer];
        case TQIndexTypeCCI:
            return [TQIndexVOLLayer layer];
        case TQIndexTypeRSI:
            return [TQIndexVOLLayer layer];
        default: return nil;
    }
}

- (void)makeUpdateDateFlagCallback {
    [self.allDateFlagIndexSet removeAllIndexes];

    /**
     周K 相隔6个月份
     月K 相隔2年
     季K 相隔3年
     */
    switch (self.style.klineType) {
            
        case TQKLineTypeDayK: {
            __block NSInteger dateFlag = 0;
            [self.dataArray enumerateObjectsUsingBlock:^(id<TQKlineChartProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger month = [TQChartDateManager.sharedManager month:obj.tq_date];
                if (month && dateFlag != month) {
                    dateFlag = month;
                    [self.allDateFlagIndexSet addIndex:idx];
                }
            }];
            self.dateTextCallback = ^NSString *(id<TQKlineChartProtocol> obj) {
                return [TQChartDateManager.sharedManager stringFromDate:obj.tq_date dateFormat:@"yyyy-MM"];
            };
        } break;
            
        default:
            break;
    }
}

#pragma mark - Gestures management

- (void)gestureInitialization {
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
    return CGRectContainsPoint(self.crossLineView.frame, p) && !CGRectContainsPoint(self.chartSeparatedFrame, p);
}

#pragma mark - singleTap

- (void)singleTap:(UITapGestureRecognizer *)g {
    CGPoint p = [g locationInView:g.view];
    if (CGRectContainsPoint(self.chartKLineFrame, p)) {
    }
    if (CGRectContainsPoint(self.chartVolumeFrame, p)) {
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
            self.crossLineView.fadeHidden = NO;
            CGPoint p = [g locationInView:self];
            [self updateCrossLineViewWithPoint:p];
        } break;
        case UIGestureRecognizerStateEnded: {
            [self.crossLineView fadeHiddenDelayed:2];
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
    if (CGRectContainsPoint(self.chartKLineFrame, p)) { // chartKLineFrame correspond value
        CGPeakValue peakValue = [self getPeakValueWithRange:range];
        CGPeakValue enlarge = [self getEnlargePeakValue:peakValue];
        CGFloat value = CGpYToValueCallback(enlarge, self.chartKLineFrame, p.y);
        _crossLineView.yaixsText = NS_StringFromFloat(CG_RoundFloatKeep2(value));
    }
    if (CGRectContainsPoint(self.chartVolumeFrame, p)) { // chartVolumeFrame correspond value
        TQIndexBaseLayer *layer = [self indexLayerWithType:1];
        CGPeakValue peakValue = [layer indexChartPeakValueForRange:range];
        CGFloat value = CGpYToValueCallback(peakValue, self.chartVolumeFrame, p.y);
        _crossLineView.yaixsText = NS_StringFromFloat(CG_RoundFloatKeep2(value));
    }
    CGPoint point = [self.scrollView convertPoint:p fromView:self]; // correspond date
    NSInteger index = [self mapCorrespondIndexWithPointX:point.x];
    id<TQKlineChartProtocol>data = self.dataArray[index];
    NSString *string = [TQChartDateManager.sharedManager stringFromDate:data.tq_date dateFormat:@"yyyy-MM-dd"];
    _crossLineView.correspondIndexText = string;
    CGFloat centerX = [self getCenterXInRootViewWithIndex:index];
    _crossLineView.spotOfTouched = CGPointMake(p.x, p.y - self.chartKLineFrame.origin.y);
    [_crossLineView redrawWithCentralPoint:CGPointMake(centerX, p.y - self.chartKLineFrame.origin.y)];
    
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
            _pinchCenterIndex = [self mapCorrespondIndexWithPointX:pinchCenter.x];
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
            if (number == self.style.numberOfVisual || number > self.style.maxNumberOfVisual || number < self.style.minNumberOfVisual) return; // avoid repeated drawing
            self.style.numberOfVisual = number;
            [self updateShapeWidthByVisualCount:self.style.numberOfVisual];
            // calculate the offset position, according to '_pinchCenterIndex'
            CGFloat centerX = [self getCenterXInScrollViewWithIndex:_pinchCenterIndex];
            CGFloat offsetX = centerX - _pinchCenterOffsetOfVisual;
            offsetX = MIN(self.maxScrollOffsetX, MAX(self.minScrollOffsetX, offsetX));
            [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
            [self _updateChart];
        } break;
        default: break;
    }
}

@end
