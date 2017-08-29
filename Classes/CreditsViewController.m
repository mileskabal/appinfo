//
//  CreditsViewController.m
//  appinfo
//
//  Created by Miles on 07/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CreditsViewController.h"
#import "AppDetailViewController.h"
#import "SettingsTableViewController.h"
#import "ALSystem.h"
#import "appinfoAppDelegate.h"

@implementation CreditsViewController

@synthesize appDetailViewController;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"AppInfo";
    NSString *versionnumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	
    
    NSString *margintop = @"";
    if(([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)){
        margintop = @"margin-top:35px;";
    }
	
	NSString *lienTwitter = @"";
	BOOL TwitterApp = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"com.atebits.Tweetie2:"]];
	if(TwitterApp){
		lienTwitter = @"twitter://user?screen_name=mileskabal";
	}
	else{
		lienTwitter = @"http://mobile.twitter.com/mileskabal";
	}
	
	
	NSString *lienMail;
	
	lienMail = [NSString stringWithFormat:@"<div class=\"iMenu\" style=\"margin-bottom:10px;\"><ul class=\"iArrow\" style=\"margin-bottom:10px;\"><li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"settings:\"><img src=\"settings.png\" style=\"float:left;margin:0 5px\" width=\"25\" />%@</a></li><li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"http://mileskabal.com/cydia/?app=appinfo\"><img src=\"Icon.png\" style=\"float:left;margin:0 5px\" width=\"25\" />%@</a></li><li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"contactme:appinfo@mileskabal.com\"><img src=\"mail.png\" style=\"float:left;margin:0 5px\" width=\"25\" />%@</a></li><li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"http://mileskabal.com\"><img src=\"mileskabalcom.png\" style=\"float:left;margin:0 5px\" width=\"25\" />mileskabal.com</a></li><li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"%@\"><img src=\"twitter.png\" style=\"float:left;margin:0 5px\" width=\"25\" />%@</a></li><li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"donpaypal://miles\"><img src=\"paypal.png\" style=\"float:left;margin:0 5px\" width=\"25\" />%@</a></li></ul></div>",MyLocalizedString(@"_reglages",@""),MyLocalizedString(@"_apropos",@""),MyLocalizedString(@"_contact",@""),lienTwitter,MyLocalizedString(@"_suivezmoitwitter",@""),MyLocalizedString(@"_don",@"")];
	NSString *myHTML = [NSString stringWithFormat:@"<html><head><link href=\"Render.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body> <div id=\"WebApp\"><div id=\"iGroup\"><div class=\"iBlock\" style=\"margin-bottom:10px;%@\"><p style=\"padding-bottom:10px\"><img src=\"Icon@2x.png\" width=\"60\" style=\"float:left;margin:0 5px\" /><a href=\"http://mileskabal.com/cydia/?app=appinfo\" style=\"text-decoration:none;font-weight:bold;\">AppInfo</a> by Miles<br />%@ : %@<br />&copy; 2014 mileskabal.com</p></div> %@  </div></div></body></html>",margintop,MyLocalizedString(@"_version",@""),versionnumber,lienMail];
	//MyLocalizedString(@"_news",@"")
	[creditsWebview setDelegate:self];
	[creditsWebview loadHTMLString:myHTML baseURL:baseURL];
	
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	
	NSURL *URL = [request URL];	
	NSString *urlString = [URL absoluteString];
	if(navigationType == UIWebViewNavigationTypeLinkClicked) {
		if([urlString hasPrefix:@"mailto"]){
			
			NSString *addmail = [urlString stringByReplacingOccurrencesOfString:@"mailto:" withString:@""];
			[self  pushEmail:(addmail) andSubject:@"AppInfo Contact" andMessage:@""];
		}
		else if([urlString hasPrefix:@"twitter"]){
			
			//NSString *stringURL = [NSString stringWithFormat:@"ifile:///var/mobile/Media/iTunes_Control/Music/%@",location];
			NSURL *url = [NSURL URLWithString:urlString];
			[[UIApplication sharedApplication] openURL:url];
		
		}
		else if([urlString hasPrefix:@"donpaypal"]){
			
			NSString *paypal = @"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=KJR6K2SN5E9AW&lc=FR&item_name=AppInfo%20by%20Miles&item_number=AppInfo&currency_code=EUR&bn=PP%2dDonationsBF%3aavatar%2ejpg%3aNonHosted";
			NSURL *url = [NSURL URLWithString:paypal];
			[[UIApplication sharedApplication] openURL:url];
			//return NO;
			
		}
        else if([urlString hasPrefix:@"settings"]){
            SettingsTableViewController *settingsTableViewController = [[SettingsTableViewController alloc] initWithNibName:@"SettingsTableViewController" bundle:nil];
            settingsTableViewController.title = [NSString stringWithFormat:@"AppInfo - %@", MyLocalizedString(@"_reglages",@"")];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:settingsTableViewController];
            nav.navigationBar.tintColor = UIColorFromRGB(0x0B4E92);
            
            UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] init];
            saveButton.title = @"Ok";
            settingsTableViewController.navigationItem.leftBarButtonItem = saveButton;
            [saveButton setTarget:self];
            [saveButton setAction:@selector(okSettings:)];
            [saveButton release];
            
            [self presentViewController:nav animated:YES completion:nil];
        }
        else if([urlString hasPrefix:@"contactme"]){
			AppDetailViewController *aAppDetail = [[AppDetailViewController alloc] initWithNibName:@"AppDetailViewController" bundle:nil];
			self.appDetailViewController = aAppDetail;
			appDetailViewController.title = MyLocalizedString(@"_contact",@"");
            aChargeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
            aChargeView.alpha = 0;
            aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];//init and create the UIWebView
			aWebView.autoresizesSubviews = YES;
			aWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
            NSString *path = [[NSBundle mainBundle] bundlePath];
			NSURL *baseURL = [NSURL fileURLWithPath:path];
			NSString *myHTML = [NSString stringWithFormat:@"<html><head><link href=\"Render.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body> <div id=\"WebApp\"><div id=\"iGroup\"><div class=\"iBlock\" style=\"margin-bottom:10px;\"><p style=\"padding-bottom:10px;\"><img src=\"mail.png\" width=\"25\" style=\"float:left;margin:0 7px 0 0\" /> <span style=\"display:inline-block;margin-top:3px;margin-bottom:4px\"><b>%@</b></span><br />%@</p></div><div class=\"iBlock\"><p><b>%@ :</b><textarea id=\"bodymail\" style=\"width:100%%;height:130px;font-size:1.1em;margin-bottom:7px;\"></textarea><br /><a href=\"actioncontactme:appinfo@mileskabal.com\" style=\"text-decoration:none;color:#7E7E84;text-transform:uppercase;font-weight:bold;\">%@</a></div></p></div></div></body></html>", MyLocalizedString(@"_contact",@""),MyLocalizedString(@"_creditstexte",@""),MyLocalizedString(@"_message",@""),MyLocalizedString(@"_envoiparemail",@"")];
			[aWebView loadHTMLString:myHTML baseURL:baseURL];
            [aWebView setDelegate:self];
			[appDetailViewController.view addSubview:aWebView];
			[aWebView release];
            aWebView = nil;
			[self.navigationController pushViewController:appDetailViewController animated:YES];
            [appDetailViewController release];
            appDetailViewController = nil;
            [aAppDetail release];
            aAppDetail = nil;
			return NO;
			
		}
        else if([urlString hasPrefix:@"actioncontactme"]){
            NSString *messagecontent = [NSString stringWithString:[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('bodymail').value"]];
            if([messagecontent compare:@""] == NSOrderedSame){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"your message is empty..." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            else{
                messagecontent = [messagecontent stringByAppendingFormat:@"\n\n%@ - iOS %@ | AppInfo v%@",[ALHardware platformType],[ALHardware systemVersion],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
                [self  pushEmail:@"appinfo@mileskabal.com" andSubject:@"AppInfo Contact" andMessage:messagecontent];
            }
        
        }
		else if([urlString hasPrefix:@"http"] || [urlString hasPrefix:@"https"]){
			
			AppDetailViewController *aAppDetail = [[AppDetailViewController alloc] initWithNibName:@"AppDetailViewController" bundle:nil];
			self.appDetailViewController = aAppDetail;
			[aAppDetail release];
            aAppDetail = nil;
			
			
			
			
			aChargeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
			/*aChargeView.backgroundColor = [[UIColor alloc] initWithRed:50.0 / 255 green:50.0 / 255 blue:50.0 / 255 alpha:100];//[UIColor grayColor];
			 
			 UILabel *myLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(60, 140, 200, 80)];
			 myLabel2.text = MyLocalizedString(@"_chargement",@"");
			 myLabel2.textAlignment = UITextAlignmentCenter;
			 myLabel2.textColor = [UIColor whiteColor];
			 myLabel2.shadowColor = [UIColor blackColor];
			 myLabel2.shadowOffset = CGSizeMake(1,1);
			 //myLabel2.font = [UIFont fontWithName:@"Zapfino" size:20];
			 myLabel2.backgroundColor = [[UIColor alloc] initWithRed:50.0 / 255 green:50.0 / 255 blue:50.0 / 255 alpha:100]; //[UIColor macolor];
			 [aChargeView addSubview:myLabel2];
			 [myLabel2 release];*/
			
			UIActivityIndicatorView  *av = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
			av.frame=CGRectMake(135, 120, 40, 40);
			av.tag  = 1;
			[aChargeView addSubview:av];
			[av startAnimating];
			
			if([urlString hasPrefix:@"http://mileskabal.com/cydia/?app=appinfo"]){
				appDetailViewController.title = @"AppInfo";
			}
			else if([urlString hasPrefix:@"http://mileskabal"]){
				appDetailViewController.title = @"mileskabal.com";
			}
			else if([urlString hasPrefix:@"http://mobile.twitter"]){
				appDetailViewController.title = @"Twitter";
			}
			else{
				appDetailViewController.title = @"Web";
			}
			
			aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];//init and create the UIWebView
			aWebView.autoresizesSubviews = YES;
			aWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
			
			aWebView.scalesPageToFit = YES;
			/*
			 NSString *path = [[NSBundle mainBundle] bundlePath];
			 NSURL *baseURL = [NSURL fileURLWithPath:path];
			 
			 NSString *myHTML = [NSString stringWithFormat:@"<html><head><link href=\"Render.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body> <div id=\"WebApp\"><div id=\"iGroup\"><div class=\"iBlock\"><p>YO</p></div></div></div></body></html>"];
			 [aWebView loadHTMLString:myHTML baseURL:baseURL];
			 */
			NSURLRequest *requestObj = [NSURLRequest requestWithURL:URL];
			[aWebView loadRequest:requestObj];
			
			[aWebView setDelegate:self];
			[appDetailViewController.view addSubview:aWebView];
			[appDetailViewController.view addSubview:aChargeView];
			
			[aWebView release];
            aWebView = nil;
			
			//appinfoAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
			//[delegate.creditsNavController pushViewController:appDetailViewController animated:YES];
			[self.navigationController pushViewController:appDetailViewController animated:YES];
			//[creditsNavbar pushViewController:appDetailViewController animated:YES];
			[appDetailViewController release];
            appDetailViewController = nil;
			return NO;
		}
		
	}
	
	return YES;
}

-(void)okSettings:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	aChargeView.alpha = 0;
    [aChargeView release];
    aChargeView = nil;
	
}

-(void)pushEmail: (NSString*) contactMail andSubject: (NSString*) sujetMail andMessage: (NSString*) messageMail {
	
	MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
	mail.mailComposeDelegate = self;
    mail.navigationBar.tintColor = UIColorFromRGB(0x0B4E92);
	
	if ([MFMailComposeViewController canSendMail]) {
		[mail setToRecipients:[NSArray arrayWithObjects:contactMail,nil]];
		[mail setSubject:sujetMail];
		[mail setMessageBody:messageMail isHTML:NO];
		//[self presentModalViewController:mail animated:YES];
        [self presentViewController:mail animated:YES completion:nil];
			
		/*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please speak english or french\nAnd use Cancel button if your message is empty..." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		[alert show];
		[alert release];
		*/
	}
	
	[mail release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	
	//[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
	
	if (result == MFMailComposeResultFailed) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Failed!" message:@"Your email has failed to send" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
	}
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[appDetailViewController release];
    [super dealloc];
}


@end
