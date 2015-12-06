//
//  Story.h
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/12/5.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface Story : BaseModel

@property (nonatomic, strong)   NSDate          *date;
@property (nonatomic, copy)     NSString        *title;
@property (nonatomic, copy)     NSString        *gaPrefix;
@property (nonatomic, strong)   NSArray         *imageURLs;
@property (nonatomic, copy)     NSString        *topImageURL;
@property (nonatomic, assign)   NSUInteger      type;
@property (nonatomic, strong)   NSString        *storyID;
@property (nonatomic, assign)   BOOL            multipic;
@property (nonatomic, assign)   BOOL            hasRead;

@end
