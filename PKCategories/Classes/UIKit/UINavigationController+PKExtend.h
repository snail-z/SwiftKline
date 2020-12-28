//
//  UINavigationController+PKExtend.h
//  PKCategories
//
//  Created by zhanghao on 2020/9/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (PKExtend)

/** 为导航控制器pop动画增加完成回调 */
- (void)pk_popViewControllerCompletion:(void (^)(void))completion;

/** 为导航控制器push动画增加完成回调 */
- (void)pk_pushViewController:(UIViewController *)viewController completion:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
