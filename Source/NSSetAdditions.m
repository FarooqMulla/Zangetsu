/*
//  NSSetAdditions.m
//  Zangetsu
//
//  Created by Colin Wheeler on 11/15/10.
//  Copyright 2010. All rights reserved.
//
 
 Copyright (c) 2013, Colin Wheeler
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 - Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "NSSetAdditions.h"


@implementation NSSet (CWNSSetAdditions)

-(void)cw_each:(void (^)(id obj, BOOL *stop))block {
	[self enumerateObjectsUsingBlock:block];
}

-(void)cw_eachConcurrentlyWithBlock:(void (^)(id obj,BOOL *stop))block {
	[self enumerateObjectsWithOptions:NSEnumerationConcurrent
						   usingBlock:block];
}

-(id)cw_findWithBlock:(BOOL (^)(id obj))block {
	for(id obj in self){
		if(block(obj)) return obj;
	}
	return nil;
}

-(BOOL)cw_isObjectInSetWithBlock:(BOOL (^)(id obj))block {
	return ([self cw_findWithBlock:block] ? YES : NO);
}

#if Z_HOST_OS_IS_MAC_OS_X
-(NSHashTable *)cw_findAllIntoWeakRefsWithBlock:(BOOL (^)(id))block {
	NSHashTable *results = [NSHashTable hashTableWithWeakObjects];
	[self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
		if (block(obj)) [results addObject:obj];
	}];
	return results;
}
#endif

-(NSSet *)cw_mapSet:(id (^)(id obj))block {
	NSMutableSet *mappedSet = [NSMutableSet set];
	[self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
		id rObj = block(obj);
		if (rObj) [mappedSet addObject:rObj];
	}];
    return mappedSet;
}

@end
