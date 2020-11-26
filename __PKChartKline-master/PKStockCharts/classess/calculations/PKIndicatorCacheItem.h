//
//  PKIndicatorCacheItem.h
//  PKChartKit
//
//  Created by zhanghao on 2017/12/26.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/* RSI store value . */
typedef struct CGStoreRSIValue {
    CGFloat smax;
    CGFloat sabs;
} CGStoreRSIValue;

/* CGStoreRSIValue */
CG_INLINE CGStoreRSIValue
CGStoreRSIValueMake(CGFloat smax, CGFloat sabs) {
    CGStoreRSIValue value; value.smax = smax; value.sabs = sabs; return value;
}

/* VR store value . */
typedef struct CGStoreVRValue {
    CGFloat avs;
    CGFloat bvs;
    CGFloat cvs;
} CGStoreVRValue;

/* CGStoreVRValue */
CG_INLINE CGStoreVRValue
CGStoreVRValueMake(CGFloat avs, CGFloat bvs, CGFloat cvs) {
    CGStoreVRValue value; value.avs = avs; value.bvs = bvs; value.cvs = cvs; return value;
}

@interface PKIndicatorCacheItem : NSObject

// VOL
@property (nonatomic, assign) CGFloat VOLMAAValue;
@property (nonatomic, assign) CGFloat VOLMABValue;
@property (nonatomic, assign) CGFloat VOLMACValue;
@property (nonatomic, assign) CGFloat VOLMADValue;

// MA
@property (nonatomic, assign) CGFloat MAAValue;
@property (nonatomic, assign) CGFloat MABValue;
@property (nonatomic, assign) CGFloat MACValue;
@property (nonatomic, assign) CGFloat MADValue;
@property (nonatomic, assign) CGFloat MAEValue;

// BOLL
@property (nonatomic, assign) CGFloat BOLLMBValue;
@property (nonatomic, assign) CGFloat BOLLUPValue;
@property (nonatomic, assign) CGFloat BOLLDPValue;

// DMA
@property (nonatomic, assign) CGFloat DMAValue;
@property (nonatomic, assign) CGFloat AMAValue;

// DMI
@property (nonatomic, assign) CGFloat DMIPDIValue;
@property (nonatomic, assign) CGFloat DMIMDIValue;
@property (nonatomic, assign) CGFloat DMIADXValue;
@property (nonatomic, assign) CGFloat DMIADXRValue;

// KDJ
@property (nonatomic, assign) CGFloat KValue;
@property (nonatomic, assign) CGFloat DValue;
@property (nonatomic, assign) CGFloat JValue;

// CCI
@property (nonatomic, assign) CGFloat CCIValue;

// BIAS
@property (nonatomic, assign) CGFloat BIAS6Value;
@property (nonatomic, assign) CGFloat BIAS12Value;
@property (nonatomic, assign) CGFloat BIAS24Value;

// OBV
@property (nonatomic, assign) CGFloat OBVValue;
@property (nonatomic, assign) CGFloat OBVMValue;

// VR
@property (nonatomic, assign) CGFloat VR24Value;
@property (nonatomic, assign) CGStoreVRValue VR24StoreValue;

// CR
@property (nonatomic, assign) CGFloat CR26Value;
@property (nonatomic, assign) CGFloat crUpValue;
@property (nonatomic, assign) CGFloat crDpValue;

// WR
@property (nonatomic, assign) CGFloat WR6Value;
@property (nonatomic, assign) CGFloat WR10Value;

// RSI
@property (nonatomic, assign) CGFloat RSI6Value;
@property (nonatomic, assign) CGFloat RSI12Value;
@property (nonatomic, assign) CGFloat RSI24Value;
@property (nonatomic, assign) CGStoreRSIValue RSI6StoreValue;
@property (nonatomic, assign) CGStoreRSIValue RSI12StoreValue;
@property (nonatomic, assign) CGStoreRSIValue RSI24StoreValue;

// PSY
@property (nonatomic, assign) CGFloat PSYValue;
@property (nonatomic, assign) CGFloat PSYMAValue;

// MACD
@property (nonatomic, assign) CGFloat EMAFastValue;
@property (nonatomic, assign) CGFloat EMASlowValue;
@property (nonatomic, assign) CGFloat DIFFValue;
@property (nonatomic, assign) CGFloat DEAValue;
@property (nonatomic, assign) CGFloat MACDValue;

@end

NS_ASSUME_NONNULL_END
