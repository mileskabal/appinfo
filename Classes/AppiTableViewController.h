//
//  AppiTableViewController.h
//  appinfo
//
//  Created by Miles on 10/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "CustomCell.h"

@class AppDetailViewController;

@interface AppiTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, UIActionSheetDelegate,MFMailComposeViewControllerDelegate> {
	IBOutlet UITableView *appiTableView;
	NSString *documentsDir;
	NSMutableDictionary *dicoApp;
	AppDetailViewController *appDetailViewController;
	UIWebView *aWebView;
	UIButton *detailDisclosureButtonType;
	NSString *emailUser;
	NSString *unitUser;
}

@property (nonatomic, retain) IBOutlet UITableView *appiTableView;
@property (nonatomic, retain) UIWebView *aWebView;
@property (nonatomic, retain) NSString *emailUser;
@property (nonatomic, retain) NSString *unitUser;
@property (nonatomic, retain) NSString *documentsDir;
@property (nonatomic, retain) NSMutableDictionary *dicoApp;
@property (nonatomic, retain) AppDetailViewController *appDetailViewController;

-(void)detailDiscolosureIndicatorSelected:(UIButton *)sender;
-(UIButton *)getDetailDiscolosureIndicatorForIndexPath:(NSIndexPath *)indexPath;
-(void)pushEmail:(NSString*)contactMail andSubject:(NSString*)sujetMail andBody:(NSString*)messageMail;

@end
