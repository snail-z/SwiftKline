//
//  UICollectionView+PKExtend.h
//  PKCategories
//
//  Created by zhanghao on 2020/9/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (PKExtend)

/** 返回collectionView所有section中的所有条数 */
@property (nonatomic, assign, readonly) NSInteger pk_numberOfItems;

/** 刷新数据完成处理回调 */
- (void)pk_reloadDataWithCompletion:(void (^ __nullable)(void))completion;

/** 使用类名出列可重用的UICollectionViewCell */
- (__kindof UICollectionViewCell *)pk_dequeueReusableCellWithClass:(Class)aClass forIndexPath:(NSIndexPath *)indexPath;

/** 使用类名出列可重用的UICollectionReusableView - Header */
- (__kindof UICollectionReusableView *)pk_dequeueReusableSectionHeaderWithClass:(Class)aClass forIndexPath:(NSIndexPath *)indexPath;

/** 使用类名出列可重用的UICollectionReusableView - Footer */
- (__kindof UICollectionReusableView *)pk_dequeueReusableSectionFooterWithClass:(Class)aClass forIndexPath:(NSIndexPath *)indexPath;

/** 使用类名注册UICollectionViewCell */
- (void)pk_registerCellWithClass:(Class)aClass;

/** 使用类名注册UICollectionReusableView - Header */
- (void)pk_registerSectionHeaderWithClass:(Class)aClass;

/** 使用类名注册UICollectionReusableView - Footer */
- (void)pk_registerSectionFooterWithClass:(Class)aClass;

/** 安全滚动到目标位置 (检查IndexPath在CollectionView中是否有效) */
- (void)pk_scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
