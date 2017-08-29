//
//  appinfoAppDelegate.h
//  appinfo
//
//  Created by Miles on 07/01/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppsNavController;
@class CreditsNavController;
@class PackageNavController;
@class SpringboardNavController;
@class IpodNavController;

@interface appinfoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	NSString *emailConfigF;
	NSString *packageConfig;
	NSString *unitConfig;
	NSString *configOk;
    NSString *nbreMessageSMS;
    NSString *dateFormatter;
    NSString *chatpaging;
    NSString *chatpage;
    NSString *language;
    NSString *languageVal;
    NSString *dateVal;
    NSString *unitVal;
    NSString *iIdHidden;
    
	IBOutlet UITabBarController *rootController;
	IBOutlet AppsNavController *appsNavController;
	IBOutlet CreditsNavController *creditsNavController;
	IBOutlet PackageNavController *packageNavController;
	IBOutlet SpringboardNavController *springboardNavController;
	IBOutlet IpodNavController *ipodNavController;
    
    NSString *pathAppStoreApps;
    NSString *pathCydia;
    NSString *pathCydiaMetadata;
    NSString *pathAptLists;
    NSString *pathDpkgStatus;
    NSString *pathDpkgInfo;
    NSString *pathAppSystem;
    NSString *pathWebclips;
    NSString *pathContacts;
    NSString *pathSms;
    NSString *pathCalendar;
    NSString *pathNotes;
    NSString *pathIbooks;
    NSString *pathMedia;
    NSString *pathDocuments;
    NSString *pathConfig;
    NSString *pathAppInfoSavedFolder;
    NSString *pathSpringboardPosition;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) NSString *emailConfigF;
@property (nonatomic, retain) NSString *packageConfig;
@property (nonatomic, retain) NSString *unitConfig;
@property (nonatomic, retain) NSString *configOk;
@property (nonatomic, retain) NSString *nbreMessageSMS;
@property (nonatomic, retain) NSString *dateFormatter;
@property (nonatomic, retain) NSString *chatpaging;
@property (nonatomic, retain) NSString *chatpage;
@property (nonatomic, retain) NSString *language;
@property (nonatomic, retain) NSString *languageVal;
@property (nonatomic, retain) NSString *dateVal;
@property (nonatomic, retain) NSString *unitVal;
@property (nonatomic, retain) NSString *iIdHidden;
@property (nonatomic, retain) IBOutlet UITabBarController *rootController;
@property (nonatomic, retain) IBOutlet AppsNavController *appsNavController;
@property (nonatomic, retain) IBOutlet CreditsNavController *creditsNavController;
@property (nonatomic, retain) IBOutlet PackageNavController *packageNavController;
@property (nonatomic, retain) IBOutlet SpringboardNavController *springboardNavController;
@property (nonatomic, retain) IBOutlet IpodNavController *ipodNavController;
@property (nonatomic, retain) NSString *pathAppStoreApps;
@property (nonatomic, retain) NSString *pathCydia;
@property (nonatomic, retain) NSString *pathCydiaMetadata;
@property (nonatomic, retain) NSString *pathAptLists;
@property (nonatomic, retain) NSString *pathDpkgStatus;
@property (nonatomic, retain) NSString *pathDpkgInfo;
@property (nonatomic, retain) NSString *pathAppSystem;
@property (nonatomic, retain) NSString *pathWebclips;
@property (nonatomic, retain) NSString *pathContacts;
@property (nonatomic, retain) NSString *pathSms;
@property (nonatomic, retain) NSString *pathCalendar;
@property (nonatomic, retain) NSString *pathNotes;
@property (nonatomic, retain) NSString *pathIbooks;
@property (nonatomic, retain) NSString *pathMedia;
@property (nonatomic, retain) NSString *pathDocuments;
@property (nonatomic, retain) NSString *pathConfig;
@property (nonatomic, retain) NSString *pathAppInfoSavedFolder;
@property (nonatomic, retain) NSString *pathSpringboardPosition;

- (void) updateConfig:(NSString *)key withString:(NSString *)val andVal:(NSString *)value;

@end

