//
//  MenuHeaderView.h
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/12/1.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^IconTappedAction)(NSInteger index);

@interface MenuHeaderView : UIView

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nicknameLabel;

@property (nonatomic, copy) IconTappedAction action;

@end
