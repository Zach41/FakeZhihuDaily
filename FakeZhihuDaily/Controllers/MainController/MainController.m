//
//  MainController.m
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/11/28.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import <SDCycleScrollView.h>
#import <UIViewController+MMDrawerController.h>
#import <ZFModalTransitionAnimator.h>
#import <Masonry.h>
#import <SVProgressHUD.h>
#import <SDWebImageManager.h>

#import "MainController.h"
#import "MainCell.h"
#import "UINavigationBar+Awesome.h"
#import "ParallaxHeaderView.h"
#import "ContentBottomBar.h"
#import "ContentController.h"
#import "LaunchController.h"
#import "Theme.h"
#import "ZhihuClient.h"
#import "Constants.h"
#import "Story.h"

static NSString * const kMainCellID = @"MainCell";

@interface MainController () <SDCycleScrollViewDelegate, ParallaxHeaderViewDelegate>

@property (nonatomic, strong) LaunchController  *launchController;
@property (nonatomic, strong) UIView            *launchView;
@property (nonatomic, strong) SDCycleScrollView *headerScrollView;

@property (nonatomic, strong) NSArray           *stories;
@property (nonatomic, strong) NSArray           *topStories;
@property (nonatomic, assign) BOOL              updated;

//@property (nonatomic, copy) NSString          *launchImageText;
//@property (nonatomic, strong) UIImage           *launchImage;

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[MainCell class]
           forCellReuseIdentifier:kMainCellID];
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    SDCycleScrollView *headerScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 214.f)imagesGroup:nil];
    headerScrollView.titleLabelBackgroundColor = [UIColor clearColor];
    headerScrollView.titleLabelTextFont = [UIFont boldSystemFontOfSize:19.f];
    headerScrollView.titleLabelHeight = 60.f;
    headerScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    headerScrollView.delegate = self;
    self.headerScrollView = headerScrollView;
    
    ParallaxHeaderView *parallaxHeader = [ParallaxHeaderView parallaxHeaderWithSubView:headerScrollView forSize:headerScrollView.frame.size];
    parallaxHeader.delegate = self;
    self.tableView.tableHeaderView = parallaxHeader;
    
    // 设置导航栏
    [self setupNavigationBar];
    // 设置引导界面
    [self setupLaunchView];
    
    // 添加通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedLauchImageDownloadedNotification:) name:kLaunchImageDownloaded object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getThemesAndStory];
    
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _stories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MainCell *cell = [tableView dequeueReusableCellWithIdentifier:kMainCellID];
    Story *story = [_stories objectAtIndex:indexPath.row];
    cell.story = story;
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ContentController *contentController = [[ContentController alloc] init];
    [[_stories objectAtIndex:indexPath.row] setHasRead:YES];
    
    [self.navigationController pushViewController:contentController animated:YES];
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
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - Private

// 设置launchView
- (void)setupLaunchView {
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction:)];
    leftBarBtn.tintColor = [UIColor whiteColor];
    
    UIView *launchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    launchView.alpha = 0.99;
    self.launchView = launchView;
    
    self.launchController = [[LaunchController alloc] init];
    
    SDWebImageManager *sharedManager = [SDWebImageManager sharedManager];
    
    UIImage *diskImage = [[sharedManager imageCache] imageFromDiskCacheForKey:kLaunchImage1080_1776];

    
    if (diskImage) {
        _launchController.launchImage = diskImage;
        _launchController.launchText = [[NSUserDefaults standardUserDefaults] objectForKey:kLaunchTextKey];
    } else {
        _launchController.launchImage = [UIImage imageNamed:@"lauchImage"];
        _launchController.launchText = @"";
    }
    [self addChildViewController:_launchController];
    
    [launchView addSubview:_launchController.view];
    [self.view addSubview:launchView];

    self.navigationItem.titleView.hidden = YES;
    [UIView animateWithDuration:2.5 animations:^{
        launchView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self.navigationItem setLeftBarButtonItem:leftBarBtn animated:NO];
        self.navigationItem.titleView.hidden = NO;
        
        [UIView animateWithDuration:0.2 animations:^{
            launchView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [launchView removeFromSuperview];
            
            if (!self.updated) {
                [SVProgressHUD show];
            }
        }];
    }];
}

- (void)setupNavigationBar {
    [self.navigationController.navigationBar lt_setBackgourndColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    titleLabel.text = @"今日热文";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

// 获得主题信息
- (void)getThemesAndStory {
    if (self.updated) {
        [self.tableView reloadData];
        return;
    }
    ZhihuClient *sharedClient = [ZhihuClient sharedClient];
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [sharedClient getWithURL:kThemes
                  parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         NSArray *jsonArray = responseObject[@"others"];
                         NSArray *themesArray = [Theme modelArrayWithJSONArray:jsonArray];
                         // 发出通知
                         NSDictionary *userInfo = @{@"themes" : themesArray};
                         [[NSNotificationCenter defaultCenter] postNotificationName:kThemeNamesDownloaded object:nil userInfo:userInfo];
                        dispatch_group_leave(group);
                     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         NSLog(@"Error : %@", error);
                         dispatch_group_leave(group);
                     }];
    
    dispatch_group_enter(group);
    [sharedClient getWithURL:kLatestStories
                  parameters:nil
                     success:^(AFHTTPRequestOperation *operaton, id responseObject) {
                         NSArray *topJsonArray = responseObject[@"top_stories"];
                         NSArray *lastestArray = responseObject[@"stories"];
                         
                         self.stories = [Story modelArrayWithJSONArray:lastestArray];
                         self.topStories = [Story modelArrayWithJSONArray:topJsonArray];
                         dispatch_group_leave(group);
                     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         NSLog(@"Error : %@", error);
                         dispatch_group_leave(group);
                     }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self.updated = YES;
        if ([SVProgressHUD isVisible]) {
            [SVProgressHUD dismiss];
        }
        [self.tableView reloadData];
        
        NSMutableArray *urlArray = [NSMutableArray arrayWithCapacity:_topStories.count];
        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:_topStories.count];
        for (Story *topStory in _topStories) {
            [urlArray addObject:topStory.topImageURL];
            [titleArray addObject:topStory.title];
        }
        _headerScrollView.imageURLStringsGroup = [urlArray copy];
        _headerScrollView.titlesGroup = titleArray;
    });
}

@end
