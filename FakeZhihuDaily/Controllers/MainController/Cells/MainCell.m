//
//  MainCell.m
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/11/28.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import <Chameleon.h>
#import <Masonry.h>
#import <UIImageView+WebCache.h>

#import "MainCell.h"

@interface MainCell ()

@property (nonatomic, strong) UIImageView *titleImageView;
// 表示是否多图
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UIView  *separateLine;

@end

@implementation MainCell

#pragma mark - Life Cycle

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.titleImageView = [[UIImageView alloc] init];
        _titleImageView.contentMode = UIViewContentModeScaleAspectFill;
        _titleImageView.clipsToBounds = YES;
        _titleImageView.backgroundColor = [UIColor flatBlackColor];
        [self.contentView addSubview:_titleImageView];
        
        self.tagLabel = [UILabel new];
        _tagLabel.textColor = [UIColor flatWhiteColor];
        _tagLabel.font = [UIFont systemFontOfSize:9.f];
        _tagLabel.backgroundColor = [UIColor flatGrayColor];
        _tagLabel.alpha = 0.8;
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        [_titleImageView addSubview:_tagLabel];
        
        self.titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
        
        self.categoryLabel = [UILabel new];
        _categoryLabel.textColor = [UIColor grayColor];
        _categoryLabel.font = [UIFont systemFontOfSize:10.f];
        [self.contentView addSubview:_categoryLabel];
        
        self.separateLine = [[UIView alloc] init];
        _separateLine.backgroundColor = [UIColor flatGrayColor];
        _separateLine.alpha = 0.5;
        [self.contentView addSubview:_separateLine];
        
        [self setupLayout];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStory:(Story *)story {
    _story = story;
    
    if (_story == nil) {
        return;
    }
    
    if (_story.imageURLs == nil && _story.topImageURL == nil) {
        _titleImageView.hidden = YES;
    }
    if (_story.imageURLs != nil) {
        [_titleImageView sd_setImageWithURL:[NSURL URLWithString:_story.imageURLs[0]]];
    } else {
        [_titleImageView sd_setImageWithURL:[NSURL URLWithString:_story.topImageURL]];
    }
    
    if (_story.multipic) {
        _tagLabel.hidden = NO;
        _tagLabel.text = @"多图";
    } else {
        _tagLabel.hidden = YES;
    }
    
    _titleLabel.text = _story.title;
    if (_story.hasRead) {
        _titleLabel.textColor = [UIColor lightGrayColor];
    } else {
        _titleLabel.textColor = [UIColor blackColor];
    }
}

#pragma mark - Private

- (void)setupLayout {
    CGFloat marginLength = 10.f;
    
    [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.equalTo(@70);
        
        make.top.equalTo(@(marginLength));
        make.right.equalTo(self.contentView).with.offset(-marginLength);
        make.bottom.equalTo(_separateLine.mas_top).with.offset(-marginLength);
    }];
    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_titleImageView);
        make.bottom.equalTo(_titleImageView);
        make.width.equalTo(@30);
        make.height.equalTo(@15);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleImageView);
        make.left.equalTo(self.contentView).with.offset(marginLength);
        if (_titleImageView.hidden) {
            make.right.equalTo(self.titleImageView.mas_right);
        }
        else {
            make.right.equalTo(_titleImageView.mas_left).with.offset(-marginLength);
        }
    }];
    
    [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(_titleLabel.mas_bottom).with.offset(5);
        make.left.equalTo(_titleLabel.mas_left);
        make.bottom.equalTo(_separateLine).with.offset(-5);
    }];
    
    [_separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@1);
        make.right.equalTo(self.contentView);
    }];
}

@end
