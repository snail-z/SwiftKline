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
#import "TQTimePulsingView.h"
#import "TQChartCrossLineView.h"
#import "TQTimeGradientLayer.h"
#import "TQStockChart+Categories.h"
#import "TQChartDateManager.h"
#import <objc/message.h>

@interface TQTimeChart () <UIGestureRecognizerDelegate>

/** 横向网格线(分时区域) */
@property (nonatomic, strong) CAShapeLayer *yTimeGridLayer;

/** 横向网格线(成交量区域) */
@property (nonatomic, strong) CAShapeLayer *yVolumeGridLayer;

/** 横向网格虚线 */
@property (nonatomic, strong) CAShapeLayer *timeDashLineLayer;

/** 纵向网格线(时间标记线) */
@property (nonatomic, strong) CAShapeLayer *dateGridLayer;

/** 网格两端的边框线 */
@property (nonatomic, strong) CAShapeLayer *borderGridLayer;

/** 分时线 */
@property (nonatomic, strong) CAShapeLayer *timeLineLayer;

/** 分时线填充 */
@property (nonatomic, strong) TQTimeGradientLayer *timeLineFillLayer;

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

/** 映射时间线文本 */
@property (nonatomic, strong) TQChartTextLayer *dateLineTextLayer;

/** 分时线闪动点视图 */
@property (nonatomic, strong) TQTimePulsingView *pulsingView;

/** 十字线查询视图 */
@property (nonatomic, strong) TQChartCrossLineView *crosswireView;
// 应在调用'-drawChart'方法后使用以下frame
//@property (nonatomic, assign, readonly) CGRect chartFrame;
//@property (nonatomic, assign, readonly) CGRect chartTimeFrame;
//@property (nonatomic, assign, readonly) CGRect chartVolumeFrame;
//@property (nonatomic, assign, readonly) CGRect chartSeparatedFrame;

/** 设置内边距(边缘留白) */
@property (nonatomic, assign) UIEdgeInsets contentEdgeInset;

/** 设置分时图表高度 */
@property (nonatomic, assign) CGFloat chartTimeHeight;

/** 设置中间分隔区域 */
@property (nonatomic, assign) CGFloat chartSeparatedGap;

@end

@implementation TQTimeChart

#pragma mark - SublayerInitialization

- (void)sublayerInitialization {
    _yTimeGridLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_yTimeGridLayer];
    
    _timeDashLineLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_timeDashLineLayer];
    
    _yVolumeGridLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_yVolumeGridLayer];
    
    _dateGridLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_dateGridLayer];
    
    _borderGridLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_borderGridLayer];

    _timeLineFillLayer = [TQTimeGradientLayer layer];
    [self.contentChartLayer insertSublayer:_timeLineFillLayer atIndex:0];
    
    _timeLineLayer = [CAShapeLayer layer];
    [self.contentChartLayer addSublayer:_timeLineLayer];
    
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
    
    _dateLineTextLayer = [TQChartTextLayer layer];
    [self.contentTextLayer addSublayer:_dateLineTextLayer];
    
    _pulsingView = [TQTimePulsingView new];
    [self addSubview:_pulsingView];
    
    _crosswireView = [TQChartCrossLineView new];
    _crosswireView.fadeHidden = YES;
    [self addSubview:_crosswireView];
}

#pragma mark - Update sublayer

- (void)updateSublayerStyle {
    _yTimeGridLayer.fillColor = [UIColor clearColor].CGColor;
    _yTimeGridLayer.strokeColor = self.style.gridLineColor.CGColor;
    _yTimeGridLayer.lineWidth = self.style.gridLineWidth;
    
    _timeDashLineLayer.fillColor = [UIColor clearColor].CGColor;
    _timeDashLineLayer.strokeColor = self.style.dashLineColor.CGColor;
    _timeDashLineLayer.lineWidth = self.style.dashLineWidth;
    _timeDashLineLayer.lineDashPattern = self.style.dashLinePattern;
    
    _yVolumeGridLayer.fillColor = _yTimeGridLayer.fillColor;
    _yVolumeGridLayer.strokeColor = _yTimeGridLayer.strokeColor;
    _yVolumeGridLayer.lineWidth = _yTimeGridLayer.lineWidth;
    
    _dateGridLayer.fillColor = _yTimeGridLayer.fillColor;
    _dateGridLayer.strokeColor = _yTimeGridLayer.strokeColor;
    _dateGridLayer.lineWidth = _yTimeGridLayer.lineWidth;
    
    _borderGridLayer.fillColor = _yTimeGridLayer.fillColor;
    _borderGridLayer.strokeColor = _yTimeGridLayer.strokeColor;
    _borderGridLayer.lineWidth = _yTimeGridLayer.lineWidth;
    
    _timeLineLayer.fillColor = [UIColor clearColor].CGColor;
    _timeLineLayer.strokeColor = self.style.timeLineColor.CGColor;
    _timeLineLayer.lineWidth = self.style.timeLineWith;
    _timeLineFillLayer.gradientClolors = self.style.timeLineFillGradientClolors;
    
    _avgTimeLineLayer.fillColor = [UIColor clearColor].CGColor;
    _avgTimeLineLayer.strokeColor = self.style.avgTimeLineColor.CGColor;
    _avgTimeLineLayer.lineWidth = self.style.avgTimeLineWidth;
    
    _volumeRiseLayer.fillColor = self.style.volumeRiseColor.CGColor;
    _volumeFallLayer.fillColor = self.style.volumeFallColor.CGColor;
    _volumeFlatLayer.fillColor = self.style.volumeFlatColor.CGColor;
    _pulsingView.standpointColor = self.style.timeLineColor;
    
    _crosswireView.textFont = self.style.plainTextFont;
    _crosswireView.textColor = self.style.crossTextColor;
    _crosswireView.lineWidth = self.style.crossLineWidth;
    _crosswireView.lineColor = self.style.crossLineColor;
}

#pragma mark - Update drawing layout

- (void)updateLayout {
    NSValue* (^callValue)(CGRect) = ^(CGRect rect) { return [NSValue valueWithCGRect:rect];};
    NSString *(^callKey)(SEL) = ^(SEL sel) { return NSStringFromSelector(sel);};
    CGRect frame1 = CGRectIntegral(UIEdgeInsetsInsetRect(self.bounds, self.layout.contentEdgeInset));
    [self.layout setValue:callValue(frame1) forKey:callKey(@selector(contentFrame))];
    
    CGRect frame2 = self.layout.contentFrame;
    frame2.size.height = MIN(self.layout.topChartHeight, frame2.size.height);
    [self.layout setValue:callValue(frame2) forKey:callKey(@selector(topChartFrame))];
    
    CGRect frame3 = self.layout.contentFrame;
    frame3.origin.y = CGRectGetMaxY(self.layout.topChartFrame);
    frame3.size.height = self.layout.separatedGap;
    [self.layout setValue:callValue(frame3) forKey:callKey(@selector(separatedFrame))];
    
    CGRect frame4 = self.layout.contentFrame;
    frame4.origin.y = CGRectGetMaxY(self.layout.separatedFrame);
    frame4.size.height = CGRectGetMaxY(self.layout.contentFrame) - frame4.origin.y;
    [self.layout setValue:callValue(frame4) forKey:callKey(@selector(bottomChartFrame))];
    
    _timeLineFillLayer.frame = (CGRect){.size.width = self.layout.contentFrame.size.width, .size.height = CGRectGetMaxY(self.layout.topChartFrame)};
    _crosswireView.frame = self.layout.contentFrame;
    _crosswireView.fadeHidden = YES;
    _crosswireView.separationRect = CGRectMake(self.layout.contentFrame.origin.x, self.layout.topChartFrame.size.height, self.layout.topChartFrame.size.width, self.chartSeparatedGap);
    
    NSInteger maxCount = self.style.maxDataCount;
    CGFloat allGap = (maxCount - 1) * self.style.volumeShapeGap;
    CGFloat oneWidth = (self.layout.topChartFrame.size.width - allGap) / (CGFloat)maxCount;
    [self.style setValue:@(oneWidth) forKey:callKey(@selector(volumeShapeWidth))];
}

#pragma mark - Draw charts

- (void)drawChart {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (!self.dataArray) return;
    [self layoutIfNeeded];
    [self updateLayout];
    [self updateSublayerStyle];
    
    [self drawGridBorderLines];
    [self drawTimeGridLines];
    [self drawVolumeGridLines];
    [self drawVolumeChart];
    
    if (self.style.chartType == TQTimeChartTypeFiveDay) {
        [self drawFiveTimeChart];
    } else {
        [self drawTimeChart];
    }
    [CATransaction commit];
}

/** 绘制网格的边框线 */
- (void)drawGridBorderLines {
    CGFloat halfWidth = half(self.style.gridLineWidth);
    CGFloat minX = CGRectGetMinX(self.layout.contentFrame) + halfWidth;
    CGFloat maxX = CGRectGetMaxX(self.layout.contentFrame) - halfWidth;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addVerticalLine:CGPointMake(minX, CGRectGetMinY(self.layout.topChartFrame)) len:self.layout.topChartFrame.size.height];
    [path addVerticalLine:CGPointMake(maxX, CGRectGetMinY(self.layout.topChartFrame)) len:self.layout.topChartFrame.size.height];
    [path addVerticalLine:CGPointMake(minX, CGRectGetMinY(self.layout.bottomChartFrame)) len:self.layout.bottomChartFrame.size.height];
    [path addVerticalLine:CGPointMake(maxX, CGRectGetMinY(self.layout.bottomChartFrame)) len:self.layout.bottomChartFrame.size.height];
    _borderGridLayer.path = path.CGPath;
}

/** 绘制分时区域网格水平线 */
- (void)drawTimeGridLines {
    NSArray<NSString *> *leftTexts = [NSArray tq_segmentedGrid:self.style.timeGridSegments peakValue:self.timePeakValue];
    NSArray<NSString *> *rightTexts = [NSArray tq_segmentedGrid:self.style.timeGridSegments peakValue:self.changeRatioPeakValue];
    CGFloat segGap = self.layout.topChartFrame.size.height / (CGFloat)(leftTexts.count - 1);
    CGFloat originY = self.layout.topChartFrame.origin.y + self.style.gridLineWidth * 0.5;
    CGFloat ratioY = originY + self.changeRatioPeakValue.max / CG_GetPeakDistance(self.changeRatioPeakValue) * self.layout.topChartFrame.size.height;
    UIColor *(^callbackColor)(CGFloat) = ^(CGFloat y) {
        if (y < ratioY) return self.style.volumeRiseColor;
        else if (y > ratioY) return self.style.volumeFallColor;
        else return self.style.plainTextColor;
    };
    
    UIBezierPath *dash = [UIBezierPath bezierPath];
    [dash addHorizontalLine:CGPointMake(self.layout.topChartFrame.origin.x, ratioY) len:self.layout.topChartFrame.size.width];
    _timeDashLineLayer.path = dash.CGPath;
    UIBezierPath *path = [UIBezierPath bezierPath];
    __block NSMutableArray<TQChartTextRenderer *> *rendArray = [NSMutableArray array];
    [leftTexts enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint start = CGPointMake(self.layout.topChartFrame.origin.x, originY + segGap * idx);
        [path addHorizontalLine:start len:self.layout.topChartFrame.size.width];

        TQChartTextRenderer *leftRen = [TQChartTextRenderer defaultRenderer];
        leftRen.font = self.style.plainTextFont;
        leftRen.font = self.style.plainTextFont;
        leftRen.text = text;
        leftRen.color = callbackColor(start.y);
        leftRen.positionCenter = start;
        leftRen.offsetRatio = (CGPoint){.x = 0, .y = (!idx ? 0 : 1)};
        [rendArray addObject:leftRen];
    
        TQChartTextRenderer *rightRen = [TQChartTextRenderer defaultRenderer];
        rightRen.font = self.style.plainTextFont;
        rightRen.font = self.style.plainTextFont;
        rightRen.text = rightTexts[idx];
        rightRen.color = callbackColor(start.y);
        rightRen.positionCenter = (CGPoint){.x = start.x + self.layout.topChartFrame.size.width, .y = start.y};
        rightRen.offsetRatio = (CGPoint){.x = 1, .y = (!idx ? 0 : 1)};
        [rendArray addObject:rightRen];
    }];
    _yTimeGridLayer.path = path.CGPath;
    _yTimeTextLayer.renders = rendArray;
}

/** 绘制成交量区域网格水平线 */
- (void)drawVolumeGridLines {
    CGPeakValue peak = [self.dataArray tq_peakValueBySel:@selector(tq_timeVolume)];
    NSArray<NSString *> *array = [NSArray tq_segmentedGrid:self.style.volumeGirdSegments peakValue:peak];
    CGFloat segGap = self.layout.bottomChartFrame.size.height / (CGFloat)(array.count - 1);
    CGFloat originY = self.layout.bottomChartFrame.origin.y;
    UIBezierPath *path = [UIBezierPath bezierPath];
    __block NSMutableArray<TQChartTextRenderer *> *rendArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint start = CGPointMake(self.layout.bottomChartFrame.origin.x, originY + segGap * idx);
        [path addHorizontalLine:start len:self.layout.bottomChartFrame.size.width];
    }];
    TQChartTextRenderer *firstRen = [TQChartTextRenderer defaultRenderer];
    firstRen.font = self.style.plainTextFont;
    firstRen.color = self.style.plainTextColor;
    firstRen.text = array.firstObject;
    firstRen.positionCenter = self.layout.bottomChartFrame.origin;
    firstRen.offsetRatio = kCGOffsetRatioTopLeft;
    [rendArray addObject:firstRen];
    
    _yVolumeGridLayer.path = path.CGPath;
    _yVolumeTextLayer.renders = rendArray;
}

/** 绘制成交量条形图 */
- (void)drawVolumeChart {
    CGPeakValue peak = [self.dataArray tq_peakValueBySel:@selector(tq_timeVolume)]; // should optimized
//    CGFloat(^pyCallback)(CGFloat) = [self makePyConverter:peak inRect:self.chartVolumeFrame];
    CGpYFromValueCallback pyCallback = CGpYConverterMake(peak, self.layout.bottomChartFrame, self.style.gridLineWidth);
    
    UIBezierPath *risePath = [UIBezierPath bezierPath];
    UIBezierPath *fallPath = [UIBezierPath bezierPath];
    UIBezierPath *flatPath = [UIBezierPath bezierPath];
    [self.dataArray enumerateObjectsUsingBlock:^(id<TQTimeChartProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat originX = [self getOriginXWithIndex:idx];
        CGFloat pointY = pyCallback(obj.tq_timeVolume);
        CGRect rect = CGRectMake(originX, pointY, self.style.volumeShapeWidth, CGRectGetMaxY(self.layout.bottomChartFrame) - pointY);
        NSInteger previousIdx = !idx ?: idx - 1;
        CGFloat previousPrice = self.dataArray[previousIdx].tq_timePrice;
        CGFloat currentPrice = obj.tq_timePrice;
        if (currentPrice > previousPrice) [risePath addRect:rect];
        else if (currentPrice < previousPrice) [fallPath addRect:rect];
        else [flatPath addRect:rect];
    }];
    _volumeRiseLayer.path = risePath.CGPath;
    _volumeFallLayer.path = fallPath.CGPath;
    _volumeFlatLayer.path = flatPath.CGPath;
}

/** 绘制分时图 */
- (void)drawTimeChart {
    [self drawTimeDateLines];
    
    CGpYFromValueCallback pYCallback = CGpYConverterMake(self.timePeakValue, self.layout.topChartFrame, self.style.gridLineWidth);
    CGFloat halfWith = half(self.style.timeLineWith);
    UIBezierPath *timePath = [UIBezierPath bezierPath];
    UIBezierPath *avgPath = [UIBezierPath bezierPath];
    id<TQTimeChartProtocol>firstData = self.dataArray.firstObject;
    CGFloat firstOriginY = pYCallback(firstData.tq_timeClosePrice) + halfWith;
    CGFloat firstAvgOriginY = pYCallback(firstData.tq_timeAveragePrice) + halfWith;
    [timePath moveToPoint:CGPointMake(self.layout.topChartFrame.origin.x, firstOriginY)];
    [avgPath moveToPoint:CGPointMake(self.layout.topChartFrame.origin.x, firstAvgOriginY)];
    [self.dataArray enumerateObjectsUsingBlock:^(id<TQTimeChartProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat centerX = [self getCenterXWithIndex:idx];
        CGFloat originY = pYCallback(obj.tq_timePrice) + halfWith;
        CGFloat avgOriginY = pYCallback(obj.tq_timeAveragePrice) + halfWith;
        [timePath addLineToPoint:CGPointMake(centerX, originY)];
        [avgPath addLineToPoint:CGPointMake(centerX, avgOriginY)];
    }];
    _timeLineLayer.path = timePath.CGPath;
    _avgTimeLineLayer.path = avgPath.CGPath;
    
    id<TQTimeChartProtocol>lastData = self.dataArray.lastObject;
    CGFloat lastCenterX = [self getCenterXWithIndex:self.dataArray.count - 1];
    UIBezierPath *fillPath = [UIBezierPath bezierPathWithCGPath:timePath.CGPath];
    [fillPath addLineToPoint:CGPointMake(lastCenterX, CGRectGetMaxY(self.layout.topChartFrame))];
    [fillPath addLineToPoint:CGPointMake(self.layout.topChartFrame.origin.x, CGRectGetMaxY(self.layout.topChartFrame))];
    [fillPath closePath];
    _timeLineFillLayer.path = fillPath.CGPath;
    
    CGFloat lastOriginY = pYCallback(lastData.tq_timePrice) + halfWith;
    _pulsingView.center = CGPointMake(lastCenterX, lastOriginY);
    [_pulsingView startAnimating];
}

/** 绘制分时日期线及文本 */
- (void)drawTimeDateLines {
    if (self.dateArray.count < 2) return;
    NSInteger section = self.style.maxDataCount / (self.dateArray.count - 1);
    NSRange range = NSMakeRange(1, self.dateArray.count - 2);
    CGFloat positionCenterY; CGFloat baseOffsetVertical;
    [self makeDateRenderer:&positionCenterY baseOffsetVertical:&baseOffsetVertical];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    __block NSMutableArray<TQChartTextRenderer *> *renders = [NSMutableArray array];
    void (^makeRender)(NSString *, CGPoint, CGFloat) = ^(NSString *text, CGPoint ratio, CGFloat centerX) {
        TQChartTextRenderer *render = [TQChartTextRenderer defaultRenderer];
        render.font = self.style.plainTextFont;
        render.color = self.style.plainTextColor;
        render.baseOffset = UIOffsetMake(0, baseOffsetVertical);
        render.text = text;
        render.offsetRatio = ratio;
        render.positionCenter = CGPointMake(centerX, positionCenterY);
        [renders addObject:render];
    };
    makeRender(self.dateArray.firstObject, kCGOffsetRatioCenterLeft, CGRectGetMinX(self.layout.contentFrame));
    [self.dateArray tq_enumerateObjectsAtRange:range usingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat centerX = [self getCenterXWithIndex:(idx * section)];
        [path addVerticalLine:CGPointMake(centerX, CGRectGetMinY(self.layout.topChartFrame)) len:self.layout.topChartFrame.size.height];
        [path addVerticalLine:CGPointMake(centerX, CGRectGetMinY(self.layout.bottomChartFrame)) len:self.layout.bottomChartFrame.size.height];
        makeRender(text, kCGOffsetRatioCenter, centerX);
    }];
    makeRender(self.dateArray.lastObject, kCGOffsetRatioCenterRight, CGRectGetMaxX(self.layout.contentFrame));
    _dateGridLayer.path = path.CGPath;
    _dateLineTextLayer.renders = renders;
}

#pragma mark - 五日分时图

/** 绘制五日分时图 */
- (void)drawFiveTimeChart {
    NSMutableIndexSet *dateIndexSet = [NSMutableIndexSet indexSet];
    NSInteger dayCount = self.style.maxDataCount / 5;
    NSInteger dataCount = self.dataArray.count;
    for (NSInteger i = 0; i < 5; i++) {
        NSInteger index = i * dayCount;
        if (index < dataCount) [dateIndexSet addIndex:index];
    }
    [self drawFiveDateLinesWithIndexSet:dateIndexSet];

    CGFloat(^pyCallback)(CGFloat) = CGpYConverterMake(self.timePeakValue, self.layout.topChartFrame, 1);
    CGFloat halfTimeLineWith = self.style.timeLineWith * 0.5;
    id<TQTimeChartProtocol>firstObj = self.dataArray.firstObject;
    CGFloat firstPointY = pyCallback(self.propConfig.tq_originPrice) + halfTimeLineWith;
    CGFloat avgFirstPointY = pyCallback(firstObj.tq_timeAveragePrice) + halfTimeLineWith;
    
    UIBezierPath *timePath = [UIBezierPath bezierPath];
    UIBezierPath *avgPath = [UIBezierPath bezierPath];
    UIBezierPath *fillPath = [UIBezierPath bezierPath];
    [timePath moveToPoint:CGPointMake(self.layout.topChartFrame.origin.x, firstPointY)];
    [fillPath moveToPoint:CGPointMake(self.layout.topChartFrame.origin.x, firstPointY)];
    [avgPath moveToPoint:CGPointMake(self.layout.topChartFrame.origin.x, avgFirstPointY)];
    [self.dataArray enumerateObjectsUsingBlock:^(id<TQTimeChartProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat centerX = [self getCenterXWithIndex:idx];
        CGFloat pointY = pyCallback(obj.tq_timePrice) + halfTimeLineWith;
        CGFloat avgPointY = pyCallback(obj.tq_timeAveragePrice) + halfTimeLineWith;
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
    [fillPath addLineToPoint:CGPointMake(lastCenterX, CGRectGetMaxY(self.layout.topChartFrame))];
    [fillPath addLineToPoint:CGPointMake(self.layout.topChartFrame.origin.x, CGRectGetMaxY(self.layout.topChartFrame))];
    [fillPath closePath];
    _timeLineFillLayer.path = fillPath.CGPath;
    
    CGFloat lastPointY = pyCallback(lastObj.tq_timePrice) + halfTimeLineWith;
    _pulsingView.center = CGPointMake(lastCenterX, lastPointY);
    [_pulsingView startAnimating];
}

- (void)drawFiveDateLinesWithIndexSet:(NSIndexSet *)indexSet {
    CGFloat positionCenterY; CGFloat baseOffsetVertical;
    [self makeDateRenderer:&positionCenterY baseOffsetVertical:&baseOffsetVertical];
    NSInteger gap = self.layout.topChartFrame.size.width / indexSet.count;
    __block CGFloat originX = self.layout.contentFrame.origin.x;
    __block NSMutableArray<TQChartTextRenderer *> *rendArray = [NSMutableArray array];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat centerX = originX +  gap * 0.5;
        [path addVerticalLine:CGPointMake(originX, CGRectGetMinY(self.layout.topChartFrame)) len:self.layout.topChartFrame.size.height];
        [path addVerticalLine:CGPointMake(originX, CGRectGetMinY(self.layout.bottomChartFrame)) len:self.layout.bottomChartFrame.size.height];
        
        TQChartTextRenderer *ren = [TQChartTextRenderer defaultRenderer];
        ren.font = self.style.plainTextFont;
        ren.color = self.style.plainTextColor;
        ren.text = [TQChartDateManager.sharedManager stringFromDate:self.dataArray[idx].tq_timeDate dateFormat:@"MM-dd"];
        ren.offsetRatio = kCGOffsetRatioCenter;
        ren.baseOffset = UIOffsetMake(0, baseOffsetVertical);
        ren.positionCenter = CGPointMake(centerX, positionCenterY);
        [rendArray addObject:ren];
        originX += gap;
    }];
    _dateGridLayer.path = path.CGPath;
    _dateLineTextLayer.renders = rendArray;
}

#pragma mark - GestureInitialization / 手势管理

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
    return CGRectContainsPoint(self.layout.contentFrame, p) && !CGRectContainsPoint(self.layout.separatedFrame, p);
}

- (void)singleTap:(UITapGestureRecognizer *)g {
    CGPoint p = [g locationInView:g.view];
    BOOL isTimeChartRange = CGRectContainsPoint(self.layout.topChartFrame, p);
    if ([self.delegate respondsToSelector:@selector(stockTimeChart:didSingleTapAtRange:)]) {
        [self.delegate stockTimeChart:self didSingleTapAtRange:isTimeChartRange];
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)g {
    CGPoint p = [g locationInView:g.view];
    BOOL isTimeChartRange = CGRectContainsPoint(self.layout.topChartFrame, p);
    if ([self.delegate respondsToSelector:@selector(stockTimeChart:didDoubleTapAtRange:)]) {
        [self.delegate stockTimeChart:self didDoubleTapAtRange:isTimeChartRange];
    }
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
            if ([self.delegate respondsToSelector:@selector(stockTimeChartEndLongPress:)]) {
                [self.delegate stockTimeChartEndLongPress:self];
            }
        } break;
        default: break;
    }
}

- (void)updateCrosswireLayerWithPoint:(CGPoint)p {
    BOOL isNeedsDisplay = !self.style.crossLineHidden;
    if (CGRectContainsPoint(self.layout.topChartFrame, p) && isNeedsDisplay) {
        CGFloat value = CGpYToValueCallback(self.timePeakValue, self.layout.topChartFrame, p.y);
        CGFloat subValue = CGpYToValueCallback(self.changeRatioPeakValue, self.layout.topChartFrame, p.y);
        _crosswireView.yaixsText = NS_StringFromFloat(CG_RoundFloatKeep2(value));
        if (CG_FloatIs2fZero(subValue)) subValue = 0.00;
        _crosswireView.yaixsSubText = NS_StringFromFloat(CG_RoundFloatKeep2(subValue));
    }
    if (CGRectContainsPoint(self.layout.bottomChartFrame, p) && isNeedsDisplay) {
        CGPeakValue peak = [self.dataArray tq_peakValueBySel:@selector(tq_timeVolume)];
        CGFloat value = CGpYToValueCallback(peak, self.layout.bottomChartFrame, p.y);
        _crosswireView.yaixsText = NS_StringFromFloat(CG_RoundFloatKeep(value, 1));
        _crosswireView.yaixsSubText = nil;
    }
    p.x -= self.layout.contentFrame.origin.x; p.y -= self.layout.contentFrame.origin.y;
    NSInteger index = [self mapIndexWithOriginX:p.x];
    if (isNeedsDisplay) {
        id<TQTimeChartProtocol>obj = self.dataArray[index];
        NSString *dateFormat = (self.style.chartType == TQTimeChartTypeFiveDay) ? @"MM-dd HH:mm" : @"HH:mm";
        NSString *mapText = [TQChartDateManager.sharedManager stringFromDate:obj.tq_timeDate dateFormat:dateFormat];
        _crosswireView.correspondIndexText = mapText;
        CGFloat centerX = [self getCenterXWithIndex:index]; // centerX value
        _crosswireView.spotOfTouched = p;
        [_crosswireView redrawWithCentralPoint:CGPointMake(centerX - self.layout.contentFrame.origin.x, p.y)];
    }
    if ([self.delegate respondsToSelector:@selector(stockTimeChart:didLongPressAtCorrespondIndex:)]) {
        [self.delegate stockTimeChart:self didLongPressAtCorrespondIndex:index];
    }
}

@end
