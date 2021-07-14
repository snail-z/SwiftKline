//
//  TQIndicatorType.m
//  TQChartKit
//
//  Created by zhanghao on 2018/9/18.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndicatorType.h"

NSString * const TQIndicatorVOL     = @"TQIndicatorVOLLayer";
NSString * const TQIndicatorBOLL    = @"TQIndicatorBOLLLayer";
NSString * const TQIndicatorMACD    = @"TQIndicatorMACDLayer";
NSString * const TQIndicatorKDJ     = @"TQIndicatorKDJLayer";
NSString * const TQIndicatorOBV     = @"TQIndicatorOBVLayer";
NSString * const TQIndicatorRSI     = @"TQIndicatorRSILayer";
NSString * const TQIndicatorWR      = @"TQIndicatorWRLayer";
NSString * const TQIndicatorVR      = @"TQIndicatorVRLayer";
NSString * const TQIndicatorCR      = @"TQIndicatorCRLayer";
NSString * const TQIndicatorBIAS    = @"TQIndicatorBIASLayer";
NSString * const TQIndicatorCCI     = @"TQIndicatorCCILayer";
NSString * const TQIndicatorDMI     = @"TQIndicatorDMILayer";
NSString * const TQIndicatorDMA     = @"TQIndicatorDMALayer";
NSString * const TQIndicatorSAR     = @"TQIndicatorSARLayer";
NSString * const TQIndicatorPSY     = @"TQIndicatorPSYLayer";
NSString * const TQIndicatorMA      = @"TQIndicatorMALayer";

NSString* MakeIndicatorIdentifier(NSString *acronyms) {
    return [NSString stringWithFormat:@"TQIndicator%@Layer", acronyms];
}

NSString* MakeIndicatorAcronyms(NSString *identifier) {
    NSUInteger prefixLen = 11, suffixLen = 5;
    if (identifier.length < (prefixLen + suffixLen)) return nil;
    NSMutableString *acronyms = [NSMutableString stringWithString:identifier];
    [acronyms deleteCharactersInRange:NSMakeRange(0, prefixLen)];
    [acronyms deleteCharactersInRange:NSMakeRange(acronyms.length - suffixLen, suffixLen)];
    return acronyms.copy;
}
