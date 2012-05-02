/*
//  CWBTreeTests.m
//  Zangetsu
//
//  Created by Colin Wheeler on 7/18/11.
//  Copyright 2011. All rights reserved.
//
 
 Copyright (c) 2011 Colin Wheeler
 
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

#import "CWSimpleBTreeTests.h"
#import "CWSimpleBTree.h"
#import "CWAssertionMacros.h"

@implementation CWSimpleBTreeTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

/**
 test that the CWTree objects are being created and correctly
 assigning their root nodes
 */
-(void)testBasicTreeCreation
{    
    NSString *string1 = @"Hypnotoad";
    
    CWSimpleBTree *tree1 = [[CWSimpleBTree alloc] initWithRootNodeValue:string1];
    
    CWSimpleBTree *tree2 = [[CWSimpleBTree alloc] init];
    CWSimpleBTreeNode *node1 = [[CWSimpleBTreeNode alloc] initWithValue:string1];
    tree2.rootNode = node1;
	
    STAssertTrue([[[tree1 rootNode] value] isEqual:[[tree2 rootNode] value]], @"Root nodes should be equal");
}

/**
 test for node equality
 */
-(void)testNodeIsEqual
{    
    NSString *string1 = @"Hypnotoad";
    
    CWSimpleBTreeNode *node1 = [[CWSimpleBTreeNode alloc] initWithValue:string1];
    CWSimpleBTreeNode *node2 = node1;
    
    STAssertTrue([node1 isEqualTo:node2], @"Nodes should be equivalent");
    
    CWSimpleBTreeNode *node3 = [[CWSimpleBTreeNode alloc] initWithValue:@"Cheez it!"];
    
    STAssertFalse([node1 isEqualTo:node3], @"The 2 nodes have different values and should always be false");
}

/**
 Test that we are running the iterative preorder traversal in the correct order...
 */
-(void)testEnumeration
{    
    /**
     Unit Test Example Tree Structure
     Internally CWTree uses a Stack (CWStack) object to visit all nodes...
     ---------------------
           4
           |
        /-----\
        2     5
        |
      /---\ 
      1   3
     
     //iterative preorder traversal order
     1) push node 4 onto the stack
     2) visit node 4 (popped off the stack)
     3) push 5 then 2 onto the stack
     4) visit 2 (popped off the stack)
     5) push 3 then 1 onto the stack
     6) visit 1 (popped off the stack)
     7) visit 3 (popped off the stack)
     8) visit 5 (popped off the stack)
     stack is now empty & all tree nodes traversed...
     ---------------------
     */
    
    CWSimpleBTreeNode *rNode = [[CWSimpleBTreeNode alloc] initWithValue:@"4"];
    
    CWSimpleBTreeNode *rRNode = [[CWSimpleBTreeNode alloc] initWithValue:@"5"];
	rNode.rightNode = rRNode;
    
    CWSimpleBTreeNode *rLNode = [[CWSimpleBTreeNode alloc] initWithValue:@"2"];
	rNode.leftNode = rLNode;
    
    CWSimpleBTreeNode *node2L = [[CWSimpleBTreeNode alloc] initWithValue:@"1"];
	rLNode.leftNode = node2L;
    
    CWSimpleBTreeNode *node2R = [[CWSimpleBTreeNode alloc] initWithValue:@"3"];
	rLNode.rightNode = node2R;
    
    CWSimpleBTree *tree = [[CWSimpleBTree alloc] init];
	tree.rootNode = rNode;
    
    __block NSMutableString *testString = [[NSMutableString alloc] init];
    
    [tree enumerateBTreeWithBlock:^(id nodeValue, id node, BOOL *stop) {
        [testString appendString:(NSString *)nodeValue];
    }];
    
    NSString *truthString = @"42135";
    
	CWAssertEqualsStrings(testString, truthString);
}

/**
 Test that the bool pointer in the block correctly stops enumation
 */
-(void)testStopPointer
{    
    /**
     same tree structure as the testEnumeration test...
     we should visit node 4 then 2 and then stop...
     */
    
    CWSimpleBTreeNode *rNode = [[CWSimpleBTreeNode alloc] initWithValue:@"4"];
    
    CWSimpleBTreeNode *rRNode = [[CWSimpleBTreeNode alloc] initWithValue:@"5"];
	rNode.rightNode = rRNode;
    
    CWSimpleBTreeNode *rLNode = [[CWSimpleBTreeNode alloc] initWithValue:@"2"];
	rNode.leftNode = rLNode;
    
    CWSimpleBTreeNode *node2L = [[CWSimpleBTreeNode alloc] initWithValue:@"1"];
	rLNode.leftNode = node2L;
    
    CWSimpleBTreeNode *node2R = [[CWSimpleBTreeNode alloc] initWithValue:@"3"];
	rLNode.rightNode = node2R;
    
    CWSimpleBTree *tree = [[CWSimpleBTree alloc] init];
	tree.rootNode = rNode;
    
    __block NSMutableString *currentString = [[NSMutableString alloc] init];
    
    [tree enumerateBTreeWithBlock:^(id nodeValue, id node, BOOL *stop) {
        [currentString appendString:(NSString *)nodeValue];
        if ([(NSString *)nodeValue isEqualToString:@"2"]) {
            *stop = YES;
        }
    }];
    
	CWAssertEqualsStrings(currentString, @"42");
}

-(void)testNodeLevel
{
	/**
	 test the node level of nodes at various levels, nodes should report
	 that their level is 1 + N  where N is the amount of parent nodes they
	 have. 
	 */
    
    static NSString *const kTestValue = @"Now look I am not evil, my Loan officer told me so";
    
    CWSimpleBTreeNode *node1 = [[CWSimpleBTreeNode alloc] initWithValue:kTestValue];
    
    CWSimpleBTreeNode *node2 = [[CWSimpleBTreeNode alloc] initWithValue:kTestValue];
	node1.rightNode = node2;
    
    CWSimpleBTreeNode *node3 = [[CWSimpleBTreeNode alloc] initWithValue:kTestValue];
	node2.rightNode = node3;
    
    CWSimpleBTreeNode *node4 = [[CWSimpleBTreeNode alloc] initWithValue:kTestValue];
	node3.rightNode = node4;
    
    STAssertTrue([node1 nodeLevel] == 1, @"Node1 should be at Level 1");
    STAssertTrue([node2 nodeLevel] == 2, @"Node1 should be at Level 2");
    STAssertTrue([node3 nodeLevel] == 3, @"Node1 should be at Level 3");
    STAssertTrue([node4 nodeLevel] == 4, @"Node1 should be at Level 4");
}

-(void)testSetPointerToNil
{	
	CWSimpleBTreeNode *node = [[CWSimpleBTreeNode alloc] initWithValue:@"Hypnotoad"];
	STAssertNil(node.rightNode, @"Node should be nil now");
	
	CWSimpleBTreeNode *node2 = [[CWSimpleBTreeNode alloc] initWithValue:@"Nibbler"];
	[node setRightNode:node2];
	STAssertNotNil(node.rightNode, @"Node should be non nil");
	
	[node setRightNode:nil];
	STAssertNil(node.rightNode, @"Node should be nil now");
	
	[node setRightNode:node];
	STAssertNil(node.rightNode, @"Node should not allow setting itself as a child node");
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

@end