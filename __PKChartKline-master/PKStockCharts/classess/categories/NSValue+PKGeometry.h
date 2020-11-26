//
//  NSValue+PKGeometry.h
//  PKStockCharts
//
//  Created by zhanghao on 2019/7/11.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/* Peak value . */
struct CGPeakValue {
    CGFloat max, min;
};
typedef struct CGPeakValue CGPeakValue;

/* Index value . */
struct CGIndexValue {
    NSInteger index;
    CGFloat value;
};
typedef struct CGIndexValue CGIndexValue;

/* Index peak value . */
struct CGIndexPeakValue {
    CGIndexValue max, min;
};
typedef struct CGIndexPeakValue CGIndexPeakValue;

/* Candle Shape . */
struct CGCandleShape {
    CGPoint top;
    CGRect rect;
    CGPoint bottom;
};
typedef struct CGCandleShape CGCandleShape;

/* Chart Scaler . */
struct CGChartScaler {
    CGFloat shapeWidth, shapeGap;
    CGRect chartRect;
};
typedef struct CGChartScaler CGChartScaler;

/* CGPeakValue */
CG_INLINE CGPeakValue CGPeakValueMake(CGFloat max, CGFloat min) {
    CGPeakValue peak; peak.max = max; peak.min = min; return peak;
}

/* CGIndexValue */
CG_INLINE CGIndexValue CGIndexValueMake(NSInteger idx, CGFloat value) {
    CGIndexValue idxValue; idxValue.index = idx; idxValue.value = value; return idxValue;
}

/* CGIndexPeakValue */
CG_INLINE CGIndexPeakValue CGIndexPeakValueMake(CGIndexValue max, CGIndexValue min) {
    CGIndexPeakValue value; value.max = max; value.min = min; return value;
}

/* CGCandleShape */
CG_INLINE CGCandleShape CGCandleShapeMake(CGPoint top, CGRect rect, CGPoint bottom) {
    CGCandleShape shape;
    shape.top = top; shape.rect = rect; shape.bottom = bottom;
    return shape;
}

/* CGChartScaler */
CG_INLINE CGChartScaler CGChartScalerMake(CGFloat shapeWidth, CGFloat shapeGap, CGRect chartRect) {
    CGChartScaler scaler;
    scaler.shapeWidth = shapeWidth; scaler.shapeGap = shapeGap;
    scaler.chartRect = chartRect;
    return scaler;
}

CG_EXTERN const CGPeakValue CGPeakValueZero;
CG_EXTERN const CGIndexValue CGIndexValueZero;
CG_EXTERN const CGIndexPeakValue CGIndexPeakValueZero;
CG_EXTERN const CGCandleShape CGCandleShapeZero;
CG_EXTERN const CGChartScaler CGChartScalerZero;


/** 判断range1是否包含range2 */
NS_INLINE bool NS_RangeContainsRange(NSRange range1, NSRange range2) {
    return !((range1.location > range2.location) || (NSMaxRange(range1) < NSMaxRange(range2)));
}

/** Range范围向后偏移1位的Range */
NS_INLINE NSRange NS_RangeOffset1(NSRange range) {
    return NSMakeRange(range.location + 1, range.length - 1);
}

/** 取数值的一半 */
CG_INLINE CGFloat half(CGFloat a) { return (a) * 0.5; }


/** 返回一个有效除数(非零值但存在误差) */
CG_EXTERN CGFloat CGValidDivisor(CGFloat a);

/** 限制浮点数值在(0~1)之间 */
CG_EXTERN CGFloat CGRatioLimit(CGFloat a);

/** 限制浮点数值在极值之间 */
CG_EXTERN CGFloat CGPeakLimit(CGPeakValue peak, CGFloat a);

/** 判断浮点数是否为0值 (最小误差0.000001，小数点后6位) */
CG_EXTERN bool CGFloatEqualZero(CGFloat a);

/** 判断浮点数是否为0值 (最小误差0.001，小数点后3位) */
CG_EXTERN bool CGFloatRoughEqualZero(CGFloat a);

/** 判断两个浮点数是否相等 (最小误差0.000001) */
CG_EXTERN bool CGFloatEqualFloat(CGFloat a, CGFloat b);


/** 判断浮点数是否在极值范围内 */
CG_EXTERN bool CGPeakValueContainsFloat(CGPeakValue peak, CGFloat a);

/** 判断两个极值是否相同 */
CG_EXTERN bool CGPeakValueEqualToPeakValue(CGPeakValue peak1, CGPeakValue peak2);

/** 若极值中有一个为0值，则返回YES */
CG_EXTERN bool CGPeakValueContainZero(CGPeakValue peakValue);

/** 获取peakValue的中间值 */
CG_EXTERN CGFloat CGPeakValueGetMidValue(CGPeakValue peak);

/** 获取peakValue极值间的距离 */
CG_EXTERN CGFloat CGPeakValueGetDistance(CGPeakValue peak);

/** 获得数组中的CGPeakValue比较后的最大最小值 */
CG_EXTERN CGPeakValue CGPeakValueTraverses(const CGPeakValue *traverses, size_t count);

/** 同上方法，将跳过0值的比较 */
CG_EXTERN CGPeakValue CGPeakValueSkipZeroTraverses(const CGPeakValue *traverses, size_t count);


/** 将纵轴数值转为对应的位置 */
typedef CGFloat(^CGMakeYaxisBlock)(CGFloat floatValue);

/** 生成一个纵轴数值转换器 */
CG_EXTERN CGMakeYaxisBlock CGMakeYaxisBlockCreator (CGPeakValue peakValue, CGRect rect);

/** 将纵轴位置转为对应的数值 */
CG_EXTERN CGFloat CGMakeYnumberBlock (CGPeakValue peakValue, CGRect rect, CGFloat yaxis);

/** 将纵轴下标转为横轴对应的位置 */
typedef CGFloat(^CGMakeXaxisBlock)(NSInteger index);

/** 生成一个横轴索引转换器 */
CG_EXTERN CGMakeXaxisBlock CGMakeXaxisBlockCreator (CGFloat shapeWidth, CGFloat shapeGap);

/** 将纵轴位置转为横轴对应的下标 */
CG_EXTERN NSInteger CGMakeXindexBlock (CGFloat shapeWidth, CGFloat shapeGap, CGFloat dataCount, CGFloat xaxis);


@interface NSValue (PKGeometry)

+ (NSValue *)pk_valueWithPeakValue:(CGPeakValue)peakValue;
- (CGPeakValue)pk_peakValue;

+ (NSValue *)pk_valueWithIndexValue:(CGIndexValue)indexValue;
- (CGIndexValue)pk_indexValue;

+ (NSValue *)pk_valueWithIndexPeakValue:(CGIndexPeakValue)indexPeakValue;
- (CGIndexPeakValue)pk_indexPeakValue;

+ (NSValue *)pk_valueWithCandleShape:(CGCandleShape)candleShape;
- (CGCandleShape)pk_candleShape;

+ (NSValue *)pk_valueWithChartScaler:(CGChartScaler)chartScaler;
- (CGChartScaler)pk_chartScaler;

@end

NS_ASSUME_NONNULL_END

