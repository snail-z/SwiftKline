//
//  TQStockDataManager.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/21.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^__nullable TQStcokSuccessCallback)(id _Nullable  requestObj, id _Nullable responseObj);
typedef void(^__nullable TQStcokFailureCallback)(id _Nullable requestObj, NSError *_Nullable error);

@interface TQStockDataManager : NSObject

- (void)sendTimeRequest:(TQStcokSuccessCallback)successCallback
        failureCallback:(TQStcokFailureCallback)failureCallback;

- (void)sendFiveDayTimeRequest:(TQStcokSuccessCallback)successCallback
               failureCallback:(TQStcokFailureCallback)failureCallback;

- (void)sendKlineRequest:(TQStcokSuccessCallback)successCallback
         failureCallback:(TQStcokFailureCallback)failureCallback;

@end

NS_ASSUME_NONNULL_END
