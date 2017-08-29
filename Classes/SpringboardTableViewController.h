//
//  SpringboardTableViewController.h
//  appinfo
//
//  Created by Miles on 21/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SpringboardTableViewController : UITableViewController < UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, MFMailComposeViewControllerDelegate > {
	IBOutlet UITableView *springboardTableView;
	NSMutableArray *rubrique;
    NSString *emailUser;
}

@property (nonatomic , retain) IBOutlet UITableView *springboardTableView;
@property (nonatomic, retain) NSMutableArray *rubrique;
@property (nonatomic, retain) NSString *emailUser;

- (void)exportAction:(id)sender;
- (NSDictionary *) getDeviceInfo;
-(void)pushEmail:(NSString*)contactMail andSubject:(NSString*)sujetMail andBody:(NSString*)messageMail;
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
    
@end
