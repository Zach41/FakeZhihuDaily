//
//  ContentHeaderView.m
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/12/3.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import <Chameleon.h>
#import <Masonry.h>

#import "ContentHeaderView.h"

@implementation ContentHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initSubviews];
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    
    if (self) {
        [self initSubviews];
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    self = [super initWithImage:image highlightedImage:highlightedImage];
    
    if (self) {
        [self initSubviews];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [_sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).with.offset(-16);
        make.right.equalTo(self.mas_right).with.offset(-32);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_sourceLabel.mas_top).with.offset(-16);
        make.left.equalTo(self.mas_left).with.offset(32);
    }];
}

#pragma mark - Private
- (void)initSubviews {
    self.titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:19.f];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.numberOfLines = 0;
    
    [self addSubview:_titleLabel];
    
    self.sourceLabel = [UILabel new];
    _sourceLabel.textColor = [UIColor flatWhiteColor];
    _sourceLabel.font = [UIFont systemFontOfSize:8.0];
    _sourceLabel.textAlignment = NSTextAlignmentLeft;
    _sourceLabel.backgroundColor = [UIColor clearColor];
    _sourceLabel.numberOfLines = 1;
    [self addSubview:_sourceLabel];
    
    self.contentMode = UIViewContentModeScaleAspectFill;
}

@end
