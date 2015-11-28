//
//  MainCell.m
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/11/28.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import <Chameleon.h>
#import <Masonry.h>

#import "MainCell.h"

@interface MainCell ()

@property (nonatomic, strong) UIImageView *titleImageView;
// 表示是否多图
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *categoryLabel;

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
        [self.contentView addSubview:_titleImageView];
        
        self.tagLabel = [UILabel new];
        _tagLabel.textColor = [UIColor flatWhiteColor];
        _tagLabel.font = [UIFont systemFontOfSize:7.f];
        _tagLabel.backgroundColor = [UIColor flatGrayColor];
        _tagLabel.alpha = 0.8;
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        [_titleImageView addSubview:_tagLabel];
        
        self.titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:12.f];
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
        
        self.categoryLabel = [UILabel new];
        _categoryLabel.textColor = [UIColor grayColor];
        _categoryLabel.font = [UIFont systemFontOfSize:10.f];
        [self.contentView addSubview:_categoryLabel];
        
        [self setupLayout];
        
        // TODO: 删除测试代码
        [self setupTest];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Private

- (void)setupLayout {
    CGFloat marginLength = 10.f;
    
    [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.equalTo(@60);
        
        make.top.equalTo(@(marginLength));
        make.right.equalTo(self.contentView).with.offset(-marginLength);
        make.bottom.equalTo(self.contentView).with.offset(-marginLength);
    }];
    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_titleImageView);
        make.bottom.equalTo(_titleImageView);
        make.width.equalTo(@20);
        make.height.equalTo(@10);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleImageView);
        make.left.equalTo(self.contentView).with.offset(marginLength);
        make.right.equalTo(_titleImageView.mas_left).with.offset(-marginLength);
    }];
    
    [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(_titleLabel.mas_bottom).with.offset(5);
        make.left.equalTo(_titleLabel.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-5);
    }];
}

// just for test
- (void)setupTest {
    _titleImageView.image = [UIImage imageNamed:@"tets_thumbnail"];
    _titleLabel.text = @"卷饼做起来特别简单，但注意一些细节会更好卷饼做起来特别简单，但注意一些细节会更好";
    _categoryLabel.text = @"吃货日常";
    _tagLabel.text = @"多图";
}

@end
