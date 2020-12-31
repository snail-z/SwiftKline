
//
//  Demo3ViewController.m
//  PKCategories_Example
//
//  Created by zhanghao on 2020/12/31.
//  Copyright © 2020 gren-beans. All rights reserved.
//

#import "Demo3ViewController.h"

@interface Demo3ViewController ()

@end

@implementation Demo3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    
    NSLog(@"viewDidLoad->  Demo3ViewController");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear-> Demo3ViewController");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear-> Demo3ViewController");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
