//
//  StoryDetail.m
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/12/6.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import "StoryDetail.h"

@implementation StoryDetail

- (NSDictionary *)customPropertyMapper {
    return @{
             @"body"        : @"bodyString",
             @"title"       : @"title",
             @"image"       : @"imageURLString",
             @"share_url"   : @"shareURLString",
             @"ga_prefix"   : @"gaPrefix",
             @"type"        : @"type",
             @"id"          : @"detailID",
             @"css"         : @"cssURLStrings",
             @"image_source": @"imageSourceString"
             };
}

- (NSDictionary *)arrayModelMapper {
    return @{
             @"cssURLStrings"   : @"NSString"
             };
}
@end
