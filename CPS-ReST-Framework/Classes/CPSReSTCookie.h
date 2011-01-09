//
//  CPSReSTCookie.h
//  CPS-ReST-Framework
//
//  Created by Stefan Hochuli Paychère on 22.04.10.
//  Copyright 2010 Pistache-Soft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CPSReSTCookie : NSObject {
	NSString *name;
	NSString *value;
}

@property (nonatomic,retain) NSString* name;
@property (nonatomic,retain) NSString* value;

+(id)cookieWithName:(NSString *)name andValue:(NSString*)value;
-(id)initWithName:(NSString *)myname andValue:(NSString*)myvalue;

@end
