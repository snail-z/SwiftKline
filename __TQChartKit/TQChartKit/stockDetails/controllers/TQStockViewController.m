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
#import "TQStockChart+Categories.h"
#import "TQStockChartUtilities.h"

@interface TQStockViewController ()

@end

@implementation TQStockViewController

- (void)navigaInitialization {
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"横屏" style:UIBarButtonItemStylePlain target:self action:@selector(present)];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)present {
    TQStockHorizontalController *horizontalVC = [TQStockHorizontalController new];
    horizontalVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    horizontalVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:horizontalVC animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigaInitialization];
    
//    [self example1];
//    [self example2];

    // 1. 指针数组对比NSArray (存储结构体)
//    [self test1];
//    [self test2];
    
    // 2.计算数组最大最小值 (KVC取值对比IMP取值)
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 1; i <= 3000; i++) {
        [array addObject:NS_StringFromFloat(i)];
    }
    [self test3:array];
    [self test4:array];
}

#pragma mark - exp

- (void)example1 {
    TQStockFiedLabel *fiedLabel = [TQStockFiedLabel new];
    fiedLabel.frame = CGRectMake(100, 100, 200, 50);
    fiedLabel.backgroundColor = [UIColor orangeColor];
    //    [self.view addSubview:fiedLabel];
    //    fiedLabel.prefixText = @"最高";
    //    fiedLabel.suffixText = @"17.85";
}

- (void)example2 {
    CGFloat value = 5.82995;
    CGFloat value2 = 5.82295;
    NSString *string1 = NS_PercentFromFloat(value);
    NSString *string2 = NS_PercentFromFloat(CG_RoundFloatKeep2(value2));
    NSLog(@"string1 is: %@", string1);
    NSLog(@"string2 is: %@", string2);
    
//    NSString *string1 = @"1%";
//    NSString *string2 = @"16.78%";
//
//    NSLog(@"1 is: %@", @(CG_FloatFromPercent(string1)));
//    NSLog(@"2 is: %@", @(CG_FloatFromPercent(string2)));
    
    
//    NSNumberFormatter *formatter = [NSNumberFormatter new];
//    formatter.numberStyle = NSNumberFormatterSpellOutStyle;
//    NSString *newString = [formatter stringFromNumber:@(934855)];
//    NSLog(@"newString is: %@", newString);
    
    // 货币形式 -- 本地化
    NSLog(@"doll is: %@", NS_CurrencyFromFloat(100005.5));
    
//    NSString *numberCurrencyStyleStr = [NSNumberFormatter localizedStringFromNumber:@(8234) numberStyle:NSNumberFormatterCurrencyStyle];
//    NSLog(@"numberCurrencyStyleStr is: %@", numberCurrencyStyleStr);
    
//    NSLog(@"string1 is: %@", @(CG_RoundFloatKeep(value, 2)));
//    NSLog(@"string2 is: %@", @(CG_RoundFloatKeep(value2, 2)));
    
//    NSLog(@"string1 is: %@", @(CG_PlainFloatKeep(value, 2)));
//    NSLog(@"string2 is: %@", @(CG_PlainFloatKeep(value2, 2)));
}

#pragma mark - test

- (void)test1 {
    NSInteger dataCount = 2000;
    [NSTimer tq_runningTimeBlock:^{
        CGPoint *array = malloc(dataCount * sizeof(CGPoint));
        for (int i = 0; i < dataCount; i++) {
            CGPoint p = CGPointMake(i + 2, i * 2);
            array[i] = p;
        }
        CGPoint p =  array[1999];
        NSLog(@"%@", @(p));
        free(array); // 确认不用这块内存再free，不要free以后接着使用
    } withPrefix:@"A"];
    
}

- (void)test2 {
    NSInteger dataCount = 2000;
    
    [NSTimer tq_runningTimeBlock:^{
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < dataCount; i++) {
            CGPoint p = CGPointMake(i + 2, i * 2);
            [array addObject:[NSValue valueWithCGPoint:p]];
        }
        NSValue *value = array.lastObject;
        NSLog(@"%@", @(value.CGPointValue));
    } withPrefix:@"B"];
}

- (void)test3:(NSArray *)array {
    [NSTimer tq_runningTimeBlock:^{
        NSNumber *max = [array valueForKeyPath:@"@max.self"]; // @max.floatValue
        NSNumber *min = [array valueForKeyPath:@"@min.self"]; // @min.floatValue
        NSLog(@"max is: %@", max);
        NSLog(@"min is: %@", min);
    } withPrefix:@"A"];
}

- (void)test4:(NSArray *)array {
    [NSTimer tq_runningTimeBlock:^{
        CGPeakValue peak = [array tq_peakValue];
        NSLog(@"max is: %@", @(peak.max));
        NSLog(@"min is: %@", @(peak.min));
    } withPrefix:@"B"];
}

@end
