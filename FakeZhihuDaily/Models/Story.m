//
//  Story.m
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/12/5.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import "Story.h"

@implementation Story

- (NSDictionary *)customPropertyMapper {
    return @{
             @"type"        : @"type",
             @"id"          : @"storyID",
             @"ga_prefix"   : @"gaPrefix",
             @"title"       : @"title",
             @"image"       : @"topImageURL",
             @"images"      : @"imageURLs",
             @"multipic"    : @"multipic"
             };
}

- (NSDictionary *)arrayModelMapper {
    return @{
             @"imageURLs"   : @"NSURL"
             };
}




@end
