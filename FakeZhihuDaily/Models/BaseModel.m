//
//  BaseModel.m
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/12/6.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (instancetype)initWithDictionary:(NSDictionary *)jsonDictionary {
    self = [super init];
    
    if (self) {
        [self setValuesForKeysWithDictionary:jsonDictionary];
    }
    
    return self;
}

+ (NSArray *)modelArrayWithJSONArray:(NSArray *)jsonArray {
    NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:jsonArray.count];
    
    for (id info in jsonArray) {
        if(![info isKindOfClass:[NSDictionary class]])
            return nil;
        
        [modelArray addObject:[[self alloc] initWithDictionary:info]];
    }
    
    return [modelArray copy];
}

- (NSDictionary *)customPropertyMapper {
    // 子类应该返回一个映射字典
    return nil;
}

- (NSDictionary *)customModelPropertyMapper {
    return nil;
}

- (NSDictionary *)arrayModelMapper {
    return nil;
}

#pragma mark - KeyValue Coding

- (void)setValue:(id)value forKey:(NSString *)key {
    NSDictionary *propertyMapper = [self customPropertyMapper];
    NSDictionary *arrayMapper = [self arrayModelMapper];
    NSDictionary *modelMapper = [self customModelPropertyMapper];
    
    if ([propertyMapper.allKeys containsObject:key]) {
        if (value == nil) {
            [super setValue:nil forKey:propertyMapper[key]];
        } else if ([arrayMapper.allKeys containsObject:propertyMapper[key]]){
            [self setArray:value forKey:propertyMapper[key]];
        } else if ([modelMapper.allKeys containsObject:propertyMapper[key]]){
            [self setModel:value forKey:propertyMapper[key]];
        } else {
            [super setValue:value forKey:propertyMapper[key]];
        }
    } else {
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"Trying to set an undefined key %@ with value %@", key, value);
}


- (void)setModel:(id)modelValue forKey:(NSString *)key {
    NSDictionary *modelMapper = [self customModelPropertyMapper];
    Class modelClass = NSClassFromString(modelMapper[key]);
    id model = [[modelClass alloc] initWithDictionary:modelValue];
    [super setValue:model forKey:key];
}

- (void)setArray:(id)arrayValue forKey:(NSString *)key {
    if (![arrayValue isKindOfClass:[NSArray class]]) {
        [super setValue:nil forKey:key];
    }
    
    NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:[arrayValue count]];
    
    NSDictionary *arrayMapper = [self arrayModelMapper];
    Class modelClass = NSClassFromString(arrayMapper[key]);
    for (id modelValue in arrayValue) {
        if (![modelValue isKindOfClass:[NSDictionary class]]) {
            // 如果不是字典就认为是OC的类型对象，这样简单判断会有问题，但先这么写了
            typeof(modelClass) tempModel = modelValue;
            [modelArray addObject:tempModel];
            continue;
        }
        id tempModel = [[modelClass alloc] initWithDictionary:modelValue];
        [modelArray addObject:tempModel];
    }
    [super setValue:[modelArray copy] forKey:key];
}

@end
