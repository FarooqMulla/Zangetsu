/*
//  CWURLRequest.m
//  Zangetsu
//
//  Created by Colin Wheeler on 12/13/11.
//  Copyright (c) 2012. All rights reserved.
//
 	*/

#import "CWURLRequest.h"

static NSString * const kCWURLRequestErrorDomain = @"com.Zangetsu.CWSimpleURLRequest";

@interface CWURLRequest() <NSURLConnectionDelegate>
//Public Readonly rewritten
@property(readwrite, retain) NSString *urlHost;
@property(readwrite, retain) NSURLResponse *connectionResponse;
@property(readwrite, retain) NSError *connectionError;
//Private only
@property(retain) NSString *httpAuthorizationHeader;
@property(retain) NSURLConnection *instanceConnection;
@property(retain) NSMutableData *receivedData;
@property(assign) BOOL connectionIsFinished;
-(NSMutableURLRequest *)_createInternalURLRequest;
@end

@implementation CWURLRequest

/**
<<<<<<< HEAD
 Designated Initializer	*/
-(id)initWithHost:(NSString *)host
{
=======
 Designated Initializer
 */
-(id)initWithHost:(NSString *)host {
>>>>>>> upstream/master
	self = [super init];
	if (self) {
		_urlHost = host;
		_httpAuthorizationHeader = nil;
		_instanceConnection = nil;
		_receivedData = [[NSMutableData alloc] init];
		_connectionResponse = nil;
		_connectionError = nil;
	}
	return self;
}

/**
 A request object initialized this way is unusable.
 This is here just to give an error message when this 
<<<<<<< HEAD
 class is initialized incorrectly.	*/
-(id)init
{
=======
 class is initialized incorrectly.
 */
-(id)init {
>>>>>>> upstream/master
	self = [super init];
	if (self) {
		_urlHost = nil;
		_httpAuthorizationHeader = nil;
		_instanceConnection = nil;
		_connectionIsFinished = NO;
		_receivedData = nil;
		_connectionResponse = nil;
		_connectionError = CWCreateError(kCWURLRequestErrorDomain, kCWSimpleURLRequestNoHostError,
										@"Host is nil and therefore cannot be used for a connection");
	}
	return self;
}

/**
 Returns a debug description of the instance request class
 
<<<<<<< HEAD
 @return a NSString with debug information of the instance request class	*/
-(NSString *)description
{
=======
 @return a NSString with debug information of the instance request class
 */
-(NSString *)description {
>>>>>>> upstream/master
	return [NSString stringWithFormat:@"%@: Host: %@\nAuth Header: %@\nIs Finished Connecting: %@",
			NSStringFromClass([self class]),
			[self urlHost],
			[self httpAuthorizationHeader],
			(self.connectionIsFinished ? @"YES" : @"NO")];
}

-(void)setAuthorizationHeaderLogin:(NSString *)login 
					   andPassword:(NSString *)passwd {
	if (!(login && passwd)) return;
	
	NSString *base64AuthString = CWURLAuthorizationHeaderString(login, passwd);
	if (base64AuthString) {
		[self setHttpAuthorizationHeader:base64AuthString];
	}
}

-(NSMutableURLRequest *)_createInternalURLRequest {
	/**
	 private internal method, creates the NSMutableURLRequest & applies any http
	 headers or other attributes that need to be applied
	 */
	if(!self.urlHost) return nil;
	
	NSURL *url = [NSURL URLWithString:[self urlHost]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request cw_setHTTPAuthorizationHeaderFieldString:[self httpAuthorizationHeader]];
	return request;
}

#pragma mark Connection Initiaton Methods -

-(NSData *)startSynchronousConnection {
	NSMutableURLRequest *request = [self _createInternalURLRequest];
	if (!request) {
		self.connectionError = CWCreateError(kCWURLRequestErrorDomain, kCWSimpleURLRequestNoHostError,
											 @"Host is nil and therefore cannot be used for a connection");
		return nil;
	}
	
	self.instanceConnection = [[NSURLConnection alloc] initWithRequest:request
															  delegate:self];
	[self.instanceConnection scheduleInRunLoop:[NSRunLoop currentRunLoop]
									   forMode:NSDefaultRunLoopMode];
	[self.instanceConnection start];
	
	while (self.connectionIsFinished == NO) {
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
								 beforeDate:[[NSDate date] dateByAddingTimeInterval:10]];
	}
	return self.receivedData;
}

-(void)startAsynchronousConnectionWithCompletionBlock:(void (^)(NSData *data, NSError *error, NSURLResponse *response))block {
	const char *label = CWUUIDCStringPrependedWithString(@"com.Zangetsu.CWURLRequest");
	dispatch_queue_t queue = dispatch_queue_create(label, 0);
	dispatch_async(queue, ^{
		NSData *data = [self startSynchronousConnection];
		dispatch_async(dispatch_get_main_queue(), ^{
			block(data,self.connectionError,self.connectionResponse);
		});
	});
	dispatch_release(queue);
}

-(void)startAsynchronousConnectionOnGCDQueue:(dispatch_queue_t)queue 
						 withCompletionBlock:(void (^)(NSData *data, NSError *error, NSURLResponse *response))block {
	NSParameterAssert(queue);
	
	dispatch_async(queue, ^{
		NSData *data = [self startSynchronousConnection];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			block(data, self.connectionError, self.connectionResponse);
		});
	});
}

-(void)startAsynchronousConnectionOnQueue:(NSOperationQueue *)queue 
					  withCompletionBlock:(void (^)(NSData *data, NSError *error, NSURLResponse *response))block {
	NSParameterAssert(queue);
	
	[queue addOperationWithBlock:^{
		NSData *data = [self startSynchronousConnection];
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			block(data, self.connectionError, self.connectionResponse);
		}];
	}];
}

#pragma mark NSURLConnection Delegate Methods (Private) -

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	if ([connection isEqual:self.instanceConnection]) self.connectionResponse = response;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if ([connection isEqual:self.instanceConnection]) [self.receivedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
	/**
	 when we get a notification that we are finished, we mark 
	 ourselves as finished so we don't keep running the runloop
	 and return the received data.
	 */
	if ([self.instanceConnection isEqual:connection]) self.connectionIsFinished = YES;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	/**
	 if we get a error during the connection, then what
	 this does is retain the error object and mark ourselves
	 as finished and log the error.
	 */
	if ([self.instanceConnection isEqual:connection]) {
		self.connectionError = error;
		self.connectionIsFinished = YES;
	}
}

@end
