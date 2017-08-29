//
//  RemindersViewController.h
//  appinfo
//
//  Created by Miles on 19/02/14.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <sqlite3.h>
#import "CustomCell.h"

@class AppDetailViewController;

@interface RemindersViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate >{
    IBOutlet UITableView *remindersTableView;
    NSMutableArray *dicoReminders;
    NSMutableArray *dicoRemindersFiltered;
    UIWebView *aWebView;
	NSString *emailUser;
    NSString *id_calendar_event;
    NSString *calendarPath;
    NSMutableArray *reminders_id_hidden;
    NSMutableArray *reminders_id_all;
    NSString *datetimeFormat;
    BOOL completedFilter;
}

@property (nonatomic, retain) IBOutlet UITableView *remindersTableView;
@property (nonatomic, retain) NSMutableArray *dicoReminders;
@property (nonatomic, retain) NSMutableArray *dicoRemindersFiltered;
@property (nonatomic, retain) UIWebView *aWebView;
@property (nonatomic, retain) NSString *emailUser;
@property (nonatomic, retain) NSString *id_calendar_event;
@property (nonatomic, retain) NSString *calendarPath;
@property (nonatomic, retain) NSMutableArray *reminders_id_hidden;
@property (nonatomic, retain) NSMutableArray *reminders_id_all;
@property (nonatomic, retain) NSString *datetimeFormat;

-(void)pushEmail:(NSString*)contactMail andSubject:(NSString*)sujetMail andBody:(NSString*)messageMail;

@end
