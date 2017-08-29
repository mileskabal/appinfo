//
//  AlbumsTableViewController.h
//  appinfo
//
//  Created by Miles on 25/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <sqlite3.h>

@class MorceauxTableViewController;

@interface AlbumsTableViewController : UITableViewController < UITableViewDelegate , UITableViewDataSource, UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate > {
	
	NSMutableArray *albumArtiste;
	NSMutableArray *albumAlbum;
	NSMutableArray *albumPid;
	NSString *emailUser;
    NSString *databasePath;
	BOOL verifios5;
}

@property (nonatomic, retain) NSMutableArray *albumArtiste;
@property (nonatomic, retain) NSMutableArray *albumAlbum;
@property (nonatomic, retain) NSMutableArray *albumPid;
@property (nonatomic, retain) NSString *emailUser;
@property (nonatomic, retain) NSString *databasePath;


-(void)pushEmail:(NSString*)contactMail andSubject:(NSString*)sujetMail andBody:(NSString*)messageMail;

@end
