//
//  TJPageController.m
//  PKCategories_Example
//
//  Created by zhanghao on 2020/12/30.
//  Copyright © 2020 gren-beans. All rights reserved.
//

#import "TJPageController.h"

#pragma mark - TJPageCollectionView

@interface TJPageCollectionView : UICollectionView

/// 触摸点在边缘时(panGestureTriggerBoundary以内)启用多手势
@property (nonatomic, assign) CGFloat panGestureTriggerBoundary;

@end

@implementation TJPageCollectionView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer locationInView:self].x < self.panGestureTriggerBoundary) {
        return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
    }
    return NO;
}

@end

#pragma mark - TJPageCollectionViewCell

static NSString* const TJPageCollectionCellIdentifier = @"TJPageCollectionReuseCell";

@interface TJPageCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak, readonly) UIViewController *childVC;

@end

@implementation TJPageCollectionViewCell

- (void)configureViewController:(UIViewController *)childVC {
    _childVC = childVC;
}

- (void)removeChildView {
    if (_childVC.view.superview) {
        [_childVC.view removeFromSuperview];
    }
}

- (void)addChildView {
    if (![self hasOwnerOfViewController:_childVC]) {
        [self.contentView addSubview:_childVC.view];
        _childVC.view.frame = self.contentView.bounds;
        _childVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
}

- (BOOL)hasOwnerOfViewController:(UIViewController *)viewController {
    return viewController.view.superview && (viewController.view.superview == self.contentView);
}

@end

#pragma mark - TJPageController

@interface TJPageController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) UICollectionViewFlowLayout *collectionLayout;
@property(nonatomic, strong) TJPageCollectionView *collectionView;
@property(nonatomic, assign, readonly) NSInteger numberOfPageControllers;

@end

@implementation TJPageController {
    BOOL _dragTriggered;
    BOOL _initialLoaded;
    NSInteger _currentIndex;
    NSInteger _previousIndex;
    NSMutableIndexSet *_draggingIndexSet;
    NSMutableDictionary<NSNumber*, UIViewController*>* _controllerCache;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self _initialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _initialization];
    }
    return self;
}

- (void)_initialization {
    _previousIndex = -1;
    _currentIndex = -1;
    _allowBounces = NO;
    _scrollEnabled = YES;
    _dragTriggered = YES;
    _initialLoaded = YES;
    _sendEndTransitionWhenPageChanged = NO;
    _controllerCache = [NSMutableDictionary dictionary];
    _draggingIndexSet = [NSMutableIndexSet indexSet];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    
    if (self.numberOfPageControllers > 0) {
        _currentIndex = 0;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{ // -viewDidLayoutSubviews
        // 如果外部重新布局self.view会导致collectionView布局重置，所以要等runloop执行布局完成后修正起始选中位置
        [self scrollToItemAtIndex:self->_currentIndex animated:NO];
    });
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.collectionLayout.itemSize = self.view.bounds.size;
    self.collectionView.frame = self.view.bounds;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberOfPageControllers;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TJPageCollectionViewCell *pageCell = [collectionView dequeueReusableCellWithReuseIdentifier:TJPageCollectionCellIdentifier forIndexPath:indexPath];
    
    UIViewController *page = [self viewControllerAtIndex:indexPath.item];
    [pageCell configureViewController:page];
    
    return pageCell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    TJPageCollectionViewCell *pageCell = (id)cell;
    [pageCell addChildView]; // 添加当前cell的childVC.view
    
    if (_initialLoaded) { // 首次显示cell后，手动调用`pageControllerDidEndTransition`
        _initialLoaded = NO;
        if ([self.delegate respondsToSelector:@selector(pageControllerDidEndTransition:)]) {
            [self.delegate pageControllerDidEndTransition:self];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    TJPageCollectionViewCell *pageCell = (id)cell;
    [pageCell removeChildView]; // 删除前一个cell的childVC.view
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    _dragTriggered = YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _dragTriggered = YES;
    
    if (self.sendEndTransitionWhenPageChanged) {
        [_draggingIndexSet addIndex:[self currentPage]];
    }

    if ([self.delegate respondsToSelector:@selector(pageControllerWillStartTransition:)]) {
        [self.delegate pageControllerWillStartTransition:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.sendEndTransitionWhenPageChanged) {
        if (_previousIndex != _currentIndex) {
            _previousIndex = _currentIndex;
            if ([self.delegate respondsToSelector:@selector(pageControllerDidEndTransition:)]) {
                [self.delegate pageControllerDidEndTransition:self];
            }
        } else {
            if (_draggingIndexSet.count > 1) {
                if ([self.delegate respondsToSelector:@selector(pageControllerDidEndTransition:)]) {
                    [self.delegate pageControllerDidEndTransition:self];
                }
            }
        }
        [_draggingIndexSet removeAllIndexes];
    } else {
        if ([self.delegate respondsToSelector:@selector(pageControllerDidEndTransition:)]) {
            [self.delegate pageControllerDidEndTransition:self];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_dragTriggered) {
        _currentIndex = [self currentPage];
        
        if ([self.delegate respondsToSelector:@selector(pageController:didUpdateTransition:)]) {
            CGFloat progress = _collectionView.contentOffset.x / _collectionView.frame.size.width;
            NSInteger integerProgress = (NSInteger)progress;
            CGFloat partProgress = integerProgress % self.numberOfPageControllers;
            progress = partProgress + fabs(progress - integerProgress);
            [self.delegate pageController:self didUpdateTransition:progress];
        }
    }
}

- (NSInteger)currentPage {
    NSInteger page = _collectionView.contentOffset.x / _collectionView.frame.size.width + 0.5;
    if (page >= self.numberOfPageControllers) page = self.numberOfPageControllers - 1;
    if (page < 0) page = 0;
    return page;
}

- (NSInteger)numberOfPageControllers {
    NSParameterAssert([self.dataSource respondsToSelector:@selector(numberOfPagesInPageController:)]);
    return [self.dataSource numberOfPagesInPageController:self];
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index {
    UIViewController *controller = _controllerCache[@(index)];
    if (!controller) {
        NSParameterAssert([self.dataSource respondsToSelector:@selector(pageController:pageAtIndex:)]);
        controller = [self.dataSource pageController:self pageAtIndex:index];
        [self addChildViewController:controller];
        [controller didMoveToParentViewController:self];
        _controllerCache[@(index)] = controller;
    }
    return controller;
}

- (void)clearAllCache {
    if (_controllerCache.count) {
        for (UIViewController *controller in _controllerCache.allValues) {
            [controller willMoveToParentViewController:nil];
            [controller.view removeFromSuperview];
            [controller removeFromParentViewController];
        }
        [_controllerCache removeAllObjects];
    }
}

- (void)reloadPages {
    [self clearAllCache];
    [self.collectionView reloadData];
    
    NSInteger pagesCount = self.numberOfPageControllers;
    if (pagesCount <= 0) {
        _currentIndex = -1;
    } else {
        _currentIndex = MIN(MAX(0, _currentIndex), pagesCount - 1);
    }
}

- (void)setCurrentIndex:(NSInteger)index animated:(BOOL)animated {
    if (index != _currentIndex) {
        _currentIndex = index;
        
        [self scrollToItemAtIndex:_currentIndex animated:animated];
        
        _dragTriggered = NO; // 外部触发
    }
}

- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated { // 滚动到指定位置
    if (index < 0 || index >= [self.collectionView numberOfItemsInSection:0]) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
}

- (NSInteger)currentIndex {
    return _currentIndex;
}

- (__kindof UIViewController *)currentViewController {
    if (self.currentIndex < 0 || self.currentIndex > self.numberOfPageControllers - 1) {
        return nil;
    }
    return [self viewControllerAtIndex:self.currentIndex];
}

- (NSArray<__kindof UIViewController *> *)viewControllers {
    return _controllerCache.allValues;
}

- (void)setAllowBounces:(BOOL)allowBounces {
    _allowBounces = allowBounces;
    _collectionView.bounces = allowBounces;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    _scrollEnabled = scrollEnabled;
    _collectionView.scrollEnabled = scrollEnabled;
}

- (void)setPanGestureTriggerBoundary:(CGFloat)panGestureTriggerBoundary {
    _panGestureTriggerBoundary = panGestureTriggerBoundary;
    _collectionView.panGestureTriggerBoundary = panGestureTriggerBoundary;
}

- (UICollectionViewFlowLayout *)collectionLayout {
    if (!_collectionLayout) {
        _collectionLayout = [UICollectionViewFlowLayout new];
        _collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionLayout.itemSize = self.view.bounds.size;
        _collectionLayout.minimumLineSpacing = 0;
        _collectionLayout.minimumInteritemSpacing = 0;
        _collectionLayout.sectionInset = UIEdgeInsetsZero;
    }
    return _collectionLayout;
}

- (TJPageCollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[TJPageCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.collectionLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollEnabled = self.scrollEnabled;
        _collectionView.bounces = self.allowBounces;
        _collectionView.directionalLockEnabled = YES;
        [_collectionView registerClass:[TJPageCollectionViewCell class] forCellWithReuseIdentifier:TJPageCollectionCellIdentifier];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _collectionView;
}

- (void)dealloc {
    NSLog(@"%@~~~dealloc✈️", NSStringFromClass(self.class));
}

@end
