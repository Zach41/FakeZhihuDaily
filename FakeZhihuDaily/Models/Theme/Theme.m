//
//  Theme.m
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/12/6.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import "Theme.h"

@implementation Theme

- (NSDictionary *)customPropertyMapper {
    return @{
             @"color"       : @"color",
             @"thumbnail"   : @"thumbnailURL",
             @"description" : @"themeDescription",
             @"id"          : @"themeID",
             @"name"        : @"name"
             };
}
    
@end
