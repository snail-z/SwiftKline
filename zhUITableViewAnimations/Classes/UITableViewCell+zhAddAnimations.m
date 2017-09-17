//
//  UITableViewCell+zhAddAnimations.m
//  ThemeManager
//
//  Created by zhanghao on 2017/9/17.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UITableViewCell+zhAddAnimations.h"

@implementation UITableViewCell (zhAddAnimations)

- (void)zh_presentAnimateSlideFromLeft {
    CATransform3D rotation;//3D旋转

    rotation = CATransform3DMakeTranslation(0 ,50 ,20);
    // rotation = CATransform3DMakeRotation( M_PI_4 , 0.0, 0.7, 0.4);
    // 逆时针旋转

    rotation = CATransform3DScale(rotation, 0.5, 0.5, 1);
    rotation.m34 = 1.0/ -600;

    self.layer.shadowColor = [[UIColor blackColor]CGColor];
    self.layer.shadowOffset = CGSizeMake(10, 10);
    self.alpha = 0;
    self.layer.transform = rotation;

    [UIView beginAnimations:@"rotation" context:NULL];

    [UIView setAnimationDuration:0.6];
    self.layer.transform = CATransform3DIdentity;
    self.alpha = 1;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}

@end
