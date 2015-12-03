//
//  UIButton+Badge.h
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/12/2.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Badge)

@property (nonatomic, strong) UILabel *badge;

@property (nonatomic, strong) NSString  *badgeValue;
@property (nonatomic, strong) UIFont    *badgeFont;
@property (nonatomic, strong) UIColor   *textColor;
@property (nonatomic, strong) UIColor   *bgColor;

@property (nonatomic, assign) CGFloat   badgePadding;
@property (nonatomic, assign) CGFloat   badgeOriginX;
@property (nonatomic, assign) CGFloat   badgeOriginY;

@property (nonatomic, assign) BOOL shouldHideBageAtZero;
@property (nonatomic, assign) BOOL shouldBounceAtChange;

@end
