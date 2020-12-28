//
//  UIAlertController+PKExtend.h
//  PKCategories
//
//  Created by zhanghao on 2020/9/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (PKExtend)

/** 显示信息提示框 */
+ (void)pk_showMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
