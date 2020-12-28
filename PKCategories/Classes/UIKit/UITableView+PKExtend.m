//
//  UITableView+PKExtend.m
//  PKCategories
//
//  Created by zhanghao on 2020/9/17.
//

#import "UITableView+PKExtend.h"

@implementation UITableView (PKExtend)

- (NSInteger)pk_numberOfRows {
    NSInteger section = 0;
    NSInteger rowCount = 0;
    while (section < self.numberOfSections) {
        rowCount += [self numberOfRowsInSection:section];
        section += 1;
    }
    return rowCount;
}

- (void)pk_reloadDataWithCompletion:(void (^)(void))completion {
    [UIView animateWithDuration:0 animations:^{
        [self reloadData];
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

- (void)pk_removeTableHeaderView {
    self.tableHeaderView = nil;
}

- (void)pk_removeTableFooterView {
    self.tableFooterView = nil;
}

- (void)pk_scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    if (indexPath.row >= 0 &&
        indexPath.section >= 0 &&
        indexPath.section < self.numberOfSections &&
        indexPath.row < [self numberOfRowsInSection:indexPath.section]) {
        [self scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    }
}

@end


@implementation UITableViewCell (PKExtend)

+ (__kindof UITableViewCell *)pk_cellWithTableView:(UITableView *)tableView {
    NSString *identifier = NSStringFromClass(self);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end


@implementation UITableViewHeaderFooterView (PKExtend)

+ (__kindof UITableViewHeaderFooterView *)pk_headerFooterWithTableView:(UITableView *)tableView {
    NSString *identifier = NSStringFromClass(self);
    UITableViewHeaderFooterView *reuseView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!reuseView) {
        reuseView = [[self alloc] initWithReuseIdentifier:identifier];
    }
    return reuseView;
}

@end
