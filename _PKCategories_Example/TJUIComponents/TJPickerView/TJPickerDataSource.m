
//
//  TJPickerDataSource.m
//  TJCategories_Example
//
//  Created by zhanghao on 2020/12/23.
//  Copyright © 2020 gren-beans. All rights reserved.
//

#import "TJPickerDataSource.h"

@implementation TJPickerItem

@synthesize text;
@synthesize identifier;

+ (instancetype)itemWithText:(NSString *)text identifier:(NSInteger)identifier {
    TJPickerItem *item = [TJPickerItem new];
    item.text = text;
    item.identifier = identifier;
    return item;
}

@end
