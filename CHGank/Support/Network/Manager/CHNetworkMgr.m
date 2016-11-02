//
//  CHNetworkMgr.m
//  CHNetwork
//
//  Created by ChiHo on 6/28/15.
//  Copyright (c) 2015 ChiHo. All rights reserved.
//

#import "CHNetworkMgr.h"
#import "CHAFAPIClient.h"
#import "CHNetworkConfig.h"

@implementation CHNetworkMgr

#pragma mark - 类方法

+ (CHNetworkMgr *)sharedInstance
{
    static dispatch_once_t onceToken;
    static CHNetworkMgr *_sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[CHNetworkMgr alloc] init];
    });
    
    return _sharedInstance;
}

#pragma mark - 方法

- (NSURLSessionDataTask *)requestDataWithType:(CHRequestType)type
                                     formData:(NSDictionary *)formData
                                   parameters:(NSDictionary *)params
                                     userInfo:(NSDictionary *)userInfo
                                     progress:(void (^)(float progress))progress
                                      success:(void (^)(id responseObject, NSDictionary *userInfo))success
                                      failure:(void (^)(NSInteger errCode, NSString *errMsg, NSDictionary *userInfo))failure
{
    return [self requestDataWithRetryTimes:kNetworkRetryTimes
                                      type:type
                                  formData:formData
                                parameters:params
                           timeoutInterval:kNetworkTimeoutInterval
                                  userInfo:userInfo
                                  progress:progress
                                  success:success
                                   failure:failure];
}

- (NSURLSessionDataTask *)requestDataWithRetryTimes:(NSUInteger)ntimes
                                               type:(CHRequestType)type
                                           formData:(NSDictionary *)formData
                                         parameters:(NSDictionary *)params
                                    timeoutInterval:(NSTimeInterval)timeoutInterval
                                           userInfo:(NSDictionary *)userInfo
                                           progress:(void (^)(float progress))progress
                                            success:(void (^)(id responseObject, NSDictionary *userInfo))success
                                            failure:(void (^)(NSInteger errCode, NSString *errMsg, NSDictionary *userInfo))failure
{
    NSDictionary *requestConfig = [CHNetworkConfig networkRequestConfigWithType:type];
    NSString *requestPath = requestConfig[@"Path"];
    NSString *method = requestConfig[@"Method"];
    NSMutableDictionary *mutableParams = [[NSMutableDictionary alloc] initWithDictionary:params];
    return [[CHAFAPIClient sharedClient] requestDataWithPath:requestPath
                                                      method:method
                                                  parameters:mutableParams
                                             timeoutInterval:timeoutInterval
                                                    formData:formData
                                                    progress:^(NSProgress * _Nonnull downloadProgress) {
                                                        if (progress && downloadProgress.completedUnitCount && downloadProgress.totalUnitCount) {
                                                            progress((float)downloadProgress.completedUnitCount / (float)downloadProgress.totalUnitCount);
                                                        }
                                                    }
                                                     success:^(id responseObject) {
                                                         [CHNetworkConfig parseResponseWithResponse:responseObject
                                                                                           userInfo:userInfo
                                                                                            success:(void (^)(id responseObject, NSDictionary *userInfo))success
                                                                                            failure:(void (^)(NSInteger errCode, NSString *errMsg, NSDictionary *userInfo))failure];
                                                     } failure:^(NSError *error) {
                                                         if (ntimes == 0) {
                                                             CHLOG(@"CHRequestType:%ld, %@", (long)type, error.userInfo);
                                                             if (failure) {
                                                                 failure(error.code, error.domain, userInfo);
                                                             }
                                                         } else {
                                                             NSInteger retryTimes = [userInfo[@"retryTimes"] integerValue];
                                                             NSMutableDictionary *mutableInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
                                                             mutableInfo[@"retryTimes"] = @(retryTimes + 1);
                                                             CHLOG(@"CHRequestType:%ld, 网络超时, 尝试第%d次重试, 超时设置%0.1lf秒", (long)type, (int)retryTimes + 1, timeoutInterval * 2);
                                                             [self requestDataWithRetryTimes:ntimes - 1
                                                                                        type:type
                                                                                    formData:formData
                                                                                  parameters:params
                                                                             timeoutInterval:timeoutInterval * 2
                                                                                    userInfo:mutableInfo
                                                                                    progress:progress
                                                                                    success:success
                                                                                     failure:failure];
                                                         }
                                                     }];
}

@end
