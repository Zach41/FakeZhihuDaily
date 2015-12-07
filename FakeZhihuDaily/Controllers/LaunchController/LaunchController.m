//
//  LaunchController.m
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/12/5.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import <JSAnimatedImagesView.h>
#import <Masonry.h>

#import "LaunchController.h"

#define kViewSize self.view.frame.size

const CGFloat labelWidth    = 100.0;
const CGFloat labelHeight   = 10.0;
const CGFloat logoWidth     = 200.0;
const CGFloat logoHeight    = 80.0;

@interface LaunchController () <JSAnimatedImagesViewDataSource>

@property (nonatomic, strong) JSAnimatedImagesView *imageView;
@property (nonatomic, strong) UILabel              *launchLabel;
@property (nonatomic, strong) UIImageView          *logoView;

@end

@implementation LaunchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageView = [[JSAnimatedImagesView alloc] initWithFrame:self.view.bounds];
    _imageView.dataSource = self;
    [self.view addSubview:_imageView];
    
    CGFloat marginLength = 8.0;
    
    self.launchLabel = [[UILabel alloc] initWithFrame:CGRectMake((kViewSize.width-labelWidth)/2, kViewSize.height-labelHeight-marginLength, labelWidth, labelHeight)];
    _launchLabel.textColor = [UIColor lightGrayColor];
    _launchLabel.textAlignment = NSTextAlignmentCenter;
    _launchLabel.text = self.launchText;
    _launchLabel.font = [UIFont systemFontOfSize:10.0];
    [self.view addSubview:_launchLabel];
    
    self.logoView = [[UIImageView alloc] initWithFrame:CGRectMake((kViewSize.width-logoWidth)/2, _launchLabel.frame.origin.y-marginLength-logoHeight, logoWidth, logoHeight)];
    _logoView.contentMode = UIViewContentModeScaleAspectFit;
    _logoView.clipsToBounds = YES;
    _logoView.image = [UIImage imageNamed:@"Logo"];
    [self.view addSubview:_logoView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JSAnimatedView dataSouce

- (NSUInteger)animatedImagesNumberOfImages:(JSAnimatedImagesView *)animatedImagesView {
    return 2;
}

- (UIImage *)animatedImagesView:(JSAnimatedImagesView *)animatedImagesView imageAtIndex:(NSUInteger)index {
    return self.launchImage;
}

@end
