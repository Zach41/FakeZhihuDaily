//
//  ParallaxHeaderView.m
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/11/29.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import "UIImage+ImageEffects.h"

#import "ParallaxHeaderView.h"

#define kHeaderSize self.frame.size

const CGFloat kParallaxDeltaFactor  = 0.5;
const CGFloat kParallaxDeltaValue   = -63;

@interface ParallaxHeaderView ()

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIView        *subview;
@property (nonatomic, strong) UIImageView   *blureImageView;

@end

@implementation ParallaxHeaderView

#pragma mark - API
+ (id)parallaxHeaderWithSubView:(UIView *)subview forSize:(CGSize)size {
    ParallaxHeaderView *headerView = [[ParallaxHeaderView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    [headerView initialSetupForCustomSubview:subview];
    return headerView;
}

- (void)layoutParallaxHeaderViewForScrollViewOffset:(CGPoint)offset {
    if (offset.y<kParallaxDeltaValue){
        CGFloat delta =offset.y;
        
        CGRect rect = CGRectMake(0, 0, kHeaderSize.width, kHeaderSize.height);
        
        rect.origin.y += delta;
        rect.size.height -= delta;
        
        self.scrollView.frame = rect;
        self.clipsToBounds = NO;
    }
}

- (void)refreshBlurredImage {
    UIImage *screenShot = [self screenShotOfView];
    screenShot = [screenShot applyBlurWithRadius:5.0 tintColor:[UIColor colorWithWhite:0.6 alpha:0.2] saturationDeltaFactor:1.0 maskImage:nil];
    self.blureImageView.image = screenShot;
}

#pragma mark - Private

- (void)initialSetupForCustomSubview:(UIView *)subview{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    
    _scrollView.backgroundColor = [UIColor whiteColor];
    subview.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.subview = subview;
    
    [self.scrollView addSubview:subview];
    
    self.blureImageView = [[UIImageView alloc] initWithFrame:subview.bounds];
    _blureImageView.autoresizingMask = subview.autoresizingMask;
    _blureImageView.alpha = 0.0f;
    [self.scrollView addSubview:_blureImageView];
    
    [self addSubview:self.scrollView];
    
    [self refreshBlurredImage];
}

- (UIImage *)screenShotOfView{
    UIGraphicsBeginImageContextWithOptions(kHeaderSize, YES, 0.0);
    [self drawViewHierarchyInRect:CGRectMake(0, 0, kHeaderSize.width, kHeaderSize.height) afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
