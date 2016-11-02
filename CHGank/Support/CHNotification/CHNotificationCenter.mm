//
//  ExtensionCenter.m
//  ChiHo
//
//  Created by ChiHo on 13-12-14.
//  Copyright (c) 2013年 ChiHo. All rights reserved.
//

#import "CHNotificationCenter.h"
#import "ObjcRuntimeUtil.h"
#import "LogConfig.h"
#import "NSMutableObject+SafeInsert.h"

// 每5分钟清理一次
static const NSInteger EXTENSION_CLEAN_TIME = 5*60;

@implementation CHObserverObject

/**
 *  判断监听对象是否一样
 *
 *  @param object 对象
 *
 *  @return 是否一样
 */
- (BOOL)isObjectEqual:(id)object
{
	if (_deleteFlag == YES)
    {
		return NO;
	}
    if (_observer == nil)
    {
        _deleteFlag = YES;
        return NO;
    }
	if (_observer == object)
    {
		return YES;
	}
    
	return NO;
}

/**
 *  使用监听对象初始化
 *
 *  @param observer 对象
 *
 *  @return 实例对象
 */
- (id)initWithObserver:(id)observer
{
	if (self = [super init])
    {
        _deleteFlag = NO;
        self.observer = observer;
	}
	return self;
}

- (void)dealloc
{
    _observer = nil;
}

@end

@implementation CHExtensionDictionary

#pragma mark - 初始化

- (id)init
{
	if (self = [super init])
    {
		_extensionDic = [[NSMutableDictionary alloc] init];
		_isNeedCleanUp = NO;
	}
	return self;
}

- (void)dealloc
{
    _extensionDic = nil;
}

#pragma mark - 实例方法

/**
 *  注册监听对象
 *
 *  @param observer  监听对象
 *  @param oKey      监听值
 *
 *  @return 是否成功
 */
- (BOOL)registerObserver:(id)observer
                  forKey:(id)oKey
{
	if (observer == nil || oKey == nil)
    {
        CHLogError();
		return NO;
	}
    
	NSMutableArray *oberverArr = [_extensionDic objectForKey:oKey];
	if (oberverArr == nil)
	{
		oberverArr = [[NSMutableArray alloc] init];
		[_extensionDic safeSetObject:oberverArr forKey:oKey];
	}
	
	for(CHObserverObject *observerObj in oberverArr)
	{
		if ([observerObj isObjectEqual:observer])
		{
			return NO;
		}
	}
	
	CHObserverObject *observerObj = [[CHObserverObject alloc] initWithObserver:observer];
	[oberverArr safeAddObject:observerObj];
    
	return YES;
}

/**
 *  取消注册监听对象
 *
 *  @param observer  监听对象
 *  @param oKey      监听值
 *
 *  @return 是否成功
 */
- (BOOL)unregisterObserver:(id)observer
                    forKey:(id)oKey
{
	if (observer == nil)
    {
        CHLogError();
		return NO;
	}
	
	NSArray *oberverArr = [_extensionDic objectForKey:oKey];
	for(CHObserverObject *observerObj in oberverArr)
	{
		if ([observerObj isObjectEqual:observer])
		{
            observerObj.observer = nil;
			observerObj.deleteFlag = YES;
            
			return YES;
		}
	}
	return NO;
}

/**
 *  取消注册监听对象
 *
 *  @param observer 监听对象
 *
 *  @return 是否成功
 */
- (BOOL)unregisterKeyObserver:(id)observer
{
	BOOL isFound = NO;
	
    for(NSArray *selectorImp in [_extensionDic allValues])
    {
		for(CHObserverObject *observerObj in selectorImp)
		{
			if ([observerObj isObjectEqual:observer])
            {
                observerObj.observer = nil;
				observerObj.deleteFlag = YES;
				
				isFound = YES;
				break;
			}
		}
	}
	
	if (isFound)
    {
		_isNeedCleanUp = YES;
	}
	return isFound;
}

/**
 *  获取对应key的监听对象列表
 *
 *  @param oKey 监听值
 *
 *  @return 监听对象列表
 */
- (NSArray *)observerList:(id)oKey
{
	return [_extensionDic objectForKey:oKey];
}

/**
 *  清理无用扩展
 */
- (void)cleanUp
{
	if (!_isNeedCleanUp)
    {
		return;
	}
    
	_isNeedCleanUp = NO;
	
	for (id oKey in [_extensionDic allKeys])
	{
		NSMutableArray *observerArr = [_extensionDic objectForKey:oKey];
		for (UInt32 index = 0; index < observerArr.count; )
		{
			CHObserverObject *observerObj = [observerArr objectAtIndex:index];
			if (observerObj.deleteFlag)
			{
				[observerArr safeRemoveObjectAtIndex:index];
				continue;
			}
			index ++;
		}
		
		if (observerArr.count == 0)
		{
			[_extensionDic safeRemoveObjectForKey:oKey];
		}
	}
}

@end


@implementation CHExtension

#pragma mark - 初始化

- (id)initWithKey:(CHExtKey) oKey
{
    self = [super init];
	if (self)
	{
		_selectorObserver = nil;
		_keyObserver = nil;
		_extKey = oKey;
		
		// copy all selectors
		std::vector<objc_method_description> methodArr = [ObjcRuntimeUtil getAllMethodOfProtocol:oKey];
		
		_methodCount = (unsigned int)methodArr.size();
		if (_methodCount > 0)
		{
			_methods = new objc_method_description[_methodCount];
			std::copy(methodArr.begin(), methodArr.end(), _methods);
		}
	}
	return self;
}

- (void)dealloc
{
    _extKey = nil;
    _selectorObserver = nil;
    _keyObserver = nil;
    free(_methods);
}

#pragma mark - 方法监听

/**
 *  注册方法监听
 *
 *  @param observer 监听对象
 *
 *  @return 是否成功
 */
- (BOOL)registerObserver:(id)observer
{
//    CHLOG(@"%p", observer);
	if ([observer conformsToProtocol:_extKey] == NO)
    {
		return NO;
	}
	if (_selectorObserver == nil)
    {
		_selectorObserver = [[CHExtensionDictionary alloc] init];
	}
    
	Class cls = [observer class];
	for (unsigned int index = 0; index < _methodCount; index++)
	{
		objc_method_description* method = &_methods[index];
		
		if (class_respondsToSelector(cls, method->name))
		{
			[_selectorObserver registerObserver:observer
                                         forKey:NSStringFromSelector(method->name)];
		}
	}
	return YES;
}

/**
 *  取消注册方法监听对象
 *
 *  @param observer 监听对象
 */
- (void)unregisterObserver:(id)observer
{
    if (![_selectorObserver unregisterKeyObserver:observer])
    {
        CHLogError();
    }
}

/**
 *  获取监听对象列表
 *
 *  @param selector 监听方法
 *
 *  @return 监听对象列表
 */
- (NSArray *)observerListForSelector:(SEL)selector
{
    return [_selectorObserver observerList:NSStringFromSelector(selector)];
}

#pragma mark - 键值监听

/**
 *  注册键值监听对象
 *
 *  @param observer 监听对象
 *  @param oKey     监听值
 *
 *  @return 是否成功
 */
- (BOOL)registerKeyObserver:(id)observer
                     forKey:(id)oKey
{
	if ([observer conformsToProtocol:oKey] == NO)
	{
		return NO;
	}
	
	if (_keyObserver == nil)
	{
		_keyObserver = [[CHExtensionDictionary alloc] init];
	}
	[_keyObserver registerObserver:observer
                            forKey:oKey];
	
	return YES;
}


/**
 *  取消注册键值监听对象
 *
 *  @param observer 监听对象
 *  @param oKey     监听值
 */
- (void)unregisterKeyObserver:(id)observer
                       forKey:(id)oKey
{
	if (![_keyObserver unregisterObserver:observer
                                  forKey:oKey])
    {
        CHLogError();
    }
}

/**
 *  取消注册键值监听对象
 *
 *  @param observer 监听对象
 */
- (void)unregisterKeyObserver:(id)observer
{
	if (![_keyObserver unregisterKeyObserver:observer])
    {
        CHLogError();
    }
}

/**
 *  获取键值监听对象列表
 *
 *  @param oKey 监听值
 *
 *  @return 监听对象列表
 */
- (NSArray *)keyObserverList:(id)oKey
{
	return [_keyObserver observerList:oKey];
}

/**
 *  清理无用监听
 */
- (void)cleanUp
{
	[_selectorObserver cleanUp];
	[_keyObserver cleanUp];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ => {\n%@,\nkey_ext:\n%@\n}",NSStringFromProtocol(_extKey), _selectorObserver, _keyObserver];
}

@end


@implementation CHNotificationMgr

#pragma mark - 类方法

static dispatch_once_t onceToken;

+ (CHNotificationMgr *)sharedInstance
{
    static CHNotificationMgr *_sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[CHNotificationMgr alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
	if (self)
	{
		_extensionDic = [[NSMutableDictionary alloc] init];
		
		[self performSelector:@selector(cleanUp)
                   withObject:nil
                   afterDelay:EXTENSION_CLEAN_TIME];
        
	}
	return self;
}

/**
 *  根据值获取对应的扩展对象
 *
 *  @param extKey 值
 *
 *  @return 扩展对象
 */
- (CHExtension *)extensionWithKey:(CHExtKey)extKey;
{
	NSString *key = NSStringFromProtocol(extKey);
	
	CHExtension *ext = [_extensionDic objectForKey:key];
	
	if (ext == nil)
	{
		ext = [[CHExtension alloc] initWithKey:extKey];
		
		[_extensionDic safeSetObject:ext forKey:key];
	}
	return ext;
}

/**
 *  清楚无用监听
 */
- (void)cleanUp
{
	for (CHExtension *ext in [_extensionDic allValues])
    {
		[ext cleanUp];
	}
    
	[self performSelector:@selector(cleanUp)
               withObject:nil
               afterDelay:EXTENSION_CLEAN_TIME];
}

@end
