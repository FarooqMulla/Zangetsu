/*
//  CWBlockTimer.m
//  Zangetsu
//
//  Created by Colin Wheeler on 8/10/12.
//
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

#import "CWBlockTimer.h"

@interface CWBlockTimer ()
@property(copy) dispatch_block_t invocationBlock;
@property(readwrite,retain) NSTimer *internalTimer;
-(void)p_internalInvokeBlock:(NSTimer *)timer;
@end

@implementation CWBlockTimer

- (id)init {
    self = [super init];
    if (self) {
		_internalTimer = nil;
		_invocationBlock = nil;
    }
    return self;
}

+(CWBlockTimer *)timerWithTimeInterval:(NSTimeInterval)interval
							   repeats:(BOOL)repeats
								 block:(dispatch_block_t)block {
	CWAssert(block != nil);
	
	CWBlockTimer *timer = [CWBlockTimer new];
	timer.internalTimer = [NSTimer scheduledTimerWithTimeInterval:interval
														   target:timer
														 selector:@selector(p_internalInvokeBlock:)
														 userInfo:nil
														  repeats:repeats];
	timer.invocationBlock = block;
	return timer;
}

-(void)fire {
	[self p_internalInvokeBlock:self.internalTimer];
}

-(void)invalidate {
	[self.internalTimer invalidate];
}

-(BOOL)isValid {
	return self.internalTimer.isValid;
}
				   
-(void)p_internalInvokeBlock:(NSTimer *)timer {
	if ([timer isEqual:self.internalTimer] && self.invocationBlock) {
		self.invocationBlock();
	} else {
		CWLogInfo(@"ERROR: No invocation block to invoke for timer...");
	}
}

-(void)dealloc {
	[_internalTimer invalidate];
}

@end
