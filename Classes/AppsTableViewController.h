//
//  AppsTableViewController.h
//  appinfo
//
//  Created by Miles on 07/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "CustomCell.h"
//#import <SpringBoard/SpringBoard.h>

@class AppDetailViewController;
//@class SBApplicationController;
//@class SBApplicationController;


@interface AppsTableViewController : UITableViewController < UITableViewDelegate , UITableViewDataSource , UIWebViewDelegate, UIActionSheetDelegate,MFMailComposeViewControllerDelegate > {
	IBOutlet UITableView *appsTableView;
	NSString *documentsDir;
	NSMutableDictionary *dicoApp;
	NSMutableDictionary *dicoAppiTunes;
	AppDetailViewController *appDetailViewController;
	UIWebView *aWebView;
	UIButton *detailDisclosureButtonType;
	NSString *emailUser;
	NSString *unitUser;
    
    NSString *dateFormat;
    NSString *datetimeFormat;
	
	NSMutableArray *appByDateArray;
    NSMutableArray *appBySize;
	NSMutableArray *arrayOfCharacters;
	NSMutableDictionary *objectsForCharacters;
	BOOL appBySizeDispo;
	BOOL appBySizeSort;
    BOOL appByDate;
	/*
	NSMutableArray *copyListOfItems;
	IBOutlet UISearchBar *searchBar;
	BOOL searching;
	BOOL letUserSelectRow;
	 */
	
}

@property (nonatomic, retain) UIWebView *aWebView;
@property (nonatomic, retain) IBOutlet UITableView *appsTableView;
@property (nonatomic, retain) NSMutableArray *appByDateArray;
@property (nonatomic, retain) NSMutableArray *appBySize;
@property (nonatomic, retain) NSMutableArray *arrayOfCharacters;
@property (nonatomic, retain) NSMutableDictionary *objectsForCharacters;
@property (nonatomic, retain) NSString *emailUser;
@property (nonatomic, retain) NSString *unitUser;
@property (nonatomic, retain) NSString *documentsDir;
@property (nonatomic, retain) NSString *dateFormat;
@property (nonatomic, retain) NSString *datetimeFormat;
@property (nonatomic, retain) NSMutableDictionary *dicoApp;
@property (nonatomic, retain) NSMutableDictionary *dicoAppiTunes;
@property (nonatomic, retain) AppDetailViewController *appDetailViewController;

-(void)detailDiscolosureIndicatorSelected:(UIButton *)sender;
-(UIButton *)getDetailDiscolosureIndicatorForIndexPath:(NSIndexPath *)indexPath enableOrDisable:(NSString *)disaenable;
-(void)actionDetailDiscolosureIndicatorSelected:(NSIndexPath *)indexPath;

- (void)exportAction:(id)sender;

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)startTheBackgroundJob;

- (void)finiTaff;
- (void)ajoutSizeDico:(NSMutableArray *)ajoutSize;
- (void) pourcentage:(NSString *)pourcentActu;
- (NSString *)stringFromDateIsoString:(NSString *)dateString withFormat:(NSString *)formater;
- (void)exportActionApp:(id)sender;

-(void)pushEmail:(NSString*)contactMail andSubject:(NSString*)sujetMail andBody:(NSString*)messageMail;
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
-(void)pushEmailAttachments:(NSString*)contactMail andSubject:(NSString*)sujetMail andBody:(NSString*)messageMail andAttachments:(NSString*)attachmentsMail andExtension:(NSString*)extensionMail;

@end
