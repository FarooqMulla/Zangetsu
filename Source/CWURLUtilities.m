//
//  URLUtilities.m
//  Zangetsu
//
//  Created by Colin Wheeler on 2/11/11.
//  Copyright 2011. All rights reserved.
//

#import "CWURLUtilities.h"

/**
 * Creates a NSURL with the string passed in
 *
 * Creates a URL with the string passed in and escapes the necessary
 * url characters to create a NSURL object
 *
 * @param url a NSString with the url you want to make a NSURL object from
 * @return a NSURL object from the string passed in
 */
NSURL * CWURL(NSString * url){
	
	NSURL *_urlValue = [NSURL URLWithString:url];

    return _urlValue;
}

static NSString * kCWURLUtiltyErrorDomain = @"com.Zangetsu.CWURLUtilities";

@implementation CWURLUtilities

+ (NSError *) errorWithLocalizedMessageForStatusCode:(NSInteger)code {
    NSString * localizedMessage = [NSHTTPURLResponse localizedStringForStatusCode:code];

    if (localizedMessage) {
        return CWCreateError(code, kCWURLUtiltyErrorDomain, localizedMessage);
    }

    return nil;
}

@end
