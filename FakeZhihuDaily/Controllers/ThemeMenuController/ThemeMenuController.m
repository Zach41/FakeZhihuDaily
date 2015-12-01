//
//  ThemeMenuController.m
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/11/30.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import <Chameleon.h>
#import <UIViewController+MMDrawerController.h>
#import <Masonry.h>

#import "ThemeMenuController.h"
#import "UINavigationBar+Awesome.h"
#import "ThemeController.h"
#import "MainController.h"
#import "MenuHeaderView.h"

@interface ThemeMenuController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MenuHeaderView *headerView;

@end

@implementation ThemeMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor flatBlackColor];
//    _tableView.
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    self.headerView = [[MenuHeaderView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.headerView];
    // TODO: 设置头像昵称和各个点击时间
    
    self.view.backgroundColor = [UIColor flatBlackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews {
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@125);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).with.offset(20);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(_headerView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Index %ld", (long)indexPath.row];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.backgroundColor = [UIColor flatBlackColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIView *selectedView = [[UIView alloc] initWithFrame:cell.contentView.frame];
    selectedView.backgroundColor = [UIColor colorWithRed:12/255.0 green:19/255.0 blue:25/255.0 alpha:0.5];
    cell.selectedBackgroundView = selectedView;
    
    return cell;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath .row == 0) {
        MainController *mainController = [[MainController alloc] init];
        UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:mainController];
        
        [self.mm_drawerController setCenterViewController:mainNav withCloseAnimation:YES completion:nil];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    ThemeController *themeController = [[ThemeController alloc] init];
    UINavigationController *themeNav = [[UINavigationController alloc] initWithRootViewController:themeController];
    
    [self.mm_drawerController setCenterViewController:themeNav withCloseAnimation:YES completion:nil];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}
@end
