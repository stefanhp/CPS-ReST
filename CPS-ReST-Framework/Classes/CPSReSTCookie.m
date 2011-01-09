//
//  CPSReSTCookie.m
//  CPS-ReST-Framework
//
//  Created by Stefan Hochuli Paychère on 22.04.10.
//  Copyright 2010 Pistache-Soft. All rights reserved.
//

#import "CPSReSTCookie.h"


@implementation CPSReSTCookie

@synthesize name;
@synthesize value;

+ (id)cookieWithName:(NSString *)name andValue:(NSString*)value {
	return [[[CPSReSTCookie alloc] initWithName:name andValue:value]autorelease];
}

- (id)initWithName:(NSString *)myname andValue:(NSString*)myvalue {
	[self setName: myname];
	[self setValue: myvalue];
	return self;
}

@end
