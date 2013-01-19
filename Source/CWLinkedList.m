/*
//  CWLinkedList.m
//  Zangetsu
//
//  Created by Colin Wheeler on 4/26/12.
//  Copyright (c) 2012. All rights reserved.
//


Copyright (c) 2012 Colin Wheeler

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

#import "CWLinkedList.h"

@interface CWLinkedListNode : NSObject
@property(retain) CWLinkedListNode *next;
@property(retain) id data;
@end

@implementation CWLinkedListNode

- (id)init
{
    self = [super init];
    if (self) {
        _next = nil;
		_data = nil;
    }
    return self;
}

@end

@interface CWLinkedList ()
@property(readwrite,assign) NSUInteger count;
@property(retain) CWLinkedListNode *head;
@property(weak) CWLinkedListNode *tail;
-(BOOL)hasErrorForObjectAtIndex:(NSUInteger)index;
-(CWLinkedListNode *)nodeAtIndex:(NSUInteger)index;
@end

@implementation CWLinkedList

- (id)init
{
    self = [super init];
    if (self) {
        _head = nil;
		_tail = nil;
		_count = 0;
    }
    return self;
}

-(BOOL)hasErrorForAddObject:(id)object
{
	if (!object) {
		CWLogErrorInfo(@"com.Zangetsu.CWLinkedList", 442,
					   @"Trying to add nil object to Linked List Instance");
		return YES;
	}
	
	return NO;
}

-(void)addObject:(id)anObject
{
	if ([self hasErrorForAddObject:anObject]) {
		return;
	}
	
	CWLinkedListNode *node = [[CWLinkedListNode alloc] init];
	node.data = anObject;
	
	if (self.head) {
		self.tail.next = node;
		self.tail = node;
	} else {
		self.head = node;
		self.tail = node;
	}
	
	self.count++;
}

-(BOOL)hasErrorForInsertObject:(id)anObject atIndex:(NSUInteger)index
{
	if (!anObject) {
		CWLogErrorInfo(@"com.Zangetsu.CWLinkedList", 442,
					   @"Trying to add a nil object to the receiver list");
		return YES;
	}
	if (index > (self.count - 1)) {
		CWLogErrorInfo(@"com.Zangetsu.CWLinkedList", 443,
					   @"Trying to insert an item beyond list bounds");
		return YES;
	}
	
	return NO;
}

-(void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
	if ([self hasErrorForInsertObject:anObject atIndex:index]) {
		return;
	}
	
	if (index == 0) {
		CWLinkedListNode *node = [[CWLinkedListNode alloc] init];
		node.data = anObject;
		node.next = self.head;
		self.head = node;
		self.count++;
	} else {
		NSUInteger current = 0;
		CWLinkedListNode *node = self.head;
		while (current != (index - 1)) {
			node = node.next;
			current++;
		}
		CWLinkedListNode *insertNode = [[CWLinkedListNode alloc] init];
		insertNode.data = anObject;
		insertNode.next = node.next;
		node.next = insertNode;
		self.count++;
	}
}

-(void)removeObjectAtIndex:(NSUInteger)index
{
	if (index > (self.count - 1)) {
		CWLogErrorInfo(@"com.Zangetsu.CWLinkedList", 443,
					   @"Trying to retrieve an item beyond list bounds");
		return;
	}
	
	if (index == 0) {
		if (self.count > 1) {
			self.head = self.head.next;
		} else {
			self.head = nil;
			self.tail = nil;
		}
		self.count--;
		return;
	}
	
	NSUInteger current = 0;
	CWLinkedListNode *node = self.head;
	while (current != ( index - 1 )) {
		node = node.next;
		current++;
	}
	
	node.next = node.next.next;
	self.count--;
}

-(BOOL)hasErrorForRemoveObject:(id)object
{
	if (!object) {
		CWLogErrorInfo(@"com.Zangetsu.CWLinkedList", 442,
					   @"passed object is nil");
		return YES;
	}
	if (!self.head) {
		CWLogErrorInfo(@"com.Zangetsu.CWLinkedList", 443,
					   @"trying to remove object in list with no objects");
		return YES;
	}
	return NO;
}

-(void)removeObject:(id)object
{
	if ([self hasErrorForRemoveObject:object]) {
		return;
	}
	
	NSUInteger index = 0;
	NSUInteger max = (self.count - 1);
	CWLinkedListNode *currentNode = self.head;
	
	if ([currentNode.data isEqual:object]) {
		[self removeObjectAtIndex:0];
		return;
	}
	
	do {
		CWLinkedListNode *nextNode = currentNode.next;
		if ([nextNode.data isEqual:object]) {
			currentNode.next = currentNode.next.next;
			nextNode.next = nil;
			self.count--;
			return;
		}
		currentNode = currentNode.next;
		index++;
	} while ((index < max) && currentNode);
	
	CWLogErrorInfo(@"com.Zangetsu.CWLinkedList", 404,
				   @"Object not found in linked list");
}

-(BOOL)hasErrorForObjectAtIndex:(NSUInteger)index
{
	if (!self.head) {
		CWLogErrorInfo(@"com.Zangetsu.CWLinkedList", 442,
					   @"Trying to retrieve a item with an index in an empty list");
		return YES;
	}
	if (index > (self.count - 1)) {
		CWLogErrorInfo(@"com.Zangetsu.CWLinkedList", 443,
					   @"Trying to retrieve an item beyond list bounds");
		return YES;
	}
	return NO;
}

-(CWLinkedListNode *)nodeAtIndex:(NSUInteger)index
{
	NSUInteger current = 0;
	CWLinkedListNode *currentNode = self.head;
	
	while (current != index) {
		currentNode = currentNode.next;
		current++;
	}
	
	return currentNode;
}

-(id)objectAtIndexedSubscript:(NSUInteger)index
{
	return [self objectAtIndex:index];
}

-(void)setObject:(id)object atIndexedSubscript:(NSUInteger)idx
{
	if ([self hasErrorForObjectAtIndex:idx]) {
		return;
	}
	
	CWLinkedListNode *node = [self nodeAtIndex:idx];
	node.data = object;
}

-(void)swapObjectAtIndex:(NSUInteger)index1 withIndex:(NSUInteger)index2
{
	if ([self hasErrorForObjectAtIndex:index1] ||
		[self hasErrorForObjectAtIndex:index2]) {
		return;
	}
	
	CWLinkedListNode *node1 = [self nodeAtIndex:index1];
	CWLinkedListNode *node2 = [self nodeAtIndex:index2];
	
	id temp = node1.data;
	node1.data = node2.data;
	node2.data = temp;
}


-(id)objectAtIndex:(NSUInteger)index
{
	if ([self hasErrorForObjectAtIndex:index]) {
		return nil;
	}
	
	CWLinkedListNode *node = [self nodeAtIndex:index];
	return node.data;
}

-(void)enumerateObjectsWithBlock:(void(^)(id object, BOOL *stop))block
{
	if(!self.head) { return; }
	BOOL shouldStop = NO;
	NSUInteger index = 0;
	NSUInteger max = self.count;
	CWLinkedListNode *currentNode = self.head;
	
	while ((index < max) && currentNode) {
		block(currentNode.data, &shouldStop);
		if(shouldStop == YES) { return; }
		currentNode = currentNode.next;
		index++;
	}
}

@end
