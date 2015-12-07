//
//  MenuHeaderView.m
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/12/1.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import <Masonry.h>
#import <Chameleon.h>
#import <BlocksKit+UIKit.h>

#import "MenuHeaderView.h"
#import "TitleImageView.h"

const CGFloat kAvatarWidth = 50.f;
const CGFloat kIconWidth   = 24.f;
const CGFloat kIconHeight  = 45.f;

@interface MenuHeaderView ()

@property (nonatomic, strong) TitleImageView *favorsView;
@property (nonatomic, strong) TitleImageView *messagesView;
@property (nonatomic, strong) TitleImageView *settingsView;

@end

@implementation MenuHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // 添加阴影
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
        self.layer.shadowOffset = CGSizeMake(0, 1.1);
        self.layer.shadowOpacity = 0.2f;
        self.layer.shadowPath = shadowPath.CGPath;
        self.layer.shadowColor = [UIColor colorWithWhite:0.000 alpha:0.6].CGColor;
        self.layer.shadowRadius = 1.f;
        self.clipsToBounds = NO;
        
        self.backgroundColor = [UIColor flatBlackColor];
        self.avatarView = [UIImageView new];
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarView.layer.cornerRadius = kAvatarWidth / 2;
        _avatarView.clipsToBounds = YES;
        [self addSubview:_avatarView];
        
        self.nicknameLabel = [UILabel new];
        _nicknameLabel.textColor = [UIColor flatWhiteColor];
        _nicknameLabel.backgroundColor = [UIColor clearColor];
        _nicknameLabel.font = [UIFont systemFontOfSize:17.f];
        _nicknameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_nicknameLabel];
        
        [self initTitleImageWithImageName:@"favor" title:@"收藏"];
        [self initTitleImageWithImageName:@"message" title:@"消息"];
        [self initTitleImageWithImageName:@"settting" title:@"设置"];
        
        // TODO: 删除测试代码
        [self setupTest];
    }
    
    return self;
}

- (void)layoutSubviews {
    [_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@15);
        make.width.equalTo(@(kAvatarWidth));
        make.height.equalTo(@(kAvatarWidth));
    }];
    
    [_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarView.mas_right).with.offset(15);
        make.centerY.equalTo(_avatarView.mas_centerY);
    }];
    
    [_favorsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(_avatarView.mas_bottom).with.offset(20);
        make.width.equalTo(@(kIconWidth));
        make.height.equalTo(@(kIconHeight));
    }];
    
    [_messagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_favorsView.mas_right).with.offset(40);
        make.width.equalTo(@(kIconWidth));
        make.height.equalTo(@(kIconHeight));
        make.top.equalTo(_favorsView.mas_top);
    }];
    
    [_settingsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_messagesView.mas_right).with.offset(40);
        make.width.equalTo(@(kIconWidth));
        make.height.equalTo(@(kIconHeight));
        make.top.equalTo(_favorsView.mas_top);
    }];
}
#pragma mark - Private
- (void)initTitleImageWithImageName:(NSString *)imageName title:(NSString *) title{
    
    TitleImageView *titleView = [[TitleImageView alloc] initWithFrame:CGRectZero];
    titleView.titleLabel.text = title;
    titleView.imageView.image = [UIImage imageNamed:imageName];
    
    if ([title isEqualToString:@"收藏"]) {
        self.favorsView = titleView;
    } else if ([title isEqualToString:@"消息"]) {
        self.messagesView = titleView;
    } else {
        self.settingsView = titleView;
    }
    
    [titleView bk_whenTapped:^{
        if (self.action == nil) {
            return;
        }
        if ([title isEqualToString:@"收藏"]) {
            self.action(0);
        }
        if ([title isEqualToString:@"消息"]) {
            self.action(1);
        }
        if ([title isEqualToString:@"设置"]) {
            self.action(2);
        }
    }];
    
    [self addSubview:titleView];
}

- (void)setupTest {
    _avatarView.image = [UIImage imageNamed:@"tets_thumbnail"];
    _nicknameLabel.text = @"Zach";
}
@end
