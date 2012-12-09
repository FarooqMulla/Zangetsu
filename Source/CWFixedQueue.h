/*
//  CWFixedQueue.h
//  Zangetsu
//
//  Created by Colin Wheeler on 9/10/12.
//
//
 	*/

#import <Foundation/Foundation.h>

/**
 CWFixedQueue

 CWFixedQueue is intended to be a liberal queue data structure. It is
 intended to be a collection object that forces old objects out the queue
 when they surpass the capacity of the data structure. Unlike a strict
 queue, CWFixedQueue can return and set objects at any index in the
 structure. Although CWFixedQueues can be used like NSArrays it should not
 be used for this purpose. CWFixedQueues should be used where you need
 a fixed lenth list where older objects get pushed off the queue.	*/

typedef void (^CWFixedQueueEvictionBlock)(id evictedObject);

@interface CWFixedQueue : NSObject

/**
 Initializes the Queue and sets the capacity property to the NSUInteger passed in
 
 @param capacity a NSUInteger that limits the queue to this number of items it should contain
 @return a new CWFixedQueue instance	*/
-(id)initWithCapacity:(NSUInteger)capacity;

/**
 The maximum # of items the queue should contain	*/
@property(assign) NSUInteger capacity;

/**
 The eviction block is called just before an Object is evicted from the Queue
 
 Providing an eviction block to the queue gives you a chance to do something with
 an object before it is evicted, otherwise it will simply remove the item from
 the queue and not notify you.	*/
@property(copy) CWFixedQueueEvictionBlock evictionBlock;

/**
 Enqueues the object onto the queue
 
 If the object is nil then this method does nothing. If enqueuing this item
 makes the queue over capacity then the queue will remove the oldest items
 till the queue is no longer over capacity.
 
 @param object the object to be enqueued	*/
-(void)enqueue:(id)object;

/**
 Enqueues the objects in array onto the queue
 
 If array is nil or contains 0 objects this method does nothing. Otherwise
 this method will add the objects in array onto the queue. If enqueueing
 these objects makes the queue over capacity then it will remove the
 oldest items until the queue is no longer over capacity.
 
 @param array the array of items to be enqueued	*/
-(void)enqueueObjectsInArray:(NSArray *)array;

/**
 Removes the oldest item off the queue and returns it
 
 If the queue has no items this returns nil, otherwise it removes the oldest
 item off the queue and returns it to you.
 
 @return the oldest item on the queue or nil if there are no items in the queue	*/
-(id)dequeue;

-(id)objectAtIndexedSubscript:(NSUInteger)index;

-(void)setObject:(id)object atIndexedSubscript:(NSUInteger)idx;

/**
 Returns the count of items in the queue
 
 @return count a NSUInteger with the number of items in the queue	*/
-(NSUInteger)count;

/**
 Enumerates over the queue contents using a block	*/
-(void)enumerateContents:(void (^)(id object, NSUInteger index, BOOL *stop))block;

/**
 Enumerates over the queue using a block allowing you to pass options for how to enumerate it
 
 @param options NSEnumerationOptions for how to enumerate the queue, same as NSArrays options
 @param block the block to be called for enumerating the block	*/
-(void)enumerateContentsWithOptions:(NSEnumerationOptions)options
						 usingBlock:(void (^)(id object, NSUInteger index, BOOL *stop))block;

@end
