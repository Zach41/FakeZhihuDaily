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

@interface LaunchController () <JSAnimatedImagesViewDataSource>

@property (nonatomic, strong) JSAnimatedImagesView *imageView;

@end

@implementation LaunchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageView = [[JSAnimatedImagesView alloc] initWithFrame:self.view.bounds];
    _imageView.dataSource = self;
    [self.view addSubview:_imageView];
    
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
