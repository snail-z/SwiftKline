//
//  PKExample1ViewController.m
//  PKStockCharts
//
//  Created by zhanghao on 2019/7/11.
//  Copyright © 2019年 PsychokinesisTeam. All rights reserved.
//

#import "PKExample1ViewController.h"
#import "PKLandscapeViewController.h"

@interface PKExample1ViewController ()

@property (nonatomic, strong) CAShapeLayer *myShaperLayer;

@end

@implementation PKExample1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _myShaperLayer = [CAShapeLayer layer];
    _myShaperLayer.strokeColor = [UIColor brownColor].CGColor;
    _myShaperLayer.fillColor = [UIColor yellowColor].CGColor;
    _myShaperLayer.lineWidth= 5;
    [self.view.layer addSublayer:_myShaperLayer];
    
    
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:CGRectMake(100, 100, 200, 200)];
    _myShaperLayer.path = path1.CGPath;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:CGRectMake(150, 150, 80, 80)];
        self->_myShaperLayer.path = path2.CGPath;
        
        [self addAnimationFromPath:path1.CGPath toPath:path2.CGPath];
    });
    

//    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"点击横屏" style:UIBarButtonItemStylePlain target:self action:@selector(present)];
//    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)addAnimationFromPath:(CGPathRef)fromPath toPath:(CGPathRef)toPath {
    if (!fromPath || !toPath) return;
    UIBezierPath *originPath = [UIBezierPath bezierPathWithCGPath:fromPath];
    UIBezierPath *targetPath = [UIBezierPath bezierPathWithCGPath:toPath];
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
    anim.duration = 0.15;
    anim.fromValue = (__bridge id _Nullable)(originPath.CGPath);
    anim.toValue = (__bridge id _Nullable)(targetPath.CGPath);
    anim.removedOnCompletion = YES;
    [_myShaperLayer addAnimation:anim forKey:nil];
}

- (void)present {
    PKLandscapeViewController *vc = [[PKLandscapeViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
