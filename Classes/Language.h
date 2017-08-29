//
//  Language.h
//  appinfo
//
//  Created by Miles on 08/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Language : NSObject {

}

+(void)setLanguage:(NSString *)l;
+(NSString *)get:(NSString *)key alter:(NSString *)alternate;

@end
