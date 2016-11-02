//
//  GKConstants.h
//  CHGank
//
//  Created by ChiHo on 6/2/16.
//  Copyright © 2016 ChiHo. All rights reserved.
//

#ifndef GKConstants_h
#define GKConstants_h

static const NSInteger kNetworkServerErrorCode = 2727;
#ifdef DEBUG
static NSString *const kAppDomain = @"http://gank.io/api";
static const NSInteger kNetworkRetryTimes = 2;
static const NSTimeInterval kNetworkTimeoutInterval = 4;
#else
static NSString *const kAppDomain = @"http://gank.io/api";
static const NSInteger kNetworkRetryTimes = 2;
static const NSTimeInterval kNetworkTimeoutInterval = 4;
#endif

#define color_d3ccc6 RGB(0xd3, 0xcc, 0xc6)
#define color_fffdf8 RGB(0xff, 0xfd, 0xf8)
#define color_fffcf2 RGB(0xff, 0xfc, 0xf2)
#define color_4f331a RGB(0x4f, 0x33, 0x1a)
#define color_c4bbb2 RGB(0xc4, 0xbb, 0xb2)

#endif /* GKConstants_h */
