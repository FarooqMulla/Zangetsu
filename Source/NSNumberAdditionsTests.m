//
//  NSNumberAdditionsTests.m
//  Zangetsu
//
//  Created by Colin Wheeler on 2/24/13.
//
//

#import "NSNumberAdditionsTests.h"
#import "NSNumberAdditions.h"

SpecBegin(CWNSNumberAdditions)

it(@"should repeatedly execute the block an expected amount of times", ^{
	__block NSUInteger count = 0;
	[@8 cw_times:^(NSInteger index, BOOL *stop) {
		++count;
	}];
	expect(count == 8).to.beTruthy();
});

it(@"should not execute at all when 0", ^{
	__block NSUInteger count = 0;
	[@0 cw_times:^(NSInteger index, BOOL *stop) {
		++count;
	}];
	expect(count == 0).to.beTruthy();
});

it(@"should stop when the stop pointer is set to YES", ^{
	__block NSUInteger count = 0;
	[@30 cw_times:^(NSInteger index, BOOL *stop) {
		++count;
		if (count == 5) *stop = YES;
	}];
	expect(count == 5).to.beTruthy();
});

SpecEnd
