//
//  UIAlertController+zhExtend.m
//  zhCategoryKit
//
//  Created by zhanghao on 2017/12/13.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "UIAlertController+zhExtend.h"

@implementation UIAlertController (zhExtend)

+ (void)zh_testAlert:(NSString *)message {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
#pragma clang diagnostic pop
}

+ (void)zh_testAlert:(NSString *)message inVC:(UIViewController *)vc {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
    [vc presentViewController:alert animated:YES completion:NULL];
}

@end
