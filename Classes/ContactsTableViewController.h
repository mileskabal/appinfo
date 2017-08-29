//
//  ContactsTableViewController.h
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

@interface ContactsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate > {
	IBOutlet UITableView *contactsTableView;
	NSMutableDictionary *dicoContacts;
	UIWebView *aWebView;
	NSString *emailUser;
    NSString *contactsPath;
}

@property (nonatomic, retain) IBOutlet UITableView *contactsTableView;
@property (nonatomic, retain) NSMutableDictionary *dicoContacts;
@property (nonatomic, retain) UIWebView *aWebView;
@property (nonatomic, retain) NSString *emailUser;
@property (nonatomic, retain) NSString *contactsPath;

-(void)pushEmail:(NSString*)contactMail andSubject:(NSString*)sujetMail andBody:(NSString*)messageMail;

@end
