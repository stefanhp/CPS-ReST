//
//  CPSReSTClient.h
//  CPS-ReST-Framework
//
//  Created by Stefan Hochuli Paychère on 22.04.10.
//  Copyright 2010 Pistache-Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPSReSTCookie.h"
#import "CPSReSTBasicAuthentication.h"

// macro used for debug
//#define REST_DEBUG 
#ifdef REST_DEBUG
#define REST_LOG(obj) NSLog(@"%s = %@",__FUNCTION__,obj);
#else
#define REST_LOG(obj)
#endif

typedef enum {
	CPSReSTMethodGET,
	CPSReSTMethodPOST, 
	CPSReSTMethodPUT,
	CPSReSTMethodDELETE
} CPSReSTMethod;

typedef enum {
	CPSReSTContentTypeAll = 0,
	CPSReSTContentTypeApplicationXML,
	CPSReSTContentTypeApplicationXHTMLXML,
	CPSReSTContentTypeApplicationSVGXML,
	CPSReSTContentTypeApplicationAtomXML,
	CPSReSTContentTypeApplicationJSON,
	CPSReSTContentTypeApplicationXWWWFormURLEncoded,
	CPSReSTContentTypeApplicationOctetStream,
	CPSReSTContentTypeTextPlain,
	CPSReSTContentTypeTextXML,
	CPSReSTContentTypeTextHTML,
	CPSReSTContentTypeMultipartFormData,
	CPSReSTContentTypeImage
} CPSReSTContentType;

@protocol CPSReSTClientDelegate
@required
- (void)connectionError:(NSError *)error;
- (void)asyncResponse:(NSDictionary*)result;
@end

@interface CPSReSTClient : NSObject {
	// Connection
	NSString* server;
	NSInteger port;
	BOOL ssl;
	
	// Delegate
	NSObject<CPSReSTClientDelegate>* delegate;
	
	// Authentication
	CPSReSTCookie* cookie;
	CPSReSTBasicAuthentication* basicAuthentication;
	
	// Other
	NSTimeInterval timeout;
	
}
@property (retain,readwrite) NSObject<CPSReSTClientDelegate>* delegate;
@property (retain,readwrite) CPSReSTCookie* cookie;
@property (retain,readwrite) CPSReSTBasicAuthentication* basicAuthentication;
@property (readwrite) BOOL ssl;
@property (readwrite) NSInteger port;
@property (readwrite) NSTimeInterval timeout;
@property (retain,readwrite) NSArray * acceptedLanguages;

// constructors, default: port=8280 ssl=NO
+ (id) clientWithServer:(NSString*)server;
+ (id) clientWithServer:(NSString*)server onPort:(int)port withSSL:(BOOL) useSSL;

- (id) initWithServer:(NSString*)server;
- (id) initWithServer:(NSString*)server onPort:(int)port withSSL:(BOOL) useSSL;

// content types
+ (NSString*)contentTypeForKey:(CPSReSTContentType)key;

// sync requests
- (NSMutableDictionary*)request:(CPSReSTMethod)method atURL:(NSString*)url;
- (NSMutableDictionary*)request:(CPSReSTMethod)method atURL:(NSString*)url withGET:(NSDictionary*)get;
- (NSMutableDictionary*)request:(CPSReSTMethod)method atURL:(NSString*)url withGET:(NSDictionary*)get withPOST:(NSDictionary*)post asXML:(BOOL)xml;
- (NSMutableDictionary*)request:(CPSReSTMethod)method atURL:(NSString*)url withGET:(NSDictionary*)get withPOST:(NSDictionary*)post asXML:(BOOL)xml accept:(CPSReSTContentType)contentType;

// async requests
- (void) async:(id)sender request:(CPSReSTMethod)method atURL:(NSString*)url;
- (void) async:(id)sender request:(CPSReSTMethod)method atURL:(NSString*)url withGET:(NSDictionary*)get;
- (void) async:(id)sender request:(CPSReSTMethod)method atURL:(NSString*)url withGET:(NSDictionary*)get withPOST:(NSDictionary*)post asXML:(BOOL)xml;
- (void) async:(id)sender request:(CPSReSTMethod)method atURL:(NSString*)url withGET:(NSDictionary*)get withPOST:(NSDictionary*)post asXML:(BOOL)xml accept:(CPSReSTContentType)contentType;
@end

@interface CPSReSTClient ()
- (NSMutableDictionary*)execRequest:(NSURLRequest*)request;
- (NSURLRequest*)prepareRequest:(CPSReSTMethod)method
						  atURL:(NSString*)url 
						withGET:(NSDictionary*)get
					   withPOST:(NSDictionary*)post 
						  asXML:(BOOL)xml 
						 accept:(CPSReSTContentType)acceptType;
- (void)threadRequest:(NSURLRequest*)request;
@end

@interface CPSReSTClient (CoDec)
+ (NSString*) stringUrlEncode:(NSString*) unencodedString;
- (NSString*)urlencode:(NSDictionary*)data;
- (NSString*)encodeXML:(NSDictionary*)data;
- (NSMutableDictionary*)decodeXML:(NSString*)xml;
@end

@interface CPSReSTClient (CoDecHelpers)
- (void)getPost:(NSDictionary*)data withPrefix:(NSString*)pfx into:(NSMutableString*)res;
- (void)getXML:(NSDictionary*)data withIdent:(NSString*)spc into:(NSMutableString*)res;
@end

