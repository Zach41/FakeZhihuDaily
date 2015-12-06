//
//  ZhihuClient.m
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/12/5.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import "ZhihuClient.h"

static NSString const *kBaseURL = @"http://news-at.zhihu.com/api/4/";

@interface ZhihuClient ()

@property (nonatomic, copy, readwrite) NSString *baseURL;
@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;

@end

@implementation ZhihuClient

+ (instancetype)sharedClient {
    static ZhihuClient *sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[ZhihuClient alloc] init];
        sharedClient.requestManager = [AFHTTPRequestOperationManager manager];
        sharedClient.baseURL = [kBaseURL copy];
        sharedClient.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
        sharedClient.requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        sharedClient.requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [sharedClient.requestManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    });
    
    return sharedClient;
}

- (AFHTTPRequestOperation *)getWithURL:(NSString *)urlString parameters:(NSDictionary *)parameters success:(successOperationBlock)successBlock failure:(failureOperationBlock)failureBlock {
    return [self requestWithMethod:@"GET"
                               URL:urlString
                        parameters:parameters
                           success:successBlock
                           failure:failureBlock];
}

- (AFHTTPRequestOperation *)postWithURL:(NSString *)urlString parameters:(NSDictionary *)parameters success:(successOperationBlock)successBlock failure:(failureOperationBlock)failureBlock {
    return [self requestWithMethod:@"POST"
                               URL:urlString
                        parameters:parameters
                           success:successBlock
                           failure:failureBlock];
}

#pragma mark - Private
- (AFHTTPRequestOperation *)requestWithMethod:(NSString *)method
                                          URL:(NSString *)urlString
                                   parameters:(NSDictionary *)parameters
                                      success:(successOperationBlock)success
                                      failure:(failureOperationBlock)failure {
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", _baseURL, urlString];
    if ([method isEqualToString:@"GET"]) {
        return [_requestManager GET:fullURL
                  parameters:parameters
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         if (success) {
                             success(operation, responseObject);
                         }
                     }
                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         if (failure) {
                             failure(operation, error);
                         }
                     }];
    } else if ([method isEqualToString:@"POST"]) {
        return [_requestManager POST:fullURL
                          parameters:parameters
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 if (success) {
                                     success(operation, responseObject);
                                 }
                             }
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 if (failure) {
                                     failure(operation, error);
                                 }
                             }];
    }
    return nil;
}
@end
