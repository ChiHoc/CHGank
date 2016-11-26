//
//  CHAFAPIClient.h
//  CHNetwork
//
//  Created by ChiHo on 6/28/15.
//  Copyright (c) 2015 ChiHo. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface CHAFAPIClient : AFHTTPSessionManager

/**
 *  GKAPI client singleton.
 *
 *  @return singleton of API client.
 */
+ (id)sharedClient;

/**
 *  Reset singleton client.
 */
+ (void)resetSharedClient;

/**
 *  Add http header.
 *
 *  @param headerData  value.
 *  @param fieldString filed.
 *
 *  @return API client.
 */
- (id)addHeader:(NSString *)headerData forField:(NSString *)fieldString;

/**
 *  Check network.
 *
 *  @return Reachable or not.
 */
- (BOOL)isNetworkReachable;

/**
 *  网络请求
 *
 *  @param path     请求地址
 *  @param method   请求方法
 *  @param params   参数
 *  @param timeoutInterval 超时时间
 *  @param formData 表格数据
 *  @param progress 进度
 *  @param success  成功回调
 *  @param failure  失败回调
 *
 *  @return 下载进程
 */
- (NSURLSessionDataTask *)requestDataWithPath:(NSString *)path
                                       method:(NSString *)method
                                   parameters:(NSDictionary *)params
                              timeoutInterval:(NSTimeInterval)timeoutInterval
                                     formData:(NSDictionary *)formData
                                     progress:(void (^)(NSProgress *))progress
                                      success:(void (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))failure;

@end
