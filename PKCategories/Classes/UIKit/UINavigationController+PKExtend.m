//
//  UINavigationController+PKExtend.m
//  PKCategories
//
//  Created by zhanghao on 2020/9/17.
//

#import "UINavigationController+PKExtend.h"

@implementation UINavigationController (PKExtend)

- (void)pk_popViewControllerCompletion:(void (^)(void))completion {
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    [self popViewControllerAnimated:YES];
    [CATransaction commit];
}

- (void)pk_pushViewController:(UIViewController *)viewController completion:(void (^)(void))completion {
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    [self pushViewController:viewController animated:YES];
    [CATransaction commit];
}

@end
