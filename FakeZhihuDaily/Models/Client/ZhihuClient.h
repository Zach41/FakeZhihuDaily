//
//  ZhihuClient.h
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/12/5.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef void (^successOperationBlock) (AFHTTPRequestOperation *, id responseObject);
typedef void (^failureOperationBlock) (AFHTTPRequestOperation *, NSError *error);

@interface ZhihuClient : NSObject

@property (nonatomic, copy, readonly) NSString *baseURl;

+ (instancetype)sharedClient;

- (AFHTTPRequestOperation *)getWithURL:(NSString *)urlString
                            parameters:(NSDictionary *)parameters
                               success:(successOperationBlock)successBlock
                               failure:(failureOperationBlock)failureBlock;

- (AFHTTPRequestOperation *)postWithURL:(NSString *)urlString
                             parameters:(NSDictionary *)parameters
                                success:(successOperationBlock)successBlock
                                failure:(failureOperationBlock)failureBlock;


@end
