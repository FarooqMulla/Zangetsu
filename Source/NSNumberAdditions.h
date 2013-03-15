/*
//  NSNumber+NSNumberAdditions.h
//  Zangetsu
//
//  Created by Colin Wheeler on 2/24/13.
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

#import <Foundation/Foundation.h>

@interface NSNumber (CWNSNumberAdditions)

/**
 Executes the block n number of times where n is the integer value of self
 
 Converts the NSNumbers value to a NSInteger value and then repeatedly 
 executes the block n number of times where n is the NSInteger value of the
 receiver.
 
 @param index - The current iteration of executing the block
 @param stop - a BOOL pointer which if set to YES stops executing anymore blocks
 */
-(void)cw_times:(void (^)(NSInteger index, BOOL *stop))block;

@end
