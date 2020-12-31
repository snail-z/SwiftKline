
//
//  PKNextViewController.m
//  PKCategories_Example
//
//  Created by zhanghao on 2018/12/12.
//  Copyright © 2018年 gren-beans. All rights reserved.
//

#import "PKNextViewController.h"
#import <PKCategories/PKCategories.h>
#import "MyCollectionViewCell.h"
#import "TJProgressView.h"
#import "TJProgressLayer.h"
#import "TJPickerView.h"
#import "TJPickerDateView.h"
#import "NSDate+PKExtend.h"
#import "TJStarRateView.h"
#import "TJPageController.h"
#import "Demo1ViewController.h"
#import "Demo2ViewController.h"
#import "Demo3ViewController.h"
#import "Demo4ViewController.h"
#import "Demo5ViewController.h"
#import "PKSegmentedSlideControl.h"

@interface PKNextViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource, TJPickerViewDelegate, TJPickerDateViewDelegate, TJPageControllerDataSource, TJPageControllerDelegate>

@property(nonatomic, strong) PKSegmentedSlideControl *slideControl;
@property(nonatomic, strong) TJPageController *pageController;
@property(nonatomic, strong) NSMutableArray<UIViewController *> *allControllers;

@end

@implementation PKNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self example1];
//    [self example2];
//    [self example3];
//    [self example4];
//    [self example5];
    
//    [self UIAlertControllerTest];
//    [self UIApplicationTest];
//    [self UICollectionViewTest];
    
//    [self UIFontTest];
//    [self UILabelTest];
//    [self UITableViewTest];
//    [self PKUIButtonTest];
    
    
//    [self progreeTest];
//    [self pickerTest];
//    [self pickerDateTest];
//    [self fiveStarTest];
    
    _pageController = [TJPageController new];
    _pageController.dataSource = self;
    _pageController.delegate = self;
    [self addChildViewController:_pageController];
    [self.view addSubview:_pageController.view];
    _pageController.view.frame = CGRectMake(10, 160, self.view.bounds.size.width-20, 300);
    [_pageController didMoveToParentViewController:self];
    
    Demo1ViewController *vc1 = [Demo1ViewController new];
    Demo2ViewController *vc2 = [Demo2ViewController new];
    Demo3ViewController *vc3 = [Demo3ViewController new];
    Demo4ViewController *vc4 = [Demo4ViewController new];
    Demo5ViewController *vc5 = [Demo5ViewController new];
    _allControllers = [NSMutableArray array];
    [_allControllers addObject:vc1];
    [_allControllers addObject:vc2];
    [_allControllers addObject:vc3];
    [_allControllers addObject:vc4];
    [_allControllers addObject:vc5];
    [_pageController setCurrentIndex:2 animated:NO];
    
    NSArray *titles = @[@"Believer", @"Natural", @"The Ocean", @"Friends", @"Wolves"];
    self.slideControl = [[PKSegmentedSlideControl alloc] initWithTitles:titles];
    self.slideControl.frame = CGRectMake(10, 100, self.view.bounds.size.width-20, 50);
    self.slideControl.normalTextColor = [UIColor blackColor];
    self.slideControl.selectedTextColor = [UIColor pk_colorWithRed:223 green:80 blue:50];
    self.slideControl.backgroundColor = [UIColor whiteColor];
    self.slideControl.plainTextFont =  [UIFont boldSystemFontOfSize:20];
    self.slideControl.indicatorLineWidth = 4;
    self.slideControl.paddingInset = 20;
    self.slideControl.innerSpacing = 20;
    self.slideControl.allowBounces = NO;
    self.slideControl.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
    self.slideControl.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
    [self.slideControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slideControl];
    [self.slideControl setWithIndex:2 animated:NO];
}

- (NSInteger)numberOfPagesInPageController:(TJPageController *)pageController {
    return _allControllers.count;
}

-(UIViewController *)pageController:(TJPageController *)pageController pageAtIndex:(NSInteger)index {
    return _allControllers[index];
}

- (void)pageControllerWillStartTransition:(TJPageController *)pageController {
    NSLog(@"pageControllerWillStartTransition");
    
}

- (void)pageController:(TJPageController *)pageController didUpdateTransition:(CGFloat)progress {
    NSLog(@"progress is: %@", @(progress));
    [self.slideControl updateWithProgress:progress];
}

- (void)pageControllerDidEndTransition:(TJPageController *)pageController {
    NSLog(@"pageControllerDidEndTransition");
}

- (void)valueChanged:(PKSegmentedSlideControl *)sender {
    NSLog(@"The selected index is: %@", @(sender.index));
    [_pageController setCurrentIndex:sender.index animated:NO];
}

#pragma mark - Test

- (void)fiveStarTest {
    TJStarRateView *view = [[TJStarRateView alloc] initWithItemCount:7];
    view.frame = CGRectMake(10, 100, 380, 50);
    view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.25];
    [self.view addSubview:view];
    view.uncheckedImage = [UIImage imageNamed:@"game_evaluate_gray"];
    view.checkedImage = [UIImage imageNamed:@"star_red"];
    view.itemSize = CGSizeMake(40, 40);
    view.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    view.maxScore = 50;
    view.defaultScore = 0;
    view.didScoreChanged = ^(TJStarRateView * _Nonnull sender, float currentScore) {
        NSLog(@"currentScore is: %@", @(currentScore));
    };
}

- (void)pickerDateTest {
    TJPickerDateView *pickerView = [TJPickerDateView new];
    pickerView.delegate = self;
    pickerView.frame = CGRectMake(20, 100, 350, 200);
    pickerView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.25];
    [self.view addSubview:pickerView];
    [pickerView reloadComponents:[NSDate date]];
}

- (void)pickerDateView:(TJPickerDateView *)sender didSelectItem:(id<TJPickerDataSource>)item {
    NSLog(@"日期is: %@", [NSDate pk_stringFromDate:sender.selectedDate formatter:@"yyyy-MM-dd"]);
}

- (void)pickerTest {
    TJPickerView *aview = [TJPickerView new];
    aview.delegate = self;
    aview.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    aview.frame = CGRectMake(20, 100, 370, 200);
    [self.view addSubview:aview];
    
    TJPickerItem *item1 = [TJPickerItem itemWithText:@"东方红" identifier:1];
    TJPickerItem *item2 = [TJPickerItem itemWithText:@"A" identifier:2];
    TJPickerItem *item3 = [TJPickerItem itemWithText:@"BC" identifier:3];
    TJPickerItem *item5 = [TJPickerItem itemWithText:@"UYD" identifier:4];
    aview.columnItems = @[@[item5, item2, item3, item1], @[item1, item2, item3]];
    
    aview.oneColumnItems = @[item1, item2, item3];
//    [aview needSelectedItems:@[item3, item1]];
    
//    [aview needSelectedIdentifiers:@[@2, @4]];
    
//    [aview setSelectIdentifiers:@[@2, @3]];
    
    aview.didSelectItem = ^(TJPickerView * _Nonnull pickerView, id<TJPickerDataSource>  _Nonnull item) {
        NSLog(@"item.text==> %@", item.text);
        
        NSLog(@"pickerView.selectedItems==> %@", pickerView.selectedItems);
    };
    
    [aview setSelectItems:@[item3, item2]];
    
    NSLog(@"hahi 结果is： %@", aview.selectedItems);
    
    
}


- (void)pickerView:(TJPickerView *)pickerView didSelectItem:(id<TJPickerDataSource>)item {
    NSLog(@"delegate ==> item.text==> %@", item.text);
    NSLog(@"delegate ==> pickerView.selectedItems==> %@", pickerView.selectedItems);
}




- (void)progreeTest {
    TJProgressBarView *aView = [[TJProgressBarView alloc] init];
    aView.frame = CGRectMake(50, 200, 200, 50);
    aView.backgroundColor = [UIColor orangeColor];
//    aView.layer.cornerRadius = 10;

    aView.trackTintColor = [UIColor lightGrayColor];
    aView.progressTintColor = [UIColor redColor];
//    aView.barLayer.progress = 0.7;
    aView.adjustsRoundedCornersAutomatically = YES;

//    [aView setProgress:0.75 animated:YES];
    aView.progress = 0;
    [self.view addSubview:aView];
    
    
//    TJProgressArcView *layer = [TJProgressArcView new];
//    layer.backgroundColor = UIColor.darkGrayColor;
//    layer.frame = CGRectMake(50, 200, 200, 200);
//    layer.animationDuration = 1.5;
//    [self.view addSubview:layer];
//
//    layer.trackWidth = 30;
//    layer.progressTintColor = UIColor.greenColor;
//    layer.trackTintColor = UIColor.lightGrayColor;
//
////    layer.startAngle = kArcStartAngleTop;
//
//    layer.progress = 0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [aView setProgress:0.75 animated:YES];
    });
}

- (void)PKUIButtonTest {
    PKUIButton *button = [PKUIButton buttonWithType:UIButtonTypeCustom];
    button.imagePosition = PKUIButtonImagePositionRight;
    button.imageAndTitleSpacing = 25;
    button.backgroundColor = [UIColor orangeColor];
    button.frame = CGRectMake(100, 200, 200, 100);
    button.imageView.backgroundColor = [UIColor pk_randomColor];
    button.titleLabel.backgroundColor = [UIColor pk_randomColor];
    [self.view addSubview:button];
 
    [button setTitle:@"哈哈哈" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"sheet_Collection"] forState:UIControlStateNormal];
}

- (void)UITableViewTest {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = 100;
    tableView.contentInset = UIEdgeInsetsZero;
    [tableView pk_eatAutomaticallyAdjustsInsets];
    [self.view addSubview:tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCTableViewCell *cell = [MyCTableViewCell pk_cellWithTableView:tableView];
    cell.backgroundColor = [UIColor pk_randomColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *aView = [MYhahHeaderView pk_headerFooterWithTableView:tableView];
    return aView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *indp = [NSIndexPath indexPathForRow:10 inSection:2];
    [tableView pk_scrollToRowAtIndexPath:indp atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)UILabelTest {
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:label];
    label.text = @"赫赫";
    label.frame = CGRectMake(100, 200, 200, 50);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [label pk_setText:@"谁看得见风" fadeDuration:0.25];
    });
}

- (void)UIAlertControllerTest {
    [UIAlertController pk_showMessage:@"知道了"];
}

- (void)UIApplicationTest {
    id value1 = [UIApplication pk_appDisplayName];
    id value2 = [UIApplication pk_appBundleName];
    id value3 = [UIApplication pk_appBundleID];
    id value4 = [UIApplication pk_appVersion];
    id value5 = [UIApplication pk_appBuildVersion];
    NSLog(@"value1 is: %@", value1);
    NSLog(@"value2 is: %@", value2);
    NSLog(@"value3 is: %@", value3);
    NSLog(@"value4 is: %@", value4);
    NSLog(@"value5 is: %@", value5);
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"clicked" forState:UIControlStateNormal];
    [self.view addSubview:button];
    button.frame = CGRectMake(100, 200, 200, 50);
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [button pk_showIndicatorWithText:@"加载中"];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [button pk_hideIndicator];
    });
}

- (void)buttonClicked {
    [UIApplication pk_telephone:@"10086"];
}

- (void)UICollectionViewTest {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 16; // 与滚动方向相同的item间距，默认为10
    flowLayout.minimumInteritemSpacing = 14; // 与滚动方向相反的两个item之间最小距离，默认为10
    flowLayout.sectionInset = UIEdgeInsetsMake(16, 16, 10, 16);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.footerReferenceSize = CGSizeMake(self.view.bounds.size.width, 50);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.bounces = YES;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView pk_registerCellWithClass:MyCollectionViewCell.class];
    [collectionView pk_registerSectionFooterWithClass:MyCollectionViewHeader.class];
    [self.view addSubview:collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 10;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectionViewCell *cell = [collectionView pk_dequeueReusableCellWithClass:MyCollectionViewCell.class forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor pk_randomColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(nonnull NSString *)kind atIndexPath:(nonnull NSIndexPath *)indexPath {
    MyCollectionViewHeader *header = [collectionView pk_dequeueReusableSectionFooterWithClass:MyCollectionViewHeader.class forIndexPath:indexPath];
    header.backgroundColor = [UIColor pk_randomColor];
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForItem:5 inSection:3];
    [collectionView pk_scrollToItemAtIndexPath:indexPath2 atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    
    
    UIImage *img = [collectionView pk_snapshot];
    [img pk_saveToAlbumFinished:NULL];
}

- (void)UIFontTest {
    id values = [UIFont pk_entireFamilyNames];
    NSLog(@"values is: %@", values);
}

#pragma make -

- (void)example1 {
    UIImage *loadingImage = [UIImage imageNamed:@"hud_loading_03"];
    [self.view pk_showHud:@"正在加载" image:loadingImage spin:YES layout:PKHudLayoutTop];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view pk_hideHud];
        UIImage *successImage = [UIImage imageNamed:@"hud_success_01"];
        [self.view pk_showHud:@"加载完成" image:successImage layout:PKHudLayoutTop];
    });
}

- (void)example2 {
    PKHudStyle *style = [[PKHudStyle alloc] init];
    style.positionOffset = 200;
    style.cornerRadius = 4;
    
    UIImage *loadingImage = [UIImage imageNamed:@"hud_loading_03"];
    [self.view pk_showHud:@"正在加载" image:loadingImage spin:YES layout:PKHudLayoutLeft position:PKHudPositionTop style:style];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view pk_hideHud];
        UIImage *failureImage = [UIImage imageNamed:@"hud_failure_01"];
        [self.view pk_showHud:@"加载失败" image:failureImage spin:NO layout:PKHudLayoutLeft position:PKHudPositionTop style:style];
    });
    
    
//    NSArray<NSString *> *array = @[@"~~~~~~~~~~", @"abc", @"abcdef", @"zhang-zhang-zheng"];
//    NSArray *mapArray = [array pk_map:^id _Nonnull(NSString * _Nonnull obj) {
//        return [obj stringByAppendingString:@"666"];
//    }];
//    NSLog(@"mapArray is: %@", mapArray);
//
//    NSArray *filerArray = [array pk_filer:^BOOL(NSString * _Nonnull obj) {
//        return obj.length < 5;
//    }];
//    NSLog(@"filerArray is: %@", filerArray);
//
//    NSInteger lastLength = [array pk_filer:^BOOL(NSString * _Nonnull obj) {
//        return obj.length > 3;
//    }].lastObject.length;
//    NSLog(@"lastLength is: %ld", (long)lastLength);
}

- (void)example3 {
    UIImageView *imageView = [UIImageView new];
    imageView.frame = CGRectMake(50, 100, 100, 100);
    imageView.layer.cornerRadius = 50;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
    imageView.image = [self getImageWithName:@"PsychokinesisTeam" size:100];
}

- (UIImage *)getImageWithName:(NSString *)name size:(CGFloat)size {
    if (name.length == 0) {
        name = @"#";
    } else {
        if ([name pk_isAllChineseCharacters]) {
            name = [name substringFromIndex:name.length - 1];
        } else {
            name = [[name substringToIndex:1] uppercaseString];
        }
    }
    return [UIImage pk_imageWithString:name fontSize:size margin:20];
}

- (void)example4 {
    UIColor *color = [[UIColor pk_colorWithHexString:@"#FFC0CB"] colorWithAlphaComponent:0.2];
    NSArray<NSNumber *> *array = [color pk_RGBAValues];
    NSLog(@"%@", array);
}

- (void)example5 {
    NSString *bundle = [NSBundle pk_mainBundleWithName:@"pk_filesA.json"];
    NSString *jsonStriing = [[NSString alloc] initWithContentsOfFile:bundle
                                                            encoding:NSUTF8StringEncoding
                                                               error:nil];
    NSArray *array = [NSArray pk_arrayWithJSONString:jsonStriing];
    NSLog(@"array======> %@", array);
}

@end
