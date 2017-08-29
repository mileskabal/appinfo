//
//  CreditsViewController.h
//  appinfo
//
//  Created by Miles on 07/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIWebView.h>
#import <MessageUI/MessageUI.h>

@class AppDetailViewController;

@interface CreditsViewController : UIViewController <UIWebViewDelegate , MFMailComposeViewControllerDelegate> {
	IBOutlet UIWebView *creditsWebview;
	AppDetailViewController *appDetailViewController;
	UIWebView *aWebView;
	UIView *aChargeView;
}

@property (nonatomic, retain) AppDetailViewController *appDetailViewController;

-(void)pushEmail: (NSString*) contactMail andSubject: (NSString*) sujetMail andMessage: (NSString*) messageMail;

@end
