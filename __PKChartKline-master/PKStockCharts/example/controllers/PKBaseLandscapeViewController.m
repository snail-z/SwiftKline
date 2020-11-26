//
//  PKBaseLandscapeViewController.m
//  PKStockCharts
//
//  Created by zhanghao on 2019/8/22.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import "PKBaseLandscapeViewController.h"

@interface PKBaseLandscapeViewController ()

@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation PKBaseLandscapeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _containerView = [UIView new];
    [self.view addSubview:_containerView];
    
    _closeButton = [self createCloseButton];
    [self.view addSubview:_closeButton];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGSize size = CGSizeMake(self.view.bounds.size.height, self.view.bounds.size.width);
        make.left.top.equalTo(self.view);
        make.width.mas_equalTo(size.width);
        make.height.mas_equalTo(size.height);
    }];

    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view).offset(-5);
    }];
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
    return UIInterfaceOrientationMaskLandscapeRight;
}

@end
