//
//  TJPageController.h
//  PKCategories_Example
//
//  Created by zhanghao on 2020/12/30.
//  Copyright © 2020 gren-beans. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TJPageControllerDataSource, TJPageControllerDelegate;

@interface TJPageController : UIViewController

@property(nonatomic, weak, nullable) id<TJPageControllerDataSource> dataSource;
@property(nonatomic, weak, nullable) id<TJPageControllerDelegate> delegate;

/** 当前显示的子控制器对应的索引 */
@property(nonatomic, assign, readonly) NSInteger currentIndex;

/** 当前显示的子控制器，与currentIndex对应 */
@property(nonatomic, readonly, nullable) __kindof UIViewController *currentViewController;

/** 分页控制器的所有子控制器 */
@property(nonatomic, readonly, nullable) NSArray<__kindof UIViewController *> *viewControllers;

/** 是否启用边缘弹性效果，默认NO */
@property(nonatomic, assign) BOOL allowBounces;

/** 是否允许滚动，默认YES */
@property(nonatomic, assign) BOOL scrollEnabled;

/** 触摸点在边缘时是否启用多手势，启用需设置此边界值 */
@property (nonatomic, assign) CGFloat panGestureTriggerBoundary;

/** 是否当索引发生改变后，页面过渡完成的回调才会响应，默认NO */
@property (nonatomic, assign) BOOL sendEndTransitionWhenPageChanged;

/** 滚动到指定页面 (调用该方法时不会触发`TJPageControllerDelegate`回调) */
- (void)setCurrentIndex:(NSInteger)index animated:(BOOL)animated;

/** 重载页面所有子视图控制器 */
- (void)reloadPages;

@end

@protocol TJPageControllerDataSource <NSObject>
@required

/** 分页视图控制器的页面数量 */
- (NSInteger)numberOfPagesInPageController:(TJPageController *)pageController;

/** 返回指定位置的视图控制器 */
- (UIViewController *)pageController:(TJPageController *)pageController pageAtIndex:(NSInteger)index;

@end

@protocol TJPageControllerDelegate <NSObject>
@optional

/** 页面将要开始过渡 */
- (void)pageControllerWillStartTransition:(TJPageController *)pageController;

/** 页面正在过渡中(progress-滚动进度) */
- (void)pageController:(TJPageController *)pageController didUpdateTransition:(CGFloat)progress;

/** 页面已经完成过渡 */
- (void)pageControllerDidEndTransition:(TJPageController *)pageController;

@end

NS_ASSUME_NONNULL_END
