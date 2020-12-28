//
//  UIAlertController+PKExtend.m
//  PKCategories
//
//  Created by zhanghao on 2020/9/11.
//

#import "UIAlertController+PKExtend.h"
#import "UIApplication+PKExtend.h"

@implementation UIAlertController (PKExtend)

+ (void)pk_showMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
    [UIApplication.pk_keyWindow.rootViewController presentViewController:alertController animated:YES completion:NULL];
}

@end
