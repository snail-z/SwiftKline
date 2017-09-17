//
//  zh_ViewController.m
//  zhUITableViewAnimations
//
//  Created by snail-z on 09/17/2017.
//  Copyright (c) 2017 snail-z. All rights reserved.
//

#import "zh_ViewController.h"
#import "zh_ExampleViewController.h"

@interface zh_ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *styles;

@end

@implementation zh_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    textAttrs[NSFontAttributeName] = [UIFont fontWithName:@"GillSans-SemiBoldItalic" size:25];
    self.navigationController.navigationBar.titleTextAttributes = textAttrs;
    self.navigationItem.title = @"zhUITableViewAnimations";
    
    [self commonInitialization];
}

- (void)commonInitialization {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.delaysContentTouches = NO;
        _tableView.rowHeight = 60;
        _tableView.tableFooterView = [UIView new];
    }
    self.view = _tableView;
    
    if (!_styles) {
        _styles = @[@"SlideFromLeft", @"SlideFromRight", @"Fade", @"Fall", @"Vallum", @"Shakee", @"Flip", @"FlipX", @"Balloon", @"BalloonTop"];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _styles.count;
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
    NSLog(@"indexPath.row-> %lu", indexPath.row);
    zh_ExampleViewController *vc = [zh_ExampleViewController new];
    vc.type = indexPath.row + 1;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
