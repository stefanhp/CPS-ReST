//
//  TestCPSReSTBasicAuthentication.m
//  CPS-ReST-Framework
//
//  Created by Stefan Hochuli Paychère on 22.04.10.
//  Copyright 2010 Pistache-Soft. All rights reserved.
//

#import "TestCPSReSTBasicAuthentication.h"
#import "CPSReSTBasicAuthentication.h"

// Constants
static NSString *const USERNAME = @"username";
static NSString *const PASSWORD = @"password";
static NSString *const COMPLEX_USERNAME = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+*%/()=?$";
static NSString *const COMPLEX_PASSWORD = @"+*%/()=?$0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

// Encoding provided by http://www.motobit.com/util/base64-decoder-encoder.asp
static NSString *const ENCODED_USERNAME_PASSWORD = @"dXNlcm5hbWU6cGFzc3dvcmQ=";
static NSString *const ENCODED_COMPLEX_USERNAME_PASSWORD = @"QUJDREVGR0hJSktMTU5PUFFSU1RVVldYWVphYmNkZWZnaGlqa2xtbm9wcXJzdHV2d3h5ejAxMjM0NTY3ODkrKiUvKCk9PyQ6KyolLygpPT8kMDEyMzQ1Njc4OWFiY2RlZmdoaWprbG1ub3BxcnN0dXZ3eHl6QUJDREVGR0hJSktMTU5PUFFSU1RVVldYWVo=";

@implementation TestCPSReSTBasicAuthentication

- (void)testEncoding{
	CPSReSTBasicAuthentication* bs = [[CPSReSTBasicAuthentication alloc]init];

	STAssertNil([bs encodedUsernameAndPassword], @"%@", [bs encodedUsernameAndPassword]);
	
	[bs setUsername:USERNAME];
	[bs setPassword:PASSWORD];

	STAssertNotNil([bs encodedUsernameAndPassword], @"encodedUsernameAndPassword should not be nil");
	STAssertTrue([[bs encodedUsernameAndPassword] isEqualToString:ENCODED_USERNAME_PASSWORD], @"Wrong encoding ('%@' != '%@')", [bs encodedUsernameAndPassword], ENCODED_USERNAME_PASSWORD);
	
	[bs setUsername:COMPLEX_USERNAME];
	[bs setPassword:COMPLEX_PASSWORD];
	
	STAssertNotNil([bs encodedUsernameAndPassword], @"encodedUsernameAndPassword should not be nil");
	STAssertTrue([[bs encodedUsernameAndPassword] isEqualToString:ENCODED_COMPLEX_USERNAME_PASSWORD], @"Wrong encoding ('%@' != '%@')", [bs encodedUsernameAndPassword], ENCODED_COMPLEX_USERNAME_PASSWORD);
}

@end
