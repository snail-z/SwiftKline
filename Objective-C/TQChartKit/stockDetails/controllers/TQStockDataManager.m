//
//  TQStockDataManager.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/21.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQStockDataManager.h"
#import "TQStockModel.h"

@implementation TQStockDataManager

- (void)sendTimeRequest:(TQStcokSuccessCallback)successCallback
        failureCallback:(TQStcokFailureCallback)failureCallback
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"time_chart_data" ofType:@"json"];
    NSArray *array = [path zh_JSONToArray];
    NSArray<TQStcokTimeModel *> *respData = [TQStcokTimeModel mj_objectArrayWithKeyValuesArray:array];

    if (self && successCallback) {
        successCallback(nil, respData);
    }
}

- (void)sendFiveDayTimeRequest:(TQStcokSuccessCallback)successCallback
               failureCallback:(TQStcokFailureCallback)failureCallback
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"600887_five_day" ofType:@"json"];
    NSArray *array = [path zh_JSONToArray];
    NSArray<TQStcokTimeModel *> *respData = [TQStcokTimeModel mj_objectArrayWithKeyValuesArray:array];
    
    if (self && successCallback) {
        successCallback(nil, respData);
    }
}

- (void)sendKlineRequest:(TQStcokSuccessCallback)successCallback
         failureCallback:(TQStcokFailureCallback)failureCallback
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"stock_allHistory_data" ofType:@"plist"];
    NSMutableDictionary *resp = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSLog(@"~~~~~~data2 is: %@", resp);
    
//    NSArray<TQStockKLineModel *> *resp = [TQStockKLineModel mj_objectArrayWithKeyValuesArray:dataArray];
   
    if (self && successCallback) {
        successCallback(nil, resp);
    }
}

@end
