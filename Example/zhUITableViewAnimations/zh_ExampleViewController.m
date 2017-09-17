//
//  zh_ExampleViewController.m
//  zhUITableViewAnimations
//
//  Created by zhanghao on 2017/9/17.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "zh_ExampleViewController.h"
#import "UIView+AddConstraints.h"
#import <zhUITableViewAnimations/zhTableViewAnimations.h>

@interface zh_ExampleViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation zh_ExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self commonInitialization];
}

- (void)commonInitialization {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.delaysContentTouches = NO;
        _tableView.rowHeight = 90;
        _tableView.zh_reloadAnimationType = self.type;
    }
    self.view = _tableView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(zh_reload)];
}

- (void)zh_reload {
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"_cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"_cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [UIColor darkGrayColor];
        button.layer.cornerRadius = 5;
        [cell.contentView addSubview:button];
        [button zh_makeConstraints:^(SnailConstraintMaker *make) {
            [make.width zh_equalTo:self.view.bounds.size.width - 20];
            [make.height zh_equalTo:tableView.rowHeight - 20];
            [make.center equalTo:cell.contentView];
        }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell zh_presentAnimateSlideFromLeft];
}

@end
