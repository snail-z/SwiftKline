//
//  TQStockChartUtilities.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/17.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///* Index value . */
//struct TNIndexValue {
//    NSInteger index;
//    CGFloat value;
//};
//typedef struct TNIndexValue TNIndexValue;
//
///* Index peak . */
//struct TNIndexPeak {
//    TNIndexValue max;
//    TNIndexValue min;
//};
//typedef struct TNIndexPeak TNIndexPeak;


/* Peak value . */
struct CGPeakValue {
    CGFloat max;
    CGFloat min;
};
typedef struct CGPeakValue CGPeakValue;

/* Index value . */
struct CGIndexValue {
    NSInteger index;
    CGFloat value;
};
typedef struct CGIndexValue CGIndexValue;

/* Peak index value . */
struct CGPeakIndexValue {
    CGIndexValue max;
    CGIndexValue min;
};
typedef struct CGPeakIndexValue CGPeakIndexValue;

/* Candle Shape . */
struct CGCandleShape {
    CGPoint top;
    CGRect rect;
    CGPoint bottom;
};
typedef struct CGCandleShape CGCandleShape;

/* Chart Plotter . */
struct CGChartPlotter {
    CGFloat shapeWidth;
    CGFloat shapeGap;
    CGRect drawRect;
    CGFloat strokeWidth;
};
typedef struct CGChartPlotter CGChartPlotter;

/* CGPeakValue */
CG_INLINE CGPeakValue
CGPeakValueMake(CGFloat max, CGFloat min) {
    CGPeakValue peak; peak.max = max; peak.min = min; return peak;
}
#define CGPeakValueZero CGPeakValueMake(0.f, 0.f)

/* CGIndexValue */
CG_INLINE CGIndexValue
CGIndexValueMake(NSInteger idx, CGFloat value) {
    CGIndexValue idxValue; idxValue.index = idx; idxValue.value = value; return idxValue;
}

/* CGPeakIndexValue */
CG_INLINE CGPeakIndexValue
CGPeakIndexValueMake(CGIndexValue max, CGIndexValue min) {
    CGPeakIndexValue piv; piv.max = max; piv.min = min; return piv;
}

/* CGCandleShape */
CG_INLINE CGCandleShape
CGCandleShapeMake(CGPoint top, CGRect rect, CGPoint bottom) {
    CGCandleShape shape;
    shape.top = top; shape.rect = rect; shape.bottom = bottom;
    return shape;
}
#define CGCandleShapeZero CGCandleShapeMake(CGPointZero, CGRectZero, CGPointZero)

/* CGChartPlotter */
CG_INLINE CGChartPlotter
CGChartPlotterMake(CGFloat shapeWidth, CGFloat shapeGap, CGFloat strokeWidth, CGRect drawRect) {

    CGChartPlotter plotter;
    plotter.shapeWidth = shapeWidth; plotter.shapeGap = shapeGap; plotter.strokeWidth = strokeWidth;
    plotter.drawRect = drawRect;
    return plotter;
}

/** 判断两个极值peakValue是否相同 */
CG_INLINE bool CG_PeakEqualToPeak(CGPeakValue peak1, CGPeakValue peak2) {
    return peak1.max == peak2.max && peak1.min == peak2.min;
}

/** 获取peakValue的中间值 */
CG_INLINE CGFloat CG_GetPeakMidValue(CGPeakValue peak) {
    return peak.max - (peak.max - peak.min) * 0.5;
}

/** 获取peakValue极值间的距离 */
CG_INLINE CGFloat CG_GetPeakDistance(CGPeakValue peak) {
    return fabs(peak.max - peak.min) * 1.f;
}

/** 判断range1是否包含range2 */
NS_INLINE BOOL NS_RangeContainsRange(NSRange range1, NSRange range2) {
    return !((range1.location > range2.location) || (NSMaxRange(range1) < NSMaxRange(range2)));
}

/** Range范围内向后偏移1位range */
NS_INLINE NSRange NS_RangeOffset1(NSRange range) {
    return NSMakeRange(range.location + 1, range.length - 1);
}

/////////////////////////////////////////////////////////////////

/** 纵轴数值=>转axisY */
typedef CGFloat(^CGaxisYConverBlock)(CGFloat value);
UIKIT_EXTERN CGaxisYConverBlock CGaxisYConverMaker (CGPeakValue peak, CGRect rect, CGFloat borderWidth);
/** axisY=>转对应的数值 */
UIKIT_EXTERN CGFloat CGaxisYToValueBlock (CGPeakValue peak, CGRect rect, CGFloat axisY);

/** 数组下标=>转axisX(这里的axisX实际是每个shape对应的中心点CenterX) */
typedef CGFloat(^CGaxisXConverBlock)(NSInteger index);
UIKIT_EXTERN CGaxisXConverBlock CGaxisXConverMaker (CGFloat shapeWidth, CGFloat shapeGap);
/** axisX=>转对应的数组下标 */
UIKIT_EXTERN CGFloat CGaxisXToIndexBlock (CGFloat axisX, CGFloat shapeWidth, CGFloat shapeGap, NSUInteger dataCount);

#ifndef half
#define half(a) ((a) * 0.5)
#endif

#ifndef STRINGSEL
#define STRINGSEL(sel) NSStringFromSelector(@selector(sel))
#endif

/////////////////////////////////////////////////////////////////

/** 检测使用CGPeakValue绘图时是否异常 */
UIKIT_EXTERN CGPeakValue CG_CheckPeakValue(CGPeakValue peak, NSString *description);

/** 获取数组中所有CGPeakValue比较后的最大最小值 */
UIKIT_EXTERN CGPeakValue CG_TraversePeakValues(const CGPeakValue *traverses, size_t count);

/** 同上方法，将跳过0值的比较 */
UIKIT_EXTERN CGPeakValue CG_TraverseSkipZeroPeakValues(const CGPeakValue *traverses, size_t count);

/** 判断浮点数是否为0 (最小误差0.000001) */
UIKIT_EXTERN CGFloat CG_FloatIsZero(CGFloat a);

/** 判断浮点数是否为0 (最小误差0.001) */
UIKIT_EXTERN CGFloat CG_FloatIs2fZero(CGFloat a);

/** 判断两个浮点数是否相等 */
UIKIT_EXTERN CGFloat CG_FloatEqualFloat(CGFloat a, CGFloat b);

/** 对浮点数保留n位，不四舍五入 */
UIKIT_EXTERN NSString* NS_StringFromPlainFloatKeep(CGFloat value, short n);

/** 对浮点数保留2位，不四舍五入 */
UIKIT_EXTERN NSString* NS_StringFromPlainFloatKeep2(CGFloat value);

/** 对浮点数四舍五入，精确到小数点后n位 */
UIKIT_EXTERN NSString* NS_StringFromRoundFloatKeep(CGFloat value, short n);

/** 对浮点数四舍五入，精确到小数点后两位 */
UIKIT_EXTERN NSString* NS_StringFromRoundFloatKeep2(CGFloat value);

/** 浮点数转百分数字符串，例如0.01 = 1% */
UIKIT_EXTERN NSString* NS_PercentFromFloat(CGFloat value);

/** 百分数字符串转浮点数，例如1% = 0.01 */
UIKIT_EXTERN CGFloat CG_FloatFromPercent(NSString *percentString);

/** 浮点数转货币字符串，例如10000 = ￥10,000.00 */
UIKIT_EXTERN NSString* NS_CurrencyFromFloat(CGFloat value);

/////////////////////////////////////////////////////////////////

@interface NSValue (TQChart)

+ (NSValue *)valueWithPeakValue:(CGPeakValue)peakValue;
- (CGPeakValue)peakValue;

+ (NSValue *)valueWithIndexValue:(CGIndexValue)indexValue;
- (CGIndexValue)indexValue;

+ (NSValue *)valueWithCandleShape:(CGCandleShape)candleShape;
- (CGCandleShape)candleShape;

@end

NS_ASSUME_NONNULL_END
