//
//  UINavigationBar+Awesome.m
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/11/28.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import <objc/runtime.h>

#import "UINavigationBar+Awesome.h"

@implementation UINavigationBar (Awesome)

static char overlayKey;

- (UIView *)overlay {
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)lt_setBackgourndColor:(UIColor *)color {
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)+20.f)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = color;
}

- (void)lt_setElementsAlpha:(CGFloat)alpha {
    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    [[self valueForKey:@"_titleView"] setAlpha:alpha];
}

- (void)lt_reset {
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}

- (void)lt_setTranslationY:(CGFloat)translationY {
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}


@end
