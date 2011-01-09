//
//  CPSReSTXMLParser.m
//  CPS-ReST-Framework
//
//  Created by Stefan Hochuli Paychère on 14.05.10.
//  Copyright 2010 Pistache-Soft. All rights reserved.
//

#import "CPSReSTXMLParser.h"

#define PARSE_TEXT @"text"

@implementation CPSReSTXMLParser
+ (NSMutableDictionary*)parseXML:(NSString*) xml {
	CPSReSTXMLParser *p=[[CPSReSTXMLParser alloc] init];
	NSMutableDictionary *res=[p parseXML:xml];
	[p release];
	return res;
}

- (NSMutableDictionary*)parseXML:(NSString*) xml {
	//NSLog(@"%s = %@",__FUNCTION__,xml);
	NSMutableDictionary *res=[[[NSMutableDictionary alloc] init] autorelease];
	stack=[[NSMutableArray alloc] initWithObjects:res, nil];
	parser=[[NSXMLParser alloc] initWithData:[xml dataUsingEncoding:NSUTF8StringEncoding]];
	[parser setDelegate:self];
	[parser parse];
	[parser release];
	[stack release];
	//NSLog(@"%s = %@",__FUNCTION__,res);
	return res;
}

#pragma mark -
#pragma mark NSXMLParser Delegate methods

- (void)parser:(NSXMLParser*)p didStartElement:(NSString *)name namespaceURI:(NSString *)ns qualifiedName:(NSString *)qn attributes:(NSDictionary *)attr {
	NSMutableDictionary *d=[[[NSMutableDictionary alloc] init] autorelease];
	// Add attributes if any, prefixing names with "@"
	if(attr != nil && [attr count]>0){
		for(NSString* key in attr){
			[d setObject:[attr objectForKey:key] forKey:[@"@" stringByAppendingString:key]];
		}
	}
	// Add object to stack
	NSObject *obj=[[stack lastObject] objectForKey:name];
	if (obj!=nil) {
		NSMutableArray *a;
		if ([obj isKindOfClass:[NSArray class]]){
			a=(NSMutableArray*)obj;
		} else {
			a=[NSMutableArray array];
			[a addObject:obj];
			[[stack lastObject] setObject:a forKey:name];
		}
		[a addObject:d];
	} else {
		[[stack lastObject] setObject:d forKey:name];
	}
	[stack addObject:d];
}

- (void)parser:(NSXMLParser*)p didEndElement:(NSString *)name namespaceURI:(NSString *)ns qualifiedName:(NSString *)qn {
	NSMutableDictionary *d=[stack lastObject];
	NSString *s=[d objectForKey:PARSE_TEXT];
	[stack removeLastObject];
	if ([d count]==1 && s!=nil) {
		NSMutableDictionary *c=[stack lastObject];
		NSArray *k=[c allKeysForObject:d];
		[c setObject:s forKey:[k objectAtIndex:0]];
	}	
}

- (void)parser:(NSXMLParser*)p foundCharacters:(NSString *)string {
	string=[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if (![string length]){
		return;
	}
	
	NSMutableDictionary *d=[stack lastObject];
	NSString* s=[d objectForKey:PARSE_TEXT];
	if (s!=nil) {
		[d setObject:[s stringByAppendingString:string] forKey:PARSE_TEXT];
	} else {
		[d setObject:string forKey:PARSE_TEXT];
	}
}

@end
