//
//  CHNetworkMgr.h
//  CHNetwork
//
//  Created by ChiHo on 6/28/15.
//  Copyright (c) 2015 ChiHo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHNetworkConfig.h"

@interface CHNetworkMgr : NSObject

/**
 *  获取单例
 *
 *  @return 单例
 */
+ (CHNetworkMgr *)sharedInstance;

/**
 *  网络请求,回调使用代理方法
 *
 *  @param type     请求类型
 *  @param formData 表格数据
 *  @param params   参数
 *  @param userInfo 用户数组
 *  @param progress 进度
 *  @param success  成功回调
 *  @param failure  失败回调
 *
 *  @return 下载进程
 */
- (NSURLSessionDataTask *)requestDataWithType:(CHRequestType)type
                                     formData:(NSDictionary *)formData
                                   parameters:(NSDictionary *)params
                                     userInfo:(NSDictionary *)userInfo
                                     progress:(void (^)(float progress))progress
                                      success:(void (^)(id responseObject, NSDictionary *userInfo))success
                                      failure:(void (^)(NSInteger errCode, NSString *errMsg, NSDictionary *userInfo))failure;


/**
 *  网络请求
 *
 *  @param ntimes    重试次数
 *  @param type      请求类型
 *  @param formData  表格数据
 *  @param params    参数
 *  @param timeoutInterval 超时时间
 *  @param userInfo  用户数组
 *  @param progress  进度
 *  @param success  成功回调
 *  @param failure  失败回调
 *
 *  @return 下载进程
 */
- (NSURLSessionDataTask *)requestDataWithRetryTimes:(NSUInteger)ntimes
                                               type:(CHRequestType)type
                                           formData:(NSDictionary *)formData
                                         parameters:(NSDictionary *)params
                                    timeoutInterval:(NSTimeInterval)timeoutInterval
                                           userInfo:(NSDictionary *)userInfo
                                           progress:(void (^)(float progress))progress
                                            success:(void (^)(id responseObject, NSDictionary *userInfo))success
                                            failure:(void (^)(NSInteger errCode, NSString *errMsg, NSDictionary *userInfo))failure;

@end
