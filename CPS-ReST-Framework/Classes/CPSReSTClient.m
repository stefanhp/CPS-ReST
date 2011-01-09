//
//  CPSReSTClient.m
//  CPS-ReST-Framework
//
//  Created by Stefan Hochuli Paychère on 22.04.10.
//  Copyright 2010 Pistache-Soft. All rights reserved.
//

#import "CPSReSTClient.h"
#import "CPSReSTXMLParser.h"
#import "JSON.h"

#define DEFAULT_TIMEOUT_INTERVAL 15 // seconds timeout
#define DEF_RETURN @"return"


@implementation CPSReSTClient

@synthesize delegate;
@synthesize cookie;
@synthesize basicAuthentication;
@synthesize timeout;
@synthesize ssl;
@synthesize port;
@synthesize acceptedLanguages;

#pragma mark -
#pragma mark Constructors

+ (id) clientWithServer:(NSString*)srv {
	return [[[CPSReSTClient alloc] initWithServer:srv] autorelease];
}

+ (id) clientWithServer:(NSString*)srv onPort:(int)port withSSL:(BOOL) useSSL {
	return [[[CPSReSTClient alloc] initWithServer:srv onPort:port withSSL:useSSL] autorelease];
}

- (id) initWithServer:(NSString*)srv {
	return [self initWithServer:srv onPort:8280 withSSL:NO];
}

- (id) initWithServer:(NSString*)_server onPort:(int)_port withSSL:(BOOL)_ssl {
	if (self=[super init]) {
		server=[_server retain]; 
		port=_port; 
		ssl=_ssl; 
		delegate=nil;
		timeout=DEFAULT_TIMEOUT_INTERVAL;
		acceptedLanguages = nil;
		cookie= nil;
	}
	return self;
}

- (void) dealloc {
	[delegate release];
	[cookie release];
	[server release];
	[acceptedLanguages release];
	[super dealloc];
}
#pragma mark -
#pragma mark Instance methods

+ (NSString*)contentTypeForKey:(CPSReSTContentType)key{
	static NSArray *contenTypeNames;
	
	if(contenTypeNames == nil){
		contenTypeNames = [NSArray arrayWithObjects: @"*/*",
						   @"application/xml",
						   @"application/xhtml+xml",
						   @"application/svg+xml",
						   @"application/atom+xml",
						   @"application/json",
						   @"application/x-www-form-urlencoded",
						   @"application/octet-stream",
						   @"text/plain",
						   @"text/xml",
						   @"text/html",
						   @"multipart/form-data",
						   @"image",
						   nil];
		[contenTypeNames retain];
	}
	
	if(key < [contenTypeNames count]){
		return (NSString *)[contenTypeNames objectAtIndex:key];
	}
	return (NSString *)[contenTypeNames objectAtIndex:CPSReSTContentTypeAll];
}

#pragma mark -
#pragma mark Synchronous requests

- (NSMutableDictionary*)request:(CPSReSTMethod)method atURL:(NSString*)url {
	return [self request:method atURL:url withGET:nil withPOST:nil asXML:NO accept:CPSReSTContentTypeAll];
}
- (NSMutableDictionary*)request:(CPSReSTMethod)method atURL:(NSString*)url withGET:(NSDictionary*)get {
	return [self request:method atURL:url withGET:get withPOST:nil asXML:NO accept:CPSReSTContentTypeAll];
}
- (NSMutableDictionary*)request:(CPSReSTMethod)method atURL:(NSString*)url withGET:(NSDictionary*)get withPOST:(NSDictionary*)post asXML:(BOOL)xml {
	return [self request:method atURL:url withGET:get withPOST:post asXML:xml accept:CPSReSTContentTypeAll];
}

- (NSMutableDictionary*)request:(CPSReSTMethod)method atURL:(NSString*)url withGET:(NSDictionary*)get withPOST:(NSDictionary*)post asXML:(BOOL)xml accept:(CPSReSTContentType)contentType {
	return [self execRequest:[self prepareRequest:method atURL:url withGET:get withPOST:post asXML:xml accept:contentType]];
}

#pragma mark -
#pragma mark Asynchronous requests

- (void) async:(id)sender request:(CPSReSTMethod)method atURL:(NSString*)url{
	return [self async:sender request:method atURL:url withGET:nil withPOST:nil asXML:NO accept:CPSReSTContentTypeAll];
}
- (void) async:(id)sender request:(CPSReSTMethod)method atURL:(NSString*)url withGET:(NSDictionary*)get{
	return [self async:sender request:method atURL:url withGET:get withPOST:nil asXML:NO accept:CPSReSTContentTypeAll];
}
- (void) async:(id)sender request:(CPSReSTMethod)method atURL:(NSString*)url withGET:(NSDictionary*)get withPOST:(NSDictionary*)post asXML:(BOOL)xml{
	return [self async:sender request:method atURL:url withGET:get withPOST:post asXML:xml accept:CPSReSTContentTypeAll];
}
- (void) async:(id)sender request:(CPSReSTMethod)method atURL:(NSString*)url withGET:(NSDictionary*)get withPOST:(NSDictionary*)post asXML:(BOOL)xml accept:(CPSReSTContentType)contentType{
	if(sender == delegate){
		[NSThread detachNewThreadSelector:@selector(threadRequest:)
								 toTarget:self
							   withObject:[self prepareRequest:method atURL:url withGET:get withPOST:post asXML:xml accept:contentType]];
	}
}

- (void)threadRequest:(NSURLRequest*)request{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSDictionary *res=[self execRequest:request];
	
	if(delegate != nil && [delegate respondsToSelector:@selector(asyncResponse:)]){
		[delegate asyncResponse:res];
	}

	[pool release];
	[NSThread exit];
}


#pragma mark -
#pragma mark Private stuff

char* c_urlencode(const char* str) {
	unsigned char c, *s=(unsigned char*)str;
	int i=0,j=0,l=0; char *r=0;
	for (i=0; c=s[i]; ++i) {
		if ((c>='0'&&c<='9') || (c>='a'&&c<='z') || (c>='A'&&c<='Z') || strchr("-_.",c)) ++l;
		else l+=3;
	}
	r=malloc(l+1); if (!r) return nil;
	for (i=0; c=s[i]; ++i) {
		if ((c>='0'&&c<='9') || (c>='a'&&c<='z') || (c>='A'&&c<='Z') || strchr("-_.",c)) { r[j]=c; ++j; }
		else { snprintf(r+j,4,"%%%02x",(int)c); j+=3; }
	}
	r[l]=0;
	return r;
}

- (NSMutableDictionary*)execRequest:(NSURLRequest*)request {
#ifdef REST_DEBUG
	NSLog(@"%s %@", __FUNCTION__, request);
#endif
	NSHTTPURLResponse * response;
	NSError *err = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	NSString *doc = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];	
	NSDictionary* headers = [response allHeaderFields];
	NSMutableDictionary* result=[[NSMutableDictionary alloc] init];	
	NSMutableDictionary* content=nil;	
	NSString *cookieStringForm;
	
	if(response != nil){
		[result setObject:[NSNumber numberWithInteger:[response statusCode]] forKey:@"statusCode"];
		[result setObject:[response allHeaderFields] forKey:@"headers"];
	}
#ifdef REST_DEBUG
	if(response != nil){
		//NSLog(@"response: %@",response);
		//NSLog(@"response: %i",[response statusCode]);
		NSLog(@"response: %i:%@",[response statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]]);
	}
	NSLog(@"err: %@",err);
	NSLog(@"data: %@",data);
	NSLog(@"doc: %@",doc);
	NSLog(@"headers: %@",headers);
#endif
	
	if (err != nil && (err.code!=0 || response.statusCode==403 || response.statusCode == 400)) {
		if (delegate != nil && [delegate conformsToProtocol:@protocol(CPSReSTClientDelegate)]) {
			content=[self decodeXML:doc];
			[delegate performSelectorOnMainThread:@selector(connectionError: ) withObject:content waitUntilDone:YES];
		}
#ifdef REST_DEBUG
		if (err.code!=0){
			[result setObject:err.localizedDescription forKey:@"error"];
			NSLog(@"Error: %@",err.localizedDescription);
		}
		else {
			content=[self decodeXML:doc];
			[result setObject:content forKey:@"error"];
			NSLog(@"Error code: %i, HTTP status: %i, additional info: %@, %@", err.code, response.statusCode, [content objectForKey:@"name"],[content objectForKey:@"message"]);
		}
#endif
		return [result autorelease];
	}
	if ((cookieStringForm = [headers objectForKey:@"Set-Cookie"]) != nil) {
		// If a cookie was set by the server
		/*
		 Cookies are in form : cookieName=cookieValue
		 */
		NSArray * cookieArray = [[[cookieStringForm componentsSeparatedByString:@";"] objectAtIndex:0] componentsSeparatedByString:@"="];
		if ([cookieArray count] == 2) {
			
			[self setCookie:[CPSReSTCookie cookieWithName:[cookieArray objectAtIndex:0] andValue:[cookieArray objectAtIndex:1]]];
			NSLog(@"New cookie : (%@=%@)",cookie.name,cookie.value);
		}
	}
	
	if ([[headers objectForKey:@"Content-Type"] hasPrefix:[CPSReSTClient contentTypeForKey:CPSReSTContentTypeTextXML]] ||
		[[headers objectForKey:@"Content-Type"] hasPrefix:[CPSReSTClient contentTypeForKey:CPSReSTContentTypeApplicationXML]]) {
		content=[self decodeXML:doc];
		[result setObject:content forKey:@"content"];
	} else if([[headers objectForKey:@"Content-Type"] hasPrefix:[CPSReSTClient contentTypeForKey:CPSReSTContentTypeApplicationJSON]]){
		
		
		// This fails in the debugger: id jsonContent = [rawContent JSONValue];
		// So let's work around it:
		SBJsonParser *jsonParser = [SBJsonParser new];
		id jsonContent = [jsonParser objectWithString:doc];
		if (!jsonContent){
			NSLog(@"-JSONValue failed. Error trace is: %@", [jsonParser error]);
		}
		[jsonParser release];
		
		if(jsonContent != nil){
			if([jsonContent isKindOfClass:[NSDictionary class]]){
				content = [NSMutableDictionary dictionaryWithDictionary:jsonContent];
				[result setObject:content forKey:@"content"];
			} else if ([jsonContent isKindOfClass:[NSArray class]]) {
				[result setObject:jsonContent forKey:@"content"];
			}
		}
	} /*else {
		result=[NSMutableDictionary dictionaryWithObject:doc forKey:DEF_RETURN];
	}*/
	return [result autorelease];
}

- (NSURLRequest*)prepareRequest:(CPSReSTMethod)method
						  atURL:(NSString*)url 
						withGET:(NSDictionary*)get
					   withPOST:(NSDictionary*)post 
						  asXML:(BOOL)xml 
						 accept:(CPSReSTContentType)acceptType {
	// Create request from URL
	NSMutableString* u=[NSMutableString stringWithFormat:@"http%s://%@:%d%@",ssl?"s":"",server,port,url];
	if (get && [get count]>0) {
		[u appendFormat:@"?%@",[self urlencode:get]];
	}
	NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:u]];
	
	// Method 
	switch(method) {
		case CPSReSTMethodGET: [req setHTTPMethod:@"GET"]; break;
		case CPSReSTMethodPOST: [req setHTTPMethod:@"POST"]; break;
		case CPSReSTMethodPUT: [req setHTTPMethod:@"PUT"]; break;
		case CPSReSTMethodDELETE: [req setHTTPMethod:@"DELETE"]; break;
		default: NSLog(@"UNIMPLEMENTED"); return nil;
	}
	
	// Default values
	[req setTimeoutInterval:self.timeout];
	[req setValue:@"close" forHTTPHeaderField:@"Connection"];
	// Locales
	// ie, Accept-Language: fr,fr-fr;q=0.8,en-us;q=0.5,en;q=0.3
	/*
	if (acceptedLanguages != nil) {
		NSMutableString * stringsLocales = [[NSMutableString alloc] init];
		BOOL firstLocale = YES;
		for(NSString * strLocale in self.acceptedLanguages) {
			[stringsLocales appendFormat:firstLocale ? @"%@": @",%@", strLocale];
			firstLocale = NO;
		}
		[req setValue:stringsLocales forHTTPHeaderField:@"Accept-Language"];
		[stringsLocales release];
	}
	*/
	
	// POST content
	if (post && [post count]>0) {
		//if (method==CPSReSTMethodGET) method=CPSReSTMethodPOST;
		if (xml) {
			[req setValue:@"text/xml; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
			[req setHTTPBody:[[self encodeXML:post] dataUsingEncoding:NSUTF8StringEncoding]];
		} else {
			[req setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
			[req setHTTPBody:[[self urlencode:post] dataUsingEncoding:NSUTF8StringEncoding]];
		}
	}
	
	// Accept
	[req setValue:[CPSReSTClient contentTypeForKey:acceptType] forHTTPHeaderField:@"Accept"];
	
	// Basic Authentication
	if ([self basicAuthentication] != nil) {
		// If basic authentication is set -> encode username and password and add it to http headers.
		[req setValue:[NSString stringWithFormat:@"BASIC %@",[[self basicAuthentication] encodedUsernameAndPassword]] forHTTPHeaderField:@"Authorization"];
	}
	
	// If we have a cooke set, add it to all requests
	if (cookie != nil) {
		[req setValue:[NSString stringWithFormat:@"%@=%@",cookie.name,cookie.value] forHTTPHeaderField:@"cookie"];
	} else {
		[req setValue:@"" forHTTPHeaderField:@"cookie"];
	}
	
	return req;
}
@end

#define XML_HEADER @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<o11n>\n"
#define XML_FOOTER @"</o11n>"
#define XML_IDENT  @"\t"

@implementation CPSReSTClient (CoDec)
+ (NSString*) stringUrlEncode:(NSString*) unencodedString {
	char * encoded = c_urlencode([unencodedString cStringUsingEncoding:NSUTF8StringEncoding]);
	NSString* encodedString = [NSString stringWithCString:encoded encoding:NSUTF8StringEncoding];
	free(encoded);
	return encodedString;
}

- (NSString*) urlencode:(NSDictionary*)data {
	NSMutableString* r=[[[NSMutableString alloc] init] autorelease];
	NSArray* ka=[data allKeys];
	char * encoded;
	for (NSString *raw_k in ka) {
		encoded = c_urlencode([raw_k cStringUsingEncoding:NSUTF8StringEncoding]);
		NSString* key = [NSString stringWithCString:encoded encoding:NSUTF8StringEncoding];
		free(encoded);
		encoded = c_urlencode([[data objectForKey:key] cStringUsingEncoding:NSUTF8StringEncoding]);
		NSString* value=[NSString stringWithCString:encoded encoding:NSUTF8StringEncoding];
		free(encoded);
		if ([value isKindOfClass:[NSString class]]) {
			[r appendFormat:@"%@=%@&",key,value];
		} else if ([value isKindOfClass:[NSDictionary class]]) {
			[self getPost:(NSDictionary*)value withPrefix:key into:r];
		}
	}
	return [r substringToIndex:[r length]-1];
}

- (NSString*) encodeXML:(NSDictionary*)data {
	NSMutableString* r=[[[NSMutableString alloc] initWithString:XML_HEADER] autorelease];
	[self getXML:data withIdent:XML_IDENT into:r];
	[r appendString:XML_FOOTER];
	return r;
}

- (NSMutableDictionary*) decodeXML:(NSString*)xml {
	return [CPSReSTXMLParser parseXML:xml];
}

@end

@implementation CPSReSTClient (CoDecHelpers)
- (void) getPost:(NSDictionary*)data withPrefix:(NSString*)pfx into:(NSMutableString*)res {
	NSArray* ka=[data allKeys];
	int i,n=[ka count];
	for (i=0; i<n; i++) {
		NSString* k=[[ka objectAtIndex:i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSObject* o=[data objectForKey:k];
		if ([o isKindOfClass:[NSString class]]) {
			[res appendFormat:@"%@%%5B%@%%5D=%@&",pfx,k,[(NSString*)o stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		} else if ([o isKindOfClass:[NSDictionary class]]) {
			[self getPost:(NSDictionary*)o withPrefix:[pfx stringByAppendingFormat:@"%%5B%@%%5D",k] into:res];
		}
	}
}

- (void) getXML:(NSDictionary*)data withIdent:(NSString*)spc into:(NSMutableString*)res {
	NSArray* ka=[data allKeys];
	int i,n=[ka count];
	for (i=0; i<n; i++) {
		NSString* k=[ka objectAtIndex:i];
		NSObject* o=[data objectForKey:k];
		if ([o isKindOfClass:[NSString class]]) {
			[res appendFormat:@"%@<%@>%@</%@>\n",spc,k,o,k];
		} else if ([o isKindOfClass:[NSDictionary class]]) {
			[res appendFormat:@"%@<%@>\n",spc,k];
			[self getXML:(NSDictionary*)o withIdent:[spc stringByAppendingString:XML_IDENT] into:res];
			[res appendFormat:@"%@</%@>\n",spc,k];
		}
	}
}
@end


