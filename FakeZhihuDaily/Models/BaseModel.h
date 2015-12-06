//
//  BaseModel.h
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/12/6.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)jsonDictionary;

+ (NSArray *)modelArrayWithJSONArray:(NSArray *)jsonArray;

- (NSDictionary *)customPropertyMapper;

- (NSDictionary *)customModelPropertyMapper;

- (NSDictionary *)arrayModelMapper;

@end
