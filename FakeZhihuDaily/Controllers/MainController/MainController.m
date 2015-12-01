//
//  MainController.m
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/11/28.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import <SDCycleScrollView.h>
#import <UIViewController+MMDrawerController.h>

#import "MainController.h"
#import "MainCell.h"
#import "UINavigationBar+Awesome.h"
#import "ParallaxHeaderView.h"

static NSString * const kMainCellID = @"MainCell";

@interface MainController () <SDCycleScrollViewDelegate, ParallaxHeaderViewDelegate>

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[MainCell class]
           forCellReuseIdentifier:kMainCellID];
    
    // FIXME: 测试代码移除
    NSArray *imageGroup = @[
                            [UIImage imageNamed:@"test_scroll_image"],
                            [UIImage imageNamed:@"test_scroll_image"],
                            [UIImage imageNamed:@"test_scroll_image"]];
    
    SDCycleScrollView *headerScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 214.f) imagesGroup:imageGroup];
    headerScrollView.titlesGroup = @[@"这是一张测试图片哦哦哦哦哦",
                                     @"这是一张测试图片哦哦哦哦哦",
                                     @"这是一张测试图片哦哦哦哦哦这是一张测试图片哦哦哦哦哦这是一张测试图片哦哦哦哦哦"];
    headerScrollView.titleLabelBackgroundColor = [UIColor clearColor];
    headerScrollView.titleLabelTextFont = [UIFont boldSystemFontOfSize:19.f];
    headerScrollView.titleLabelHeight = 60.f;
    headerScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    headerScrollView.delegate = self;
    ParallaxHeaderView *parallaxHeader = [ParallaxHeaderView parallaxHeaderWithSubView:headerScrollView forSize:headerScrollView.frame.size];
    parallaxHeader.delegate = self;
    
    self.tableView.tableHeaderView = parallaxHeader;
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    
    // 设置导航栏
    self.title = @"今日热文";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar lt_setBackgourndColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction:)];
    leftBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MainCell *cell = [tableView dequeueReusableCellWithIdentifier:kMainCellID];
    
    if (cell == nil) {
        cell = [[MainCell alloc] init];
    }
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    ParallaxHeaderView *headerView = (ParallaxHeaderView *)self.tableView.tableHeaderView;
    
    [headerView layoutParallaxHeaderViewForScrollViewOffset:scrollView.contentOffset];
    
    UIColor *color = [UIColor colorWithRed:1/255.0 green:131/255.0 blue:209/255.0 alpha:1.0];
    
    CGFloat prelude = 150.f;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY>=0) {
        CGFloat alpha = MIN(1, (offsetY) / (prelude));
        [self.navigationController.navigationBar lt_setBackgourndColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgourndColor:[UIColor clearColor]];
    }
}
#pragma mark - SDCycleImageView Delegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"第%ld张图片被点击了.", (long)index);
}

#pragma mark - ParallaxHeader Delegate
- (void)lockDirection {
    CGPoint offset = self.tableView.contentOffset;
    [self.tableView setContentOffset:CGPointMake(offset.x, -90) animated:NO];
    [self.tableView setContentOffset:CGPointMake(offset.x, 0) animated:YES];
}

#pragma mark - Button targets
- (void)leftBarButtonAction:(UIBarButtonItem *)item {
    // FIXME : 将测试的代码删除
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
@end
