//
//  NSValue+PKExtend.m
//  PKCategories
//
//  Created by zhanghao on 2020/9/21.
//

#import "NSValue+PKExtend.h"

CGFloat screenScale() {
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    return scale;
}

CGSize screenSize() {
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = [UIScreen mainScreen].bounds.size;
        if (size.height < size.width) {
            CGFloat tmp = size.height;
            size.height = size.width;
            size.width = tmp;
        }
    });
    return size;
}

@implementation NSValue (PKExtend)

+ (NSValue *)pk_valueWithExtremaValue:(CGExtremaValue)extremaValue {
    return [NSValue value:&extremaValue withObjCType:@encode(CGExtremaValue)];
}

- (CGExtremaValue)pk_extremaValue {
    CGExtremaValue extremaValue;
    [self getValue:&extremaValue];
    return extremaValue;
}

@end
