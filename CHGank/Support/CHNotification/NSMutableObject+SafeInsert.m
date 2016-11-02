//
//  NSMutableObject+safeInsert.m
//  ChiHo
//
//  Created by ChiHo on 13-12-14.
//  Copyright (c) 2013年 ChiHo. All rights reserved.
//

#import "NSMutableObject+safeInsert.h"

@implementation NSMutableDictionary (SafeInsert)

- (void) safeSetObject:(id)anObject forKey:(id)aKey {
	if (anObject && aKey) {
		[self setObject:anObject forKey:aKey];
	}
}

- (void) safeRemoveObjectForKey:(id)aKey {
	if (aKey) {
		[self removeObjectForKey:aKey];
	}
}

@end

@implementation NSMutableSet (SafeInsert)

- (void) safeAddObject:(id)object {
	if (object) {
		[self addObject:object];
	}
}

- (void) safeRemoveObject:(id)object {
	if (object) {
		[self removeObject:object];
	}
}

@end

@implementation NSMutableArray (SafeInsert)

- (void) safeAddObject:(id)anObject {
	if (anObject) {
		[self addObject:anObject];
	}
}

- (void) safeInsertObject:(id)anObject atIndex:(NSUInteger)index {
	if (anObject && index <= self.count) {
		[self insertObject:anObject atIndex:index];
	}
}

- (void) safeRemoveObjectAtIndex:(NSUInteger)index {
	if (index < self.count) {
		[self removeObjectAtIndex:index];
	}
}

- (void) safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
	if (index < self.count && anObject) {
		[self replaceObjectAtIndex:index withObject:anObject];
	}
}

- (id)firstObject {
	if (self.count > 0) {
		return [self objectAtIndex:0];
	}
	return nil;
}

- (void) removeFirstObject {
	if (self.count > 0) {
		[self removeObjectAtIndex:0];
    }
}

@end
