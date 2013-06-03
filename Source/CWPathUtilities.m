/*
//  CWPathUtilities.m
//  Zangetsu
//
//  Created by Colin Wheeler on 12/20/10.
//  Copyright 2010. All rights reserved.
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

#import "CWPathUtilities.h"

static NSString * const kCWAppName = @"CFBundleName";


NSString *CWFullPathFromTildeString(NSString *tildePath) {
	if(tildePath == nil) return nil;
	NSString *path = [tildePath stringByExpandingTildeInPath];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		return path;
	}
	return nil;
}

@implementation CWPathUtilities

+ (NSString *) applicationSupportFolder {
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) cw_firstObject];
    if (path) {
		NSString * appName = [[[NSBundle mainBundle] infoDictionary] valueForKey:kCWAppName];
		return [NSString stringWithFormat:@"%@/%@", path, appName];
	}
	return nil;
}

+ (NSString *) documentsFolderPathForFile:(NSString *)file {
    NSString *path = nil;
    path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) cw_firstObject];
    if (path) {
		return [NSString stringWithFormat:@"%@/%@",path,file];
	}
	return nil;
}

+ (NSString *) pathByAppendingAppSupportFolderWithPath:(NSString *)path {
    NSString * appSupportPath = [CWPathUtilities applicationSupportFolder];
	if (appSupportPath) {
		return [NSString stringWithFormat:@"%@/%@", appSupportPath, path];
	}
    return nil;
}

+ (NSString *) pathByAppendingHomeFolderPath:(NSString *)subPath {
	return [NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),subPath];
}

+(NSString *)temporaryFilePath {
	return [NSString stringWithFormat:@"%@%@.temp", NSTemporaryDirectory(), [NSString cw_uuidString]];
}

@end
