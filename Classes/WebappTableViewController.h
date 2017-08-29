//
//  WebappTableViewController.h
//  appinfo
//
//  Created by Miles on 22/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "CustomCell.h"

@class AppDetailViewController;

@interface WebappTableViewController : UITableViewController < UITableViewDelegate, UITableViewDataSource ,UIWebViewDelegate, UIActionSheetDelegate,MFMailComposeViewControllerDelegate> {
	IBOutlet UITableView *webappTableView;
	NSMutableDictionary *dicoWebapp;
	UIWebView *aWebView;
	NSString *emailUser;
	NSString *unitUser;
    NSString *documentsDir;
}

@property (nonatomic, retain) IBOutlet UITableView *webappTableView;
@property (nonatomic, retain) NSMutableDictionary *dicoWebapp;
@property (nonatomic, retain) UIWebView *aWebView;
@property (nonatomic, retain) NSString *emailUser;
@property (nonatomic, retain) NSString *unitUser;
@property (nonatomic, retain) NSString *documentsDir;


-(void)pushEmail:(NSString*)contactMail andSubject:(NSString*)sujetMail andBody:(NSString*)messageMail;

@end
