//
//  ContentController.m
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/12/3.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import <Masonry.h>
#import <Chameleon.h>
#import <UIViewController+MMDrawerController.h>
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>

#import "UIButton+Badge.h"
#import "ContentController.h"
#import "ContentBottomBar.h"
#import "ParallaxHeaderView.h"
#import "ContentHeaderView.h"
#import "UINavigationBar+Awesome.h"
#import "ZhihuClient.h"
#import "Constants.h"

#define kViewSize self.view.frame.size

const CGFloat kBottomBarHeight = 50.0;
const CGFloat kHeaderImageHeight = 223.0;

@interface ContentController () <UIScrollViewDelegate, ParallaxHeaderViewDelegate>

@property (nonatomic, strong) ContentBottomBar *bottomBar;
@property (nonatomic, strong) ParallaxHeaderView *headerView;
@property (nonatomic, strong) ContentHeaderView *headerImageView;
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) StoryDetail *detail;

@end

@implementation ContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bottomBar = [[ContentBottomBar alloc] initWithFrame:CGRectMake(0, 0, kViewSize.width, kBottomBarHeight)];
    
    __weak typeof(self) weakSelf = self;
    _bottomBar.actions = ^(UIButton *button, NSInteger index) {
        __strong typeof(self) strongSelf = weakSelf;
        switch (index) {
            case 0: {
                // 返回上一级
                [strongSelf.navigationController popViewControllerAnimated:YES];
                [strongSelf.navigationController setNavigationBarHidden:NO animated:NO];
            }
            case 1:
                break;
            case 2: {
                NSInteger curValue = [button.badgeValue integerValue];
                if (button.buttonSelected) {
                    curValue -= 1;
                    button.textColor = [UIColor lightGrayColor];
                    button.buttonSelected = NO;
                } else {
                    curValue += 1;
                    button.textColor = [UIColor flatBlueColor];
                    button.buttonSelected = YES;
                }
                button.badgeValue = [NSString stringWithFormat:@"%ld", (long)curValue];
            }
                break;
                
            default:
                break;
        }
    };
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.webView.scrollView.delegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_webView];
    [self.view addSubview:_bottomBar];
    
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.view.clipsToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    
    if (self.detail) {
        [self setupContent];
    } else {
        [SVProgressHUD show];
        [self getStoryContent];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"Log point");
}

- (void)viewDidLayoutSubviews {
    [_bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@(kBottomBarHeight));
    }];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(_bottomBar.mas_top);
        make.top.equalTo(self.view.mas_top);
    }];
    
    if (self.headerView) {
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_webView);
            make.right.equalTo(_webView);
            make.top.equalTo(_webView.scrollView.mas_top).with.offset(-20);
            make.height.equalTo(@(kHeaderImageHeight));
        }];
    }
}

#pragma mark - ScrolView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_headerView layoutParallaxWebHeaderForScrollViewOffset:scrollView.contentOffset];
}

#pragma mark - ParallaxHeaderView Delegate 
- (void)lockDirection {
    [_webView.scrollView setContentOffset:CGPointMake(0, -110)];
    [_webView.scrollView setContentOffset:CGPointMake(0, -20) animated:YES];
}

#pragma mark - Private
- (void)setupContent{
    if (_detail.imageURLString != nil) {
        self.headerImageView = [[ContentHeaderView alloc] initWithFrame:CGRectMake(0, 0, kViewSize.width, kHeaderImageHeight)];
        self.headerImageView.clipsToBounds = YES;
        _headerImageView.titleLabel.text = _detail.title;
        _headerImageView.sourceLabel.text = _detail.imageSourceString;
        
        self.headerView = [ParallaxHeaderView parallaxHeaderWithSubView:_headerImageView forSize:CGSizeMake(kViewSize.width, kHeaderImageHeight)];
        self.headerView.delegate = self;
        
        [self.webView.scrollView addSubview:_headerView];
    }
    
    NSString *imageURLString = nil;
    if (_detail.imageURLString) {
        imageURLString = _detail.imageURLString;
    } else if (_story.imageURLs && _story.imageURLs.count>0) {
        imageURLString = _story.imageURLs[0];
    } else {
        imageURLString = _story.topImageURL;
    }
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:imageURLString]];
    
    NSString *htmlString = [NSString stringWithFormat:@"<html>\n<head>\n<link rel=\"stylesheet\" href=\"%@\"/>\n</head>\n<body>\n%@\n</body>\n</html>", _detail.cssURLStrings[0], _detail.bodyString];
    [_webView loadHTMLString:htmlString baseURL:nil];
}

- (void)getStoryContent {
    ZhihuClient *sharedClient = [ZhihuClient sharedClient];
    
    NSString *urlString = [NSString stringWithFormat:kNewsDetail, _story.storyID];
    [sharedClient getWithURL:urlString
                  parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         self.detail = [[StoryDetail alloc] initWithDictionary:responseObject];
                         
                         [self setupContent];
                         [SVProgressHUD dismiss];
                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         NSLog(@"Error : %@", error);
                     }];
}

@end
