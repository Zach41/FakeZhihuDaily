//
//  ParallaxHeaderView.h
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/11/29.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ParallaxHeaderViewDelegate <NSObject>

- (void)lockDirection;

@end

@interface ParallaxHeaderView : UIView

@property (nonatomic, weak) id<ParallaxHeaderViewDelegate> delegate;

+ (id)parallaxHeaderWithSubView:(UIView *)subView forSize:(CGSize)size;

- (void)layoutParallaxHeaderViewForScrollViewOffset:(CGPoint)offset;

- (void)refreshBlurredImage;

@end
