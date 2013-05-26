//
//  CWRuntimeTests.m
//  Zangetsu
//
//  Created by Colin Wheeler on 5/24/13.
//
//

#import "CWRuntimeTests.h"

static const NSInteger kInstanceCode1 = 100;
static const NSInteger kInstanceCode2 = 200;

static const NSInteger kClassCode1 = 300;
static const NSInteger kClassCode2 = 400;

@interface CWTestFoo : NSObject
-(NSInteger)instanceCode1;
-(NSInteger)instanceCode2;
+(NSInteger)classCode1;
+(NSInteger)classCode2;
@end

@implementation CWTestFoo

-(NSInteger)instanceCode1 {
	return kInstanceCode1;
}

-(NSInteger)instanceCode2 {
	return kInstanceCode2;
}

+(NSInteger)classCode1 {
	return kClassCode1;
}

+(NSInteger)classCode2 {
	return kClassCode2;
}

@end

SpecBegin(CWRuntime)

it(@"should swizzle instance methods", ^{
	CWTestFoo *foo = [CWTestFoo new];
	
	NSError *error1;
	[foo setError1:&error1];
	expect(error1.domain).to.equal(@"domain");
	expect(error1.code == instanceErrorCode1).to.beTruthy();
	
	NSError *error2;
	[foo setError2:&error2];
	expect(error2.domain).to.equal(@"domain");
	expect(error2.code == instanceErrorCode2).to.beTruthy();
	
	NSError *swizzleError;
	CWSwizzleInstanceMethods([foo class], @selector(setError1:), @selector(setError2:), &swizzleError);
	if(swizzleError != nil) NSLog(@"Swizzle Error: %@",swizzleError);
	
	NSError *error3;
	[foo setError1:&error3];
	expect(error3.domain).to.equal(@"domain");
	expect(error3.code == instanceErrorCode2).to.beTruthy();
	
	NSError *error4;
	[foo setError2:&error4];
	expect(error4.domain).to.equal(@"domain");
	expect(error4.code == instanceErrorCode1).to.beTruthy();
});

it(@"should swizzle class methods", ^{
	NSError *error1;
	[CWTestFoo setClassError1:&error1];
	expect(error1.code == classErrorCode1).to.beTruthy();
	
	NSError *error2;
	[CWTestFoo setClassError2:&error2];
	expect(error2.code == classErrorCode2).to.beTruthy();
	
	NSError *swizzleError;
	CWSwizzleClassMethods([CWTestFoo class], @selector(setClassError1:), @selector(setClassError2:), &swizzleError);
	if(swizzleError != nil) NSLog(@"Swizzle Error: %@",swizzleError);
	
	NSError *error3;
	[CWTestFoo setClassError1:&error3];
	expect(error3.code == classErrorCode2).to.beTruthy();
	
	NSError *error4;
	[CWTestFoo setClassError2:&error4];
	expect(error4.code == classErrorCode1).to.beTruthy();
});

SpecEnd
