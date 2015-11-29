//
//  ThemeController.m
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/11/29.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import "ThemeController.h"
#import "MainCell.h"
#import "ParallaxHeaderView.h"
#import "UINavigationBar+Awesome.h"

static NSString * const kThemeCellID = @"ThemeCellID";
const CGFloat kLockDelta = -95.0;

@interface ThemeController () <ParallaxHeaderViewDelegate>

@end

@implementation ThemeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *navHeaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navHeaderView.image = [UIImage imageNamed:@"theme_test"];
    navHeaderView.contentMode = UIViewContentModeScaleAspectFill;
    navHeaderView.clipsToBounds = YES;
    
    
    ParallaxHeaderView *parallaxHeader = [ParallaxHeaderView parallaxThemeHeaderWithSubview:navHeaderView image:[UIImage imageNamed:@"theme_test"] forSize:navHeaderView.frame.size];
    parallaxHeader.delegate = self;
    
    self.tableView.tableHeaderView = parallaxHeader;
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 88.0;
    
    [self.navigationController.navigationBar lt_setBackgourndColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.title = @"主题日报";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainCell *cell = [tableView dequeueReusableCellWithIdentifier:kThemeCellID];
    
    if (cell == nil) {
        cell = [[MainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kThemeCellID];
    }
    
    return cell;
}

#pragma mark - TableView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    ParallaxHeaderView *headerView = (ParallaxHeaderView *)self.tableView.tableHeaderView;
    [headerView layoutParallaxThemeHeaderForScrollViewOffset:scrollView.contentOffset];
}

#pragma mark - ParallaxHeaderView Delegate 

- (void)lockDirection {
    CGPoint contentOffset = self.tableView.contentOffset;
    [self.tableView setContentOffset:CGPointMake(contentOffset.x, kLockDelta) animated:NO];
    [self.tableView setContentOffset:CGPointMake(contentOffset.x, 0) animated:YES];
}

@end
