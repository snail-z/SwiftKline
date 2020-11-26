//
//  TQStockTypePopupBar.h
//  TQChartKit
//
//  Created by zhanghao on 2018/7/21.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TQStockTypePopupBarDelegate;

@interface TQStockTypePopupBar : UIView

@property (nonatomic, strong, readonly) NSMutableArray<UIButton *> *items;
@property (nonatomic, assign, readonly) NSInteger currentSelectedIndex;
@property (nonatomic, weak) id<TQStockTypePopupBarDelegate> delegate;

/** 是否正在显示 */
@property (nonatomic, assign, readonly) BOOL isPresenting;

/** 文本颜色 */
@property (nonatomic, assign) UIColor *textColor;

/** 文本字体 */
@property (nonatomic, strong) UIFont *textFont;

/** 分割线颜色 */
@property (nonatomic, strong) UIColor *lineColor;

/** 分割线宽度 */
@property (nonatomic, assign) CGFloat lineWidth;

/** 线边缘留白 */
@property (nonatomic, assign) CGFloat lineEdgePadding;

/** 蒙版覆盖区域 */
@property (nonatomic, assign) CGRect popupCoverFrame;

/** 视图将要显示的回调 */
@property (nonatomic, copy) void (^willPresent)(void);

/** 视图将要隐藏的回调 */
@property (nonatomic, copy) void (^willDismiss)(void);

/** 设置数据源 */
@property (nonatomic, strong) NSArray<NSString *> *titles;

- (void)present;
- (void)presentFromRect:(CGRect)fromRect toRect:(CGRect)toRect;

- (void)dismiss;

@end

@protocol TQStockTypePopupBarDelegate <NSObject>
@optional

/** 点击了每个item */
- (void)stockTypePopupBar:(TQStockTypePopupBar *)popupBar didClickItemAtIndex:(NSInteger)index;

@end
