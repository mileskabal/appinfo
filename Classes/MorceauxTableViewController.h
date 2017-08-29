//
//  MorceauxTableViewController.h
//  appinfo
//
//  Created by Miles on 25/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <sqlite3.h>

@class AppDetailViewController;

@interface MorceauxTableViewController : UITableViewController < UITableViewDelegate , UITableViewDataSource, UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate > {
	
	NSMutableArray *chansonInfos;
	NSMutableArray *chansonTitre;
	NSMutableArray *chansonArtiste;
	NSMutableArray *chansonAlbum;
	NSMutableArray *chansonPid;
	NSMutableArray *chansonTotalTime;
	NSMutableArray *chansonComment;
	NSMutableArray *chansonGrouping;
	NSIndexPath *myIndexPath;
	NSString *isAlbum;
	UIWebView *aWebView;
	BOOL actionSheetExport;
	NSString *emailUser;
    NSString *databasePath;
    NSString *mediafilepath;
    NSString *documentPath;
	BOOL verifios5;
}


@property (nonatomic, retain) NSMutableArray *chansonInfos;
@property (nonatomic, retain) NSMutableArray *chansonTitre;
@property (nonatomic, retain) NSMutableArray *chansonArtiste;
@property (nonatomic, retain) NSMutableArray *chansonAlbum;
@property (nonatomic, retain) NSMutableArray *chansonPid;
@property (nonatomic, retain) NSMutableArray *chansonTotalTime;
@property (nonatomic, retain) NSMutableArray *chansonComment;
@property (nonatomic, retain) NSMutableArray *chansonGrouping;
@property (nonatomic, retain) NSIndexPath *myIndexPath;
@property (nonatomic, retain) UIWebView *aWebView;
@property (nonatomic, retain) NSString *isAlbum;
@property (nonatomic, retain) NSString *emailUser;
@property (nonatomic, retain) NSString *databasePath;
@property (nonatomic, retain) NSString *mediafilepath;
@property (nonatomic, retain) NSString *documentPath;


-(void)detailDiscolosureIndicatorSelected:(UIButton *)sender;
-(UIButton *)getDetailDiscolosureIndicatorForIndexPath:(NSIndexPath *)indexPath;
-(void)pushEmail:(NSString*)contactMail andSubject:(NSString*)sujetMail andBody:(NSString*)messageMail;
-(void)pushEmailAttachments:(NSString*)contactMail andSubject:(NSString*)sujetMail andBody:(NSString*)messageMail andAttachments:(NSString*)attachmentsMail andExtension:(NSString*)extensionMail;

@end
