//
//  PKIndicatorCycler.h
//  PKChartKit
//
//  Created by zhanghao on 2017/12/26.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define PKCYCLER [PKIndicatorCycler sharedIndicatorCycler]

@interface PKIndicatorCycler : NSObject

+ (instancetype)sharedIndicatorCycler;

#pragma mark - VOL

// VOLMAA计算周期(默认为5)
@property (nonatomic, assign) NSUInteger VOL_MAA_CYELE;
// VOLMAB计算周期(默认为10)
@property (nonatomic, assign) NSUInteger VOL_MAB_CYELE;
// VOLMAC计算周期(默认为20)
@property (nonatomic, assign) NSUInteger VOL_MAC_CYELE;
// VOLMAD计算周期(默认为60)
@property (nonatomic, assign) NSUInteger VOL_MAD_CYELE;

#pragma mark - MA

// MAA计算周期(默认为5)
@property (nonatomic, assign) NSUInteger MAA_CYELE;
// MAB计算周期(默认为10)
@property (nonatomic, assign) NSUInteger MAB_CYELE;
// MAC计算周期(默认为20)
@property (nonatomic, assign) NSUInteger MAC_CYELE;
// MAD计算周期(默认为60)
@property (nonatomic, assign) NSUInteger MAD_CYELE;
// MAE计算周期(默认为120)
@property (nonatomic, assign) NSUInteger MAE_CYELE;

#pragma mark - BOLL

// BOLL计算周期(默认为20)
@property (nonatomic, assign) NSUInteger BOLL_CYELE;
// BOLL计算参数(默认为2)
@property (nonatomic, assign) NSUInteger BOLL_PARAM;

#pragma mark - MACD

// 快速移动平均线(默认为12)
@property (nonatomic, assign) NSUInteger EMA_SHORT;
// 慢速移动平均线(默认为26)
@property (nonatomic, assign) NSUInteger EMA_LONG;
// 离差值的9日移动平均值(默认为9)
@property (nonatomic, assign) NSUInteger DIFF_CYCLE;

#pragma mark - KDJ

// KDJ计算周期(默认为9)
@property (nonatomic, assign) NSUInteger KDJ_CYELE;

#pragma mark - WR

// WR6计算周期(默认为6)
@property (nonatomic, assign) NSUInteger WR_SHORT_CYELE;
// WR10计算周期(默认为10)
@property (nonatomic, assign) NSUInteger WR_LONG_CYELE;

// RSI6计算周期(默认为6)
@property (nonatomic, assign) NSUInteger RSI6_CYELE;
// RSI12计算周期(默认为12)
@property (nonatomic, assign) NSUInteger RSI12_CYELE;
// RSI24计算周期(默认为24)
@property (nonatomic, assign) NSUInteger RSI24_CYELE;

// OBVM计算周期(默认30)
@property (nonatomic, assign) NSUInteger OBVM_CYELE;

// PSY计算周期(默认12)
@property (nonatomic, assign) NSUInteger PSY_CYELE;
// PSY移动平均值计算周期(默认6)
@property (nonatomic, assign) NSUInteger PSYMA_CYELE;

// VR24计算周期(默认为24)
@property (nonatomic, assign) NSUInteger VR24_CYELE;

// CR26计算周期(默认为26)
@property (nonatomic, assign) NSUInteger CR26_CYELE;

// DMI14计算周期(默认为14)
@property (nonatomic, assign) NSUInteger DMI14_CYELE;
// DMI_ADX计算周期(默认为6)
@property (nonatomic, assign) NSUInteger DMI_ADX_CYELE;
// DMI_ADXR计算周期(默认为6)
@property (nonatomic, assign) NSUInteger DMI_ADXR_CYELE;

// BIAS6计算周期(默认为6)
@property (nonatomic, assign) NSUInteger BIAS6_CYELE;
// BIAS12计算周期(默认为12)
@property (nonatomic, assign) NSUInteger BIAS12_CYELE;
// BIAS24计算周期(默认为24)
@property (nonatomic, assign) NSUInteger BIAS24_CYELE;

// DMA短期计算周期(默认为10)
@property (nonatomic, assign) NSUInteger DMA_SHORT_CYELE;
// DMA长期计算周期(默认为50)
@property (nonatomic, assign) NSUInteger DMA_LONG_CYELE;

- (void)default_VOLMA;
- (void)default_MA;
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
- (void)default_all;

//- (void)restoreDefaultValueWithSecretKey:(NSString *)secretKey;

- (void)saveIndicatorCyclesWithIdentifier:(NSString *)identifier;
- (void)updateIndicatorCyclesWithIdentifier:(NSString *)identifier;
- (void)clearIndicatorCyclesWithIdentifier:(NSString *)identifier;
- (void)clearAllIndicatorCycleKeys;

- (nullable NSDictionary<NSString *, id> *)allStorageInfo;
- (NSDictionary<NSString *, id> *)ownerInfo;

@end

NS_ASSUME_NONNULL_END
