//
//  CalendrierTableViewController.h
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

@interface CalendrierTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate >{
	IBOutlet UITableView *calTableView;
    NSMutableArray *dicoCalendar;
    NSMutableArray *dicoCalendarFiltered;
	UIWebView *aWebView;
	NSString *emailUser;
    NSString *id_calendar_event;
    NSString *calendarPath;
    NSMutableArray *calendar_id_hidden;
    NSMutableArray *calendar_id_all;
    NSString *datetimeFormat;
}

@property (nonatomic, retain) IBOutlet UITableView *calTableView;
@property (nonatomic, retain) NSMutableArray *dicoCalendar;
@property (nonatomic, retain) NSMutableArray *dicoCalendarFiltered;
@property (nonatomic, retain) UIWebView *aWebView;
@property (nonatomic, retain) NSString *emailUser;
@property (nonatomic, retain) NSString *id_calendar_event;
@property (nonatomic, retain) NSString *calendarPath;
@property (nonatomic, retain) NSMutableArray *calendar_id_hidden;
@property (nonatomic, retain) NSMutableArray *calendar_id_all;
@property (nonatomic, retain) NSString *datetimeFormat;

-(void)pushEmail:(NSString*)contactMail andSubject:(NSString*)sujetMail andBody:(NSString*)messageMail;


@end
