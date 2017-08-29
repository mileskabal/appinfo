//
//  Language.m
//  appinfo
//
//  Created by Miles on 08/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Language.h"


@implementation Language

static NSBundle *bundle = nil;

+(void)initialize {
	NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
	NSArray* languages = [defs objectForKey:@"AppleLanguages"];
	NSString *current = [[languages objectAtIndex:0] retain];
	[self setLanguage:current];
	
}

/*
 example calls:
 [Language setLanguage:@"it"];
 [Language setLanguage:@"de"];
 */

+(void)setLanguage:(NSString *)l {
	//NSLog(@"preferredLang: %@", l);
	
	NSString *lang = [NSString stringWithFormat:@"%@", l];
	
	if([l compare:@"en"] != NSOrderedSame && [l compare:@"fr"] != NSOrderedSame && [l compare:@"de"] != NSOrderedSame && [l compare:@"it"] != NSOrderedSame && [l compare:@"es"] != NSOrderedSame && [l compare:@"hr"] != NSOrderedSame && [l compare:@"pt"] != NSOrderedSame && [l compare:@"sv"] != NSOrderedSame && [l compare:@"cs"] != NSOrderedSame && [l compare:@"tr"] != NSOrderedSame){
		lang = @"en";
	}
	
	NSString *path = [[ NSBundle mainBundle ] pathForResource:lang ofType:@"lproj" ];
	bundle = [[NSBundle bundleWithPath:path] retain];
}

+(NSString *)get:(NSString *)key alter:(NSString *)alternate {
	return [bundle localizedStringForKey:key value:alternate table:nil];
}


@end
