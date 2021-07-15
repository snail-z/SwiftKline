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

/*** 定义内联函数 */

/* CGPeakValue */
CG_INLINE CGPeakValue
CGPeakValueMake(CGFloat max, CGFloat min) {
    CGPeakValue peak; peak.max = max; peak.min = min; return peak;
}
#define CGPeakValueZero CGPeakValueMake(0.f, 0.f)

CG_INLINE bool CGPeakEqualToPeak(CGPeakValue peak1, CGPeakValue peak2) {
    return peak1.max == peak2.max && peak1.min == peak2.min;
}

CG_INLINE CGFloat CGGetPeakMidValue(CGPeakValue peak) {
    return peak.max - (peak.max - peak.min) * 0.5;
}

CG_INLINE CGFloat CGGetPeakDistanceValue(CGPeakValue peak) {
    return (CGFloat)fabs(peak.max - peak.min);
}

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


/** 对浮点数value四舍五入 (keep-精确到小数点后的位数) */
CG_INLINE CGFloat CG_RoundKeepFloat(CGFloat value, short keep) {
    double factor = pow(10, keep);
    return (floor(value * factor + 0.5)) / factor;
}

/** 浮点数四舍五入，精确到小数点后两位 */
CG_INLINE CGFloat CG_RoundFloat(CGFloat value) {
    return CG_RoundKeepFloat(value, 2);
}

/** 判断浮点数是否为0 */
CG_INLINE CGFloat CG_FloatIsZero(CGFloat a) {
    CGFloat _EPSILON = 0.000001; // 最小误差
    return (fabs(a) < _EPSILON);
}

/** 判断浮点数是否为0 (两位浮点误差) */
CG_INLINE CGFloat CG_Float2fIsZero(CGFloat a) {
    CGFloat _EPSILON = 0.001; // 2位浮点误差
    return (fabs(a) < _EPSILON);
}

/** 判断两个浮点数是否相等 */
CG_INLINE CGFloat CG_FloatEqualFloat(CGFloat a, CGFloat b) {
    return (fabs(a - b) <= DBL_EPSILON);
}

/** 返回在Rect范围内的Point */
CG_INLINE CGPoint CG_RectBoundaryPoint(CGRect rect, CGPoint point) {
    CGPoint p = point;
    p.x = MIN(CGRectGetMaxX(rect), MAX(rect.origin.x, p.x));
    p.y = MIN(CGRectGetMaxY(rect), MAX(rect.origin.y, p.y));
    return p;
}

/** 判断range1是否包含range2 */
NS_INLINE BOOL NS_RangeContainsRange(NSRange range1, NSRange range2) {
    return !((range1.location > range2.location) || (NSMaxRange(range1) < NSMaxRange(range2)));
}

/** Range范围内向后偏移1位range */
NS_INLINE NSRange NS_RangeOffset1(NSRange range) {
    return NSMakeRange(range.location + 1, range.length - 1);
}


typedef CGFloat(^CG_AxisConvertBlock)(CGFloat value);
/** 纵轴换算 */
CG_INLINE CG_AxisConvertBlock CG_YaxisConvertBlock (CGPeakValue peak, CGRect rect) {
    CGFloat delta = peak.max - peak.min; delta = (delta != 0 ? delta : 1);
    return ^(CGFloat value) {
        CGFloat proportion = fabs(peak.max - value) / delta;
        return rect.origin.y + rect.size.height * proportion;
    };
}



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
