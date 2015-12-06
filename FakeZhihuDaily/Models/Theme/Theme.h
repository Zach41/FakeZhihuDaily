//
//  Theme.h
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/12/6.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseModel.h"


@interface Theme : BaseModel

@property (nonatomic, copy) NSString    *color;
@property (nonatomic, copy) NSString     *thumbnailURL;
@property (nonatomic, copy) NSString    *themeDescription;
@property (nonatomic, assign) NSInteger themeID;
@property (nonatomic, copy) NSString    *name;

@end
