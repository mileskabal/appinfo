//
//  NotesTableViewController.h
//  appinfo
//
//  Created by Miles on 22/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <sqlite3.h>
#import "CustomCell.h"

@class AppDetailViewController;

@interface NotesTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate,UIActionSheetDelegate, MFMailComposeViewControllerDelegate>{
	IBOutlet UITableView *notesTableView;
	NSMutableDictionary *dicoNotes;
	UIWebView *aWebView;
	NSString *emailUser;
    NSString *notesPath;
}

@property (nonatomic, retain) IBOutlet UITableView *notesTableView;
@property (nonatomic, retain) NSMutableDictionary *dicoNotes;
@property (nonatomic, retain) UIWebView *aWebView;
@property (nonatomic, retain) NSString *emailUser;
@property (nonatomic, retain) NSString *notesPath;

-(void)pushEmail:(NSString*)contactMail andSubject:(NSString*)sujetMail andBody:(NSString*)messageMail;


@end
