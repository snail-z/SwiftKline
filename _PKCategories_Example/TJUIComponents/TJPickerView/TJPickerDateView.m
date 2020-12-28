//
//  TJPickerDateView.m
//  TJCategories_Example
//
//  Created by zhanghao on 2020/12/23.
//  Copyright © 2020 gren-beans. All rights reserved.
//

#import "TJPickerDateView.h"
#import "NSDate+PKExtend.h"

@interface TJPickerDateView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, strong) UIPickerView *pickerView;

@end

@implementation TJPickerDateView {
    struct {
        NSInteger year;
        NSInteger month;
        NSInteger day;
    } _pickerUnit;
}

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
    _pickerUnit.year = 0;
    _pickerUnit.month = 0;
    _pickerUnit.day = 0;
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
    id<TJPickerDataSource> item = _columnItems[component][row];
    switch (component) {
        case 0: { // year
            _pickerUnit.year = item.identifier;
            [self reloadDaysColumn:[self didSelectDate]];
        } break;
        case 1: { // month
            _pickerUnit.month = item.identifier;
            [self reloadDaysColumn:[self didSelectDate]];
        } break;
        case 2: { // day
            _pickerUnit.day = item.identifier;
        } break;
        default: break;
    }
    
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@", @(_pickerUnit.year), @(_pickerUnit.month), @(_pickerUnit.day)];
    NSDate *date = [NSDate pk_dateFromString:dateStr formatter:@"yyyy-MM-dd"];
    _selectedDate = date;
    
    if ([self.delegate respondsToSelector:@selector(pickerDateView:didSelectItem:)]) {
        [self.delegate pickerDateView:self didSelectItem:item];
    } else {
        if (self.didSelectItem) self.didSelectItem(self, item);
    }
}

- (NSDate *)didSelectDate {
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@", @(_pickerUnit.year), @(_pickerUnit.month)];
    return [NSDate pk_dateFromString:dateStr formatter:@"yyyy-MM"];
}

- (void)setColumnItems:(NSArray<NSArray<id<TJPickerDataSource>> *> *)columnItems {
    _columnItems = columnItems;
    [self reloadComponents:[NSDate date]];
}

- (void)reloadComponents:(NSDate *)date {
    if (!_columnItems) {
        _columnItems = [NSDate tj_yearsMonthsAndDays];
    }
    if (_columnItems.count < 1 || !date) return;
    [self reloadAllComponentsBy:date];
}

- (void)reloadAllComponentsBy:(NSDate *)date {
    NSArray *days = [NSDate tj_daysOfDate:date];
    NSMutableArray *temps = _columnItems.mutableCopy;
    [temps removeLastObject];
    [temps addObject:days];
    _columnItems = temps.copy;
    [_pickerView reloadAllComponents];

    _selectedDate = date;
    _pickerUnit.year = date.pk_year;
    _pickerUnit.month = date.pk_month;
    _pickerUnit.day = date.pk_day;
    
    NSArray<NSNumber *> *keys = @[@(_pickerUnit.year), @(_pickerUnit.month), @(_pickerUnit.day)];
    for (NSInteger column = 0; column < _columnItems.count; column++) { // 遍历每列
        NSArray<id<TJPickerDataSource>> *targets = _columnItems[column];
        for (NSInteger index = 0; index < targets.count; index++) {
            if (targets[index].identifier == keys[column].integerValue) { // 当前列需要选中的项
                [self.pickerView selectRow:index inComponent:column animated:YES];
                break;
            }
        }
    }
}

- (void)reloadDaysColumn:(NSDate *)date {
    NSArray<id<TJPickerDataSource>> *days = [NSDate tj_daysOfDate:date];
    NSMutableArray *temps = _columnItems.mutableCopy;
    [temps removeLastObject];
    [temps addObject:days];
    _columnItems = temps.copy;
    
    __block NSInteger index = days.count - 1;
    [days enumerateObjectsUsingBlock:^(id<TJPickerDataSource> obj, NSUInteger idx, BOOL *stop) {
        if (obj.identifier == _pickerUnit.day) {
            index = idx;
            *stop = YES;
        }
    }];
    _pickerUnit.day = days[index].identifier;
    [_pickerView reloadComponent:2];
}

@end
