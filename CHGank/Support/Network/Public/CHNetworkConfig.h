//
//  CHNetworkConfig.h
//  CHNetwork
//
//  Created by ChiHo on 6/28/15.
//  Copyright (c) 2015 ChiHo. All rights reserved.
//

#import "CHBaseResponse.h"

@interface CHNetworkConfig : CHBaseResponse

/**
 *  请求类型
 */
typedef NS_ENUM(NSInteger, CHRequestType) {
    // 福利页
    CHRequestTypeImagePage,
};

/**
 *  通过类型获取请求配置
 *
 *  @param type 类型
 *
 *  @return 请求配置
 */
+ (NSDictionary *)networkRequestConfigWithType:(CHRequestType)type;

+ (void)parseResponseWithResponse:(id)responseObject
                         userInfo:(NSDictionary *)userInfo
                          success:(void (^)(id responseObject, NSDictionary *userInfo))success
                          failure:(void (^)(NSInteger errCode, NSString *errMsg, NSDictionary *userInfo))failure;

@end
