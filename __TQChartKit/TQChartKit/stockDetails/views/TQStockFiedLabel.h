//
//  TQStockFiedLabel.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/22.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TQStockFiedRenderer : NSObject

/** 文本颜色 */
@property (nonatomic, strong) UIColor *prefixColor;
@property (nonatomic, strong) UIColor *suffixColor;

/** 文本字体 */
@property (nonatomic, strong) UIFont *prefixFont;
@property (nonatomic, strong) UIFont *suffixFont;

/** 设置文本 */
@property (nonatomic, strong) NSString *prefixText;
@property (nonatomic, strong) NSString *suffixText;

+ (instancetype)defaultRenderer;

@end

@interface TQStockFiedLabel : UIView

@property (nonatomic, strong) TQStockFiedRenderer *renderer;

@end
