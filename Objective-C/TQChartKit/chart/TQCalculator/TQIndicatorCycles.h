//
//  TQIndicatorCycles.h
//  TQChartKit
//
//  Created by zhanghao on 2018/9/20.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TQIndicatorCycles : NSObject

@property (nonatomic, assign) NSUInteger EMA_SHORT; // 快速移动平均线(默认为12)
@property (nonatomic, assign) NSUInteger EMA_LONG; // 慢速移动平均线(默认为26)
@property (nonatomic, assign) NSUInteger DIF_CYCLE; // 离差值的9日移动平均值(默认为9)

@property (nonatomic, assign) NSUInteger KDJ_CYELE; // KDJ计算周期(默认为9)

@property (nonatomic, assign) NSUInteger WR_SHORT_CYELE; // WR6计算周期(默认为6)
@property (nonatomic, assign) NSUInteger WR_LONG_CYELE; // WR10计算周期(默认为10)

@property (nonatomic, assign) NSUInteger RSI6_CYELE; // RSI6计算周期(默认为6)
@property (nonatomic, assign) NSUInteger RSI12_CYELE; // RSI12计算周期(默认为12)
@property (nonatomic, assign) NSUInteger RSI24_CYELE; // RSI24计算周期(默认为24)

@property (nonatomic, assign) NSUInteger OBVM_CYELE; // OBVM计算周期(默认30)

@property (nonatomic, assign) NSUInteger PSY_CYELE; // PSY计算周期(默认12)
@property (nonatomic, assign) NSUInteger PSYMA_CYELE; // PSY移动平均值计算周期(默认6)

@property (nonatomic, assign) NSUInteger VR24_CYELE; // VR24计算周期(默认为24)

@property (nonatomic, assign) NSUInteger CR26_CYELE; // CR26计算周期(默认为26)

@property (nonatomic, assign) NSUInteger BOLL20_CYELE; // BOLL20计算周期(默认为20)
@property (nonatomic, assign) NSUInteger BOLL_PARAM; // BOLL计算参数(默认为2)

@property (nonatomic, assign) NSUInteger DMI14_CYELE; // DMI14计算周期(默认为14)
@property (nonatomic, assign) NSUInteger DMI_ADX_CYELE; // DMI_ADX计算周期(默认为6)
@property (nonatomic, assign) NSUInteger DMI_ADXR_CYELE; // DMI_ADXR计算周期(默认为6)

@property (nonatomic, assign) NSUInteger BIAS6_CYELE; // BIAS6计算周期(默认为6)
@property (nonatomic, assign) NSUInteger BIAS12_CYELE; // BIAS12计算周期(默认为12)
@property (nonatomic, assign) NSUInteger BIAS24_CYELE; // BIAS24计算周期(默认为24)

@property (nonatomic, assign) NSUInteger DMA_SHORT_CYELE; // DMA短期计算周期(默认为10)
@property (nonatomic, assign) NSUInteger DMA_LONG_CYELE; // DMA长期计算周期(默认为50)

@property (nonatomic, assign) NSUInteger MA5_CYELE; // MA1计算周期(默认为5)
@property (nonatomic, assign) NSUInteger MA10_CYELE; // MA2计算周期(默认为10)
@property (nonatomic, assign) NSUInteger MA20_CYELE; // MA3计算周期(默认为20)
@property (nonatomic, assign) NSUInteger MA60_CYELE; // MA4计算周期(默认为60)
@property (nonatomic, assign) NSUInteger MA_N_CYELE; // MAN计算周期(默认为120)

- (void)default_MACD;
- (void)default_KDJ;
- (void)default_WR;
- (void)default_RSI;
- (void)default_OBV;
- (void)default_PSY;
- (void)default_VR;
- (void)default_CR;
- (void)default_BOLL;
- (void)default_DMI;
- (void)default_BIAS;
- (void)default_DMA;
- (void)default_MA;
- (void)default_all;

- (void)saveIndicatorCyclesWithIdentifier:(NSString *)identifier;
- (void)changeIndicatorCyclesWithIdentifier:(NSString *)identifier;
- (void)clearIndicatorCyclesWithIdentifier:(NSString *)identifier;
- (void)clearAllIndicatorCycleKeys;

- (nullable NSDictionary<NSString *, id> *)allStorageInfo;
- (NSDictionary<NSString *, id> *)ownerInfo;

+ (instancetype)sharedIndicatorCycles;

@end

NS_ASSUME_NONNULL_END
