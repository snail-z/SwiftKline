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
#import "TQKLineChartView.h"
#import "TQStockDetailTextView.h"
#import "TQStockTypeSegmentedBar.h"
#import "TQStockTypePopupBar.h"
#import "TQStockIndicatorSegmentedBar.h"
#import "TQStockDetailBusinessView.h"
#import "YYFPSLabel.h"

@interface TQStockHorizontalController () <TQStockTypeSegmentedBarDelegate, TQStockIndicatorSegmentedBarDelegate, TQStockTypePopupBarDelegate>

/** 数据管理 */
@property (nonatomic, strong) TQStockDataManager *dataManager;
@property (nonatomic, strong) TQStockTimePropData *timePropData;

/** 分时五日图 */
@property (nonatomic, strong) TQTimeChartView *timeChartView;

/** K线图 */
@property (nonatomic, strong) TQKLineChartView *klineChartView;

/** 顶部文本视图 */
@property (nonatomic, strong) TQStockDetailTextView *topTextView;

/** 顶部股票类型切换条 */
@property (nonatomic, strong) TQStockTypeSegmentedBar *bottomSegmentedBar;

/** 底部分钟弹窗条 */
@property (nonatomic, strong) TQStockTypePopupBar *bottomPopupBar;

/** 股票指标切换条(用于K线图显示时) */
@property (nonatomic, strong) TQStockIndicatorSegmentedBar *indexSegmentedBar;

/** 股票买卖明细视图(用于分时图显示时) */
@property (nonatomic, strong) TQStockDetailBusinessView *detailBusinessView;

/** 查看屏幕帧数工具视图 */
@property (nonatomic, strong) YYFPSLabel *fpsLabel;

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
    
    // 设置底部条初始选项
    [self stockTypeSegmentedBar:self.bottomSegmentedBar didClickItemAtIndex:2];
    // 设置指标初始选项
    [self stockIndicatorSegmentedBar:self.indexSegmentedBar didClickHeaderItemAtIndex:1];
    [self stockIndicatorSegmentedBar:self.indexSegmentedBar didClickItemAtIndex:0];
}

- (void)_initialization {
    self.dataManager = [TQStockDataManager new];
    self.timePropData = [TQStockTimePropData new];
    
    TQStockChartLayout *layout = [TQStockChartLayout layoutWithTopChartHeight:170];
    layout.separatedGap = 20;
    layout.contentEdgeInset = UIEdgeInsetsMake(20, 0, 20, 0);
    self.timeChartView = [TQTimeChartView new];
    self.timeChartView.layout = layout;
    [self.containerView addSubview:self.timeChartView];
    
    self.klineChartView = [TQKLineChartView new];
    self.klineChartView.layout = layout;
    self.klineChartView.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:self.klineChartView];
    
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
    
    self.indexSegmentedBar = [TQStockIndicatorSegmentedBar new];
    self.indexSegmentedBar.delegate = self;
    [self.containerView addSubview:self.indexSegmentedBar];
    
    self.detailBusinessView = [TQStockDetailBusinessView new];
    self.detailBusinessView.backgroundColor = [UIColor orangeColor];
    [self.containerView addSubview:self.detailBusinessView];
    
    [self.containerView bringSubviewToFront:self.bottomPopupBar]; // 控制视图层级
    [self.containerView bringSubviewToFront:self.bottomSegmentedBar];
}

- (void)_updateLayout {
    CGFloat topPadding = 40;
    CGFloat bottomPadding = 40;
    CGRect blankFrame = CGRectMake(0, topPadding, self.containerView.width, self.containerView.height - topPadding - bottomPadding);
    UIEdgeInsets blackInset = UIEdgeInsetsMake(0, 40, 0, 75);
    CGRect chartRect = UIEdgeInsetsInsetRect(blankFrame, blackInset);
    
    self.timeChartView.frame = chartRect;
    self.klineChartView.frame = chartRect;
    
    TQKLineChartStyle *style = [TQKLineChartStyle defaultStyle];
    self.klineChartView.style = style;
    [self.klineChartView drawChart];
    
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
    self.indexSegmentedBar.height = CGRectGetMaxY(blankFrame) - topPadding - self.timeChartView.layout.contentEdgeInset.top;
    self.indexSegmentedBar.top = topPadding + self.timeChartView.layout.contentEdgeInset.top;
    self.indexSegmentedBar.left = CGRectGetMaxX(self.timeChartView.frame) + margin;
    [self.indexSegmentedBar zh_add1pxSidelinePosition:zhSidelinePositionLeft | zhSidelinePositionTop | zhSidelinePositionRight];
}

- (void)_updateInitialConfiguration {
    TQTimeChartStyle *config = [TQTimeChartStyle defaultStyle];
    self.timeChartView.style = config;
    
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
    
    NSArray *indexHeaderTitles = @[@"前复权", @"不复权", @"后复权"];
    self.indexSegmentedBar.headerTitles = indexHeaderTitles;
    
    NSArray *indexTitles = @[@"VOL", @"MACD", @"BIAS", @"VR", @"PSY", @"OBV", @"RSI", @"WR", @"BOLL", @"DMI", @"DMA", @"KDJ", @"CR", @"CCI"];
    self.indexSegmentedBar.titles = indexTitles;
    [self.indexSegmentedBar reloadData];
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
        self.klineChartView.hidden = YES;
        self.timeChartView.hidden = NO;
    } else if ([currentTitle isEqualToString:@"分时"]) {
        [self _updateTimeData];
        self.klineChartView.hidden = YES;
        self.timeChartView.hidden = NO;
    } else {
        if (!self.klineChartView.hidden) {
            [self _updateKlineData];
        }
        self.klineChartView.hidden = NO;
        self.timeChartView.hidden = YES;
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
- (void)stockIndicatorSegmentedBar:(TQStockIndicatorSegmentedBar *)segmentedBar didClickHeaderItemAtIndex:(NSInteger)index {
    if (index == segmentedBar.headerSelectedIndex) return;
    segmentedBar.headerSelectedIndex = index;
}

// 点击了指标切换条
- (void)stockIndicatorSegmentedBar:(TQStockIndicatorSegmentedBar *)segmentedBar didClickItemAtIndex:(NSInteger)index {
    if (index == segmentedBar.selectedIndex) return;
    segmentedBar.selectedIndex = index;
    NSString *stringKey = [self.indexSegmentedBar.titles objectAtIndex:index];
    [self.klineChartView changeIndicatorWithIdentifier:MakeIndicatorIdentifier(stringKey)];
}

#pragma mark - Update data

- (void)_updateTimeData {
    @weakify(self);
    [self.dataManager sendTimeRequest:^(id  _Nullable requestObj, id  _Nullable responseObj) {
        @strongify(self);
        
        TQTimeChartStyle *config = [TQTimeChartStyle defaultStyle];
        config.chartType = TQTimeChartTypeOne;
        self.timeChartView.style = config;
        
        self.timeChartView.dataArray = responseObj;
        self.timePropData.dataArray = responseObj;
        [self.timePropData defaultStyle];
        self.timeChartView.coordsConfig = self.timePropData;
        [self.timeChartView drawChart];
    } failureCallback:NULL];
}

- (void)_updateFiveDayTimeData {
    @weakify(self);
    [self.dataManager sendFiveDayTimeRequest:^(id  _Nullable requestObj, id  _Nullable responseObj) {
        @strongify(self);
        TQTimeChartStyle *config = [TQTimeChartStyle defaultStyle];
        config.chartType = TQTimeChartTypeFive;
        config.maxDataCount = 242 * 5;
        config.volumeShapeGap = 0.2;
        self.timeChartView.style = config;
        
        self.timeChartView.dataArray = responseObj;
        self.timePropData.dataArray = responseObj;
        [self.timePropData fiveDayStyle];
        self.timeChartView.coordsConfig = self.timePropData;
        [self.timeChartView drawChart];
        
    } failureCallback:NULL];
}

- (NSArray *)respZengda:(id)resp number:(NSInteger)number {
    NSMutableArray *mud = [NSMutableArray array];
    for (NSInteger i = 0; i < number; i++) {
        [mud addObjectsFromArray:resp];
    }
    return mud;
}

- (void)_updateKlineData {
    __weak TQStockHorizontalController *weakSelf = self;
    self.klineChartView.loadingView.loadingCallback = ^(TQKLineLoadingView * _Nonnull loadingView) {
        [weakSelf loadDataCompletion:^(NSArray<TQStockKLineModel *> *array) {
            [loadingView endLoading];
            [weakSelf.klineChartView insertEarlierDataArray:array];
            [weakSelf.klineChartView drawChart];
        }];
    };
    
    @weakify(self);
    [self.dataManager sendKlineRequest:^(id  _Nullable requestObj, id  _Nullable responseObj) {
        @strongify(self);
        TQKLineChartStyle *style = [TQKLineChartStyle defaultStyle];
        self.klineChartView.style = style;
        
        self.klineChartView.dataArray = responseObj;
        [self.klineChartView drawChart];
    } failureCallback:NULL];
    
    [self _addFpsLabelInView:self.klineChartView];
}

- (void)loadDataCompletion:(void (^)(NSArray<TQStockKLineModel *> *))completion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"more_yl_kline_data" ofType:@"plist"];
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray *results = [dictionary objectForKey:@"results"];
        NSArray<TQStockKLineModel *> *respData = [TQStockKLineModel mj_objectArrayWithKeyValuesArray:results];
        if (completion) completion(respData);
    });
}

- (void)_addFpsLabelInView:(UIView *)sView {
    if (![sView.subviews containsObject:self.fpsLabel]) {
        [sView addSubview:self.fpsLabel];
        self.fpsLabel.left = sView.width - self.fpsLabel.width;
    }
}

- (YYFPSLabel *)fpsLabel {
    if (!_fpsLabel) {
        _fpsLabel = [YYFPSLabel new];
        _fpsLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }
    return _fpsLabel;
}

@end
