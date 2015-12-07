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

#import "ContentController.h"
#import "ContentBottomBar.h"
#import "ParallaxHeaderView.h"
#import "ContentHeaderView.h"
#import "UINavigationBar+Awesome.h"

#define kViewSize self.view.frame.size

const CGFloat kBottomBarHeight = 50.0;
const CGFloat kHeaderImageHeight = 220.0;

@interface ContentController () <UIScrollViewDelegate, ParallaxHeaderViewDelegate>

@property (nonatomic, strong) ContentBottomBar *bottomBar;
@property (nonatomic, strong) ParallaxHeaderView *headerView;
@property (nonatomic, strong) ContentHeaderView *headerImageView;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    
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
                break;
                
            default:
                break;
        }
    };
    
    self.headerImageView = [[ContentHeaderView alloc] initWithFrame:CGRectMake(0, 0, kViewSize.width, kHeaderImageHeight)];
    self.headerImageView.clipsToBounds = YES;
    self.headerView = [ParallaxHeaderView parallaxHeaderWithSubView:_headerImageView forSize:CGSizeMake(kViewSize.width, kHeaderImageHeight)];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.webView.scrollView.delegate = self;
    self.headerView.delegate = self;
    
    [self.view addSubview:_webView];
    [self.view addSubview:_bottomBar];
    [self.webView.scrollView addSubview:_headerView];
    
    _webView.scrollView.contentInset = UIEdgeInsetsMake(kHeaderImageHeight, 0, 0, 0);
    
    NSURL *testURL = [NSURL URLWithString:@"http://daily.zhihu.com/story/7541839?utm_campaign=in_app_share&utm_medium=iOS&utm_source=qq"];
    NSURLRequest *request = [NSURLRequest requestWithURL:testURL];
    [_webView loadRequest:request];
    [self setupTest];
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
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_webView);
        make.right.equalTo(_webView);
        make.top.equalTo(_webView.scrollView.mas_top).with.offset(-kHeaderImageHeight);
        make.height.equalTo(@(kHeaderImageHeight));
    }];
}

#pragma mark - ScrolView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_headerView layoutParallaxWebHeaderForScrollViewOffset:scrollView.contentOffset];
}

#pragma mark - ParallaxHeaderView Delegate 
- (void)lockDirection {
    [_webView.scrollView setContentOffset:CGPointMake(0, -kHeaderImageHeight-90)];
    [_webView.scrollView setContentOffset:CGPointMake(0, -kHeaderImageHeight) animated:YES];
}

#pragma mark - Private
- (void)setupTest {
    _headerImageView.titleLabel.text = @"电动刷牙好还是手动刷牙好";
    _headerImageView.sourceLabel.text = @"图片：Yestone.com 版权图片库";
    _headerImageView.image = [UIImage imageNamed:@"test_scroll_image"];
}

@end
