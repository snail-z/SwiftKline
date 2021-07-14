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
#import "NSArray+TQStockChart.h"
#import "TQStockChartUtilities.h"
#import "TQStockCacheManager.h"
#import "UIBezierPath+TQStockChart.h"
#import "TQIndicatorCycles.h"

@interface TQStockViewController ()

@end

@implementation TQStockViewController

- (void)navigaInitialization {
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"横屏" style:UIBarButtonItemStylePlain target:self action:@selector(present)];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)present {
    TQStockHorizontalController *vc = [TQStockHorizontalController new];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
