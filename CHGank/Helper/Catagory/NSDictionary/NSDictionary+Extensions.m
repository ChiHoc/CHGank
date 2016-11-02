//
//  NSDictionary+Extensions.m
//  Quketi
//
//  Created by ChiHo on 6/8/15.
//  Copyright (c) 2015 YouthMBA. All rights reserved.
//

#import "NSDictionary+Extensions.h"

@implementation NSDictionary (Extensions)

/**
 *  根据键值获取对象
 *
 *  @param aKey 键值
 *
 *  @return 对象
 */
- (id)objectOrNilForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


@end
