//
//  CHBaseResponse.h
//  CHNetwork
//
//  Created by ChiHo on 6/28/15.
//  Copyright (c) 2015 ChiHo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHBaseResponse : NSObject

/**
 *  解析返回中的错误信息
 *
 *  @param responseObject 网络返回
 *
 *  @return 错误信息
 */
+ (NSError *)parseErrorWithResponse:(id)responseObject;

@end
