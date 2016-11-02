//
//  ExtensionCenter.h
//  ChiHo
//
//  Created by ChiHo on 13-12-14.
//  Copyright (c) 2013年 ChiHo. All rights reserved.
//

#import <Foundation/Foundation.h>

struct objc_method_description;

/**
 *  封装一个监听类方便统一回收
 */
@interface CHObserverObject : NSObject

@property (nonatomic, unsafe_unretained) id observer;
@property (nonatomic, assign) BOOL deleteFlag;

- (BOOL)isObjectEqual:(id)object;

@end


@interface CHExtensionDictionary : NSObject
{
	NSMutableDictionary *_extensionDic;
	BOOL _isNeedCleanUp;
}

- (BOOL)registerObserver:(id)observer
                  forKey:(id)oKey;
- (BOOL)unregisterObserver:(id)observer
                    forKey:(id)oKey;
- (BOOL)unregisterKeyObserver:(id)observer;
- (NSArray *)observerList:(id)oKey;

- (void)cleanUp;

@end

typedef Protocol* CHExtKey;

/* extension. keep observer list.
 1. Ext -> Observer list
 2. Ext, key -> Observer List.
 key一般用nsstring
 */
@interface CHExtension : NSObject
{
    CHExtKey _extKey;
    
	// selector
	unsigned int _methodCount;
	struct objc_method_description *_methods;
	
	// selector -> instance
	CHExtensionDictionary	*_selectorObserver;
	
	// key -> instance
	CHExtensionDictionary *_keyObserver;
}

- (BOOL)registerObserver:(id)observer;
- (void)unregisterObserver:(id)observer;
- (NSArray *)observerListForSelector:(SEL)selector;

- (BOOL)registerKeyObserver:(id)observer
                     forKey:(id)oKey;
- (void)unregisterKeyObserver:(id)observer
                       forKey:(id)oKey;
- (void)unregisterKeyObserver:(id)observer;
- (NSArray *)keyObserverList:(id)oKey;

- (void)cleanUp;

@end

@interface CHNotificationMgr : NSObject
{
	//(MMExtKey -> MMExtension)
	NSMutableDictionary *_extensionDic;
}

#pragma mark - 类方法

+ (CHNotificationMgr *)sharedInstance;

- (CHExtension *)extensionWithKey:(CHExtKey)extKey;

@end

#define REGISTER_EXTENSION(ext, obj)	\
do { \
    CHExtension *__oExt__ = [[CHNotificationMgr sharedInstance] extensionWithKey:@protocol(ext)]; \
    if (__oExt__) \
    { \
        [__oExt__ registerObserver:obj]; \
    } \
} while(0)

#define UNREGISTER_EXTENSION(ext, obj)	\
do { \
    CHExtension *__oExt__ = [[CHNotificationMgr sharedInstance] extensionWithKey:@protocol(ext)]; \
    if (__oExt__) \
    { \
        [__oExt__ unregisterObserver:obj]; \
    } \
} while(0)

#define SAFECALL_EXTENSION(ext, sel, func)	\
do { \
    CHExtension *__oExt__ = [[CHNotificationMgr sharedInstance] extensionWithKey:@protocol(ext)]; \
    if (__oExt__) \
    { \
        NSArray *__ary__ = [__oExt__ observerListForSelector:sel]; \
        for(UInt32 __index__ = 0; __index__ < __ary__.count; __index__++) \
        { \
            CHObserverObject *__obj__ = [__ary__ objectAtIndex:__index__]; \
            if (__obj__.deleteFlag == YES) \
                continue; \
            id __oExtObj__ = [__obj__ observer]; \
            { \
                dispatch_async(dispatch_get_main_queue(), ^{ \
                    [__oExtObj__ func]; \
                }); \
            } \
        } \
    } \
} while(0)

//{
//    CHExtension *ext = [[CHNotificationMgr sharedInstance] extensionWithKey:@protocol(ext)];
//    if (ext)
//    {
//        NSArray *ary = [ext observerListForSelector:sel];
//        for(UInt32 index = 0; index < ary.count; index++)
//        {
//            CHObserverObject *obj = [ary objectAtIndex:index];
//            if (obj.deleteFlag == YES)
//                continue;
//            id extObj = [obj observer];
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [extObj func];
//                });
//            }
//        }
//    }
//}
