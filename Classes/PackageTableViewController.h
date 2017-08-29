//
//  PackageTableViewController.h
//  appinfo
//
//  Created by Miles on 26/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <stdlib.h>
#import <MessageUI/MessageUI.h>
#import "CustomCell.h"

@class AppDetailViewController;

@interface PackageTableViewController : UITableViewController < UITableViewDelegate , UITableViewDataSource, UIWebViewDelegate , UIActionSheetDelegate, MFMailComposeViewControllerDelegate > {

	IBOutlet UITableView *packageTableView;
	NSMutableDictionary *dicoPackage;
	NSMutableDictionary *dicoSource;
	AppDetailViewController *appDetailViewController;
	UIWebView *aWebView;
	NSString *emailUser;
	NSString *unitUser;
    NSString *pathCydia;
    BOOL sortByDate;
    BOOL sortByDateDispo;
    NSString *datetimeFormat;
}

@property (nonatomic, retain) IBOutlet UITableView *packageTableView;
@property (nonatomic, retain) UIWebView *aWebView;
@property (nonatomic, retain) NSString *unitUser;
@property (nonatomic, retain) NSString *emailUser;
@property (nonatomic, retain) NSString *pathCydia;
@property (nonatomic, retain) NSMutableDictionary *dicoPackage;
@property (nonatomic, retain) NSMutableDictionary *dicoSource;
@property (nonatomic, retain) AppDetailViewController *appDetailViewController;
@property (nonatomic, retain) NSString *datetimeFormat;

- (void)exportAction:(id)sender;
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
-(void)pushEmail:(NSString*)contactMail andSubject:(NSString*)sujetMail andBody:(NSString*)messageMail;
-(void)pushEmailAttachments:(NSString*)contactMail andSubject:(NSString*)sujetMail andBody:(NSString*)messageMail andAttachments:(NSString*)attachmentsMail andExtension:(NSString*)extensionMail;

@end
