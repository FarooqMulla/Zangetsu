/*
//  CWTree.m
//  Zangetsu
//
//  Created by Colin Wheeler on 7/12/11.
//  Copyright 2012. All rights reserved.
//
 	*/

#import "CWTree.h"

@interface CWTreeNode()
@property(readwrite, retain) NSMutableArray *children;
@end

@implementation CWTreeNode

/**
 Initializes and creates a new CWTreenode Object
 
 @return a CWTreeNode object with no value	*/
-(id)init
{
    self = [super init];
    if (self) {
        _value = nil;
        _children = [[NSMutableArray alloc] init];
        _parent = nil;
        _allowsDuplicates = YES;
    }
    return self;
}

-(id)initWithValue:(id)aValue
{
    self = [super init];
    if (self) {
        _value = aValue;
        _children = [[NSMutableArray alloc] init];
        _parent = nil;
    }
    return self;
}

/**
 Returns a NSString with the description of the receiving CWTreeNode Object
 
 @return a NSString with debug information on the receiving CWTreeNode Object	*/
-(NSString *)description
{
	NSString *desc = [NSString stringWithFormat:@"%@ Node\nValue: %@\nParent: %@\nChildren: %@\nAllows Duplicates: %@",
					  NSStringFromClass([self class]),
					  [self.value description],
					  [self.parent description],
					  [self.children description],
					  CWBOOLString(self.allowsDuplicates)];
	return desc;
}


-(void)addChild:(CWTreeNode *)node
{
	if(!node) { return; }
	
	if (self.allowsDuplicates) {
		node.parent = self;
		[self.children addObject:node];
	} else {
		if (![self.children containsObject:node]) {
			BOOL anyNodeContainsValue = [self.children cw_isObjectInArrayWithBlock:^BOOL(id obj) {
				id nodeValue = [(CWTreeNode *)obj value];
				if ([nodeValue isEqual:node.value]) {
					return YES;
				}
				return NO;
			}];
			
			if (!anyNodeContainsValue) {
				node.parent = self;
				node.allowsDuplicates = NO;
				[self.children addObject:node];
			}
		}
	}
}


-(void)removeChild:(CWTreeNode *)node
{
	if (node && [self.children containsObject:node]) {
		node.parent = nil;
		[self.children removeObject:node];
	}
}

-(BOOL)isEqualToNode:(CWTreeNode *)node
{
	if ([node.value isEqual:self.value] &&
		[node.parent isEqual:self.parent] &&
		[node.children isEqual:self.children]) {
		return YES;
	}
    return NO;
}

-(BOOL)isNodeValueEqualTo:(CWTreeNode *)node
{
    if ([node.value isEqual:self.value]) {
        return YES;
    }
    return NO;
}

-(NSUInteger)nodeLevel {
    NSUInteger level = 1;
    CWTreeNode *currentNode = self.parent;
	
    while (currentNode) {
        level++;
        currentNode = currentNode.parent;
    }
    return level;
}

@end

@implementation CWTree

-(id)initWithRootNodeValue:(id)value
{
    self = [super init];
    if (self) {
        CWTreeNode *aRootNode = [[CWTreeNode alloc] initWithValue:value];
        _rootNode = aRootNode;
    }
    
    return self;
}

-(BOOL)isEqualToTree:(CWTree *)tree
{
	if ([self.rootNode isNodeValueEqualTo:tree.rootNode] &&
		[[self.rootNode description] isEqualToString:[tree.rootNode description]]) {
		return YES;
	}
    return NO;
}

-(void)enumerateTreeWithBlock:(void (^)(id nodeValue, id node, BOOL *stop))block
{
	if(!self.rootNode) { return; }
	
	CWQueue *queue = [[CWQueue alloc] init];
	BOOL shouldStop = NO;
	
	[queue enqueue:self.rootNode];
	
	while ( [queue count] > 0 ) {
		CWTreeNode *node = (CWTreeNode *)[queue dequeue];
		
		block(node.value, node, &shouldStop);
		
		if(shouldStop) { break; }
		
		if ([node.children count] > 0) {
			for (CWTreeNode *childNode in node.children) {
				[queue enqueue:childNode];
			}
		}
	}
}

-(BOOL)containsObject:(id)object
{
	__block BOOL contains = NO;
	[self enumerateTreeWithBlock:^(id nodeValue, id node, BOOL *stop) {
		if ([object isEqual:nodeValue]) {
			contains = YES;
			*stop = YES;
		}
	}];
	return contains;
}

-(BOOL)containsObjectWithBlock:(BOOL(^)(id obj))block
{
	__block BOOL contains = NO;
	[self enumerateTreeWithBlock:^(id nodeValue, id node, BOOL *stop) {
		if (block(nodeValue)) {
			contains = YES;
			*stop = YES;
		}
	}];
	return contains;
}

@end
