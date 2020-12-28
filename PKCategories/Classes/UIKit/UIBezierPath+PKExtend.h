//
//  UIBezierPath+PKExtend.h
//  PKCategories
//
//  Created by jiaohong on 2019/1/8.
//  Copyright © 2018年 PsychokinesisTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPath (PKExtend)

/** 绘制矩形框 */
- (void)pk_addRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
