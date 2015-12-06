//
//  ContentBottomBar.m
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/12/3.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import <BlocksKit+UIKit.h>
#import <Chameleon.h>
#import <Masonry.h>

#import "ContentBottomBar.h"
#import "UIButton+Badge.h"

#define kViewWidth self.frame.size.width

const CGFloat kButtonWidth = 25.f;

@interface ContentBottomBar()

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *downButton;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *messageButton;

@end

@implementation ContentBottomBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // 设置阴影
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.frame];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowPath = shadowPath.CGPath;
        
        // 这里需要一个初始的frame，因为custom button初始为CGRectZero，如果不这么做，那么子view布局会出错(子布局没有用autolayout导致，是的我要修改这一部分代码)
        CGRect initialFrame = CGRectMake(0, 0, kButtonWidth, kButtonWidth);
        
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = initialFrame;
        [_leftButton setImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
        [self addSubview:_leftButton];
        
        self.downButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _downButton.frame = initialFrame;
        [_downButton setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [self addSubview:_downButton];
        
        self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _likeButton.frame = initialFrame;
        [_likeButton setImage:[UIImage imageNamed:@"favor"] forState:UIControlStateNormal];
        [self addSubview:_likeButton];
        
        self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.frame = initialFrame;
        [_shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [self addSubview:_shareButton];
        
        self.messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageButton.frame = initialFrame;
        [_messageButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [self addSubview:_messageButton];
        
        [self setupButtonActions];
        // TODO: 删除测试代码
        [self setupTest];
    }
    return self;
}

- (void)layoutSubviews {
    // 计算间距，确实这样做代码写起来很丑，但是autolayout的黑科技我还不会。。。
    CGFloat paddingWidth = 30.f;
    
    CGFloat marginWidth = (kViewWidth - 2*paddingWidth - 5*kButtonWidth) / 4;
    
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kButtonWidth));
        make.height.equalTo(@(kButtonWidth));
        make.left.equalTo(@(paddingWidth));
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    NSArray *prefixKeys = [self prefixStringForButtons];
    for (int i=1; i<prefixKeys.count; i++) {
        UIButton *button = [self buttonForPrefixKey:prefixKeys[i]];
        UIButton *priorBtn = [self buttonForPrefixKey:prefixKeys[i-1]];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(kButtonWidth));
            make.height.equalTo(@(kButtonWidth));
            make.left.equalTo(priorBtn.mas_right).with.offset(marginWidth);
            make.centerY.equalTo(_leftButton.mas_centerY);
        }];
    }
}

#pragma mark - Private
- (NSArray *)prefixStringForButtons {
    return @[@"left", @"down", @"like", @"share", @"message"];
}

- (UIButton *)buttonForPrefixKey:(NSString *)key {
    NSString *fullKey = [NSString stringWithFormat:@"%@Button", key];
    return [self valueForKey:fullKey];
}

- (void)setupButtonActions {
    NSArray *prefixKeys = [self prefixStringForButtons];
    for (int i=0; i<prefixKeys.count; i++) {
        NSString *key = prefixKeys[i];
        UIButton *button = [self buttonForPrefixKey:key];
        // 添加底部栏按钮的回调函数
        [button bk_addEventHandler:^(id handler) {
            if (self.actions) {
                self.actions(button, i);
            }
            NSLog(@"Bottom Bar %d was selected.", i);
        }forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setupTest {
    _likeButton.badgeValue = @"23";
    _likeButton.bgColor = [UIColor clearColor];
    _likeButton.textColor = [UIColor flatGrayColor];
    
    _messageButton.badgeValue = @"13";
    _messageButton.textColor = [UIColor flatBlackColor];
}

@end
