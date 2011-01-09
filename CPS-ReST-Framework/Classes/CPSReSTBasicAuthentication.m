//
//  CPSReSTBasicAuthentication.m
//  CPS-ReST-Framework
//
//  Created by Stefan Hochuli Paychère on 22.04.10.
//  Copyright 2010 Pistache-Soft. All rights reserved.
//

#import "CPSReSTBasicAuthentication.h"


@implementation CPSReSTBasicAuthentication

@synthesize username;
@synthesize password;

- (NSString *)encodedUsernameAndPassword{
	if(username != nil && password != nil){
		return [CPSReSTBasicAuthentication base64Encode:[NSString stringWithFormat:@"%@:%@",username,password ]];
	}
	return nil;
}

@end

static char base64EncodingTable[64] = {
	'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
	'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
	'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
	'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
}; 

@implementation CPSReSTBasicAuthentication (base64)
+ (NSString *)base64Encode:(NSString*)input{
	unsigned char base64Characters[4];
	unsigned char inputProcessed[3];
	int inputLength = [input length];
	int newCharCount;
	NSMutableString *encodedString = [[NSMutableString alloc] initWithCapacity:[input length] +2];
	const char * cString = [input cStringUsingEncoding:NSASCIIStringEncoding];
	//Process by groups of 3 bytes  
	for(int offset = 0; offset < [input length];offset+=3) {
		newCharCount = 0;
		for(int i = 0; i < 3; i++) {
			if (offset +i < inputLength) {
				inputProcessed[i] = cString[offset +i];
				newCharCount++;
			} else {// if "overflow" set byte to 0 
				inputProcessed[i] = 0;
			}
		}
		base64Characters[0] = (inputProcessed[0] & 0xFC) >> 2;
		base64Characters[1] = ((inputProcessed[0] & 0x03)<< 4) | ((inputProcessed[1] & 0xF0) >> 4);
		base64Characters[2] = ((inputProcessed[1] & 0x0F) << 2) | ((inputProcessed[2] & 0xC0) >> 6);
		base64Characters[3] = (inputProcessed[2] & 0x3F);
		for(int i = 0; i<= 3; i++){
			if (i <= newCharCount) {
				[encodedString appendFormat:@"%c", base64EncodingTable[base64Characters[i]]];
			} else {
				[encodedString appendFormat:@"="];
			}
		}
	}
	return [encodedString autorelease];
}
@end
