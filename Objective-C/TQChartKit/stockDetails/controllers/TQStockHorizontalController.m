//
//  TQStockHorizontalController.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/17.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQStockHorizontalController.h"
#import "TQStockDataManager.h"
#import "TQStockTimePropData.h"
#import "TQTimeChartView.h"
#import "TQStockDetailTextView.h"
#import "TQStockTypeSegmentedBar.h"
#import "TQStockTypePopupBar.h"
#import "TQStockIndexSegmentedBar.h"
#import "TQStockDetailBusinessView.h"

@interface TQStockHorizontalController () <TQStockTypeSegmentedBarDelegate, TQStockIndexSegmentedBarDelegate, TQStockTypePopupBarDelegate>

/** 数据管理 */
@property (nonatomic, strong) TQStockDataManager *dataManager;
@property (nonatomic, strong) TQStockTimePropData *timePropData;

/** 分时五日图 */
@property (nonatomic, strong) TQTimeChartView *timeChartView;

/** 顶部文本视图 */
@property (nonatomic, strong) TQStockDetailTextView *topTextView;

/** 顶部股票类型切换条 */
@property (nonatomic, strong) TQStockTypeSegmentedBar *bottomSegmentedBar;

/** 底部分钟弹窗条 */
@property (nonatomic, strong) TQStockTypePopupBar *bottomPopupBar;

/** 股票指标切换条(用于K线图显示时) */
@property (nonatomic, strong) TQStockIndexSegmentedBar *indexSegmentedBar;

/** 股票买卖明细视图(用于分时图显示时) */
@property (nonatomic, strong) TQStockDetailBusinessView *detailBusinessView;

@end

@implementation TQStockHorizontalController

- (void)dealloc {
    NSLog(@"%@~~~~~~dealloc!✈️",NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initialization];
    [self _updateLayout];
    [self _updateInitialConfiguration];
    
    [self _updateTimeData];
}

- (void)_initialization {
    self.dataManager = [TQStockDataManager new];
    self.timePropData = [TQStockTimePropData new];
    
    self.timeChartView = [TQTimeChartView new];
    self.timeChartView.contentEdgeInset = UIEdgeInsetsMake(20, 5, 30, 0);
    self.timeChartView.chartTimeHeight = 150;
    self.timeChartView.chartSeparationGap = 30;
    [self.containerView addSubview:self.timeChartView];
    
    self.topTextView = [TQStockDetailTextView new];
    self.topTextView.contentInsets = UIEdgeInsetsMake(0, 0, 0, 100);
    [self.containerView addSubview:self.topTextView];
    
    self.bottomSegmentedBar = [TQStockTypeSegmentedBar new];
    self.bottomSegmentedBar.delegate = self;
    [self.containerView addSubview:self.bottomSegmentedBar];
    
    self.bottomPopupBar = [TQStockTypePopupBar new];
    self.bottomPopupBar.delegate = self;
    self.bottomPopupBar.popupCoverFrame = self.containerView.bounds;
    self.bottomPopupBar.hidden = YES;
    self.bottomPopupBar.layer.cornerRadius = 2;
    __weak TQStockTypeSegmentedBar *weakBottomSegmentedBar = self.bottomSegmentedBar;
    _bottomPopupBar.willPresent = ^{
        weakBottomSegmentedBar.moreItemImageTransform = CGAffineTransformMakeRotation(M_PI);
    };
    _bottomPopupBar.willDismiss = ^{
        weakBottomSegmentedBar.moreItemImageTransform = CGAffineTransformIdentity;
    };
    [self.containerView addSubview:self.bottomPopupBar];
    
    self.indexSegmentedBar = [TQStockIndexSegmentedBar new];
    self.indexSegmentedBar.delegate = self;
    [self.containerView addSubview:self.indexSegmentedBar];
    
    [self.containerView bringSubviewToFront:self.bottomPopupBar]; // 控制视图层级
    [self.containerView bringSubviewToFront:self.bottomSegmentedBar];
}

- (void)_updateLayout {
    CGFloat topPadding = 50;
    CGFloat bottomPadding = 40;
    CGRect blankFrame = CGRectMake(0, topPadding, self.containerView.width, self.containerView.height - topPadding - bottomPadding);
    UIEdgeInsets blackInset = UIEdgeInsetsMake(0, 15, 0, 90);
    CGRect chartRect = UIEdgeInsetsInsetRect(blankFrame, blackInset);
    
    self.timeChartView.frame = chartRect;
    
    self.topTextView.size = CGSizeMake(self.containerView.width, topPadding);
    [self.topTextView zh_add1pxSidelinePosition:zhSidelinePositionBottom];
    
    self.bottomSegmentedBar.size = CGSizeMake(self.containerView.width, bottomPadding);
    self.bottomSegmentedBar.top = self.containerView.height - bottomPadding;
    [self.bottomSegmentedBar zh_add1pxSidelinePosition:zhSidelinePositionTop];
    
    self.bottomPopupBar.size = CGSizeMake(70, 220);
    self.bottomPopupBar.right = self.containerView.width - 10;
    self.bottomPopupBar.bottom = self.bottomSegmentedBar.top - 5;
    [self.bottomPopupBar zh_addLayerShadow:[[UIColor blackColor] colorWithAlphaComponent:0.6] offset:CGSizeZero radius:10];
    
    CGFloat margin = 10;
    self.indexSegmentedBar.width = blackInset.right - margin * 2;
    self.indexSegmentedBar.height = CGRectGetMaxY(blankFrame) - topPadding - self.timeChartView.contentEdgeInset.top;
    self.indexSegmentedBar.top = topPadding + self.timeChartView.contentEdgeInset.top;
    self.indexSegmentedBar.left = CGRectGetMaxX(self.timeChartView.frame) + margin;
    [self.indexSegmentedBar zh_add1pxSidelinePosition:zhSidelinePositionLeft | zhSidelinePositionTop | zhSidelinePositionRight];
}

- (void)_updateInitialConfiguration {
    TQTimeChartConfiguration *config = [TQTimeChartConfiguration defaultConfiguration];
    self.timeChartView.configuration = config;
    NSArray *dateArray = @[@"09:30", @"10:30", @"11:30/13:00", @"14:00", @"15:00"];
    self.timeChartView.dateTimeArray = dateArray;
    
    TQStockDetailsModel *detailData = [TQStockDetailsModel new];
    detailData.price_highest = 27.85;
    detailData.price_lowest = 12.76;
    detailData.price_open = 20.90;
    detailData.price_changeRatio = 0.78;
    detailData.stockName = @"伊利股票";
    detailData.stockCode = @"600887";
    self.topTextView.detailData = detailData;
    
    NSArray *segmentTitles = @[@"分时", @"五日", @"日K", @"周K", @"月K", @"季K", @"年K", @"60分", @"分钟"];
    self.bottomSegmentedBar.titles = segmentTitles;
    
    NSArray *popupTitles = @[@"120分", @"30分", @"15分", @"5分", @"1分"];
    self.bottomPopupBar.titles = popupTitles;
    
    NSArray *indexHeaderTitles = @[@"不复权", @"前复权", @"后复权"];
    self.indexSegmentedBar.headerTitles = indexHeaderTitles;
    
    NSArray *indexTitles = @[@"成交量", @"成交额", @"MACD", @"DMI", @"CCI", @"WR", @"BOLL", @"KDJ"];
    self.indexSegmentedBar.titles = indexTitles;
}

#pragma mark - TQStockTypeSegmentedBarDelegate

// 点击了底部股票切换条更多选项
- (void)stockTypeSegmentedBarDidClickMore:(TQStockTypeSegmentedBar *)segmentedBar {
    CGRect fromFrame = self.bottomPopupBar.frame;
    fromFrame.origin.y = self.containerView.height - self.bottomSegmentedBar.height;
    CGRect toFrame = self.bottomPopupBar.frame;
    toFrame.origin.y = self.bottomSegmentedBar.top - fromFrame.size.height - 5;
    [self.bottomPopupBar presentFromRect:fromFrame toRect:toFrame];
}

// 点击了底部股票切换条
- (void)stockTypeSegmentedBar:(TQStockTypeSegmentedBar *)segmentedBar didClickItemAtIndex:(NSInteger)index {
    if (index == segmentedBar.selectedIndex) return;
    segmentedBar.selectedIndex = index;
    NSString *currentTitle = segmentedBar.titles[index];
    if ([currentTitle isEqualToString:@"五日"]) {
        [self _updateFiveDayTimeData];
    } else {
        [self _updateTimeData];
    }
}

#pragma mark - TQStockTypePopupBarDelegate

// 点击了分钟弹出条
- (void)stockTypePopupBar:(TQStockTypePopupBar *)popupBar didClickItemAtIndex:(NSInteger)index {
    [popupBar dismiss];
    if (popupBar.currentSelectedIndex == index) return;
    UIButton *button = popupBar.items[index];
    self.bottomSegmentedBar.moreItemTitle = button.currentTitle;
    self.bottomSegmentedBar.selectedIndex = self.bottomSegmentedBar.moreSelectedIndex;
}

#pragma mark - TQStockIndexSegmentedBarDelegate

// 点击了指标切换条头部
- (void)stockIndexSegmentedBar:(TQStockIndexSegmentedBar *)segmentedBar didClickHeaderItemAtIndex:(NSInteger)index {
    if (index == segmentedBar.headerSelectedIndex) return;
    segmentedBar.headerSelectedIndex = index;
}

// 点击了指标切换条
- (void)stockIndexSegmentedBar:(TQStockIndexSegmentedBar *)segmentedBar didClickItemAtIndex:(NSInteger)index {
    if (index == segmentedBar.selectedIndex) return;
    segmentedBar.selectedIndex = index;
}

#pragma mark - Update data

- (void)_updateTimeData {
    @weakify(self);
    [self.dataManager sendTimeRequest:^(id  _Nullable requestObj, id  _Nullable responseObj) {
        @strongify(self);
        self.timeChartView.dataArray = responseObj;
        self.timePropData.dataArray = responseObj;
        
        TQTimeChartConfiguration *config = [TQTimeChartConfiguration defaultConfiguration];
        config.chartType = TQTimeChartTypeDefault;
        config.maxDataCount = 242;
        config.volumeBarGap = 0.5;
        self.timeChartView.configuration = config;
        
        [self.timePropData defaultStyle];
        self.timeChartView.propData = self.timePropData;
        [self.timeChartView drawChart];
    } failureCallback:NULL];
}

- (void)_updateFiveDayTimeData {
    @weakify(self);
    [self.dataManager sendFiveDayTimeRequest:^(id  _Nullable requestObj, id  _Nullable responseObj) {
        @strongify(self);
        self.timeChartView.dataArray = responseObj;
        self.timePropData.dataArray = responseObj;
        
        TQTimeChartConfiguration *config = [TQTimeChartConfiguration defaultConfiguration];
        config.chartType = TQTimeChartTypeFiveDay;
        config.maxDataCount = 242 * 5;
        config.volumeBarGap = 0.2;
        self.timeChartView.configuration = config;
        
        [self.timePropData fiveDayStyle];
        self.timeChartView.propData = self.timePropData;
        [self.timeChartView drawChart];
    } failureCallback:NULL];
}

- (void)_updateKlineData {
    @weakify(self);
    [self.dataManager sendKlineRequest:^(id  _Nullable requestObj, id  _Nullable responseObj) {
        @strongify(self);
        
        NSLog(@"responseObj is: %@", responseObj);
        [self.timeChartView drawChart];
    } failureCallback:NULL];
}

@end
