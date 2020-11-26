//
//  PKKLineChartProtocol.h
//  PKChartKit
//
//  Created by zhanghao on 2017/12/05.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PKKLineChartProtocol <NSObject>

@required

/** 开盘价 */
- (CGFloat)pk_kOpenPrice;

/** 最高价 */
- (CGFloat)pk_kHighPrice;

/** 最低价 */
- (CGFloat)pk_kLowPrice;

/** 收盘价 */
- (CGFloat)pk_kClosePrice;

/** 成交量 */
- (CGFloat)pk_kVolume;

/** 日期时间 */
- (NSDate *)pk_kDateTime;

@optional

/** 均价 */
- (CGFloat)pk_kAveragePrice;

/** 成交额 */
- (CGFloat)pk_kTurnover;

/** 昨收价 */
- (CGFloat)pk_kPreClosePrice;

@end

NS_ASSUME_NONNULL_END
