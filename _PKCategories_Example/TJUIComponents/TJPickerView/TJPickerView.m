//
//  TJPickerView.m
//  TJCategories_Example
//
//  Created by zhanghao on 2020/12/22.
//  Copyright © 2020 gren-beans. All rights reserved.
//

#import "TJPickerView.h"

@interface TJPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, strong) UIPickerView *pickerView;
@property(nonatomic, strong) NSMutableArray<id<TJPickerDataSource>> *currentSelectedItems;

@end

@implementation TJPickerView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self defaultInitialization];
        [self subviewInitialization];
    }
    return self;
}

- (void)defaultInitialization {
    _currentSelectedItems = @[].mutableCopy;
    _rowHeight = 44;
    _textFont = [UIFont systemFontOfSize:17];
    _textColor = [UIColor blackColor];
    _separatorColor = [UIColor lightGrayColor];
}

- (void)subviewInitialization {
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [self addSubview:_pickerView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _pickerView.frame = self.bounds;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _columnItems.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _columnItems[component].count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return _rowHeight;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    for (UIView *line in pickerView.subviews) {
        if (line.bounds.size.height > 1) continue;
        line.backgroundColor = self.separatorColor;
    }
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = self.textColor;
    label.font = self.textFont;
    label.text = _columnItems[component][row].text;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [_currentSelectedItems removeObjectAtIndex:component];
    [_currentSelectedItems insertObject:_columnItems[component][row] atIndex:component];
    if ([self.delegate respondsToSelector:@selector(pickerView:didSelectItem:)]) {
        [self.delegate pickerView:self didSelectItem:_columnItems[component][row]];
    } else {
        if (self.didSelectItem) self.didSelectItem(self, _columnItems[component][row]);
    }
}

- (NSArray<id<TJPickerDataSource>> *)selectedItems {
    return _currentSelectedItems.copy;
}

- (void)setRowHeight:(CGFloat)rowHeight {
    _rowHeight = rowHeight;
    [_pickerView reloadAllComponents];
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    [_pickerView reloadAllComponents];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [_pickerView reloadAllComponents];
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    _separatorColor = separatorColor;
    [_pickerView reloadAllComponents];
}

- (void)setOneColumnItems:(NSArray<id<TJPickerDataSource>> *)oneColumnItems {
    _oneColumnItems = oneColumnItems;
    [self setColumnItems:@[oneColumnItems]];
}

- (void)setColumnItems:(NSArray<NSArray<id<TJPickerDataSource>> *> *)columnItems {
    _columnItems = columnItems;
    [_pickerView reloadAllComponents];
    [self setDefaultSelected];
}

- (void)setDefaultSelected {
    if (_columnItems.lastObject.count < 1) return;
    NSMutableArray *selectIdentifiers = @[].mutableCopy;
    for (NSArray<id<TJPickerDataSource>> *items in _columnItems) {
        [selectIdentifiers addObject:@(items.firstObject.identifier)];
    }
    [self setSelectIdentifiers:selectIdentifiers];
}

- (void)updateItems:(NSArray<id<TJPickerDataSource>> *)items inColumn:(NSInteger)column {
    if (column < _columnItems.count) {
        NSMutableArray *temps = _columnItems.mutableCopy;
        [temps replaceObjectAtIndex:column withObject:items];
        _columnItems = temps.copy;
        [_pickerView reloadComponent:column];
    }
}

- (void)setSelectItems:(NSArray<id<TJPickerDataSource>> *)items {
    [_currentSelectedItems removeAllObjects];
    for (NSInteger column = 0; column < items.count; column++) { // 遍历每列
        NSArray<id<TJPickerDataSource>> *targets = _columnItems[column];
        for (NSInteger index = 0; index < targets.count; index++) {
            if (items[column].identifier == targets[index].identifier) { // 当前列需要选中的项
                [self.pickerView selectRow:index inComponent:column animated:YES];
                [_currentSelectedItems addObject:targets[index]];
                break;
            }
        }
    }
}

- (void)setSelectIdentifiers:(NSArray<NSNumber *> *)identifiers {
    [_currentSelectedItems removeAllObjects];
    for (NSInteger column = 0; column < identifiers.count; column++) {
        NSArray<id<TJPickerDataSource>> *targets = _columnItems[column];
        for (NSInteger index = 0; index < targets.count; index++) {
            if (identifiers[column].integerValue == targets[index].identifier) {
                [self.pickerView selectRow:index inComponent:column animated:YES];
                [_currentSelectedItems addObject:targets[index]];
                break;
            }
        }
    }
}

@end
