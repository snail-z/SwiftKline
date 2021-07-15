//
//  TQStockViewController.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/17.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQStockViewController.h"
#import "TQStockHorizontalController.h"
#import "TQStockFiedLabel.h"

@interface TQStockViewController ()

@end

@implementation TQStockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigaInitialization];
    
    TQStockFiedLabel *fiedLabel = [TQStockFiedLabel new];
    fiedLabel.frame = CGRectMake(100, 100, 200, 50);
    fiedLabel.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:fiedLabel];
    
//    fiedLabel.prefixText = @"最高";
//    fiedLabel.suffixText = @"17.85";

    
}

- (void)navigaInitialization {
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"横屏" style:UIBarButtonItemStylePlain target:self action:@selector(present)];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)present {
    [self presentViewController:[TQStockHorizontalController new] animated:YES completion:nil];
}

@end
