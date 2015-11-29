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
const CGFloat kParallaxDeltaValue   = -63.0;
const CGFloat kParallaxThemeDelta   = -95.0;

@interface ParallaxHeaderView ()

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIView        *subview;
@property (nonatomic, strong) UIImageView   *bluredImageView;
@property (nonatomic, strong) UIImage       *blurImage;

@end

@implementation ParallaxHeaderView

#pragma mark - API
+ (id)parallaxHeaderWithSubView:(UIView *)subview forSize:(CGSize)size {
    ParallaxHeaderView *headerView = [[ParallaxHeaderView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    [headerView initialSetupForCustomSubview:subview];
    return headerView;
}

+ (id)parallaxThemeHeaderWithSubview:(UIView *)subview image:(UIImage *)image forSize:(CGSize)size {
    ParallaxHeaderView *headerView = [[ParallaxHeaderView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    headerView.blurImage = [image applyBlurWithRadius:5.0 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
    [headerView initialSetupForThemeCustomSubview:subview];
    
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

- (void)layoutParallaxThemeHeaderForScrollViewOffset:(CGPoint)offset {
    CGRect frame = _scrollView.frame;
    
    if (offset.y > 0) {
        frame.origin.y = offset.y;
        _scrollView.frame = frame;
        self.clipsToBounds = NO;
    } else if (offset.y<kParallaxThemeDelta){
        [self.delegate lockDirection];
    } else {
        CGRect rect = CGRectMake(0, 0, kHeaderSize.width, kHeaderSize.height);
        
        CGFloat delta = offset.y;
        
        rect.origin.y += delta;
        rect.size.height -= delta;
        
        _scrollView.frame = rect;
        
        _bluredImageView.alpha = (-kParallaxThemeDelta+offset.y) / 75;
        
        self.clipsToBounds = NO;
    }
}

#pragma mark - Private

- (void)commonInitialSetupForSubview:(UIView *)subview {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.backgroundColor = [UIColor whiteColor];
    subview.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.subview = subview;
    
    [self.scrollView addSubview:subview];
}

- (void)initialSetupForCustomSubview:(UIView *)subview{
    [self commonInitialSetupForSubview:subview];
    
    [self addSubview:_scrollView];
}

- (void)initialSetupForThemeCustomSubview:(UIView *)subview {
    [self commonInitialSetupForSubview:subview];
    
    self.bluredImageView = [[UIImageView alloc] initWithFrame:subview.frame];
    _bluredImageView.autoresizingMask = subview.autoresizingMask;
    _bluredImageView.alpha = 1.0f;
    _bluredImageView.image = _blurImage;
    _bluredImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.scrollView addSubview:_bluredImageView];
    
    [self addSubview:_scrollView];
}

@end
