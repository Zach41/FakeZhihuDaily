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

const CGFloat kAvatarWidth = 40.f;
const CGFloat kIconWidth   = 30.f;
const CGFloat kIconHeight  = 47.f;

@interface MenuHeaderView ()

@property (nonatomic, strong) TitleImageView *favorsView;
@property (nonatomic, strong) TitleImageView *messagesView;
@property (nonatomic, strong) TitleImageView *settingsView;

@end

@implementation MenuHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
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
        
        [self initTitleImageWithImageName:@"home" title:@"收藏"];
        [self initTitleImageWithImageName:@"home" title:@"消息"];
        [self initTitleImageWithImageName:@"home" title:@"设置"];
        
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
//        make.height.equalTo(@(kIconHeight));
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
        if (self.action) {
            self.action(0);
        }
    } else if ([title isEqualToString:@"消息"]) {
        self.messagesView = titleView;
        if (self.action) {
            self.action(1);
        }
    } else {
        self.settingsView = titleView;
        if (self.action) {
            self.action(2);
        }
    }
    
    [self addSubview:titleView];
}

- (void)setupTest {
    _avatarView.image = [UIImage imageNamed:@"tets_thumbnail"];
    _nicknameLabel.text = @"Zach";
}
@end
