//
//  ViewController.m
//  PKStockCharts
//
//  Created by zhanghao on 2019/7/8.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *styles;
@property (nonatomic, strong) NSMutableArray *classes;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInitialization];
}

- (void)commonInitialization {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 55;
    [self.view addSubview:_tableView];
    
    _styles = @[].mutableCopy;
    _classes  = @[].mutableCopy;
    
    [self addClassName:@"PKExample1ViewController" style:@"PKTimeChart"];
}

- (void)addClassName:(NSString *)className style:(NSString *)style {
    [_styles addObject:style];
    [_classes addObject:className];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _classes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _styles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = _classes[indexPath.row];
    Class class = NSClassFromString(className);
    NSParameterAssert(class);
    UIViewController *vc = [[class alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
