//
//  UIButton+Badge.m
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/12/2.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import <objc/runtime.h>
#import <Chameleon.h>

#import "UIButton+Badge.h"

NSString const *UIButton_badgeKey       = @"BadgeKey";
NSString const *UIButton_badgeValueKey  = @"BadgeValue";
NSString const *UIButton_badgeFont      = @"BadgeFont";
NSString const *UIButton_badgeTextColor = @"BadgeTextColor";
NSString const *UIButton_badgeBGColor   = @"BadgeBGColor";
NSString const *UIButton_badgePadding   = @"BadgePadding";
NSString const *UIButton_badgeOriginX   = @"BadgeOriginX";
NSString const *UIButton_badgeOriginY   = @"BadgeOriginY";

NSString const *UIButton_shouldHideAtZero       = @"UIButton_shouldHideAtZero";
NSString const *UIButton_shouldBouceAtChange    = @"UIButton_shouldBoundceAtChange";

@implementation UIButton (Badge)

@dynamic badge;
@dynamic badgeValue;
@dynamic badgeFont;
@dynamic textColor;
@dynamic bgColor;
@dynamic badgePadding;
@dynamic badgeOriginX;
@dynamic badgeOriginY;
@dynamic shouldBounceAtChange;
@dynamic shouldHideBageAtZero;

#pragma mark - Private
- (void)badgeInit {
    self.bgColor = [UIColor colorWithRed:1/255.0 green:131/255.0 blue:209/255.0 alpha:1.0];
    self.textColor = [UIColor flatGrayColor];
    self.badgeFont = [UIFont systemFontOfSize:8.f];
    self.badgePadding = 8.f;
    self.badgeOriginX = self.frame.size.width - 10.f;
    self.badgeOriginY = -2;
    
    self.shouldBounceAtChange = YES;
    self.shouldHideBageAtZero = YES;
    
    self.clipsToBounds = NO;
}

- (void)removeBadge {
    [UIView animateWithDuration:0.2 animations:^{
        self.badge.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [self.badge removeFromSuperview];
        self.badge = nil;
    }];
}

- (void)refreshBadge {
    self.badge.textColor = self.textColor;
    self.badge.font = self.badgeFont;
    self.badge.backgroundColor = self.bgColor;
}

- (void)updateBadgeFrame {
    CGSize badgeSize = [self badgeExpectedSize];
    
    self.badge.frame = CGRectMake(self.badgeOriginX, self.badgeOriginY, badgeSize.width+self.badgePadding, badgeSize.height+self.badgePadding);
}

- (UILabel *)duplicateLabel:(UILabel *)label {
    UILabel *duplicatedLabel = [UILabel new];
    duplicatedLabel.frame = label.frame;
    duplicatedLabel.text = label.text;
    duplicatedLabel.font = label.font;
    
    return duplicatedLabel;
}

- (CGSize)badgeExpectedSize {
    UILabel *duplicatedLabel = [self duplicateLabel:self.badge];
    
    [duplicatedLabel sizeToFit];
    
    return duplicatedLabel.frame.size;
}

#pragma mark - Getters and Setters

- (UILabel *)badge {
    return objc_getAssociatedObject(self, &UIButton_badgeKey);
}

- (void)setBadge:(UILabel *)badge {
    objc_setAssociatedObject(self, &UIButton_badgeKey, badge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)badgeValue {
    return objc_getAssociatedObject(self, &UIButton_badgeValueKey);
}

- (void)setBadgeValue:(NSString *)badgeValue {
    objc_setAssociatedObject(self, &UIButton_badgeValueKey, badgeValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if (!badgeValue || [badgeValue isEqualToString:@""] || ([badgeValue isEqualToString:@"0"] && self.shouldHideBageAtZero)) {
        [self removeBadge];
    } else if (!self.badge){
        [self badgeInit];
        self.badge = [[UILabel alloc] initWithFrame:CGRectMake(self.badgeOriginX, self.badgeOriginY, 20, 12)];
        self.badge.textColor = self.textColor;
        self.badge.font = self.badgeFont;
        self.badge.textAlignment = NSTextAlignmentCenter;
        self.badge.backgroundColor = self.bgColor;
        [self addSubview:self.badge];
        self.badge.text = self.badgeValue;
    } else {
        self.badge.text = self.badgeValue;
    }
}

- (UIFont *)badgeFont {
    return objc_getAssociatedObject(self, &UIButton_badgeFont);
}

- (void)setBadgeFont:(UIFont *)badgeFont {
    objc_setAssociatedObject(self, &UIButton_badgeFont, badgeFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (self.badge)
        [self refreshBadge];
}

- (UIColor *)bgColor {
    return objc_getAssociatedObject(self, &UIButton_badgeBGColor);
}

- (void)setBgColor:(UIColor *)bgColor {
    objc_setAssociatedObject(self, &UIButton_badgeBGColor, bgColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge) {
        [self refreshBadge];
    }
}

- (UIColor *)textColor {
    return objc_getAssociatedObject(self, &UIButton_badgeTextColor);
}

- (void)setTextColor:(UIColor *)textColor {
    objc_setAssociatedObject(self, &UIButton_badgeTextColor, textColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge)
        [self refreshBadge];
}

- (CGFloat)badgePadding {
    return [objc_getAssociatedObject(self, &UIButton_badgePadding) floatValue];
}

- (void)setBadgePadding:(CGFloat)badgePadding {
    NSNumber *number = [NSNumber numberWithFloat:badgePadding];
    objc_setAssociatedObject(self, &UIButton_badgePadding, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge)
        [self updateBadgeFrame];
}

- (CGFloat)badgeOriginX {
    return [objc_getAssociatedObject(self, &UIButton_badgeOriginX) floatValue];
}

- (void)setBadgeOriginX:(CGFloat)badgeOriginX {
    NSNumber *number = [NSNumber numberWithFloat:badgeOriginX];
    objc_setAssociatedObject(self, &UIButton_badgeOriginX, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge)
        [self updateBadgeFrame];
}

- (CGFloat)badgeOriginY {
    return [objc_getAssociatedObject(self, &UIButton_badgeOriginY) floatValue];
}

- (void)setBadgeOriginY:(CGFloat)badgeOriginY {
    NSNumber *number = [NSNumber numberWithFloat:badgeOriginY];
    objc_setAssociatedObject(self, &UIButton_badgeOriginY, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.badge)
        [self updateBadgeFrame];
}

- (BOOL)shouldBounceAtChange {
    return [objc_getAssociatedObject(self, &UIButton_shouldBouceAtChange) boolValue];
}

- (void)setShouldBounceAtChange:(BOOL)shouldBounceAtChange {
    NSNumber *number = [NSNumber numberWithBool:shouldBounceAtChange];
    objc_setAssociatedObject(self, &UIButton_shouldBouceAtChange, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)shouldHideBageAtZero {
    return [objc_getAssociatedObject(self, &UIButton_shouldHideAtZero) boolValue];
}

- (void)setShouldHideBageAtZero:(BOOL)shouldHideBageAtZero {
    NSNumber *number = [NSNumber numberWithBool:shouldHideBageAtZero];
    objc_setAssociatedObject(self, &UIButton_shouldHideAtZero, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
