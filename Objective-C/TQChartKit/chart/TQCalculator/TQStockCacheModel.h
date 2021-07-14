//
//  TQStockCacheModel.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/30.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <Foundation/Foundation.h>

/* RSI temp value . */
struct CGTempRSIValue {
    CGFloat smax;
    CGFloat sabs;
};
typedef struct CGTempRSIValue CGTempRSIValue;

/* CGTempRSIValue */
CG_INLINE CGTempRSIValue
CGRSITempValueMake(CGFloat smax, CGFloat sabs) {
    CGTempRSIValue tpValue; tpValue.smax = smax; tpValue.sabs = sabs; return tpValue;
}

/* VR temp value . */
struct CGTempVRValue {
    CGFloat avs;
    CGFloat bvs;
    CGFloat cvs;
};
typedef struct CGTempVRValue CGTempVRValue;

/* CGTempVRValue */
CG_INLINE CGTempVRValue
CGVRTempValueMake(CGFloat avs, CGFloat bvs, CGFloat cvs) {
    CGTempVRValue tpValue; tpValue.avs = avs; tpValue.bvs = bvs; tpValue.cvs = cvs; return tpValue;
}

@interface TQStockCacheModel : NSObject

@property (nonatomic, assign) CGFloat openValue;
@property (nonatomic, assign) CGFloat closeValue;

// VOL
@property (nonatomic, assign) CGFloat VOLValue;
@property (nonatomic, assign) CGFloat VOLMA5Value;
@property (nonatomic, assign) CGFloat VOLMA10Value;
@property (nonatomic, assign) CGFloat VOLMA20Value;

// MA
@property (nonatomic, assign) CGFloat MA5Value;
@property (nonatomic, assign) CGFloat MA10Value;
@property (nonatomic, assign) CGFloat MA20Value;
@property (nonatomic, assign) CGFloat MA60Value;

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
@property (nonatomic, assign) CGTempVRValue vr24TpValue;

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
@property (nonatomic, assign) CGTempRSIValue rsi6TpValue;
@property (nonatomic, assign) CGTempRSIValue rsi12TpValue;
@property (nonatomic, assign) CGTempRSIValue rsi24TpValue;

// PSY
@property (nonatomic, assign) CGFloat PSYValue;
@property (nonatomic, assign) CGFloat PSYMAValue;

// MACD
@property (nonatomic, assign) CGFloat EMAFastValue;
@property (nonatomic, assign) CGFloat EMASlowValue;
@property (nonatomic, assign) CGFloat DIFValue;
@property (nonatomic, assign) CGFloat DEAValue;
@property (nonatomic, assign) CGFloat MACDValue;

@end
