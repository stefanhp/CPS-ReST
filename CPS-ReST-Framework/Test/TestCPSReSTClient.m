//
//  TestCPSReSTClient.m
//  CPS-ReST-Framework
//
//  Created by Stefan Hochuli Paychère on 22.04.10.
//  Copyright 2010 Pistache-Soft. All rights reserved.
//

#import "TestCPSReSTClient.h"

static NSString *const CPS_REST_CONTENT_TYPE_ALL = @"*/*";
static NSString *const CPS_REST_CONTENT_TYPE_APP_XML = @"application/xml";
static NSString *const CPS_REST_CONTENT_TYPE_APP_XHTML_XML = @"application/xhtml+xml";
static NSString *const CPS_REST_CONTENT_TYPE_APP_SVG_XML = @"application/svg+xml";
static NSString *const CPS_REST_CONTENT_TYPE_APP_ATOM_XML = @"application/atom+xml";
static NSString *const CPS_REST_CONTENT_TYPE_APP_JSON = @"application/json";
static NSString *const CPS_REST_CONTENT_TYPE_APP_XWWW_FORM_URL_ENCODED = @"application/x-www-form-urlencoded";
static NSString *const CPS_REST_CONTENT_TYPE_APP_OCTET_STREAM = @"application/octet-stream";
static NSString *const CPS_REST_CONTENT_TYPE_TEXT_PLAIN = @"text/plain";
static NSString *const CPS_REST_CONTENT_TYPE_TEXT_XML = @"text/xml";
static NSString *const CPS_REST_CONTENT_TYPE_TEXT_HTML = @"text/html";
static NSString *const CPS_REST_CONTENT_TYPE_MP_FORM_DATA = @"multipart/form-data";
static NSString *const CPS_REST_CONTENT_TYPE_IMAGE = @"image";

@implementation TestCPSReSTClient

- (void)testContentTypes{
	/*
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
	 CPSReSTContentTypeMultipartFormData
	 } CPSReSTContentType;
	 */
	
	STAssertTrue([[CPSReSTClient contentTypeForKey:CPSReSTContentTypeAll] isEqualToString:CPS_REST_CONTENT_TYPE_ALL],
				 @"Wrong content-type ('%@' != '%@')", [CPSReSTClient contentTypeForKey:CPSReSTContentTypeAll], CPS_REST_CONTENT_TYPE_ALL);
	
	STAssertTrue([[CPSReSTClient contentTypeForKey:CPSReSTContentTypeApplicationXML] isEqualToString:CPS_REST_CONTENT_TYPE_APP_XML],
				 @"Wrong content-type ('%@' != '%@')", [CPSReSTClient contentTypeForKey:CPSReSTContentTypeApplicationXML], CPS_REST_CONTENT_TYPE_APP_XML);
	
	STAssertTrue([[CPSReSTClient contentTypeForKey:CPSReSTContentTypeApplicationXHTMLXML] isEqualToString:CPS_REST_CONTENT_TYPE_APP_XHTML_XML],
				 @"Wrong content-type ('%@' != '%@')", [CPSReSTClient contentTypeForKey:CPSReSTContentTypeApplicationXHTMLXML], CPS_REST_CONTENT_TYPE_APP_XHTML_XML);
	
	STAssertTrue([[CPSReSTClient contentTypeForKey:CPSReSTContentTypeApplicationSVGXML] isEqualToString:CPS_REST_CONTENT_TYPE_APP_SVG_XML],
				 @"Wrong content-type ('%@' != '%@')", [CPSReSTClient contentTypeForKey:CPSReSTContentTypeApplicationSVGXML], CPS_REST_CONTENT_TYPE_APP_SVG_XML);
	
	STAssertTrue([[CPSReSTClient contentTypeForKey:CPSReSTContentTypeApplicationAtomXML] isEqualToString:CPS_REST_CONTENT_TYPE_APP_ATOM_XML],
				 @"Wrong content-type ('%@' != '%@')", [CPSReSTClient contentTypeForKey:CPSReSTContentTypeApplicationAtomXML], CPS_REST_CONTENT_TYPE_APP_ATOM_XML);
	
	STAssertTrue([[CPSReSTClient contentTypeForKey:CPSReSTContentTypeApplicationJSON] isEqualToString:CPS_REST_CONTENT_TYPE_APP_JSON],
				 @"Wrong content-type ('%@' != '%@')", [CPSReSTClient contentTypeForKey:CPSReSTContentTypeApplicationJSON], CPS_REST_CONTENT_TYPE_APP_JSON);
	
	STAssertTrue([[CPSReSTClient contentTypeForKey:CPSReSTContentTypeApplicationXWWWFormURLEncoded] isEqualToString:CPS_REST_CONTENT_TYPE_APP_XWWW_FORM_URL_ENCODED],
				 @"Wrong content-type ('%@' != '%@')", [CPSReSTClient contentTypeForKey:CPSReSTContentTypeApplicationXWWWFormURLEncoded], CPS_REST_CONTENT_TYPE_APP_XWWW_FORM_URL_ENCODED);
	
	STAssertTrue([[CPSReSTClient contentTypeForKey:CPSReSTContentTypeApplicationOctetStream] isEqualToString:CPS_REST_CONTENT_TYPE_APP_OCTET_STREAM],
				 @"Wrong content-type ('%@' != '%@')", [CPSReSTClient contentTypeForKey:CPSReSTContentTypeApplicationOctetStream], CPS_REST_CONTENT_TYPE_APP_OCTET_STREAM);
	
	STAssertTrue([[CPSReSTClient contentTypeForKey:CPSReSTContentTypeTextPlain] isEqualToString:CPS_REST_CONTENT_TYPE_TEXT_PLAIN],
				 @"Wrong content-type ('%@' != '%@')", [CPSReSTClient contentTypeForKey:CPSReSTContentTypeTextPlain], CPS_REST_CONTENT_TYPE_TEXT_PLAIN);
	
	STAssertTrue([[CPSReSTClient contentTypeForKey:CPSReSTContentTypeTextXML] isEqualToString:CPS_REST_CONTENT_TYPE_TEXT_XML],
				 @"Wrong content-type ('%@' != '%@')", [CPSReSTClient contentTypeForKey:CPSReSTContentTypeTextXML], CPS_REST_CONTENT_TYPE_TEXT_XML);
	
	STAssertTrue([[CPSReSTClient contentTypeForKey:CPSReSTContentTypeTextHTML] isEqualToString:CPS_REST_CONTENT_TYPE_TEXT_HTML],
				 @"Wrong content-type ('%@' != '%@')", [CPSReSTClient contentTypeForKey:CPSReSTContentTypeTextHTML], CPS_REST_CONTENT_TYPE_TEXT_HTML);
	
	STAssertTrue([[CPSReSTClient contentTypeForKey:CPSReSTContentTypeMultipartFormData] isEqualToString:CPS_REST_CONTENT_TYPE_MP_FORM_DATA],
				 @"Wrong content-type ('%@' != '%@')", [CPSReSTClient contentTypeForKey:CPSReSTContentTypeMultipartFormData], CPS_REST_CONTENT_TYPE_MP_FORM_DATA);

	STAssertTrue([[CPSReSTClient contentTypeForKey:CPSReSTContentTypeImage] isEqualToString:CPS_REST_CONTENT_TYPE_IMAGE],
				 @"Wrong content-type ('%@' != '%@')", [CPSReSTClient contentTypeForKey:CPSReSTContentTypeImage], CPS_REST_CONTENT_TYPE_IMAGE);

}

@end
