//
//  TQStockBaseHorizontalController.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/21.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQStockBaseHorizontalController.h"

@interface TQStockBaseHorizontalController ()

@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation TQStockBaseHorizontalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _containerView = [UIView new];
    [self.view addSubview:_containerView];
    
    _closeButton = [self createCloseButton];
    [self.view addSubview:_closeButton];
    
    CGSize _size = CGSizeMake(self.view.frame.size.height, self.view.frame.size.width);
    self.containerView.frame = self.view.frame = (CGRect){.size = _size};
    
    CGSize _buttonSize = CGSizeMake(50, 50);
    self.closeButton.frame = (CGRect){.origin.x = self.view.width - _buttonSize.width, .size = _buttonSize};
}

- (UIButton *)createCloseButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"×" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:32];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)goback {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    
//}

@end
