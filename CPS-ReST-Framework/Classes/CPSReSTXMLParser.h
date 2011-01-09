//
//  CPSReSTXMLParser.h
//  CPS-ReST-Framework
//
//  Created by Stefan Hochuli Paychère on 14.05.10.
//  Copyright 2010 Pistache-Soft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CPSReSTXMLParser : NSObject {
	NSMutableArray* stack; // stack of XML parser
	NSXMLParser *parser;
}
+ (NSMutableDictionary*)parseXML:(NSString*) xml;
- (NSMutableDictionary*)parseXML:(NSString*) xml;
@end
