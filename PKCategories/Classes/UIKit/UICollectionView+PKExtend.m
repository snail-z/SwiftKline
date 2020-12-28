//
//  UICollectionView+PKExtend.m
//  PKCategories
//
//  Created by zhanghao on 2020/9/15.
//

#import "UICollectionView+PKExtend.h"

@implementation UICollectionView (PKExtend)

- (NSInteger)pk_numberOfItems {
    NSInteger section = 0;
    NSInteger itemsCount = 0;
    while (section < self.numberOfSections) {
        itemsCount += [self numberOfItemsInSection:section];
        section += 1;
    }
    return itemsCount;
}

- (void)pk_reloadDataWithCompletion:(void (^)(void))completion {
    [UIView animateWithDuration:0 animations:^{
        [self reloadData];
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

- (__kindof UICollectionViewCell *)pk_dequeueReusableCellWithClass:(Class)aClass forIndexPath:(NSIndexPath *)indexPath {
    NSString *className = NSStringFromClass(aClass);
    UICollectionViewCell *cell = [self dequeueReusableCellWithReuseIdentifier:className forIndexPath:indexPath];
    NSAssert1(cell, @"Couldn't find UICollectionViewCell for %@, make sure the cell is registered with collection view", className);
    return cell;
}

- (__kindof UICollectionReusableView *)pk_dequeueReusableSectionHeaderWithClass:(Class)aClass forIndexPath:(NSIndexPath *)indexPath {
    NSString *className = NSStringFromClass(aClass);
    UICollectionReusableView *reusableView = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:className forIndexPath:indexPath];
    NSAssert1(reusableView, @"Couldn't find UICollectionReusableView-Header for %@, make sure the view is registered with collection view", className);
    return reusableView;
}

- (__kindof UICollectionReusableView *)pk_dequeueReusableSectionFooterWithClass:(Class)aClass forIndexPath:(NSIndexPath *)indexPath {
    NSString *className = NSStringFromClass(aClass);
    UICollectionReusableView *reusableView = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:className forIndexPath:indexPath];
    NSAssert1(reusableView, @"Couldn't find UICollectionReusableView-Footer for %@, make sure the view is registered with collection view", className);
    return reusableView;
}

- (void)pk_registerCellWithClass:(Class)aClass {
    [self registerClass:aClass forCellWithReuseIdentifier:NSStringFromClass(aClass)];
}

- (void)pk_registerSectionHeaderWithClass:(Class)aClass {
    [self registerClass:aClass forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(aClass)];
}

- (void)pk_registerSectionFooterWithClass:(Class)aClass {
    [self registerClass:aClass forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(aClass)];
}

- (void)pk_scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated {
    if (indexPath.item >= 0 &&
        indexPath.section >= 0 &&
        indexPath.section < self.numberOfSections &&
        indexPath.item < [self numberOfItemsInSection:indexPath.section]) {
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    }
}

@end
