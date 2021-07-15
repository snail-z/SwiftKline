//
//  TQTimeChart.m
//  CoreGraphics_demo
//
//  Created by zhanghao on 2018/7/6.
//  Copyright © 2018年 snail-z. All rights reserved.
//

#import "TQTimeChart.h"
#import "TQTimeChart+Calculator.h"
#import "UIBezierPath+TQChart.h"
#import "TQChartTextLayer.h"
#import "TQChartCrosswireView.h"
//#import "TQTimePulsingLayer.h"
#import "TQChartPulsingView.h"
#import "TQTimeGradientLayer.h"
#import "TQStockChart+Categories.h"
#import "TQChartDateManager.h"

@interface TQTimeChart () <UIGestureRecognizerDelegate>

/** 横向网格线(分时区域) */
@property (nonatomic, strong) CAShapeLayer *yTimeGridLayer;

/** 横向网格虚线 */
@property (nonatomic, strong) CAShapeLayer *yTimeDashLayer;

/** 横向网格线(VOL区域区域) */
@property (nonatomic, strong) CAShapeLayer *yVolumeGridLayer;

/** 纵向网格线(时间标记线) */
@property (nonatomic, strong) CAShapeLayer *xDateGridLayer;

/** 用于封闭网格两端的边框线 */
@property (nonatomic, strong) CAShapeLayer *borderGridLayer;

/** 分时线 */
@property (nonatomic, strong) CAShapeLayer *timeLineLayer;

/** 分时线填充 */
@property (nonatomic, strong) TQTimeGradientLayer *timeLineFillLayer;

/** 分时线闪动点视图 */
@property (nonatomic, strong) TQChartPulsingView *pulsingView;


/** 分时均线 */
@property (nonatomic, strong) CAShapeLayer *avgTimeLineLayer;

/** 成交量涨条形图 */
@property (nonatomic, strong) CAShapeLayer *volumeRiseLayer;

/** 成交量跌条形图 */
@property (nonatomic, strong) CAShapeLayer *volumeFallLayer;

/** 成交量平条形图 */
@property (nonatomic, strong) CAShapeLayer *volumeFlatLayer;

/** 映射分时区域y轴文本 */
@property (nonatomic, strong) TQChartTextLayer *yTimeTextLayer;

/** 映射成交量区域y轴文本 */
@property (nonatomic, strong) TQChartTextLayer *yVolumeTextLayer;

/** 映射x轴时间标记文本 */
@property (nonatomic, strong) TQChartTextLayer *xDateTextLayer;

/** 查询十字线视图 */
@property (nonatomic, strong) TQChartCrosswireView *crosswireView;

@end

@implementation TQTimeChart

#pragma mark - SublayerInitialization

- (void)sublayerInitialization {
    _yTimeGridLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_yTimeGridLayer];
    
    _yTimeDashLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_yTimeDashLayer];
    
    _yVolumeGridLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_yVolumeGridLayer];
    
    _xDateGridLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_xDateGridLayer];
    
    _borderGridLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_borderGridLayer];

    _timeLineFillLayer = [TQTimeGradientLayer layer];
    [self.contentChartLayer insertSublayer:_timeLineFillLayer atIndex:0];
    
    _timeLineLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_timeLineLayer];
    
    _pulsingView = [TQChartPulsingView new];
    [self addSubview:_pulsingView];
    
    _avgTimeLineLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_avgTimeLineLayer];
    
    _volumeRiseLayer = [CAShapeLayer layer];
    _volumeRiseLayer.lineWidth = 0;
    [self.contentChartLayer addSublayer:_volumeRiseLayer];
    
    _volumeFallLayer = [CAShapeLayer layer];
    _volumeFallLayer.lineWidth = 0;
    [self.contentChartLayer addSublayer:_volumeFallLayer];
    
    _volumeFlatLayer = [CAShapeLayer layer];
    _volumeFlatLayer.lineWidth = 0;
    [self.contentChartLayer addSublayer:_volumeFlatLayer];
    
    _yTimeTextLayer = [TQChartTextLayer layer];
    [self.contentTextLayer addSublayer:_yTimeTextLayer];
    
    _yVolumeTextLayer = [TQChartTextLayer layer];
    [self.contentTextLayer addSublayer:_yVolumeTextLayer];
    
    _xDateTextLayer = [TQChartTextLayer layer];
    [self.contentTextLayer addSublayer:_xDateTextLayer];
    
    _crosswireView = [TQChartCrosswireView new];
    _crosswireView.fadeHidden = YES;
    [self addSubview:_crosswireView];
}

#pragma mark - Update sublayer

- (void)updateSublayerAppearance {
    _yTimeGridLayer.fillColor = [UIColor clearColor].CGColor;
    _yTimeGridLayer.strokeColor = self.configuration.gridLineColor.CGColor;
    _yTimeGridLayer.lineWidth = self.configuration.gridLineWidth;
    
    _yTimeDashLayer.fillColor = [UIColor clearColor].CGColor;
    _yTimeDashLayer.strokeColor = self.configuration.dashLineColor.CGColor;
    _yTimeDashLayer.lineWidth = self.configuration.dashLineWidth;
    _yTimeDashLayer.lineDashPattern = self.configuration.dashLinePattern;
    
    _yVolumeGridLayer.fillColor = _yTimeGridLayer.fillColor;
    _yVolumeGridLayer.strokeColor = _yTimeGridLayer.strokeColor;
    _yVolumeGridLayer.lineWidth = _yTimeGridLayer.lineWidth;
    
    _xDateGridLayer.fillColor = _yTimeGridLayer.fillColor;
    _xDateGridLayer.strokeColor = _yTimeGridLayer.strokeColor;
    _xDateGridLayer.lineWidth = _yTimeGridLayer.lineWidth;
    
    _borderGridLayer.fillColor = _yTimeGridLayer.fillColor;
    _borderGridLayer.strokeColor = _yTimeGridLayer.strokeColor;
    _borderGridLayer.lineWidth = _yTimeGridLayer.lineWidth;
    
    _timeLineLayer.fillColor = [UIColor clearColor].CGColor;
    _timeLineLayer.strokeColor = self.configuration.timeLineColor.CGColor;
    _timeLineLayer.lineWidth = self.configuration.timeLineWith;
    _timeLineFillLayer.gradientClolors = self.configuration.timeLineFillGradientClolors;
    
    _avgTimeLineLayer.fillColor = [UIColor clearColor].CGColor;
    _avgTimeLineLayer.strokeColor = self.configuration.avgTimeLineColor.CGColor;
    _avgTimeLineLayer.lineWidth = self.configuration.avgTimeLineWidth;
    
    _volumeRiseLayer.fillColor = self.configuration.volumeRiseColor.CGColor;
    _volumeFallLayer.fillColor = self.configuration.volumeFallColor.CGColor;
    _volumeFlatLayer.fillColor = self.configuration.volumeFlatColor.CGColor;
    _pulsingView.standpointColor = self.configuration.timeLineColor;
    
    _crosswireView.textFont = self.configuration.textFont;
    _crosswireView.textColor = self.configuration.crosswireTextColor;
    _crosswireView.lineWidth = self.configuration.crosswireLineWidth;
    _crosswireView.lineColor = self.configuration.crosswireLineColor;
}

#pragma mark - Update drawing layout

- (void)updateLayout {
    _chartFrame = CGRectIntegral(UIEdgeInsetsInsetRect(self.bounds, self.contentEdgeInset));
    _chartTimeFrame = self.chartFrame;
    _chartTimeFrame.size.height = MIN(self.chartTimeHeight, self.chartFrame.size.height);
    
    _chartRiverFrame = self.chartFrame;
    _chartRiverFrame.origin.y = CGRectGetMaxY(self.chartTimeFrame);
    _chartRiverFrame.size.height = self.chartSeparationGap;
    
    _chartVolumeFrame = self.chartFrame;
    _chartVolumeFrame.origin.y = CGRectGetMaxY(self.chartRiverFrame);
    _chartVolumeFrame.size.height = CGRectGetMaxY(self.chartFrame) - self.chartVolumeFrame.origin.y;
    
    _timeLineFillLayer.frame = (CGRect){.size.width = self.chartFrame.size.width, .size.height = CGRectGetMaxY(self.chartTimeFrame)};
    _crosswireView.fadeHidden = YES;
    _crosswireView.separationRect = CGRectMake(self.chartFrame.origin.x, self.chartTimeFrame.size.height, self.chartTimeFrame.size.width, self.chartSeparationGap);
    
    NSInteger maxCount = self.configuration.maxDataCount;
    CGFloat allGap = (maxCount - 1) * self.configuration.volumeBarGap;
    CGFloat oneWidth = (self.chartTimeFrame.size.width - allGap) / (CGFloat)maxCount;
    [self.configuration setValue:@(oneWidth) forKey:NSStringFromSelector(@selector(volumeBarBodyWidth))];
}

#pragma mark - Draw charts

- (void)drawChart {
    if (!self.dataArray) return;
    [self layoutIfNeeded];
    [self updateLayout];
    [self updateSublayerAppearance];
    
    [self drawGridBorderLines];
    [self drawTimeGridLines];
    [self drawVolumeGridLines];
    [self drawVolumeChart];
    
    self.configuration.chartType == TQTimeChartTypeFiveDay ? \
    [self drawFiveTimeChart] : [self drawTimeChart];
}

/** 绘制网格的边框线 */
- (void)drawGridBorderLines {
    CGFloat halfWidth = self.configuration.gridLineWidth * 0.5;
    CGFloat minX = CGRectGetMinX(self.chartFrame) + halfWidth;
    CGFloat maxX = CGRectGetMaxX(self.chartFrame) - halfWidth;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addVerticalLine:CGPointMake(minX, CGRectGetMinY(self.chartTimeFrame)) len:self.chartTimeFrame.size.height];
    [path addVerticalLine:CGPointMake(maxX, CGRectGetMinY(self.chartTimeFrame)) len:self.chartTimeFrame.size.height];
    [path addVerticalLine:CGPointMake(minX, CGRectGetMinY(self.chartVolumeFrame)) len:self.chartVolumeFrame.size.height];
    [path addVerticalLine:CGPointMake(maxX, CGRectGetMinY(self.chartVolumeFrame)) len:self.chartVolumeFrame.size.height];
    _borderGridLayer.path = path.CGPath;
}

/** 绘制分时区域网格水平线 */
- (void)drawTimeGridLines {
    NSArray<NSString *> *array = [NSArray tq_partition2fWithPeak:self.timePeakValue segments:self.configuration.yAxisTimeSegments];
    NSArray<NSString *> *crArray = [NSArray tq_partition2fWithPeak:self.changeRatioPeakValue segments:self.configuration.yAxisTimeSegments];
    CGFloat segGap = self.chartTimeFrame.size.height / (CGFloat)(array.count - 1);
    CGFloat originY = self.chartTimeFrame.origin.y + self.configuration.gridLineWidth * 0.5;
    
    UIBezierPath *dash = [UIBezierPath bezierPath];
    CGFloat ratioY = originY + self.changeRatioPeakValue.max / CGGetPeakDistanceValue(self.changeRatioPeakValue) * self.chartTimeFrame.size.height;
    [dash addHorizontalLine:CGPointMake(self.chartTimeFrame.origin.x, ratioY) len:self.chartTimeFrame.size.width];
    _yTimeDashLayer.path = dash.CGPath;
    
    UIColor *(^callbackColor)(CGFloat) = ^(CGFloat y) {
        if (y < ratioY) {
            return self.configuration.volumeRiseColor;
        } else if (y > ratioY) {
            return self.configuration.volumeFallColor;
        }
        return self.configuration.textColor;
    };
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    __block NSMutableArray<TQChartTextRenderer *> *rendArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint start = CGPointMake(self.chartTimeFrame.origin.x, originY + segGap * idx);
        [path addHorizontalLine:start len:self.chartTimeFrame.size.width];

        TQChartTextRenderer *leftRen = [TQChartTextRenderer defaultRenderer];
        leftRen.font = self.configuration.textFont;
        leftRen.text = text;
        leftRen.font = self.configuration.textFont;
        leftRen.color = callbackColor(start.y);
        leftRen.positionCenter = start;
        leftRen.offsetRatio = (CGPoint){.x = 0, .y = (!idx ? 0 : 1)};
        [rendArray addObject:leftRen];
    
        TQChartTextRenderer *rightRen = [TQChartTextRenderer defaultRenderer];
        rightRen.font = self.configuration.textFont;
        rightRen.text = crArray[idx];
        rightRen.font = self.configuration.textFont;
        rightRen.color = callbackColor(start.y);
        rightRen.positionCenter = (CGPoint){.x = start.x + self.chartTimeFrame.size.width, .y = start.y};;
        rightRen.offsetRatio = (CGPoint){.x = 1, .y = (!idx ? 0 : 1)};
        [rendArray addObject:rightRen];
    }];
    _yTimeGridLayer.path = path.CGPath;
    [_yTimeTextLayer updateWithRendererArray:rendArray];
}

/** 绘制成交量区域网格水平线 */
- (void)drawVolumeGridLines {
    CGPeakValue peak = [self.dataArray tq_peakValueBySel:@selector(tq_timeVolume)];
    NSArray<NSString *> *array = [NSArray tq_partitionWithPeak:peak segments:self.configuration.yAxisVolumeSegments format:@"%.f" attachedText:nil];
    CGFloat segGap = self.chartVolumeFrame.size.height / (CGFloat)(array.count - 1);
    CGFloat originY = self.chartVolumeFrame.origin.y;
    UIBezierPath *path = [UIBezierPath bezierPath];
    __block NSMutableArray<TQChartTextRenderer *> *rendArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint start = CGPointMake(self.chartVolumeFrame.origin.x, originY + segGap * idx);
        [path addHorizontalLine:start len:self.chartVolumeFrame.size.width];
    }];
    TQChartTextRenderer *firstRen = [TQChartTextRenderer defaultRenderer];
    firstRen.font = self.configuration.textFont;
    firstRen.color = self.configuration.textColor;
    firstRen.text = array.firstObject;
    firstRen.positionCenter = self.chartVolumeFrame.origin;
    firstRen.offsetRatio = kCGOffsetRatioTopLeft;
    [rendArray addObject:firstRen];
    
    _yVolumeGridLayer.path = path.CGPath;
    [_yVolumeTextLayer updateWithRendererArray:rendArray];
}

/** 绘制成交量条形图 */
- (void)drawVolumeChart {
    CGPeakValue peak = [self.dataArray tq_peakValueBySel:@selector(tq_timeVolume)];
    CG_AxisConvertBlock yAxisCallback = CG_YaxisConvertBlock(peak, self.chartVolumeFrame);
    
    UIBezierPath *risePath = [UIBezierPath bezierPath];
    UIBezierPath *fallPath = [UIBezierPath bezierPath];
    UIBezierPath *flatPath = [UIBezierPath bezierPath];
    [self.dataArray enumerateObjectsUsingBlock:^(id<TQTimeChartProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat originX = [self getOriginXWithIndex:idx];
        CGFloat pointY = yAxisCallback(obj.tq_timeVolume);
        CGRect rect = CGRectMake(originX, pointY, self.configuration.volumeBarBodyWidth, CGRectGetMaxY(self.chartVolumeFrame) - pointY);
        NSInteger previousIdx = !idx ?: idx - 1;
        CGFloat previousPrice = self.dataArray[previousIdx].tq_timePrice;
        CGFloat currentPrice = obj.tq_timePrice;
        if (currentPrice > previousPrice) {
            [risePath addRect:rect];
        } else if (currentPrice < previousPrice) {
            [fallPath addRect:rect];
        } else {
            [flatPath addRect:rect];
        }
    }];
    _volumeRiseLayer.path = risePath.CGPath;
    _volumeFallLayer.path = fallPath.CGPath;
    _volumeFlatLayer.path = flatPath.CGPath;
}

/** 绘制分时图 */
- (void)drawTimeChart {
    [self drawTimeDateLines];
    
    CG_AxisConvertBlock yAxisCallback = CG_YaxisConvertBlock(self.timePeakValue, self.chartTimeFrame);
    CGFloat halfTimeLineWith = self.configuration.timeLineWith * 0.5;
    id<TQTimeChartProtocol>firstObj = self.dataArray.firstObject;
    CGFloat firstPointY = yAxisCallback(firstObj.tq_timeClosePrice) + halfTimeLineWith;
    CGFloat avgFirstPointY = yAxisCallback(firstObj.tq_timeAveragePrice) + halfTimeLineWith;
    
    UIBezierPath *timePath = [UIBezierPath bezierPath];
    UIBezierPath *avgPath = [UIBezierPath bezierPath];
    [timePath moveToPoint:CGPointMake(self.chartTimeFrame.origin.x, firstPointY)];
    [avgPath moveToPoint:CGPointMake(self.chartTimeFrame.origin.x, avgFirstPointY)];
    [self.dataArray enumerateObjectsUsingBlock:^(id<TQTimeChartProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat centerX = [self getCenterXWithIndex:idx];
        CGFloat pointY = yAxisCallback(obj.tq_timePrice) + halfTimeLineWith;
        CGFloat avgPointY = yAxisCallback(obj.tq_timeAveragePrice) + halfTimeLineWith;
        [timePath addLineToPoint:CGPointMake(centerX, pointY)];
        [avgPath addLineToPoint:CGPointMake(centerX, avgPointY)];
    }];
    _timeLineLayer.path = timePath.CGPath;
    _avgTimeLineLayer.path = avgPath.CGPath;
    
    id<TQTimeChartProtocol>lastObj = self.dataArray.lastObject;
    CGFloat lastCenterX = [self getCenterXWithIndex:self.dataArray.count - 1];
    UIBezierPath *fillPath = [UIBezierPath bezierPathWithCGPath:timePath.CGPath];
    [fillPath addLineToPoint:CGPointMake(lastCenterX, CGRectGetMaxY(self.chartTimeFrame))];
    [fillPath addLineToPoint:CGPointMake(self.chartTimeFrame.origin.x, CGRectGetMaxY(self.chartTimeFrame))];
    [fillPath closePath];
    _timeLineFillLayer.path = fillPath.CGPath;
    
    CGFloat lastPointY = yAxisCallback(lastObj.tq_timePrice) + halfTimeLineWith;
    _pulsingView.center = CGPointMake(lastCenterX, lastPointY);
    [_pulsingView startAnimating];
}

/** 绘制分时日期线及文本 */
- (void)drawTimeDateLines {
    if (self.dateTimeArray.count < 2) return;
    NSInteger section = self.configuration.maxDataCount / (self.dateTimeArray.count - 1);
    NSRange range = NSMakeRange(1, self.dateTimeArray.count - 2);
    CGFloat positionCenterY; CGFloat baseOffsetVertical;
    [self changeDateRenderer:&positionCenterY vertical:&baseOffsetVertical];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    __block NSMutableArray<TQChartTextRenderer *> *rendArray = [NSMutableArray array];
    [self.dateTimeArray tq_enumerateObjectsAtRange:range usingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat centerX = [self getCenterXWithIndex:(idx * section)];
        [path addVerticalLine:CGPointMake(centerX, CGRectGetMinY(self.chartTimeFrame)) len:self.chartTimeFrame.size.height];
        [path addVerticalLine:CGPointMake(centerX, CGRectGetMinY(self.chartVolumeFrame)) len:self.chartVolumeFrame.size.height];
        
        TQChartTextRenderer *ren = [TQChartTextRenderer defaultRenderer];
        ren.font = self.configuration.textFont;
        ren.color = self.configuration.textColor;
        ren.text = text;
        ren.offsetRatio = kCGOffsetRatioCenter;
        ren.baseOffset = UIOffsetMake(0, baseOffsetVertical);
        ren.positionCenter = CGPointMake(centerX, positionCenterY);
        [rendArray addObject:ren];
    }];
    TQChartTextRenderer *firstRen = [TQChartTextRenderer defaultRenderer];
    firstRen.font = self.configuration.textFont;
    firstRen.color = self.configuration.textColor;
    firstRen.baseOffset = UIOffsetMake(0, baseOffsetVertical);
    firstRen.text = self.dateTimeArray.firstObject;
    firstRen.offsetRatio = kCGOffsetRatioCenterLeft;
    firstRen.positionCenter = CGPointMake(CGRectGetMinX(self.chartFrame), positionCenterY);
    [rendArray insertObject:firstRen atIndex:0];
    
    TQChartTextRenderer *lastRen = [TQChartTextRenderer defaultRenderer];
    lastRen.font = self.configuration.textFont;
    lastRen.color = self.configuration.textColor;
    lastRen.baseOffset = UIOffsetMake(0, baseOffsetVertical);
    lastRen.text = self.dateTimeArray.lastObject;
    lastRen.offsetRatio = kCGOffsetRatioCenterRight;
    lastRen.positionCenter = CGPointMake(CGRectGetMaxX(self.chartFrame), positionCenterY);
    [rendArray addObject:lastRen];
    
    _xDateGridLayer.path = path.CGPath;
    [_xDateTextLayer updateWithRendererArray:rendArray];
}

#pragma mark - 五日分时图

/** 绘制五日分时图 */
- (void)drawFiveTimeChart {
    NSMutableIndexSet *dateIndexSet = [NSMutableIndexSet indexSet];
    NSInteger dayCount = self.configuration.maxDataCount / 5;
    NSInteger dataCount = self.dataArray.count;
    for (NSInteger i = 0; i < 5; i++) {
        NSInteger index = i * dayCount;
        if (index < dataCount) [dateIndexSet addIndex:index];
    }
    [self drawFiveDateLinesWithIndexSet:dateIndexSet];
    
    CG_AxisConvertBlock yAxisCallback = CG_YaxisConvertBlock(self.timePeakValue, self.chartTimeFrame);
    CGFloat halfTimeLineWith = self.configuration.timeLineWith * 0.5;
    id<TQTimeChartProtocol>firstObj = self.dataArray.firstObject;
    CGFloat firstPointY = yAxisCallback(self.propData.tq_originPrice) + halfTimeLineWith;
    CGFloat avgFirstPointY = yAxisCallback(firstObj.tq_timeAveragePrice) + halfTimeLineWith;
    
    UIBezierPath *timePath = [UIBezierPath bezierPath];
    UIBezierPath *avgPath = [UIBezierPath bezierPath];
    UIBezierPath *fillPath = [UIBezierPath bezierPath];
    [timePath moveToPoint:CGPointMake(self.chartTimeFrame.origin.x, firstPointY)];
    [fillPath moveToPoint:CGPointMake(self.chartTimeFrame.origin.x, firstPointY)];
    [avgPath moveToPoint:CGPointMake(self.chartTimeFrame.origin.x, avgFirstPointY)];
    [self.dataArray enumerateObjectsUsingBlock:^(id<TQTimeChartProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat centerX = [self getCenterXWithIndex:idx];
        CGFloat pointY = yAxisCallback(obj.tq_timePrice) + halfTimeLineWith;
        CGFloat avgPointY = yAxisCallback(obj.tq_timeAveragePrice) + halfTimeLineWith;
        if ([dateIndexSet containsIndex:idx]) {
            [timePath moveToPoint:CGPointMake(centerX, pointY)];
            [avgPath moveToPoint:CGPointMake(centerX, avgPointY)];
        } else {
            [timePath addLineToPoint:CGPointMake(centerX, pointY)];
            [avgPath addLineToPoint:CGPointMake(centerX, avgPointY)];
        }
        [fillPath addLineToPoint:CGPointMake(centerX, pointY)];
    }];
    _timeLineLayer.path = timePath.CGPath;
    _avgTimeLineLayer.path = avgPath.CGPath;
    
    id<TQTimeChartProtocol>lastObj = self.dataArray.lastObject;
    CGFloat lastCenterX = [self getCenterXWithIndex:self.dataArray.tq_lastIndex];
    [fillPath addLineToPoint:CGPointMake(lastCenterX, CGRectGetMaxY(self.chartTimeFrame))];
    [fillPath addLineToPoint:CGPointMake(self.chartTimeFrame.origin.x, CGRectGetMaxY(self.chartTimeFrame))];
    [fillPath closePath];
    _timeLineFillLayer.path = fillPath.CGPath;
    
    CGFloat lastPointY = yAxisCallback(lastObj.tq_timePrice) + halfTimeLineWith;
    _pulsingView.center = CGPointMake(lastCenterX, lastPointY);
    [_pulsingView startAnimating];
}

- (void)drawFiveDateLinesWithIndexSet:(NSIndexSet *)indexSet {
    CGFloat positionCenterY; CGFloat baseOffsetVertical;
    [self changeDateRenderer:&positionCenterY vertical:&baseOffsetVertical];
    NSInteger gap = self.chartTimeFrame.size.width / indexSet.count;
    __block CGFloat originX = self.chartFrame.origin.x;
    __block NSMutableArray<TQChartTextRenderer *> *rendArray = [NSMutableArray array];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat centerX = originX +  gap * 0.5;
        [path addVerticalLine:CGPointMake(originX, CGRectGetMinY(self.chartTimeFrame)) len:self.chartTimeFrame.size.height];
        [path addVerticalLine:CGPointMake(originX, CGRectGetMinY(self.chartVolumeFrame)) len:self.chartVolumeFrame.size.height];
        
        TQChartTextRenderer *ren = [TQChartTextRenderer defaultRenderer];
        ren.font = self.configuration.textFont;
        ren.color = self.configuration.textColor;
        ren.text = [TQChartDateManager.sharedManager stringFromDate:self.dataArray[idx].tq_timeDate dateFormat:@"MM-dd"];
        ren.offsetRatio = kCGOffsetRatioCenter;
        ren.baseOffset = UIOffsetMake(0, baseOffsetVertical);
        ren.positionCenter = CGPointMake(centerX, positionCenterY);
        [rendArray addObject:ren];
        originX += gap;
    }];
    _xDateGridLayer.path = path.CGPath;
    [_xDateTextLayer updateWithRendererArray:rendArray];
}

- (void)changeDateRenderer:(CGFloat *)posY vertical:(CGFloat *)vertical {
    CGFloat positionCenterY = CGRectGetMaxY(self.chartVolumeFrame);
    CGFloat baseOffsetVertical = self.contentEdgeInset.bottom * 0.5;
    if ([self.configuration.dateLocation isEqualToString:@"middle"]) {
        positionCenterY = CGRectGetMaxY(self.chartTimeFrame);
        baseOffsetVertical = self.chartSeparationGap * 0.5;
    } else if ([self.configuration.dateLocation isEqualToString:@"top"]) {
        positionCenterY = 0;
        baseOffsetVertical = self.contentEdgeInset.top * 0.5;
    }
    *posY = positionCenterY;
    *vertical = baseOffsetVertical;
}

#pragma mark - GestureInitialization / 手势管理

- (void)gestureInitialization {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] init];
    singleTap.delegate = self;
    [self addGestureRecognizer:singleTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.delegate = self;
    [self addGestureRecognizer:longPress];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (!self.crosswireView.fadeHidden) {
            self.crosswireView.fadeHidden = YES;
            return NO;
        }
    }
    CGPoint p = [gestureRecognizer locationInView:self];
    return CGRectContainsPoint(self.chartFrame, p) && !CGRectContainsPoint(self.chartRiverFrame, p);
}

- (void)longPress:(UILongPressGestureRecognizer *)g {
    switch (g.state) {
        case UIGestureRecognizerStateBegan: {
            self.crosswireView.fadeHidden = NO;
            CGPoint p = [g locationInView:self];
            [self updateCrosswireLayerWithPoint:p];
        } break;
        case UIGestureRecognizerStateEnded: {
            [self.crosswireView fadeHiddenDelayed:2];
        } break;
        case UIGestureRecognizerStateChanged: {
            CGPoint p = [g locationInView:self];
            [self updateCrosswireLayerWithPoint:p];
        } break;
        default: break;
    }
}

- (void)updateCrosswireLayerWithPoint:(CGPoint)p {
    if (CGRectContainsPoint(self.chartTimeFrame, p)) { // 获取分时区域对应值
        CGFloat mapValue = [self mapRefValueWithPointY:p.y peak:self.timePeakValue inRect:self.chartTimeFrame];
        CGFloat mapCrValue = [self mapRefValueWithPointY:p.y peak:self.changeRatioPeakValue inRect:self.chartTimeFrame];
        _crosswireView.mapYaixsText = [NSString stringWithFormat:@"%.2f", mapValue];
        if (CG_Float2fIsZero(mapCrValue)) mapCrValue = 0.00;
        _crosswireView.mapYaixsSubjoinText = [NSString stringWithFormat:@"%.2f%%", mapCrValue];
    }
    if (CGRectContainsPoint(self.chartVolumeFrame, p)) { // 获取成交量区域对应值
        CGPeakValue peak = [self.dataArray tq_peakValueBySel:@selector(tq_timeVolume)];
        CGFloat mapValue = [self mapRefValueWithPointY:p.y peak:peak inRect:self.chartVolumeFrame];
        _crosswireView.mapYaixsText = [NSString stringWithFormat:@"%.f", mapValue];
        _crosswireView.mapYaixsSubjoinText = nil;
    }
    p.x -= self.chartFrame.origin.x; p.y -= self.chartFrame.origin.y;
    NSInteger index = [self mapIndexWithPointX:p.x]; // 求对应的时间
    id<TQTimeChartProtocol>obj = self.dataArray[index];
    NSString *dateFormat = (self.configuration.chartType == TQTimeChartTypeFiveDay) ?  @"MM-dd HH:mm" : @"HH:mm";
    NSString *mapText = [TQChartDateManager.sharedManager stringFromDate:obj.tq_timeDate dateFormat:dateFormat];
    _crosswireView.mapIndexText = mapText;
    CGFloat centerX = [self getCenterXWithIndex:index]; // 取中心值
    _crosswireView.spotOfTouched = p;
    _crosswireView.centralPoint = CGPointMake(centerX - self.chartFrame.origin.x, p.y);
    [_crosswireView updateContents];
    
    if ([self.delegate respondsToSelector:@selector(stockTimeChart:didLongPresOfIndex:)]) {
        [self.delegate stockTimeChart:self didLongPresOfIndex:index];
    }
}

@end
