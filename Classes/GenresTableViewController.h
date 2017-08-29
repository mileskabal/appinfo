//
//  GenresTableViewController.h
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
@class ArtistsTableViewController;

@interface GenresTableViewController : UITableViewController < UITableViewDelegate , UITableViewDataSource, UIWebViewDelegate,UIActionSheetDelegate, MFMailComposeViewControllerDelegate > {
	NSMutableArray *genreNom;
	NSMutableArray *genrePid;
	NSString *emailUser;
    NSString *databasePath;
	BOOL verifios5;
}

@property (nonatomic, retain) NSMutableArray *genreNom;
@property (nonatomic, retain) NSMutableArray *genrePid;
@property (nonatomic, retain) NSString *emailUser;
@property (nonatomic, retain) NSString *databasePath;


-(void)pushEmail:(NSString*)contactMail andSubject:(NSString*)sujetMail andBody:(NSString*)messageMail;

@end
