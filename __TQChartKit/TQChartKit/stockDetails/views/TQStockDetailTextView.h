//
//  TQStockDetailTextView.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/21.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStockModel.h"

@interface TQStockDetailTextView : UIView

@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, strong) TQStockDetailsModel *detailData;

@end
