//
//  SmsTableViewController.h
//  appinfo
//
//  Created by Miles on 22/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <sqlite3.h>
//#import "CustomCell.h"

@class AppDetailViewController;

@interface SmsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>{
	IBOutlet UITableView *smsTableView;
	NSMutableDictionary *dicoSms;
    NSMutableArray *dicoChat;
    NSString *smsPath;
    NSString *contactPath;
	UIWebView *aWebView;
	NSString *emailUser;
    NSString *requeteCurrent;
    int pageCurrent;
    int pageTotal;
    int pageNbr;
    int chatCurrent;
    int chatTotal;
    int chatNbr;
    NSString *datetimeFormat;
    UIImage *imageSMS;
}

@property (nonatomic, retain) IBOutlet UITableView *smsTableView;
@property (nonatomic, retain) NSMutableDictionary *dicoSms;
@property (nonatomic, retain) NSMutableArray *dicoChat;
@property (nonatomic, retain) NSString *smsPath;
@property (nonatomic, retain) NSString *contactPath;
@property (nonatomic, retain) UIWebView *aWebView;
@property (nonatomic, retain) NSString *emailUser;
@property (nonatomic, retain) NSString *requeteCurrent;
@property (nonatomic, retain) NSString *datetimeFormat;
@property (nonatomic, retain) UIImage *imageSMS;



-(void)pushEmail:(NSString*)contactMail andSubject:(NSString*)sujetMail andBody:(NSString*)messageMail;

@end
