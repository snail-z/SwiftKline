//
//  UIView+PKHud.m
//  PKCategories
//
//  Created by corgi on 2020/6/23.
//

#import "UIView+PKHud.h"
#import "UIScreen+PKExtend.h"
#import <objc/runtime.h>

@implementation PKHudStyle

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static PKHudStyle *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[PKHudStyle alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self defaultValues];
    }
    return self;
}

- (void)defaultValues {
    _backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    _messageColor = [UIColor whiteColor];
    _imageColor = [UIColor whiteColor];
    _messageFont = [UIFont systemFontOfSize:15];
    _messageAlignment = NSTextAlignmentLeft;
    _messageNumberOfLines = 0;
    _messageLayoutMaxWidth = 180;
    _messageLayoutMaxHeight = 400;
    _imageSize = CGSizeMake(20, 20);
    _fadeDuration = 0;
    _cornerRadius = 2;
    _lineSpacing = 10;
    _paddingInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    _positionOffset = 0;
}

@end


@implementation UIView (PKHud)

- (void)pk_showHudText:(NSString *)message {
    return [self _messageHud:message position:PKHudPositionCenter style:PKHudStyle.sharedInstance];
}

- (void)pk_showHudText:(NSString *)message position:(PKHudPosition)position style:(PKHudStyle *)style {
    return [self _messageHud:message position:position style:style];
}

- (void)pk_showHudImage:(UIImage *)image {
    return [self _imageHud:image spin:NO position:PKHudPositionCenter style:PKHudStyle.sharedInstance];
}

- (void)pk_showHudImage:(UIImage *)image spin:(BOOL)isSpin {
    return [self _imageHud:image spin:isSpin position:PKHudPositionCenter style:PKHudStyle.sharedInstance];
}

- (void)showHudImage:(UIImage *)image spin:(BOOL)isSpin
            position:(PKHudPosition)position
               style:(PKHudStyle *)style {
    return [self _imageHud:image spin:isSpin position:position style:style];
}

- (void)pk_showHud:(NSString *)message image:(UIImage *)image {
    return [self _perfectHud:message image:image spin:NO
                      layout:PKHudLayoutLeft
                    position:PKHudPositionCenter
                       style:PKHudStyle.sharedInstance];
}

- (void)pk_showHud:(NSString *)message image:(UIImage *)image spin:(BOOL)isSpin {
    return [self _perfectHud:message image:image spin:isSpin
                      layout:PKHudLayoutLeft
                    position:PKHudPositionCenter
                       style:PKHudStyle.sharedInstance];
}

- (void)pk_showHud:(NSString *)message image:(UIImage *)image layout:(PKHudLayout)layout {
    return [self _perfectHud:message image:image spin:NO
                      layout:layout
                    position:PKHudPositionCenter
                       style:PKHudStyle.sharedInstance];
}

- (void)pk_showHud:(NSString *)message
             image:(UIImage *)image
              spin:(BOOL)isSpin
            layout:(PKHudLayout)layout {
    return [self _perfectHud:message image:image spin:isSpin
                      layout:layout
                    position:PKHudPositionCenter
                       style:PKHudStyle.sharedInstance];
}

- (void)pk_showHud:(NSString *)message
             image:(UIImage *)image
              spin:(BOOL)isSpin
            layout:(PKHudLayout)layout
          position:(PKHudPosition)position
             style:(PKHudStyle *)style {
    return [self _perfectHud:message image:image spin:isSpin
                      layout:layout position:position style:style];
}

- (void)pk_hideHud {
    if (self.pk_activeHuds.count > 0) {
        return [self _hideHud:self.pk_activeHuds.firstObject];
    }
}

- (void)pk_hideAllHuds {
    for (UIView *hud in self.pk_activeHuds) {
        [self _hideHud:hud];
    }
}

- (void)_messageHud:(NSString *)message
           position:(PKHudPosition)position
              style:(PKHudStyle *)style {
    UILabel *label = [UILabel new];
    label.text = message;
    label.font = style.messageFont;
    label.textColor = style.messageColor;
    label.numberOfLines = style.messageNumberOfLines;
    label.textAlignment = style.messageAlignment;
    CGSize size = [label sizeThatFits:CGSizeMake(style.messageLayoutMaxWidth, CGFLOAT_MAX)];
    size.height = MIN(size.height, style.messageLayoutMaxHeight);
    CGFloat scale = [UIScreen mainScreen].scale;
    size = CGSizeMake(ceil(size.width * scale) / scale, ceil(size.height * scale) / scale);
    label.frame = CGRectMake(0, 0, size.width, size.height);
    
    UIView *hud = [UIView new];
    hud.backgroundColor = style.backgroundColor;
    hud.clipsToBounds = true;
    hud.layer.cornerRadius = style.cornerRadius;
    UIEdgeInsets insets = style.paddingInsets;
    hud.frame = (CGRect){.size = CGSizeMake(size.width + insets.left + insets.right,
                                            size.height + insets.top + insets.bottom)};
    label.center = CGPointMake(hud.bounds.size.width / 2, hud.bounds.size.height / 2);
    [hud addSubview:label];
    [self addSubview:hud];
    [self.pk_activeHuds addObject:hud];
    
    hud.alpha = 0;
    [UIView animateWithDuration:style.fadeDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        hud.alpha = 1;
    } completion:NULL];
    
    [self _adjustHud:hud position:position offset:style.positionOffset];
}

- (void)_imageHud:(UIImage *)image
             spin:(BOOL)isSpin
         position:(PKHudPosition)position
            style:(PKHudStyle *)style {
    UIImageView *imgView = [UIImageView new];
    if (style.imageColor) {
        imgView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        imgView.tintColor = style.imageColor;
    } else {
        imgView.image = image;
    }
    CGSize size = style.imageSize;
    imgView.frame = CGRectMake(0, 0, size.width, size.height);
    
    UIView *hud = [UIView new];
    hud.backgroundColor = style.backgroundColor;
    hud.clipsToBounds = true;
    hud.layer.cornerRadius = style.cornerRadius;
    UIEdgeInsets insets = style.paddingInsets;
    hud.frame = (CGRect){.size = CGSizeMake(size.width + insets.left + insets.right,
                                            size.height + insets.top + insets.bottom)};
    imgView.center = CGPointMake(hud.bounds.size.width / 2, hud.bounds.size.height / 2);
    [hud addSubview:imgView];
    [self addSubview:hud];
    [self.pk_activeHuds addObject:hud];
    
    if (isSpin) {
        [self _spinView:imgView];
    }
    
    hud.alpha = 0;
    [UIView animateWithDuration:style.fadeDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        hud.alpha = 1;
    } completion:NULL];
    
    [self _adjustHud:hud position:position offset:style.positionOffset];
}

- (void)_perfectHud:(NSString *)message
              image:(UIImage *)image
               spin:(BOOL)isSpin
             layout:(PKHudLayout)layout
           position:(PKHudPosition)position
              style:(PKHudStyle *)style {
    UILabel *label = [UILabel new];
    label.text = message;
    label.font = style.messageFont;
    label.textColor = style.messageColor;
    label.numberOfLines = style.messageNumberOfLines;
    label.textAlignment = style.messageAlignment;
    CGSize size = [label sizeThatFits:CGSizeMake(style.messageLayoutMaxWidth, CGFLOAT_MAX)];
    size.height = MIN(size.height, style.messageLayoutMaxHeight);
    CGFloat scale = [UIScreen mainScreen].scale;
    size = CGSizeMake(ceil(size.width * scale) / scale, ceil(size.height * scale) / scale);
    label.frame = CGRectMake(0, 0, size.width, size.height);
    
    UIImageView *imgView = [UIImageView new];
    imgView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imgView.tintColor = style.imageColor;
    imgView.frame = CGRectMake(0, 0, style.imageSize.width, style.imageSize.height);
    
    UIView *hud = [UIView new];
    hud.backgroundColor = style.backgroundColor;
    hud.clipsToBounds = true;
    hud.layer.cornerRadius = style.cornerRadius;
    [hud addSubview:label];
    [hud addSubview:imgView];
    [self addSubview:hud];
    [self.pk_activeHuds addObject:hud];
    
    if (isSpin) {
        [self _spinView:imgView];
    }
    
    hud.alpha = 0;
    [UIView animateWithDuration:style.fadeDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        hud.alpha = 1;
    } completion:NULL];
    
    UIEdgeInsets insets = style.paddingInsets;
    CGFloat lineSpacing = style.lineSpacing;
    CGSize imgSize = imgView.bounds.size;
    CGSize labSize = label.bounds.size;
    
    switch (layout) {
        case PKHudLayoutTop: {
            CGFloat hudWidth = MAX(imgSize.width, labSize.width) + insets.left + insets.right;
            CGFloat hudHeight = imgSize.height + labSize.height + lineSpacing + insets.top + insets.bottom;
            hud.frame = (CGRect){.size = CGSizeMake(hudWidth, hudHeight)};
            imgView.center = CGPointMake(hudWidth / 2, insets.top + imgSize.height / 2);
            label.center = CGPointMake(hudWidth / 2, hudHeight - insets.bottom - labSize.height / 2);
        } break;
        case PKHudLayoutLeft: {
            CGFloat hudWidth = imgSize.width + labSize.width + lineSpacing + insets.left + insets.right;
            CGFloat hudHeight = MAX(imgSize.height, labSize.height) + insets.top + insets.bottom;
            hud.frame = (CGRect){.size = CGSizeMake(hudWidth, hudHeight)};
            imgView.center = CGPointMake(insets.left + imgSize.width / 2, hudHeight / 2);
            label.center = CGPointMake(hudWidth - insets.right - labSize.width / 2, hudHeight / 2);
        } break;
        case PKHudLayoutBottom: {
            CGFloat hudWidth = MAX(imgSize.width, labSize.width) + insets.left + insets.right;
            CGFloat hudHeight = imgSize.height + labSize.height + lineSpacing + insets.top + insets.bottom;
            hud.frame = (CGRect){.size = CGSizeMake(hudWidth, hudHeight)};
            label.center = CGPointMake(hudWidth / 2, insets.top + labSize.height / 2);
            imgView.center = CGPointMake(hudWidth / 2, hudHeight - insets.bottom - imgSize.height / 2);
        } break;
        case PKHudLayoutRight: {
            CGFloat hudWidth = imgSize.width + labSize.width + lineSpacing + insets.left + insets.right;
            CGFloat hudHeight = MAX(imgSize.height, labSize.height) + insets.top + insets.bottom;
            hud.frame = (CGRect){.size = CGSizeMake(hudWidth, hudHeight)};
            label.center = CGPointMake(insets.left + labSize.width / 2, hudHeight / 2);
            imgView.center = CGPointMake(hudWidth - insets.right - imgSize.width / 2, hudHeight / 2);
        } break;
        default: break;
    }
    
    [self _adjustHud:hud position:position offset:style.positionOffset];
}

- (void)_adjustHud:(UIView *)hud position:(PKHudPosition)position offset:(CGFloat)offset {
    UIEdgeInsets safe = [UIScreen pk_safeInsets];
    switch (position) {
        case PKHudPositionTop:
            hud.center = CGPointMake(self.bounds.size.width / 2,
                                     hud.bounds.size.height / 2 + safe.top + offset);
            break;
        case PKHudPositionCenter:
            hud.center = CGPointMake(self.bounds.size.width / 2,
                                     self.bounds.size.height / 2 + offset);
            break;
        case PKHudPositionBottom:
            hud.center = CGPointMake(self.bounds.size.width / 2,
                                     self.bounds.size.height - safe.bottom - hud.bounds.size.height / 2 + offset);
            break;
        default: break;
    }
}

- (void)_hideHud:(UIView *)hud {
    if ([self.pk_activeHuds containsObject:hud]) {
        [UIView animateWithDuration:PKHudStyle.sharedInstance.fadeDuration delay:0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
            hud.alpha = 0;
        } completion:^(BOOL finished) {
            [hud removeFromSuperview];
            [self.pk_activeHuds removeObject:hud];
        }];
    }
}

- (void)_spinView:(UIView *)aView {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @0;
    animation.toValue = @(M_PI * 2);
    animation.duration = 0.75;
    animation.repeatCount = INFINITY;
    animation.removedOnCompletion = false;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [aView.layer addAnimation:animation forKey:@"_pkHud.anim.spin"];
}

- (NSMutableArray<UIView *> *)pk_activeHuds {
    NSMutableArray *huds = objc_getAssociatedObject(self, _cmd);
    if (!huds) {
        huds = @[].mutableCopy;
        objc_setAssociatedObject(self, _cmd, huds, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return huds;
}

@end
