
//
//  TJPickerDataSource.m
//  TJCategories_Example
//
//  Created by zhanghao on 2020/12/23.
//  Copyright © 2020 gren-beans. All rights reserved.
//

#import "TJPickerDataSource.h"

@implementation TJPickerItem

@synthesize pickerText;
@synthesize pickerId;

+ (instancetype)itemWithPickerText:(NSString *)text pickerId:(NSInteger)pickerId {
    TJPickerItem *item = [TJPickerItem new];
    item.pickerText = text;
    item.pickerId = pickerId;
    return item;
}

@end
