//
//  PKAsyncTimeLayer.m
//  PKStockCharts
//
//  Created by zhanghao on 2019/7/29.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import "PKAsyncTimeLayer.h"

@interface PKAsyncTimeLayer () {
    dispatch_queue_t _render_queue;
}
@end

@implementation PKAsyncTimeLayer

- (instancetype)init {
    if (self = [super init]) {
        self.contentsScale = [UIScreen mainScreen].scale;
        _render_queue = dispatch_queue_create("com.psychokinesis.asyncTimeLayer", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)display {
    if (self) {
        [self _displayAsync];
    }
}

- (void)_displayAsync {
    BOOL opaque = self.opaque;
    CGSize size = self.bounds.size;
    CGFloat scale = self.contentsScale;
    CGColorRef backgroundColor = (opaque && self.backgroundColor) ? CGColorRetain(self.backgroundColor) : NULL;
    if (size.width < 1 || size.height < 1) {
        CGImageRef image = (__bridge_retained CGImageRef)(self.contents);
        self.contents = nil;
        if (image) {
            dispatch_async(_render_queue, ^{
                CFRelease(image);
            });
        }
        CGColorRelease(backgroundColor);
        return;
    }
    
    dispatch_async(_render_queue, ^{
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (opaque) {
            CGContextSaveGState(context);
            {
                if (!backgroundColor || CGColorGetAlpha(backgroundColor) < 1) {
                    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                    CGContextAddRect(context, CGRectMake(0, 0, size.width * scale, size.height * scale));
                    CGContextFillPath(context);
                }
                if (backgroundColor) {
                    CGContextSetFillColorWithColor(context, backgroundColor);
                    CGContextAddRect(context, CGRectMake(0, 0, size.width * scale, size.height * scale));
                    CGContextFillPath(context);
                }
                
            }
            CGContextRestoreGState(context);
            CGColorRelease(backgroundColor);
            
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            dispatch_async(dispatch_get_main_queue(), ^{
                self.contents = (__bridge id)(image.CGImage);
            });
        }
    });
}

@end
