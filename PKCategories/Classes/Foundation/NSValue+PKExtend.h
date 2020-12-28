//
//  NSValue+PKExtend.h
//  PKCategories
//
//  Created by zhanghao on 2020/9/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 主屏幕的scale */
CGFloat screenScale(void);

/** 主屏幕的size(高度总是大于宽度) */
CGSize screenSize(void);

//============================================================//

/** 将像素px转换成pt */
CG_INLINE CGFloat CGFloatFromPixel(CGFloat pixel) {
    return pixel / screenScale();
}

/** 将pt转换成像素px */
CG_INLINE CGFloat CGFloatToPixel(CGFloat aFloat) {
    return aFloat * screenScale();
}

/** CGFloatPixelCeil(n) 取大于等于数值n的最小整数 */
CG_INLINE CGFloat CGFloatPixelCeil(CGFloat value) {
    CGFloat scale = screenScale();
    return ceil(value * scale) / scale;
}

/** CGFloatPixelRound(n) 对数值n四舍五入 */
CG_INLINE CGFloat CGFloatPixelRound(CGFloat value) {
    CGFloat scale = screenScale();
    return round(value * scale) / scale;
}

/** CGFloatPixelHalf(n) 取数值n的一半 */
CG_INLINE CGFloat CGFloatPixelHalf(CGFloat value) {
    CGFloat scale = screenScale();
    return (floor(value * scale) + 0.5) / scale;
}

/** 获取⼀个随机整数，范围在[from, to)，包括from但不包括to */
NS_INLINE NSInteger RandomInteger(NSInteger from, NSInteger to) {
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

/** 通过 {0, 0, size} 生成CGRect */
CG_INLINE CGRect CGRectFast1(CGSize size) {
    return CGRectMake(0, 0, size.width, size.height);
}

/** 通过 {x, y, size} 生成CGRect */
CG_INLINE CGRect CGRectFast2(CGFloat x, CGFloat y, CGSize size) {
    return CGRectMake(x, y, size.width, size.height);
}

/** 通过 {x, 0, size} 生成CGRect */
CG_INLINE CGRect CGRectFast3(CGFloat x, CGSize size) {
    return CGRectMake(x, 0, size.width, size.height);
}

/** 通过 {0, y, size} 生成CGRect */
CG_INLINE CGRect CGRectFast4(CGFloat y, CGSize size) {
    return CGRectMake(0, y, size.width, size.height);
}

//============================================================//

/** 返回CGFloat的 0.5倍 */
CG_INLINE CGFloat CGHalf(CGFloat value) {
    return value * 0.5;
}

//============================================================//

/* Extrema value . */
struct CGExtremaValue {
    CGFloat max, min;
};
typedef struct CGExtremaValue CGExtremaValue;

/* CGExtremaValue */
CG_INLINE CGExtremaValue CGExtremaValueMake(CGFloat max, CGFloat min) {
    CGExtremaValue value; value.max = max; value.min = min; return value;
}

#define CGExtremaValueZero CGExtremaValueMake(0.f, 0.f)

@interface NSValue (PKExtend)

+ (NSValue *)pk_valueWithExtremaValue:(CGExtremaValue)extremaValue;
- (CGExtremaValue)pk_extremaValue;

@end

NS_ASSUME_NONNULL_END
