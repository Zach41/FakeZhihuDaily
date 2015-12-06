//
//  MainCell.h
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/11/28.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Story.h"

@interface MainCell : UITableViewCell

// TODO: 需要给MainCell一个Model属性

@property (nonatomic, strong) Story *story;

@end
