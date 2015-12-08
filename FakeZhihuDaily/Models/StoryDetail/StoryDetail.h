//
//  StoryDetail.h
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/12/6.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseModel.h"

@interface StoryDetail : BaseModel

@property (nonatomic, copy) NSString        *bodyString;
@property (nonatomic, copy) NSString        *title;
@property (nonatomic, copy) NSString        *imageSourceString;
@property (nonatomic, copy) NSString        *imageURLString;
@property (nonatomic, copy) NSString        *shareURLString;
@property (nonatomic, copy) NSString        *gaPrefix;
@property (nonatomic, assign) NSInteger     type;
@property (nonatomic, copy) NSString        *detailID;
@property (nonatomic, copy) NSArray         *cssURLStrings;

@end
