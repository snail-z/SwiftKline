//
//  TJPickerDataSource.h
//  TJCategories_Example
//
//  Created by zhanghao on 2020/12/23.
//  Copyright © 2020 gren-beans. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TJPickerDataSource <NSObject>

/// 标题
@property(nonatomic, copy) NSString *text;

/// 唯一标识码
@property(nonatomic, assign) NSInteger identifier;

@end


@interface TJPickerItem : NSObject <TJPickerDataSource>

/// 遍历构造器
+ (instancetype)itemWithText:(NSString *)text identifier:(NSInteger)identifier;

@end

NS_ASSUME_NONNULL_END
