//
//  TQStockChartUtilities.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/17.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

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
    CGFloat gridLineWidth;
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
CGChartPlotterMake(CGFloat shapeWidth, CGFloat shapeGap, CGRect drawRect, CGFloat gridLineWidth) {
    CGChartPlotter plotter;
    plotter.shapeWidth = shapeWidth; plotter.shapeGap = shapeGap;
    plotter.drawRect = drawRect; plotter.gridLineWidth = gridLineWidth;
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
    return (CGFloat)fabs(peak.max - peak.min);
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

/** 坐标纵轴数值⇋originY转换 */
typedef CGFloat(^CGpYFromValueCallback)(CGFloat value);
CGpYFromValueCallback CGpYConverterMake (CGPeakValue peak, CGRect rect, CGFloat borderWidth);
CGFloat CGpYToValueCallback (CGPeakValue peak, CGRect rect, CGFloat pY);


#ifndef half
#define half(a) ((a) * 0.5)
#endif

/////////////////////////////////////////////////////////////////

/** 判断浮点数是否为0 (最小误差0.000001) */
CGFloat CG_FloatIsZero(CGFloat a);

/** 判断浮点数是否为0 (两位浮点误差) */
CGFloat CG_FloatIs2fZero(CGFloat a);

/** 判断两个浮点数是否相等 */
CGFloat CG_FloatEqualFloat(CGFloat a, CGFloat b);

/** 对浮点数四舍五入，精确到小数点后n位 */
CGFloat CG_RoundFloatKeep(CGFloat value, short n);

/** 对浮点数四舍五入，精确到小数点后两位 */
CGFloat CG_RoundFloatKeep2(CGFloat value);

/** 对浮点数保留n位，不四舍五入 */
CGFloat CG_PlainFloatKeep(CGFloat value, short n);

/** 浮点数转字符串 */
NSString* NS_StringFromFloat(CGFloat value);

/** 浮点数转百分数字符串，例如0.01 = 1% */
NSString* NS_PercentFromFloat(CGFloat value);

/** 百分数字符串转浮点数，例如1% = 0.01 */
CGFloat CG_FloatFromPercent(NSString *percentString);

/** 浮点数转货币字符串，例如10000 = ￥10,000.00 */
NSString* NS_CurrencyFromFloat(CGFloat value);

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
