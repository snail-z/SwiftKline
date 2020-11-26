//
//  TQKLineChartView.m
//  TQChartKit
//
//  Created by zhanghao on 2018/7/31.
//  Copyright © 2018年 zhanghao. All rights reserved.
//

#import "TQKLineChartView.h"

@interface TQKLineChartView ()

@property (nonatomic, strong) UILabel *kLineTitleLabel;
@property (nonatomic, strong) UILabel *indexTitleLabel;

@end

@implementation TQKLineChartView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _initialization];
    }
    return self;
}

- (void)_initialization {
    self.delegate = self;
    
    _kLineTitleLabel = [UILabel new];
    _kLineTitleLabel.frame = CGRectMake(100, 100, 100, 100);
    [self addSubview:_kLineTitleLabel];
    
    _indexTitleLabel = [UILabel new];
    _indexTitleLabel.frame = CGRectMake(100, 100, 100, 100);
    [self addSubview:_indexTitleLabel];
}

- (void)drawChart {
    [super drawChart];
    [self _updateStyle];
}

- (void)_updateStyle {
    //    _kLineTitleLabel.backgroundColor = [UIColor redColor];
    //    _indexTitleLabel.backgroundColor = [UIColor yellowColor];
    
    CGRect frame = CGRectMake(1, 0, self.layout.topChartFrame.size.width, self.layout.topChartFrame.origin.y);
    _kLineTitleLabel.frame = frame;
    CGRect frame1 = self.layout.separatedFrame;
    frame1.origin.x = 1;
    _indexTitleLabel.frame = frame1;
    
//    self.crossLineView.lineColor = [UIColor redColor];
    
    _kLineTitleLabel.attributedText = [self attributedRefText];
    _indexTitleLabel.attributedText = [self VolAttributedRefText];
}

- (void)stockKLineChart:(TQKLineChart *)KLineChart didSingleTapInLocation:(CGPoint)location {
    NSLog(@"sdf");

}

- (void)stockKLineChart:(TQKLineChart *)KLineChart didLongPressAtCorrespondIndex:(NSInteger)index {
//    _kLineTitleLabel.attributedText = [self makeAttributedStringWithIndex:index];
}

- (NSAttributedString *)makeAttributedStringWithIndex:(NSInteger)index {
    id<TQKlineChartProtocol> currentObj = self.dataArray[index];
    NSString *datestring = nil;
    NSString *prefix = [NSString stringWithFormat:@"均价:%.2f", currentObj.tq_high];
    NSString *suffix = [NSString stringWithFormat:@"最新:%.2f %.2f %@", currentObj.tq_low, currentObj.tq_open, datestring];
    NSString *text = [NSString stringWithFormat:@"%@  %@", prefix, suffix];
    NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange textRange = [text rangeOfString:text];
    NSRange prefixRange = [text rangeOfString:prefix];
    NSRange suffixRange = [text rangeOfString:suffix];
    [attriText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Thonburi" size:11] range:textRange];
    [attriText addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:prefixRange];
    [attriText addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:suffixRange];
    return attriText;
}

- (void)dealloc {
    NSLog(@"%@~~~~~~dealloc!✈️",NSStringFromClass(self.class));
}

- (NSAttributedString *)attributedRefText {
    NSString *prefix = @"均线";
    NSString *textMA5 = @"MA5:2278.52";
    NSString *textMA10 = @"MA10:2278.52";
    NSString *textMA20 = @"MA20:2278.52";
    NSString *text = [NSString stringWithFormat:@"%@  %@   %@   %@", prefix, textMA5, textMA10, textMA20];
    NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attriText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:[text rangeOfString:text]];
    
    
    [attriText addAttribute:NSForegroundColorAttributeName value:[UIColor zh_colorWithHexString:@"CC0000"] range:[text rangeOfString:prefix]];
    [attriText addAttribute:NSForegroundColorAttributeName value:[UIColor zh_colorWithHexString:@"CC3333"] range:[text rangeOfString:textMA5]];
    [attriText addAttribute:NSForegroundColorAttributeName value:[UIColor zh_colorWithHexString:@"339966"]range:[text rangeOfString:textMA10]];
    [attriText addAttribute:NSForegroundColorAttributeName value:[UIColor zh_colorWithHexString:@"3333CC"] range:[text rangeOfString:textMA20]];
    
    return attriText.copy;
}

- (NSAttributedString *)VolAttributedRefText {
    NSString *prefix = @"成交量";
    NSString *textMA5 = @"12260507";
    NSString *text = [NSString stringWithFormat:@"%@  %@", prefix, textMA5];
    NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attriText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:[text rangeOfString:text]];
    [attriText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[text rangeOfString:prefix]];
    [attriText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:[text rangeOfString:textMA5]];
    [attriText addAttribute:NSForegroundColorAttributeName value:[UIColor zh_colorWithHexString:@"CC0000"] range:[text rangeOfString:text]];
    return attriText.copy;
}

@end
