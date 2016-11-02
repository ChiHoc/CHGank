//
//  GKManager.m
//  CHGank
//
//  Created by ChiHo on 8/1/15.
//  Copyright (c) 2015 ChiHo. All rights reserved.
//

#import "GKManager.h"

@implementation GKManager

#pragma mark - 类方法

+ (id)sharedInstance
{
    static GKManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[GKManager alloc] init];
    });
    return _sharedInstance;
}

- (CHNetworkMgr *)networkMgr
{
    return [CHNetworkMgr sharedInstance];
}

@end
