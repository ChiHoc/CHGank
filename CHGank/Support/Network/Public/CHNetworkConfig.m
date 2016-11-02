//
//  CHNetworkConfig.m
//  CHNetwork
//
//  Created by ChiHo on 6/28/15.
//  Copyright (c) 2015 ChiHo. All rights reserved.
//

#import "CHNetworkConfig.h"
#import "GKData.h"

@implementation CHNetworkConfig

+ (NSDictionary *)networkRequestConfigWithType:(CHRequestType)type
{
    NSDictionary *type2Config = @{@(CHRequestTypeImagePage) : @{@"Path" : @"http://gank.io/api/data/%E7%A6%8F%E5%88%A9/10",
                                                                @"Method" : @"GET"},
                                  };
    return type2Config[@(type)];
}

+ (void)parseResponseWithResponse:(id)responseObject
                         userInfo:(NSDictionary *)userInfo
                          success:(void (^)(id responseObject, NSDictionary *userInfo))success
                          failure:(void (^)(NSInteger errCode, NSString *errMsg, NSDictionary *userInfo))failure
{
    [self parseImagePageWithResponse:responseObject
                               block:^(NSDictionary *response, NSError *error) {
                                   if(!response || error) {
                                       if (failure) {
                                           failure(error.code, error.domain, userInfo);
                                       }
                                   } else {
                                       if (success) {
                                           success(response, userInfo);
                                       }
                                   }
                               }];
}

+ (void)parseImagePageWithResponse:(id)responseObject
                             block:(void(^)(NSDictionary *response, NSError *error))block
{
    NSError *error = [self parseErrorWithResponse:responseObject];
    if (error) {
        if (block) {
            block(nil, error);
        }
    } else {
        NSMutableArray *imagePages = [NSMutableArray arrayWithCapacity:[responseObject count]];
        for (NSDictionary *imagePage in responseObject[@"results"]) {
            [imagePages addObject:[[GKData alloc] initWithDictionary:imagePage]];
        }
        if (block) {
            if (imagePages) {
                block(@{@"imagePages" : imagePages}, nil);
            } else {
                block(nil, nil);
            }
        }
    }
}

@end
