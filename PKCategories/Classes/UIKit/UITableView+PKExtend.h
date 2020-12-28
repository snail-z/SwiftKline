//
//  UITableView+PKExtend.h
//  PKCategories
//
//  Created by zhanghao on 2020/9/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (PKExtend)

/** 返回tableView所有section中的所有行数 */
@property (nonatomic, assign, readonly) NSInteger pk_numberOfRows;

/** 刷新数据完成处理回调 */
- (void)pk_reloadDataWithCompletion:(void (^ __nullable)(void))completion;

/** 删除TableHeaderView */
- (void)pk_removeTableHeaderView;

/** 删除TableFooterView */
- (void)pk_removeTableFooterView;

/** 安全滚动到目标位置 (检查IndexPath在TableView中是否有效) */
- (void)pk_scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

@end


@interface UITableViewCell (PKExtend)

/** 出列当前类可重用的UITableViewCell */
+ (__kindof UITableViewCell *)pk_cellWithTableView:(UITableView *)tableView;

@end

@interface UITableViewHeaderFooterView (PKExtend)

/** 出列当前类可重用的UITableViewHeaderFooterView */
+ (__kindof UITableViewHeaderFooterView *)pk_headerFooterWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
