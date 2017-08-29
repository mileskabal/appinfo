//
//  ArtistsTableViewController.h
//  appinfo
//
//  Created by Miles on 26/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <sqlite3.h>

@class MorceauxTableViewController;
@class AlbumsTableViewController;


@interface ArtistsTableViewController : UITableViewController < UITableViewDelegate , UITableViewDataSource, UIWebViewDelegate,UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
	NSMutableArray *artistArtiste;
	NSMutableArray *artistPid;
	NSString *emailUser;
    NSString *databasePath;
	BOOL verifios5;
}

@property (nonatomic, retain) NSMutableArray *artistArtiste;
@property (nonatomic, retain) NSMutableArray *artistPid;
@property (nonatomic, retain) NSString *emailUser;
@property (nonatomic, retain) NSString *databasePath;


-(void)pushEmail:(NSString*)contactMail andSubject:(NSString*)sujetMail andBody:(NSString*)messageMail;

@end
