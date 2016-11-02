//
//  CHBaseResponse.m
//  CHNetwork
//
//  Created by ChiHo on 6/28/15.
//  Copyright (c) 2015 ChiHo. All rights reserved.
//

#import "CHBaseResponse.h"

@implementation CHBaseResponse

+ (NSError *)parseErrorWithResponse:(id)responseObject
{
    NSError *error = nil;
    if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject[@"error"] boolValue] == true) {
        if ([[responseObject valueForKeyPath:@"error"] isKindOfClass:[NSString class]]){
            error = [NSError errorWithDomain:kAppDomain
                                        code:kNetworkServerErrorCode
                                    userInfo:@{@"message" : [responseObject valueForKeyPath:@"error"],
                                               @"name" : [responseObject valueForKeyPath:@"error"]}];
        } else if ([[responseObject valueForKeyPath:@"error"] isKindOfClass:[NSDictionary class]]) {
            error = [NSError errorWithDomain:kAppDomain
                                        code:kNetworkServerErrorCode
                                    userInfo:[responseObject valueForKeyPath:@"error"]];
        } else {
            error = [NSError errorWithDomain:kAppDomain
                                        code:kNetworkServerErrorCode
                                    userInfo:@{@"message" : LS(@"未知错误"),
                                               @"name" : @"Unknown Error"}];
        }
    }
    return error;
}

@end
