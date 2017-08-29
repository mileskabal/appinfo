//
//  IbooksTableViewController.h
//  appinfo
//
//  Created by Miles on 22/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "CustomCell.h"

@class AppDetailViewController;

@interface IbooksTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
	IBOutlet UITableView *ibooksTableView;
	NSMutableDictionary *dicoIbooks;
	UIWebView *aWebView;
	NSString *emailUser;
    NSString *ibooksPath;
}

@property (nonatomic, retain) IBOutlet UITableView *ibooksTableView;
@property (nonatomic, retain) NSMutableDictionary *dicoIbooks;
@property (nonatomic, retain) UIWebView *aWebView;
@property (nonatomic, retain) NSString *emailUser;
@property (nonatomic, retain) NSString *ibooksPath;

-(void)pushEmail:(NSString*)contactMail andSubject:(NSString*)sujetMail andBody:(NSString*)messageMail;

@end
