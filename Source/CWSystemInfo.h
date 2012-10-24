/*
//  CWSystemInfo.h
//  Zangetsu
//
//  Created by Colin Wheeler on 11/14/10.
//  Copyright 2010. All rights reserved.
//
 
 */

#import <Foundation/Foundation.h>

static NSString * const kCWSystemMajorVersion =  @"majorVersion";
static NSString * const kCWSystemMinorVersion =  @"minorVersion";
static NSString * const kCWSystemBugFixVersion = @"bugfixVersion";

@interface CWSystemInfo : NSObject

/**
 * Convenience Method to return a dictionary with the Mac OS X version
 * information in a way where you can query a specific part of the version
 * information you want
 *
 * @return hostVersion a NSDictionary with the key/value pairs for the majaor/minor/bugfix version #'s of Mac OS X
 */
+(NSDictionary *)hostVersion;

/**
 * Convenience method to return a NSString with the Mac OS X version
 * information.
 *
 * @return hostVersionString a string for the version of Mac OS X in use like "10.6.6" for Mac OS X 10.6.6
 */
+(NSString *)hostVersionString;

/**
 * Does what it says it does, returns the # of cpu cores on the host Mac
 *
 * @return numberOfCUPCores a NSInteger with the number of CPU cores on the Host Mac
 */
+(NSInteger)numberOfCPUCores;

/**
 * Returns the amount of physical ram in Gigabytes the host device has
 *
 * @return a CGFloat representing the physical ram size of the host system
 */
+(CGFloat)physicalRamSize;

/**
 * Returns the processor speed of the host system in Ghz as a CGFloat
 * 
 * @return a CGFloat representing the processor speed in MHz
 */
+(CGFloat)processorSpeed;
@end
