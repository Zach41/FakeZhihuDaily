//
//  ThemeController.m
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/11/29.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import <UIViewController+MMDrawerController.h>
#import <SDWebImageManager.h>
#import <Chameleon.h>

#import "ThemeController.h"
#import "MainCell.h"
#import "ParallaxHeaderView.h"
#import "UINavigationBar+Awesome.h"
#import "ZhihuClient.h"
#import "Constants.h"
#import "Story.h"

static NSString * const kThemeCellID = @"ThemeCellID";
const CGFloat kLockDelta = -95.0;

@interface ThemeController () <ParallaxHeaderViewDelegate>

@property (nonatomic, strong) NSArray *stories;

@end

@implementation ThemeController

- (void)viewDidLoad {
    [super viewDidLoad];
//    
//    UIImageView *navHeaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
//    navHeaderView.image = [UIImage new];
//    navHeaderView.backgroundColor = [UIColor flatBlackColor];
//    navHeaderView.contentMode = UIViewContentModeScaleAspectFill;
//    navHeaderView.clipsToBounds = YES;
//    
//    
//    ParallaxHeaderView *parallaxHeader = [ParallaxHeaderView parallaxThemeHeaderWithSubview:navHeaderView image:[UIImage new] forSize:navHeaderView.frame.size];
//    parallaxHeader.delegate = self;
    
//    self.tableView.tableHeaderView = parallaxHeader;
    [self setParallaxHeaderWithImage:[self getBlackImage]];
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    
    [self getThemeStories];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_stories == nil) {
        return  0;
    }
    return _stories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainCell *cell = [tableView dequeueReusableCellWithIdentifier:kThemeCellID];
    
    if (cell == nil) {
        cell = [[MainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kThemeCellID];
    }
    cell.story = [_stories objectAtIndex:indexPath.row];
    
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

#pragma mark - Private

// gettting theme stories
- (void)getThemeStories {
    ZhihuClient *sharedClient = [ZhihuClient sharedClient];
    
    NSString *themeStoriesURL = [NSString stringWithFormat:kThemeStories, (long)_theme.themeID];
    [sharedClient getWithURL:themeStoriesURL
                  parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         NSArray *jsonArray = responseObject[@"stories"];
                         self.stories = [Story modelArrayWithJSONArray:jsonArray];
                         
                         NSString *bgImageURLString = responseObject[@"background"];
                         [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:bgImageURLString]
                     options:0
                     progress:nil
                     completed:^(UIImage *image, NSError *error, SDImageCacheType type, BOOL finished, NSURL *imageURL) {
                         [self setParallaxHeaderWithImage:image];
                     }];
                         [self.tableView reloadData];
                     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         NSLog(@"Error : %@", error);
                     }];
}

- (void)setParallaxHeaderWithImage:(UIImage *)image {
    UIImageView *navHeaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navHeaderView.image = image;
    navHeaderView.backgroundColor = [UIColor flatBlackColor];
    navHeaderView.contentMode = UIViewContentModeScaleAspectFill;
    navHeaderView.clipsToBounds = YES;
    
    
    ParallaxHeaderView *parallaxHeader = [ParallaxHeaderView parallaxThemeHeaderWithSubview:navHeaderView image:image forSize:navHeaderView.frame.size];
    parallaxHeader.delegate = self;
    
    self.tableView.tableHeaderView = parallaxHeader;
}

- (UIImage *)getBlackImage {
    CGSize imageSize = CGSizeMake(self.view.frame.size.width, 64);
    UIColor *fillColor = [UIColor flatBlackColor];
    
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [fillColor setFill];
    CGContextFillRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
