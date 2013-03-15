/*
//  CWSystemInfoIOS.m
//  Zangetsu
//
//  Created by Colin Wheeler on 1/21/12.
//  Copyright (c) 2012. All rights reserved.
//
 	*/
 
#import "CWSystemInfoIOS.h"
#import <sys/sysctl.h>

@implementation CWSystemInfoIOS

+(NSString *)systemVersionString {
	return [[UIDevice currentDevice] systemVersion];
}

+(NSDictionary *)hostVersion {
	NSMutableDictionary *versionDictionary = nil;
	NSArray *components = nil;
	components = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];
	if (components.count > 0) {
		versionDictionary = [[NSMutableDictionary alloc] initWithCapacity:3];
		[versionDictionary addEntriesFromDictionary:@{
							 kCWSystemMajorVersion : components[0],
							 kCWSystemMinorVersion : components[1]
		 }];
		if (components.count == 2) {
			[versionDictionary addEntriesFromDictionary:@{ kCWSystemBugFixVersion : @"0" }];
		} else {
			[versionDictionary addEntriesFromDictionary:@{ kCWSystemBugFixVersion : components[2] }];
		}
	}
	return versionDictionary;
}

+(NSInteger)cpuCoreCount {
	NSInteger coreCount = 0;
    size_t size = sizeof(coreCount);
    if (sysctlbyname("hw.ncpu", &coreCount, &size, NULL, 0)) {
        return 1;
    }
    return coreCount;
}

+(NSString *)hardwareModelString {
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *device = calloc(1,size);
	sysctlbyname("hw.machine", device, &size, NULL, 0);
	
	NSString *deviceString = [NSString stringWithCString:device 
												encoding:NSUTF8StringEncoding];
	free(device);
	return deviceString;
}

+(NSString *)englishHardwareString {
	NSString *machineString = [CWSystemInfoIOS hardwareModelString];
	
	NSDictionary *hardwareDictionary = @{
	// iPhone ===================================
	@"iPhone1,1" : @"iPhone",
	@"iPhone1,2" : @"iPhone 3G",
	@"iPhone2,1" : @"iPhone 3GS",
	@"iPhone3,1" : @"iPhone 4",
	@"iPhone3,3" : @"iPhone 4 (Verizon)",
	@"iPhone4,1" : @"iPhone 4S",
	// iPod Touch ===============================
	@"iPod1,1"   : @"iPod Touch (1st Generation)",
	@"iPod2,1"   : @"iPod Touch (2nd Generation)",
	@"iPod3,1"   : @"iPod Touch (3rd Generation)",
	@"iPod4,1"   : @"iPod Touch (4th Generation)",
	// iPad =====================================
	@"iPad1,1"   : @"iPad",
	@"iPad2,1"   : @"iPad 2 (WiFi)",
	@"iPad2,2"   : @"iPad 2 (GSM)",
	@"iPad2,3"   : @"iPad 2 (CDMA)",
	@"iPad2,4"   : @"iPad 2",
	@"iPad2,5"   : @"iPad Mini",
	@"iPad3,1"   : @"iPad 3 (WiFi)",
	@"iPad3,2"   : @"iPad 3 (4G)",
	@"iPad3,3"   : @"iPad 3 (4G)",
	// iOS Simulator ============================
	@"i386"      : @"iOS Simulator",
	@"x86_64"    : @"iOS Simulator"
	};
	
	NSString *hardwareString = [hardwareDictionary objectForKey:machineString];
	
	return hardwareString;
}

+(BOOL)retinaSupported
{
	return ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] &&
			([UIScreen mainScreen].scale > 1.0f));
}

@end
