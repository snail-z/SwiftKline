//
//  WMZPageScroller.h
//  WMZPageController
//
//  Created by wmz on 2019/9/20.
//  Copyright © 2019 wmz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WMZPageScroller : UITableView <UIGestureRecognizerDelegate>
@property(nonatomic,assign)CGFloat menuTitleHeight;
@property(nonatomic,assign)BOOL canScroll;
@property(nonatomic,assign)BOOL wFromNavi;
@end

@interface UIImage (PageImageName)
//从bundle获取图片
+ (UIImage*)pageBundleImage:(NSString*)name;
@end

NS_ASSUME_NONNULL_END
