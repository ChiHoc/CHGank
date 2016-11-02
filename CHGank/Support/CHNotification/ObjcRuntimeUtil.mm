//
//  ObjcRuntimeUtil.m
//  ChiHo
//
//  Created by ChiHo on 3/17/15.
//  Copyright (c) 2015 ChiHo. All rights reserved.
//

#import "ObjcRuntimeUtil.h"
#import "CHNotificationCenter.h"

/**
 *  获取指定协议的所有方法
 *
 *  @param proto      协议
 *  @param arrMethods 方法
 */
static void getAllMethodForProtocol(CHExtKey proto, std::vector<objc_method_description>& arrMethods)
{
    // <NSObject> 就不处理了
    if (protocol_isEqual(proto, @protocol(NSObject))) {
        return;
    }
    
    unsigned int protoCount = 0;
    __unsafe_unretained CHExtKey* arrProto = protocol_copyProtocolList(proto, &protoCount);
    if (arrProto != NULL && protoCount > 0)
    {
        for (unsigned int index = 0; index < protoCount; index++)
        {
            getAllMethodForProtocol(arrProto[index], arrMethods);
        }
        free(arrProto);
    }
    
    unsigned int optionalCount = 0;
    objc_method_description* optionalMethods = protocol_copyMethodDescriptionList(proto, NO, YES, &optionalCount);
    if (optionalMethods != NULL && optionalCount > 0)
    {
        arrMethods.insert(arrMethods.end(), optionalMethods, optionalMethods+optionalCount);
        free(optionalMethods);
    }
    
    unsigned int requiredCount = 0;
    objc_method_description* requiredMethods = protocol_copyMethodDescriptionList(proto, YES, YES, &requiredCount);
    if (requiredMethods != NULL && requiredCount > 0)
    {
        arrMethods.insert(arrMethods.end(), requiredMethods, requiredMethods+requiredCount);
        free(requiredMethods);
    }
}


@implementation ObjcRuntimeUtil

/**
 *  判断一个类是否继承某个类
 *
 *  @param oneClass  类
 *  @param baseClass 类
 *
 *  @return 是否继承
 */
+ (BOOL)isClass:(Class)oneClass inheritsFromClass:(Class)baseClass
{
    Class cls = oneClass;
    while(cls)
    {
        if (cls == baseClass)
        {
            return YES;
        }
        cls = class_getSuperclass(cls);
    }
    
    return NO;
}

/**
 *  获取指定协议的所有方法
 *
 *  @param proto 协议
 *
 *  @return 方法
 */
+ (std::vector<objc_method_description>)getAllMethodOfProtocol:(Protocol*) proto
{
    std::vector<objc_method_description> arrMethos;
    
    getAllMethodForProtocol(proto, arrMethos);
    
    return arrMethos;
}


@end
