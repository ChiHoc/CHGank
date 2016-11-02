//
//  NSMutableObject+SafeInsert.h
//  ChiHo
//
//  Created by ChiHo on 13-12-14.
//  Copyright (c) 2013年 ChiHo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (SafeInsert)

- (void) safeSetObject:(id)anObject forKey:(id)aKey;
- (void) safeRemoveObjectForKey:(id)aKey;

@end

@interface NSMutableSet (SafeInsert)

- (void) safeAddObject:(id)object;
- (void) safeRemoveObject:(id)object;

@end

@interface NSMutableArray (SafeInsert)

- (void) safeAddObject:(id)anObject;
- (void) safeInsertObject:(id)anObject atIndex:(NSUInteger)index;
- (void) safeRemoveObjectAtIndex:(NSUInteger)index;
- (void) safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
- (id)firstObject;
- (void) removeFirstObject;

@end

