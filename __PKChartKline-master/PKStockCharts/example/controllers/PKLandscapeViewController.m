//
//  PKLandscapeViewController.m
//  PKStockCharts
//
//  Created by zhanghao on 2019/8/22.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import "PKLandscapeViewController.h"
#import "PKLandscapeTopTextView.h"
#import "PKSegmentedSlideControl.h"
#import "PKLandscapeViewController+Extend.h"

@interface PKLandscapeViewController () <PKTimeChartDelegate, PKKLineChartDelegate>

@property (nonatomic, strong) PKLandscapeTopTextView *topTextView;
@property (nonatomic, strong) PKSegmentedSlideControl *segmentedControl;
@property (nonatomic, strong) PKTimeChart *timeChart;
@property (nonatomic, strong) PKKLineChart *KlineChart;

@end

@implementation PKLandscapeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self subviewsInitialization];
    [self layoutInitialization];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dataInitialization];
    });
}

- (void)subviewsInitialization {
    _topTextView = [[PKLandscapeTopTextView alloc] init];
    [self.containerView addSubview:_topTextView];
    
    NSArray<NSString *> *titles = @[@"分时", @"五日", @"日K", @"周K", @"月K", @"季K", @"年K", @"分钟"];
    _segmentedControl = [[PKSegmentedSlideControl alloc] initWithTitles:titles];
    _segmentedControl.normalTextColor = [UIColor blackColor];
    _segmentedControl.selectedTextColor = [UIColor pk_colorWithRed:40 green:163 blue:239];
    _segmentedControl.plainTextFont = [UIFont fontWithName:@"Avenir" size:17.0];
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    _segmentedControl.indicatorLineWidth = 4;
    _segmentedControl.paddingInset = 15;
    _segmentedControl.innerSpacing = 5;
    _segmentedControl.numberOfPageItems = titles.count;
    _segmentedControl.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
    _segmentedControl.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
    [_segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl];
    
    _timeChart = [PKTimeChart new];
    _timeChart.delegate = self;
    _timeChart.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_timeChart];
    
    _KlineChart = [PKKLineChart new];
    _KlineChart.delegate = self;
    _KlineChart.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_KlineChart];
    
    NSArray *majorIndicators = @[PKIndicatorMA];
    for (NSString *identifier in majorIndicators) {
        [_KlineChart registerClass:NSClassFromString(identifier) forIndicatorIdentifier:identifier];
    }
    NSArray *minorIndicators = @[PKIndicatorVOL, PKIndicatorBOLL, PKIndicatorMACD, PKIndicatorKDJ];
    for (NSString *identifier in minorIndicators) {
        [_KlineChart registerClass:NSClassFromString(identifier) forIndicatorIdentifier:identifier];
    }
    _KlineChart.defaultMajorIndicatorIdentifier = PKIndicatorMA;
    _KlineChart.defaultMinorIndicatorIdentifier = PKIndicatorVOL;
}

- (void)layoutInitialization {
    [_topTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.containerView);
        make.height.mas_equalTo(40);
        make.right.equalTo(self.containerView);
    }];
    
    [_segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.containerView);
        make.height.mas_equalTo(40);
    }];
    
    [_timeChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.equalTo(self.view).mas_offset(-10);
        make.top.equalTo(self.topTextView.mas_bottom).offset(2);
        make.bottom.equalTo(self.segmentedControl.mas_top).offset(-2);
    }];
    
    [_KlineChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.equalTo(self.view).mas_offset(-10);
        make.top.equalTo(self.topTextView.mas_bottom).offset(2);
        make.bottom.equalTo(self.segmentedControl.mas_top).offset(-2);
    }];
}

- (void)dataInitialization {
    [_topTextView setName:@"上证指数" withCode:@"000001"];
    [_timeChart pk_beginIndicatorLoading];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self->_timeChart pk_endIndicatorLoading];
        [self reloadDataWithIndex:0];
    });
}

#pragma mark - events

- (void)valueChanged:(PKSegmentedSlideControl *)sender {
    NSLog(@"The selected index is: %@", @(sender.index));
    [self reloadDataWithIndex:sender.index];
}

#pragma mark - data

- (void)reloadDataWithIndex:(NSInteger)index {
    __weak typeof(self) weakSelf = self;
    switch (index) {
        case 0: case 1: { // 分时
            [self displayKlineChart:NO];
            
            NSString *path = [NSBundle pk_mainBundleWithName:@"pk_times_data.plist"];
            PKStockItem *item = [PKStockItem mj_objectWithFile:path];
            weakSelf.timeChart.dataList = item.times;
            weakSelf.timeChart.set = [self makeOneTimeChartSet];
            weakSelf.timeChart.coordObj = item.times.firstObject;
            [weakSelf.timeChart drawChart];
        } break;
        case 2: { // 日K
            [self displayKlineChart:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *path = [NSBundle pk_mainBundleWithName:@"pk_dayKline_data.plist"];
                 NSArray<PKKlineItem *> *items = [PKKlineItem mj_objectArrayWithFile:path];
                weakSelf.KlineChart.set = [self makeKlineChartSet];
                weakSelf.KlineChart.dataList = items;
                [weakSelf.KlineChart drawChart];
            });
        } break;
            
        default: break;
    }
}

- (void)displayKlineChart:(BOOL)displayed {
    if (displayed) {
        self.KlineChart.alpha = 1;
        self.timeChart.alpha = 0;
    } else {
        self.KlineChart.alpha = 0;
        self.timeChart.alpha = 1;
    }
}

@end
