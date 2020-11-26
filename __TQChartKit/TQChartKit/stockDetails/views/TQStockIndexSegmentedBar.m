//
//  TQStockIndexSegmentedBar.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/21.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQStockIndexSegmentedBar.h"

@interface TQStockIndexSegmentedCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TQStockIndexSegmentedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    _titleLabel.frame = self.bounds;
}

@end

@interface TQStockIndexSegmentedBar () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, strong) NSMutableArray<UILabel *> *headerLabels;

@end

@implementation TQStockIndexSegmentedBar


- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self defaultInitialization];
        _headerLabels = [NSMutableArray array];
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.delaysContentTouches = NO;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tableView];
    }
    return self;
}

- (void)defaultInitialization {
    _unselectedTextColor = [UIColor darkGrayColor];
    _selectedTextColor = [UIColor orangeColor];
    _textFont = [UIFont systemFontOfSize:11];
    _lineColor = [UIColor grayColor];
    _lineEdgePadding = 10;
    _lineWidth = 1 / [UIScreen mainScreen].scale;
    _numberOfVisual = 7;
}

- (void)layoutSubviews {
    _tableView.frame = self.bounds;
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    if (!titles.count) return;
    _titles = titles;
    [self reloadData];
}

- (void)setHeaderTitles:(NSArray<NSString *> *)headerTitles {
    if (!headerTitles.count) return;
    _headerTitles = headerTitles;
    [self reloadData];
}

- (void)reloadData {
    [self layoutIfNeeded];
    CGFloat cellHeight = floor(self.bounds.size.height / (double)self.numberOfVisual);
    _tableView.rowHeight = cellHeight;
    if (self.headerTitles.count) {
        _headerHeight = cellHeight * self.headerTitles.count;
    }
    [_tableView reloadData];
    [self reloadHeaderView];
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.frame = CGRectMake(0, 0, _tableView.bounds.size.width, _headerHeight);
        _headerView.backgroundColor = [UIColor whiteColor];
        CALayer *line = [CALayer layer];
        line.backgroundColor = self.lineColor.CGColor;
        line.frame = CGRectMake(self.lineEdgePadding, _headerHeight - self.lineWidth - 2, _tableView.bounds.size.width - 2 * self.lineEdgePadding, self.lineWidth);
        [_headerView.layer addSublayer:line];
    }
    return _headerView;
}

- (void)reloadHeaderView {
    CGSize labelSize = CGSizeMake(_tableView.bounds.size.width, _tableView.rowHeight);
    [_headerTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull text, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [self labelWithIndex:idx];
        label.frame = CGRectMake(0, labelSize.height * idx, labelSize.width, labelSize.height);
        label.text = text;
        label.textColor = (label.tag == self->_headerView.tag) ? self.selectedTextColor : self.unselectedTextColor;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerLabelClicked:)]];
    }];
}

- (UILabel *)labelWithIndex:(NSInteger)index {
    UILabel *label = nil;
    if (index < _headerLabels.count) {
        label = _headerLabels[index];
        return label;
    }
    label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = YES;
    label.font = self.textFont;
    label.tag = index;
    [self.headerView addSubview:label];
    [_headerLabels addObject:label];
    return label;
}

- (void)headerLabelClicked:(UITapGestureRecognizer *)g {
    if ([self.delegate respondsToSelector:@selector(stockIndexSegmentedBar:didClickHeaderItemAtIndex:)]) {
        [self.delegate stockIndexSegmentedBar:self didClickHeaderItemAtIndex:g.view.tag];
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return _headerHeight ? self.headerView : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _headerHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TQStockIndexSegmentedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TQStockIndexSegmentedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.font = self.textFont;
    }
    cell.titleLabel.text = _titles[indexPath.row];
    cell.titleLabel.textColor = (indexPath.row == tableView.tag) ? self.selectedTextColor : self.unselectedTextColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(stockIndexSegmentedBar:didClickItemAtIndex:)]) {
        [self.delegate stockIndexSegmentedBar:self didClickItemAtIndex:indexPath.row];
    }
}

- (void)setHeaderSelectedIndex:(NSInteger)headerSelectedIndex {
    if (headerSelectedIndex < 0 || headerSelectedIndex >= self.titles.count) return;
    _headerSelectedIndex = headerSelectedIndex;
    _headerView.tag = headerSelectedIndex;
    [self reloadHeaderView];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex < 0 || selectedIndex >= self.titles.count) return;
    _selectedIndex = selectedIndex;
    _tableView.tag = selectedIndex;
    [_tableView reloadData];
}

@end
