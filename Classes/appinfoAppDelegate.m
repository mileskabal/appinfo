//
//  appinfoAppDelegate.m
//  appinfo
//
//  Created by Miles on 07/01/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "CreditsViewController.h"
#import "CustomCell.h"
#import "appinfoAppDelegate.h"
#import "AppsNavController.h"
#import "AppDetailViewController.h"
#import "CreditsNavController.h"
#import "PackageNavController.h"
#import "SpringboardNavController.h"
#import "IpodNavController.h"

@implementation appinfoAppDelegate

@synthesize window;
@synthesize emailConfigF;
@synthesize packageConfig;
@synthesize unitConfig;
@synthesize configOk;
@synthesize nbreMessageSMS;
@synthesize dateFormatter;
@synthesize chatpage;
@synthesize chatpaging;
@synthesize language;
@synthesize languageVal;
@synthesize dateVal;
@synthesize unitVal;
@synthesize iIdHidden;
@synthesize rootController;
@synthesize appsNavController;
@synthesize creditsNavController;
@synthesize packageNavController;
@synthesize springboardNavController;
@synthesize ipodNavController;
@synthesize pathAppStoreApps;
@synthesize pathCydia;
@synthesize pathCydiaMetadata;
@synthesize pathAptLists;
@synthesize pathDpkgStatus;
@synthesize pathDpkgInfo;
@synthesize pathAppSystem;
@synthesize pathWebclips;
@synthesize pathContacts;
@synthesize pathSms;
@synthesize pathCalendar;
@synthesize pathNotes;
@synthesize pathIbooks;
@synthesize pathMedia;
@synthesize pathDocuments;
@synthesize pathConfig;
@synthesize pathAppInfoSavedFolder;
@synthesize pathSpringboardPosition;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	//NSLog([NSString stringWithFormat:@"aa %@", [[rootController tabBarItem] valueForKey:]]);
	//NSLog(@"appDelegate");
	
	//appsNavController.view.transform = CGAffineTransformMakeRotation(M_PI/2);
	//appsNavController.view.center = window.center;

#if !TARGET_IPHONE_SIMULATOR
    
    pathAppStoreApps = @"/User/Applications";
    pathCydia = @"/Applications/Cydia.app";
    pathCydiaMetadata = @"/var/lib/cydia/metadata.plist";
    pathAptLists = @"/var/lib/apt/lists";
    pathDpkgStatus = @"/var/lib/dpkg/status";
    pathDpkgInfo = @"/var/lib/dpkg/info";
    pathAppSystem = @"/Applications";
    pathWebclips = @"/User/Library/WebClips";
    pathContacts = @"/User/Library/AddressBook/AddressBook.sqlitedb";
    pathSms = @"/User/Library/SMS/sms.db";
    pathCalendar = @"/User/Library/Calendar/Calendar.sqlitedb";
    pathNotes = @"/User/Library/Notes/notes.sqlite";
    pathIbooks = @"/User/Media/Books/Purchases";
    pathMedia = @"/User/Media";
    pathDocuments = @"/User/Documents";
    pathConfig = @"/User/Library/Preferences/com.mileskabal.appinfo.plist";
    pathAppInfoSavedFolder = @"/User/Media/AppInfo";
    pathSpringboardPosition = @"/User/Library/SpringBoard";
    
#else
    
    pathAppStoreApps = @"/Users/miles/Desktop/iPhone/Applications";
    pathCydia = @"/Users/miles/Desktop/iPhone/Applicationss/Cydia.app";
    pathCydiaMetadata = @"/Users/miles/Desktop/iPhone/lib/cydia/metadata.plist";
    pathAptLists = @"Users/miles/Desktop/iPhone/lib/apt/lists";
    pathDpkgStatus = @"Users/miles/Desktop/iPhone/lib/dpkg/status";
    pathDpkgInfo = @"Users/miles/Desktop/iPhone/lib/dpkg/info";
    pathAppSystem = @"/Users/miles/Desktop/iPhone/Applicationss";
    pathWebclips = @"/Users/miles/Desktop/iPhone/Library/WebClips";
    pathContacts = @"/Users/miles/Desktop/iPhone/Library/AddressBook/AddressBook.sqlitedb";
    pathSms = @"/Users/miles/Desktop/iPhone/Library/SMS/sms.db";
    pathCalendar = @"/Users/miles/Desktop/iPhone/Library/Calendar/Calendar.sqlitedb";
    pathNotes = @"/Users/miles/Desktop/iPhone/Library/Notes/notes.sqlite";
    pathIbooks = @"/Users/miles/Desktop/iPhone/Media/Books/Purchases";
    pathMedia = @"/Users/miles/Desktop/iPhone/Media";
    pathDocuments = @"/Users/miles/Desktop/iPhone/Documents";
    pathConfig = @"/Users/miles/Desktop/iPhone/pref.plist";
    pathAppInfoSavedFolder = @"/Users/miles/Desktop/Export";
    pathSpringboardPosition = @"/Users/miles/Desktop/iPhone/Library/SpringBoard";
    
#endif
    

	if([[NSFileManager defaultManager] fileExistsAtPath:pathConfig] == YES){
		
		NSMutableDictionary *dicoConfig = [[NSMutableDictionary alloc] initWithContentsOfFile:pathConfig];
		
		if([dicoConfig objectForKey:@"Langue"]){
			NSString *langue = [NSString stringWithFormat:@"%@", [dicoConfig objectForKey:@"Langue"]];
			if([langue compare:@"default"] == NSOrderedSame){
				[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AppleLanguages"];
                self.language = @"default";
			}
			else {
				[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObject:langue] forKey:@"AppleLanguages"];
                self.language = langue;
			}
		}
		else {
            self.language = @"default";
		}

		
		if([dicoConfig objectForKey:@"MailDef"]){
			NSString *emailUser = [NSString stringWithFormat:@"%@", [dicoConfig objectForKey:@"MailDef"]];
			if([emailUser compare:@""] == NSOrderedSame){
				self.emailConfigF = @"";
			}
			else {
				self.emailConfigF = emailUser;
			}
		}
		else {
			self.emailConfigF = @"";
		}

		
		if([dicoConfig objectForKey:@"ProPack"]){
			if([[dicoConfig objectForKey:@"ProPack"] boolValue]){
				self.packageConfig = @"1";
			}
			else{
				self.packageConfig = @"0";
			}
		}
		else{
			self.packageConfig = @"1";
		}
		
		
		if([dicoConfig objectForKey:@"Unit"]){
			NSString *langue = [NSString stringWithFormat:@"%@", [dicoConfig objectForKey:@"Unit"]];
			if([langue compare:@""] == NSOrderedSame){
				self.unitConfig = @"o";
			}
			else if([langue compare:@"b"] == NSOrderedSame){
				self.unitConfig = @"b";
			}
			else if([langue compare:@"o"] == NSOrderedSame){
				self.unitConfig = @"o";
			}
			else {
				self.unitConfig = @"o";
			}

		}
		else {
			self.unitConfig = @"o";
		}
		
		
        
        if([dicoConfig objectForKey:@"SMS"]){
            NSString *sms = [NSString stringWithFormat:@"%@", [dicoConfig objectForKey:@"SMS"]];
            if([sms compare:@""] != NSOrderedSame){
				self.nbreMessageSMS = sms;
			}
            else{
                self.nbreMessageSMS = @"100";
            }
		}
		else{
            self.nbreMessageSMS = @"100";
		}
        
        if([dicoConfig objectForKey:@"dateformat"]){
            NSString *dateformat = [NSString stringWithFormat:@"%@", [dicoConfig objectForKey:@"dateformat"]];
            if([dateformat compare:@""] != NSOrderedSame){
				self.dateFormatter = dateformat;
			}
            else{
                self.dateFormatter = @"dd/MM/yyyy";
            }
		}
		else{
            self.dateFormatter = @"dd/MM/yyyy";
		}
        
        if([dicoConfig objectForKey:@"ChatPaging"]){
			if([[dicoConfig objectForKey:@"ChatPaging"] boolValue]){
				self.chatpaging = @"1";
			}
			else{
				self.chatpaging = @"0";
			}
		}
		else{
			self.chatpaging = @"0";
		}
        
        if([dicoConfig objectForKey:@"ChatPage"]){
            NSString *chat = [NSString stringWithFormat:@"%@", [dicoConfig objectForKey:@"ChatPage"]];
            if([chat compare:@""] != NSOrderedSame){
				self.chatpage = chat;
			}
            else{
                self.chatpage = @"100";
            }
		}
		else{
            self.chatpage = @"100";
		}
        
        
        if([dicoConfig objectForKey:@"ituneshide"]){
			if([[dicoConfig objectForKey:@"ituneshide"] boolValue]){
				self.iIdHidden = @"1";
			}
			else{
				self.iIdHidden = @"0";
			}
		}
		else{
			self.iIdHidden = @"0";
		}  
		
		self.configOk = @"1";
		
		
		[dicoConfig release];
	}
	else {
        
        NSMutableDictionary *dicoConfig = [[NSMutableDictionary alloc] init];
        [dicoConfig writeToFile:pathConfig atomically:YES];
		self.configOk = @"0";
		self.emailConfigF = @"";
		self.packageConfig = @"1";
		self.unitConfig = @"o";
        self.unitVal = @"Octets";
        self.nbreMessageSMS = @"100";
        self.dateFormatter = @"dd/MM/yyyy";
        self.chatpaging = @"0";
        self.chatpage = @"100";
        self.language = @"default";
        self.languageVal = @"Default";
        self.dateVal = @"dd/MM/yyyy";
        self.iIdHidden = @"0";
	}
    
	
    NSArray *utv = [NSArray arrayWithObjects:@"o",@"b",nil];
    NSArray *utt = [NSArray arrayWithObjects:@"Octets",@"Bytes",nil];
    for(int i=0;i<[utv count];i++){
        if([[NSString stringWithFormat:@"%@",[utv objectAtIndex:i]] compare:self.unitConfig] == NSOrderedSame){
            self.unitVal = [NSString stringWithFormat:@"%@",[utt objectAtIndex:i]];
        }
    }
    NSArray *lgv = [NSArray arrayWithObjects:@"default",@"en",@"fr",@"de",@"it",@"es",@"pt",@"hr",@"sv",@"cs",@"tr",nil];
    NSArray *lgt = [NSArray arrayWithObjects:@"Default",@"English",@"Français",@"Deutsch",@"Italiano",@"Español",@"Português",@"Hrvatski",@"Svenska",@"Čeština",@"Türkçe",nil];
    for(int i=0;i<[lgv count];i++){
        if([[NSString stringWithFormat:@"%@",[lgv objectAtIndex:i]] compare:self.language] == NSOrderedSame){
            self.languageVal = [NSString stringWithFormat:@"%@",[lgt objectAtIndex:i]];
        }
    }
    NSArray *dtv = [NSArray arrayWithObjects:@"dd/MM/yyyy",@"MM/dd/yyyy",@"yyyy/MM/dd",nil];
    NSArray *dtt = [NSArray arrayWithObjects:@"day/month/year",@"month/day/year",@"year/month/day",nil];
    for(int i=0;i<[dtv count];i++){
        if([[NSString stringWithFormat:@"%@",[dtv objectAtIndex:i]] compare:self.dateFormatter] == NSOrderedSame){
            self.dateVal = [NSString stringWithFormat:@"%@",[dtt objectAtIndex:i]];
        }
    }
    
    
	NSArray *tabBarItemTitles = [NSArray arrayWithObjects: MyLocalizedString(@"_appstore", @""), @"Packages", @"Springboard", @"iPod", MyLocalizedString(@"_credits", @"") , nil];
	for (UITabBarItem *item in rootController.tabBar.items)
	{	
		item.title = [tabBarItemTitles objectAtIndex: [rootController.tabBar.items indexOfObject: item]];
	}
	
    [application setStatusBarStyle:UIStatusBarStyleDefault];
    
    // Override point for customization after application launch
    [window makeKeyAndVisible];
	//[window addSubview:rootController.view];
    [window setRootViewController:rootController];
	//[application setStatusBarStyle:UIStatusBarStyleDefault];
    //[application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
}


- (void) updateConfig:(NSString *)key withString:(NSString *)val andVal:(NSString *)value{
    if([key compare:@"ProPack"] == NSOrderedSame){
        self.packageConfig = val;
    }
    if([key compare:@"MailDef"] == NSOrderedSame){
        self.emailConfigF = val;
    }
    if([key compare:@"Unit"] == NSOrderedSame){
        self.unitConfig = val;
        self.unitVal = value;
    }
    if([key compare:@"SMS"] == NSOrderedSame){
        self.nbreMessageSMS = val;
    }
    if([key compare:@"dateformat"] == NSOrderedSame){
        self.dateFormatter = val;
        self.dateVal = value;
    }
    if([key compare:@"ChatPaging"] == NSOrderedSame){
        self.chatpaging = val;
    }
    if([key compare:@"ChatPage"] == NSOrderedSame){
        self.chatpage = val;
    }
    if([key compare:@"Langue"] == NSOrderedSame){
        self.language = val;
        self.languageVal = value;
        ChangeMyLocalize(val);
    }
    if([key compare:@"ituneshide"] == NSOrderedSame){
        self.iIdHidden = val;
    }
    
}


- (void)dealloc {
    [pathSpringboardPosition release];
    [pathAppInfoSavedFolder release];
    [pathConfig release];
    [pathAppStoreApps release];
    [pathCydia release];
    [pathCydiaMetadata release];
    [pathAptLists release];
    [pathDpkgStatus release];
    [pathDpkgInfo release];
    [pathAppSystem release];
    [pathWebclips release];
    [pathContacts release];
    [pathSms release];
    [pathCalendar release];
    [pathNotes release];
    [pathIbooks release];
    [pathMedia release];
    [pathDocuments release];
	[ipodNavController release];
    [iIdHidden release];
	[unitConfig release];
	[configOk release];
    [nbreMessageSMS release];
    [dateFormatter release];
    [chatpage release];
    [chatpaging release];
    [language release];
    [languageVal release];
    [dateVal release];
    [unitVal release];
	[emailConfigF release];
	[packageConfig release];
	[springboardNavController release];
	[packageNavController release];
	[creditsNavController release];
	[appsNavController release];
	[rootController release];
    [window release];
    [super dealloc];
}


@end
