//
//  AppleTableViewController.h
//  appinfo
//
//  Created by Miles on 14/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"

@class AppDetailViewController;


@interface AppleTableViewController : UITableViewController < UITableViewDelegate , UITableViewDataSource, UIWebViewDelegate , UIActionSheetDelegate > {
	IBOutlet UITableView *appleTableView;
	NSString *documentsDir;
	NSMutableDictionary *dicoApple;
	AppDetailViewController *appDetailViewController;
	UIWebView *aWebView;
	UIButton *detailDisclosureButtonType;
	NSString *unitUser;
}

@property (nonatomic, retain) IBOutlet UITableView *appleTableView;
@property (nonatomic, retain) UIWebView *aWebView;
@property (nonatomic, retain) NSString *unitUser;
@property (nonatomic, retain) NSString *documentsDir;
@property (nonatomic, retain) NSMutableDictionary *dicoApple;
@property (nonatomic, retain) AppDetailViewController *appDetailViewController;

-(void)detailDiscolosureIndicatorSelected:(UIButton *)sender;
-(UIButton *)getDetailDiscolosureIndicatorForIndexPath:(NSIndexPath *)indexPath;

@end
