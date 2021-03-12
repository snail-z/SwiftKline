//
//  TJPickerViewCell.h
//  PKCategories_Example
//
//  Created by zhanghao on 2021/1/8.
//  Copyright © 2021 gren-beans. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TJPickerLineCell : UIView

@property(nonatomic, copy) NSString *title;
@property(nonatomic, assign) UIEdgeInsets lineEdgeInsets;

@end

@interface TJPickerShowyCell : UIView

@end

NS_ASSUME_NONNULL_END
