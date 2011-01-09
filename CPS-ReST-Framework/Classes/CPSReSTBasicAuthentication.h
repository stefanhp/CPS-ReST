//
//  CPSReSTBasicAuthentication.h
//  CPS-ReST-Framework
//
//  Created by Stefan Hochuli Paychère on 22.04.10.
//  Copyright 2010 Pistache-Soft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CPSReSTBasicAuthentication : NSObject {
	NSString* username;
	NSString* password;
}

@property (retain,readwrite) NSString* username;
@property (retain,readwrite) NSString* password;

- (NSString *)encodedUsernameAndPassword;
@end

@interface CPSReSTBasicAuthentication (base64)
+ (NSString *)base64Encode:(NSString*)input;
@end
