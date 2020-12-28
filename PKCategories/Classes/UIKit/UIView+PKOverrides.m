//
//  UIView+PKOverrides.m
//  PKCategories
//
//  Created by zhanghao on 2020/9/17.
//

#import "UIView+PKOverrides.h"

// MARK: - PKUIButton

const UIControlContentHorizontalAlignment UIControlContentHorizontalAlignmentEachEnd = UIControlContentHorizontalAlignmentFill;
const UIControlContentVerticalAlignment UIControlContentVerticalAlignmentEachEnd = UIControlContentVerticalAlignmentFill;

static CGFloat HorizontalInsets(UIEdgeInsets inset) {
    return (inset.left + inset.right);
}

static CGFloat VerticalInsets(UIEdgeInsets inset) {
    return inset.top + inset.bottom;
}

static CGRect MakeRect(CGFloat x, CGFloat y, CGSize size) {
    return CGRectMake(x, y, size.width, size.height);
}

@implementation PKUIButton

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self defaultValues];
    }
    return self;
}

- (void)defaultValues {
    _imagePosition = PKUIButtonImagePositionLeft;
    _imageAndTitleSpacing = 10;
    _adjustsRoundedCornersAutomatically = NO;
}

- (void)setImagePosition:(PKUIButtonImagePosition)imagePosition {
    _imagePosition = imagePosition;
    [self setNeedsLayout];
}

- (void)setImageAndTitleSpacing:(CGFloat)imageAndTitleSpacing {
    _imageAndTitleSpacing = imageAndTitleSpacing;
    [self setNeedsLayout];
}

- (void)setImageSpecifiedSize:(CGSize)imageSpecifiedSize {
    _imageSpecifiedSize = imageSpecifiedSize;
    [self setNeedsLayout];
}

- (void)setAdjustsRoundedCornersAutomatically:(BOOL)adjustsRoundedCornersAutomatically {
    _adjustsRoundedCornersAutomatically = adjustsRoundedCornersAutomatically;
    [self setNeedsLayout];
}

- (void)sizeToFit {
    [super sizeToFit];
    CGRect _frame = self.frame;
    _frame.size = [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    self.frame = _frame;
}

- (CGSize)sizeThatFits:(CGSize)size {
    [super sizeThatFits:size];
    CGSize _size = [self intrinsicContentSize];
    return CGSizeMake(MIN(_size.width, size.width), MIN(_size.height, size.height));
}

- (CGSize)intrinsicContentSize {
    if ([self isImageValid] || [self isTitleValid]) {
        CGSize titleSize = [self getValidTitleSize];
        CGSize imageSize = [self getValidImageSize];
        CGFloat spacing = [self getValidSpacing];
        CGSize contentSize = CGSizeZero;
        switch (_imagePosition) {
            case PKUIButtonImagePositionTop:
            case PKUIButtonImagePositionBottom: {
                CGFloat height = titleSize.height + imageSize.height + spacing;
                CGFloat width = MAX(titleSize.width, imageSize.width);
                contentSize = CGSizeMake(width, height);
            } break;
                
            case PKUIButtonImagePositionLeft:
            case PKUIButtonImagePositionRight: {
                CGFloat width = titleSize.width + imageSize.width + spacing;
                CGFloat height = MAX(titleSize.height, imageSize.height);
                contentSize = CGSizeMake(width, height);
            } break;
            default: break;
        }
        contentSize.height += VerticalInsets(self.contentEdgeInsets);
        contentSize.width += HorizontalInsets(self.contentEdgeInsets);
        return contentSize;
    }
    return CGSizeZero;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    if (_adjustsRoundedCornersAutomatically) {
        layer.cornerRadius = self.bounds.size.height / 2;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (CGRectEqualToRect(CGRectZero, self.bounds)) return;
    
    if (![self isImageValid] && ![self isTitleValid]) return;
    
    CGSize titleSize = [self getValidTitleSize];
    CGSize imageSize = [self getValidImageSize];
    CGFloat spacing = [self getValidSpacing];
    CGFloat boundsWidth = self.bounds.size.width;
    CGFloat boundsHeight = self.bounds.size.height;
    UIEdgeInsets inset = self.contentEdgeInsets;
    
    switch (_imagePosition) {
        case PKUIButtonImagePositionTop: {
            CGFloat contentHeight = imageSize.height + titleSize.height + spacing;
            if (contentHeight > boundsHeight) {
                titleSize.height = boundsHeight - imageSize.height - spacing;
                contentHeight = boundsHeight;
            }
            CGFloat padding = [self verticalTopWithHeight:contentHeight];
            CGFloat imageX = (boundsWidth - HorizontalInsets(inset) - imageSize.width) / 2 + inset.left;
            CGFloat titleX = (boundsWidth - HorizontalInsets(inset) - titleSize.width) / 2 + inset.left;
            self.imageView.frame = MakeRect(imageX, padding, imageSize);
            CGFloat maxY = CGRectGetMaxY(self.imageView.frame) + spacing;
            CGFloat titleY = [self anotherTopWithHeight:titleSize.height originY:maxY];
            self.titleLabel.frame = MakeRect(titleX, titleY, titleSize);
        } break;
            
        case PKUIButtonImagePositionLeft: {
            CGFloat contentWidth = titleSize.width + imageSize.width + spacing;
            if (contentWidth > boundsWidth) {
                titleSize.width = boundsWidth - imageSize.width - spacing;
                contentWidth = boundsWidth;
            }
            CGFloat padding = [self horizontalLeftWithWidth:contentWidth];
            CGFloat imageY = (boundsHeight - VerticalInsets(inset) - imageSize.height) / 2 + inset.top;
            CGFloat titleY = (boundsHeight - VerticalInsets(inset) - titleSize.height) / 2 + inset.top;
            self.imageView.frame = MakeRect(padding, imageY, imageSize);
            CGFloat maxX = CGRectGetMaxX(self.imageView.frame) + spacing;
            CGFloat titleX = [self anotherLeftWithWidth:titleSize.width originX:maxX];
            self.titleLabel.frame = MakeRect(titleX, titleY, titleSize);
        } break;
            
        case PKUIButtonImagePositionBottom: {
            CGFloat contentHeight = imageSize.height + titleSize.height + spacing;
            if (contentHeight > boundsHeight) {
                titleSize.height = boundsHeight - imageSize.height - spacing;
                contentHeight = boundsHeight;
            }
            CGFloat padding = [self verticalTopWithHeight:contentHeight];
            CGFloat imageX = (boundsWidth - HorizontalInsets(inset) - imageSize.width) / 2 + inset.left;
            CGFloat titleX = (boundsWidth - HorizontalInsets(inset) - titleSize.width) / 2 + inset.left;
            self.titleLabel.frame = MakeRect(titleX, padding, titleSize);
            CGFloat maxY = CGRectGetMaxY(self.titleLabel.frame) + spacing;
            CGFloat imageY = [self anotherTopWithHeight:imageSize.height originY:maxY];
            self.imageView.frame = MakeRect(imageX, imageY, imageSize);
        } break;
            
        case PKUIButtonImagePositionRight: {
            CGFloat contentWidth = titleSize.width + imageSize.width + spacing;
            if (contentWidth > boundsWidth) {
                titleSize.width = boundsWidth - imageSize.width - spacing;
                contentWidth = boundsWidth;
            }
            CGFloat padding = [self horizontalLeftWithWidth:contentWidth];
            CGFloat imageY = (boundsHeight - VerticalInsets(inset) - imageSize.height) / 2 + inset.top;
            CGFloat titleY = (boundsHeight - VerticalInsets(inset) - titleSize.height) / 2 + inset.top;
            self.titleLabel.frame = MakeRect(padding, titleY, titleSize);
            CGFloat maxX = CGRectGetMaxX(self.titleLabel.frame) + spacing;
            CGFloat imageX = [self anotherLeftWithWidth:imageSize.width originX:maxX];
            self.imageView.frame = MakeRect(imageX, imageY, imageSize);
        } break;
        default: break;
    }
}

- (CGFloat)horizontalLeftWithWidth:(CGFloat)width {
    switch (self.contentHorizontalAlignment) {
        case UIControlContentHorizontalAlignmentLeft:
            return self.contentEdgeInsets.left;
        case UIControlContentHorizontalAlignmentRight:
            return self.bounds.size.width - self.contentEdgeInsets.right - width;
        case UIControlContentHorizontalAlignmentEachEnd:
            return self.contentEdgeInsets.left;
        default: { /// 其他类型均视为UIControlContentHorizontalAlignmentCenter
            CGFloat horizontal = self.contentEdgeInsets.left + self.contentEdgeInsets.right;
            return (self.bounds.size.width - horizontal - width) / 2 + self.contentEdgeInsets.left;
        }
    }
}

- (CGFloat)anotherLeftWithWidth:(CGFloat)width originX:(CGFloat)originX {
    switch (self.contentHorizontalAlignment) {
        case UIControlContentHorizontalAlignmentEachEnd:
            return self.bounds.size.width - width - self.contentEdgeInsets.right;
        default:
            return originX;
    }
}

- (CGFloat)verticalTopWithHeight:(CGFloat)height {
    switch (self.contentVerticalAlignment) {
        case UIControlContentVerticalAlignmentTop:
            return self.contentEdgeInsets.top;
        case UIControlContentVerticalAlignmentBottom:
            return self.bounds.size.height - self.contentEdgeInsets.bottom - height;
        case UIControlContentVerticalAlignmentEachEnd:
            return self.contentEdgeInsets.top;
        default: { /// 其他类型均视为UIControlContentVerticalAlignmentCenter
            CGFloat vertical = self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
            return (self.bounds.size.height - vertical - height) / 2 + self.contentEdgeInsets.top;
        }
    }
}

- (CGFloat)anotherTopWithHeight:(CGFloat)height originY:(CGFloat)originY {
    switch (self.contentVerticalAlignment) {
        case UIControlContentVerticalAlignmentEachEnd:
            return self.bounds.size.height - height - self.contentEdgeInsets.bottom;
        default:
            return originY;
    }
}

- (BOOL)isImageValid {
    return self.currentImage != nil;
}

- (BOOL)isTitleValid {
    return (self.currentTitle != nil || self.currentAttributedTitle != nil);
}

- (CGSize)getValidTitleSize {
    if ([self isTitleValid]) {
        return self.titleLabel.intrinsicContentSize;
    }
    return CGSizeZero;
}

- (CGSize)getValidImageSize {
    if ([self isImageValid]) {
        if (_imageSpecifiedSize.width > 0 && _imageSpecifiedSize.height > 0) {
            return _imageSpecifiedSize;
        } else {
            return self.currentImage.size;
        }
    }
    return CGSizeZero;
}

- (CGFloat)getValidSpacing {
    if ([self isImageValid] && [self isTitleValid]) {
        return _imageAndTitleSpacing;
    }
    return 0;
}

@end


// MARK: - PKUITextField

const NSUInteger UIControlEventDeleteBackward = 2001;

@implementation PKUITextField

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self defaultValues];
    }
    return self;
}

- (void)defaultValues {
    _leftViewPadding = 0;
    _rightViewPadding = 0;
    _clearButtonPadding = 0;
    _textEdgeInsets = UIEdgeInsetsZero;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect leftRect = [super leftViewRectForBounds:bounds];
    leftRect.origin.x += self.leftViewPadding;
    return leftRect;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    CGRect rightRect = [super rightViewRectForBounds:bounds];
    rightRect.origin.x -= self.rightViewPadding;
    return rightRect;
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    CGRect clearRect = [super clearButtonRectForBounds:bounds];
    clearRect.origin.x = bounds.size.width - clearRect.size.width - self.clearButtonPadding;
    return clearRect;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return [self _inputRectForBounds:bounds modes:@[@(UITextFieldViewModeAlways)]];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self _inputRectForBounds:bounds modes:@[@(UITextFieldViewModeAlways),
                                                    @(UITextFieldViewModeWhileEditing)]];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    if (self.isEditing) {
        return [self textRectForBounds:bounds];
    }
    return [self editingRectForBounds:bounds];
}

/// modes: [UITextFieldViewModeWhileEditing, UITextFieldViewModeAlways]
- (CGRect)_inputRectForBounds:(CGRect)bounds modes:(NSArray<NSNumber *> *)modes {
    UIEdgeInsets insets = self.textEdgeInsets;
    
    if (self.leftView && [modes containsObject:@(self.leftViewMode)]) {
        insets.left += CGRectGetMaxX([self leftViewRectForBounds:bounds]);
    }
    
    if (self.rightView && [modes containsObject:@(self.rightViewMode)]) {
        insets.right += (bounds.size.width - CGRectGetMinX([self rightViewRectForBounds:bounds]));
    } else {
        if ([modes containsObject:@(self.clearButtonMode)]) {
            insets.right += (bounds.size.width - CGRectGetMinX([self clearButtonRectForBounds:bounds]));
        }
    }
    
    return UIEdgeInsetsInsetRect(bounds, insets);
}

- (void)deleteBackward {
    [super deleteBackward];
    [self sendActionsForControlEvents:UIControlEventDeleteBackward];
}

@end
