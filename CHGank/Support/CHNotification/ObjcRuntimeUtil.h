//
//  ObjcRuntimeUtil.h
//  ChiHo
//
//  Created by ChiHo on 3/17/15.
//  Copyright (c) 2015 ChiHo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <vector>

@interface ObjcRuntimeUtil : NSObject

+ (BOOL)isClass:(Class)cls inheritsFromClass:(Class)baseClass;

+ (std::vector<objc_method_description>)getAllMethodOfProtocol:(Protocol*) proto;

@end