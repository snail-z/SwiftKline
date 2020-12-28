//
//  NSNull+PKSafeAccess.m
//  PKCategories
//
//  Created by zhanghao on 2019/4/13.
//

#import "NSNull+PKSafeAccess.h"
#import <objc/runtime.h>

#ifndef NULLSAFE_ENABLED
#define NULLSAFE_ENABLED 1
#endif

@implementation NSNull (PKSafeAccess)

#if NULLSAFE_ENABLED

// From: <https://github.com/nicklockwood/NullSafe>

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    //look up method signature
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if (!signature)
    {
        for (Class someClass in @[
                                  [NSMutableArray class],
                                  [NSMutableDictionary class],
                                  [NSMutableString class],
                                  [NSNumber class],
                                  [NSDate class],
                                  [NSData class]
                                  ])
        {
            @try
            {
                if ([someClass instancesRespondToSelector:selector])
                {
                    signature = [someClass instanceMethodSignatureForSelector:selector];
                    break;
                }
            }
            @catch (__unused NSException *unused) {}
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    invocation.target = nil;
    [invocation invoke];
}

#endif

- (NSInteger)length {
    return 0;
}

@end
