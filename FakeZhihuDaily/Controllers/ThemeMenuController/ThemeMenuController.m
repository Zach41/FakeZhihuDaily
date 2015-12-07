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
#import "Constants.h"
#import "Theme.h"
#import "MainController.h"
#import "ThemeController.h"

@interface ThemeMenuController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MenuHeaderView *headerView;

@property (nonatomic, strong) NSArray *themes;

@property (nonatomic, strong) NSMutableArray *controllers;
@property (nonatomic, strong) UINavigationController *mainNav;

@end

@implementation ThemeMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor flatBlackColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    self.headerView = [[MenuHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 125.f)];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.headerView];
    // TODO: 设置头像昵称和各个点击时间
    _headerView.action = ^(NSInteger index) {
        if (index == 0) {
            NSLog(@"收藏按钮.");
        }
        if (index == 1) {
            NSLog(@"消息按钮");
        }
        if (index == 2) {
            NSLog(@"设置按钮");
        }
    };
    
    self.view.backgroundColor = [UIColor flatBlackColor];
    
    // 添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedThemesDownloaded:) name:kThemeNamesDownloaded object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.mainNav == nil) {
        UINavigationController *centerViewController = (UINavigationController *)[self.mm_drawerController centerViewController];
        if ([[centerViewController topViewController] isKindOfClass:[MainController class]]) {
            self.mainNav = centerViewController;
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    return _themes.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"主页";
    } else {
        Theme *theme = [_themes objectAtIndex:indexPath.row-1];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", theme.name];
    }
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.backgroundColor = [UIColor flatBlackColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIView *selectedView = [[UIView alloc] initWithFrame:cell.contentView.frame];
    selectedView.backgroundColor = [UIColor colorWithRed:12/255.0 green:19/255.0 blue:25/255.0 alpha:0.3];
    cell.selectedBackgroundView = selectedView;
    
    return cell;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath .row == 0) {
        [self.mm_drawerController setCenterViewController:_mainNav withCloseAnimation:YES completion:nil];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    if (_controllers[indexPath.row-1] == [NSNull null]) {
        Theme *theme = [_themes objectAtIndex:indexPath.row-1];
        ThemeController *themeController = [[ThemeController alloc] init];
        themeController.theme = theme;
        UINavigationController *themeNav = [[UINavigationController alloc] initWithRootViewController:themeController];
        [_controllers replaceObjectAtIndex:indexPath.row-1 withObject:themeNav];
    }
    
    [self.mm_drawerController setCenterViewController:_controllers[indexPath.row-1] withCloseAnimation:YES completion:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.0;
}

#pragma mark - Notification Observer
- (void)receivedThemesDownloaded:(NSNotification *)notification{
    self.themes = notification.userInfo[@"themes"];
    self.controllers = [NSMutableArray arrayWithCapacity:_themes.count];
    
    for (int i=0; i<_themes.count; i++) {
        [_controllers addObject:[NSNull null]];
    }
    
    [self.tableView reloadData];
    
}
@end
