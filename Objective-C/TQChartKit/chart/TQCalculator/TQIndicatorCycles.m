//
//  TQIndicatorCycles.m
//  TQChartKit
//
//  Created by zhanghao on 2018/9/20.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQIndicatorCycles.h"

NSString *const TQStockIndicatorCyclesKey = @"TQStockIndicatorCyclesKey";
NSString *const TQStockIndicatorSortIdentifiersKey = @"TQStockIndicatorSortIdentifiersKey";

@implementation TQIndicatorCycles

+ (instancetype)sharedIndicatorCycles {
    static TQIndicatorCycles *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[TQIndicatorCycles alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    NSArray<NSString *> *array = [[NSUserDefaults standardUserDefaults] arrayForKey:TQStockIndicatorSortIdentifiersKey];
    if (array) {
        [self changeIndicatorCyclesWithIdentifier:array.lastObject];
        return self;
    }
    [self default_all];
    return self;
}

- (void)default_all {
    [self default_MACD];
    [self default_KDJ];
    [self default_WR];
    [self default_RSI];
    [self default_OBV];
    [self default_PSY];
    [self default_VR];
    [self default_CR];
    [self default_BOLL];
    [self default_DMI];
    [self default_BIAS];
    [self default_DMA];
    [self default_MA];
}

- (void)default_MACD {
    self.EMA_SHORT = 12;
    self.EMA_LONG = 26;
    self.DIF_CYCLE = 9;
}

- (void)default_KDJ {
    self.KDJ_CYELE = 9;
}

- (void)default_WR {
    self.WR_SHORT_CYELE = 6;
    self.WR_LONG_CYELE = 10;
}

- (void)default_RSI {
    self.RSI6_CYELE = 6;
    self.RSI12_CYELE = 12;
    self.RSI24_CYELE = 24;
}

- (void)default_OBV {
    self.OBVM_CYELE = 30;
}

- (void)default_PSY {
    self.PSY_CYELE = 12;
    self.PSYMA_CYELE = 6;
}

- (void)default_VR {
    self.VR24_CYELE = 24;
}

- (void)default_CR {
    self.CR26_CYELE = 26;
}

- (void)default_BOLL {
    self.BOLL20_CYELE = 20;
    self.BOLL_PARAM = 2;
}

- (void)default_DMI {
    self.DMI14_CYELE = 14;
    self.DMI_ADX_CYELE = 6;
    self.DMI_ADXR_CYELE = 6;
}

- (void)default_BIAS {
    self.BIAS6_CYELE = 6;
    self.BIAS12_CYELE = 12;
    self.BIAS24_CYELE = 24;
}

- (void)default_DMA {
    self.DMA_SHORT_CYELE = 10;
    self.DMA_LONG_CYELE = 50;
}

- (void)default_MA {
    self.MA5_CYELE = 5;
    self.MA10_CYELE = 10;
    self.MA20_CYELE = 20;
    self.MA60_CYELE = 60;
    self.MA_N_CYELE = 120;
}

- (NSDictionary *)get_propertyListDictionary {
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for(unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        id propValue = [self valueForKey:propertyName];
        [dictionary setObject:propValue?:[NSNull null] forKey:propertyName];
    }
    free(properties);
    return dictionary.copy;
}

- (void)saveIndicatorCyclesWithIdentifier:(NSString *)identifier {
    if (!identifier) return;
    NSDictionary *dictCycles = [self get_propertyListDictionary];
    NSMutableDictionary *mud = [NSMutableDictionary dictionary];
    [mud setObject:dictCycles forKey:identifier];
    [[NSUserDefaults standardUserDefaults] setObject:mud forKey:TQStockIndicatorCyclesKey];
    
    NSArray<NSString *> *array = [[NSUserDefaults standardUserDefaults] arrayForKey:TQStockIndicatorSortIdentifiersKey];
    if (!array) {
        NSMutableArray *mudArray = [NSMutableArray arrayWithObject:identifier];
        [[NSUserDefaults standardUserDefaults] setObject:mudArray forKey:TQStockIndicatorSortIdentifiersKey];
    } else {
        NSMutableArray *mudArray = [NSMutableArray arrayWithArray:array];
        [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:identifier]) {
                [mudArray removeObjectAtIndex:idx];
            }
        }];
        [mudArray addObject:identifier];
        [[NSUserDefaults standardUserDefaults] setObject:mudArray forKey:TQStockIndicatorSortIdentifiersKey];
    }
}

- (void)changeIndicatorCyclesWithIdentifier:(NSString *)identifier {
    if (!identifier) return;
    NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] objectForKey:TQStockIndicatorCyclesKey];
    if (!dictionary) return;
    NSDictionary *dictCycles = [dictionary objectForKey:identifier];
    if (dictCycles) {
        [self setValuesForKeysWithDictionary:dictCycles];
    } else {
        [self default_all];
    }
}

- (void)clearIndicatorCyclesWithIdentifier:(NSString *)identifier {
    if (!identifier) return;
    NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] objectForKey:TQStockIndicatorCyclesKey];
    NSArray<NSString *> *array = [[NSUserDefaults standardUserDefaults] arrayForKey:TQStockIndicatorSortIdentifiersKey];
    if (!dictionary) return;
    if ([dictionary.allKeys containsObject:identifier]) {
        [self clearAllIndicatorCycleKeys];
        NSMutableDictionary *mud = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [mud removeObjectForKey:identifier];
        [[NSUserDefaults standardUserDefaults] setObject:mud forKey:TQStockIndicatorCyclesKey];
        if (array) {
            NSMutableArray *mudArray = [NSMutableArray arrayWithArray:array];
            [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:identifier]) {
                    [mudArray removeObjectAtIndex:idx];
                }
            }];
            [[NSUserDefaults standardUserDefaults] setObject:mudArray forKey:TQStockIndicatorSortIdentifiersKey];
        }
    }
}

- (void)clearAllIndicatorCycleKeys {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TQStockIndicatorCyclesKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TQStockIndicatorSortIdentifiersKey];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"[%@]-setValue:%@ forUndefinedKey:%@", NSStringFromClass(self.class), value, key);
}

- (NSDictionary<NSString *,id> *)allStorageInfo {
    return [[NSUserDefaults standardUserDefaults] objectForKey:TQStockIndicatorCyclesKey];
}

- (NSDictionary<NSString *,id> *)ownerInfo {
    return [self get_propertyListDictionary];
}

@end
