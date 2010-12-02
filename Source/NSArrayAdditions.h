//
//  NSArrayAdditions.h
//  Zangetsu
//
//  Created by Colin Wheeler 

#import <Cocoa/Cocoa.h>


@interface NSArray (CWNSArrayAdditions)

-(id)cw_firstObject;

//Ruby inspired iterators
-(NSArray *)cw_each:(void (^)(id obj))block;

-(NSArray *)cw_eachWithIndex:(void (^)(id obj,NSInteger index))block;

-(id)cw_findWithBlock:(BOOL (^)(id obj))block;

-(BOOL)cw_isObjectInArrayWithBlock:(BOOL (^)(id obj))block;

-(NSArray *)cw_findAllWithBlock:(BOOL (^)(id obj))block;

-(NSHashTable *)cw_findAllIntoWeakRefsWithBlock:(BOOL (^)(id))block;

-(NSArray *)cw_mapArray:(id (^)(id obj))block;

@end
