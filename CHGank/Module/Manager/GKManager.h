//
//  GKManager.h
//  CHGank
//
//  Created by ChiHo on 8/1/15.
//  Copyright (c) 2015 ChiHo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHNetworkMgr.h"

#define QKTShareManager [GKManager sharedInstance]
#define GKShareNetworkMgr [QKTShareManager networkMgr]

@interface GKManager : NSObject

@property (nonatomic, readonly) CHNetworkMgr *networkMgr;

/**
 *  获取单例
 *
 *  @return 单例
 */
+ (id)sharedInstance;

@end
