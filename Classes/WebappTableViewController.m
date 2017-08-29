//
//  WebappTableViewController.m
//  appinfo
//
//  Created by Miles on 22/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebappTableViewController.h"
#import "appinfoAppDelegate.h"
#import "AppDetailViewController.h"
#import "CustomCell.h"


@implementation WebappTableViewController

@synthesize webappTableView;
@synthesize dicoWebapp;
@synthesize aWebView;
@synthesize emailUser;
@synthesize unitUser;
@synthesize documentsDir;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	appinfoAppDelegate *delegate = (appinfoAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSString *compareVide = [NSString stringWithFormat:@"%@", delegate.emailConfigF];
	if([compareVide compare:@""] != NSOrderedSame){
		self.emailUser = [NSString stringWithFormat:@"%@", delegate.emailConfigF];
	}
	else {
		self.emailUser = nil;
	}
	
	self.unitUser = [NSString stringWithFormat:@"%@", delegate.unitConfig];
	
	self.navigationItem.title = @"WebApp";
	
	
	UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] init];
	exportButton.title = MyLocalizedString(@"_export",@"");
	self.navigationItem.rightBarButtonItem = exportButton;
	[exportButton setTarget:self];
	[exportButton setAction:@selector(exportAction:)];
	[exportButton release]; 
	
	/*
	UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Springboard" style: UIBarButtonItemStyleBordered target:nil action:nil];
	[self.navigationItem setBackBarButtonItem:newBackButton];
	[newBackButton release];
	 */
	
	dicoWebapp = [[NSMutableDictionary alloc] init];

	
	NSArray *files;
	NSString *file;
	documentsDir = delegate.pathWebclips;

	files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDir error:nil];
	for(file in files){
		NSString *infoPlistPath = [NSString stringWithFormat:@"%@/%@/Info.plist", documentsDir,file];
		
		
		
		if([[NSFileManager defaultManager] fileExistsAtPath:infoPlistPath] == YES){			

			NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:infoPlistPath];
			
			NSString *plTitle = @"";
			if([plistDict objectForKey:@"Title"]){
				plTitle = [plistDict objectForKey:@"Title"];
			}
			
			NSString *plURL = @"";
			if([plistDict objectForKey:@"URL"]){
				plURL = [plistDict objectForKey:@"URL"];
			}
			
			NSString *plIconURL = MyLocalizedString(@"_inconnu",@"");
			if([plistDict objectForKey:@"IconURL"]){
				plIconURL = [plistDict objectForKey:@"IconURL"];
			}
			
			NSString *plStartupImageURL = MyLocalizedString(@"_inconnu",@"");
			if([plistDict objectForKey:@"StartupImageURL"]){
				plStartupImageURL = [plistDict objectForKey:@"StartupImageURL"];
			}
			
			
			NSMutableDictionary *app = [[NSMutableDictionary alloc] init];
			[app setObject:plTitle forKey:@"nom"];
			[app setObject:plURL forKey:@"url"];
			[app setObject:file forKey:@"dossier"];
			[app setObject:plIconURL forKey:@"iconUrl"];
			[app setObject:plStartupImageURL forKey:@"imageUrl"];			
			[dicoWebapp setObject:app forKey:plTitle];
			[app release];
			[plistDict release];
			app = nil;
			plistDict = nil;
			
		}
	}
			
	files = nil;
	
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.dicoWebapp count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CustomCell";
    
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray *topLevel = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:nil options:nil];
		for(id currentObj in topLevel){
			if([currentObj isKindOfClass:[UITableViewCell class]]){
				cell = (CustomCell *) currentObj;
				break;
			}
		}
    }
    
    // Set up the cell...
	id value;
	NSArray *nomApp = [dicoWebapp allKeys];
	NSArray *nomAppAlpha = [nomApp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	value = [dicoWebapp objectForKey:[nomAppAlpha objectAtIndex:indexPath.row]];
	
	
	cell.primaryLabel.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"nom"]];	
	cell.secondaryLabel.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"url"]];
    
	UIImage *image;
	NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/icon.png", documentsDir, [value objectForKey: @"dossier"]]];
	image = [[UIImage alloc] initWithData:data];
	cell.myImageView.image = image;
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	[image release];
	value = nil;
	image = nil;
	nomApp = nil;
	nomAppAlpha = nil;
	
    return cell;
}



- (void)exportAction:(id)sender{
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:MyLocalizedString(@"_exportliste",@"") delegate:self cancelButtonTitle:nil destructiveButtonTitle:MyLocalizedString(@"_annuler",@"") otherButtonTitles:MyLocalizedString(@"_exportdetails",@""), nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	actionSheet.destructiveButtonIndex = 0;
	[actionSheet showInView:self.parentViewController.tabBarController.view]; 
	[actionSheet release];
	
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == 1) {
		
		NSArray *nomApp = [dicoWebapp allKeys];
		NSArray *nomAppAlpha = [nomApp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
		NSString *exportContents = @"";
		NSMutableArray *arrayFull = [[NSMutableArray alloc] init];
		
		
		for(id app in nomAppAlpha){
			
			NSString *nomApp = [[dicoWebapp objectForKey:app] objectForKey:@"nom"];
			NSString *urlApp = [[dicoWebapp objectForKey:app] objectForKey:@"url"];
			NSString *dossierApp = [[dicoWebapp objectForKey:app] objectForKey:@"dossier"];
			NSString *iconApp = [[dicoWebapp objectForKey:app] objectForKey:@"iconUrl"];
			NSString *imageApp = [[dicoWebapp objectForKey:app] objectForKey:@"imageUrl"];
			
			
			
			NSString *exportContentFull = @"";
			
			exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<h3 style=\"margin-bottom:0px;font-size:16px;\">%@</h3>\n<ul style=\"margin-top:0px;font-size:7px;\">\n",nomApp]];
			
			exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>%@ : </strong>%@</li>\n",@"URL",urlApp]];
			
			exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>%@ : </strong>%@</li>\n",MyLocalizedString(@"_dossier",@""),dossierApp]];
			
			exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>%@ : </strong>%@</li>\n",@"Icon URL",iconApp]];
			
			exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>%@ : </strong>%@</li>\n",@"Splash URL",imageApp]];
			
			
			exportContentFull = [exportContentFull stringByAppendingString:@"</ul><hr />\n"];
			[arrayFull addObject:exportContentFull];
		}
		
		for(id value in arrayFull){
			exportContents = [exportContents stringByAppendingString:value];
		}
		[arrayFull release];
		
		
		[self  pushEmail:(self.emailUser) andSubject:[NSString stringWithFormat:MyLocalizedString(@"_exportmaildetails",@""),@"WebApp"] andBody:[NSString stringWithFormat:@"%@", exportContents]];
	}
	
	
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	
	
	//appDetailViewController = nil;
	AppDetailViewController *appDetailViewController = [[AppDetailViewController alloc] initWithNibName:@"AppDetailViewController" bundle:nil];
	//self.appDetailViewController = appDetailViewController;
	//[aAppDetail release];
	
	id value;
	NSArray *nomAppAlpha;
	NSArray *nomApp = [dicoWebapp allKeys];
	nomAppAlpha = [nomApp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	value = [dicoWebapp objectForKey:[nomAppAlpha objectAtIndex:indexPath.row]];
	
	NSString *nomApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"nom"]];
	NSString *urlApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"url"]];
	NSString *dossierApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"dossier"]];
	NSString *iconApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"iconUrl"]];
	NSString *startupApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"imageUrl"]];
	NSString *imageApplication = [NSString stringWithFormat:@"%@/%@/icon.png", documentsDir, [value objectForKey: @"dossier"]];
	
		
	NSString *cheminiFile;
	cheminiFile = [NSString stringWithFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"ifile://file%@/%@/\"><img src=\"ifile.png\" style=\"float:left;margin:0 5px\" width=\"25\" />%@</a></li>",documentsDir,dossierApplication, MyLocalizedString(@"_ouvririfile",@"")];
	
	NSString *lienExterne;
	lienExterne = [NSString stringWithFormat:@"<div class=\"iMenu\"><ul class=\"iArrow\">%@</ul></div>",cheminiFile];
	
	
	appDetailViewController.title = nomApplication;
	
	aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];//init and create the UIWebView
	aWebView.autoresizesSubviews = YES;
	aWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	[aWebView setDelegate:self];
	
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	NSString *bundleInfo = [NSString stringWithFormat:@"<b>URL :</b> %@<br /><b>Icon URL :</b> %@<br /><b>Splash URL :</b> %@<br />",urlApplication,iconApplication,startupApplication];
	
	NSString *myHTML = [NSString stringWithFormat:@"<html><head><link href=\"Render.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body> <div id=\"WebApp\"><div id=\"iGroup\"><div class=\"iBlock\" style=\"margin-bottom:10px;\"><h1>%@</h1><p style=\"padding-bottom:10px\"><img src=\"%@\" style=\"float:left;margin:0 5px\" width=\"60\" />%@</p></div> %@ </div></div></body></html>",nomApplication,imageApplication,bundleInfo,lienExterne];
	[aWebView loadHTMLString:myHTML baseURL:baseURL];
	
	[appDetailViewController.view addSubview:aWebView];
	
	[self.navigationController pushViewController:appDetailViewController animated:YES];
	
	value = nil;
	nomApp = nil;
	nomAppAlpha = nil;
	[appDetailViewController release];
	appDetailViewController = nil;
	self.aWebView = nil;
	
}


-(void)pushEmail:(NSString*)contactMail andSubject:(NSString*)sujetMail andBody:(NSString*)messageMail {
	
	MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
	mail.mailComposeDelegate = self;
    mail.navigationBar.tintColor = UIColorFromRGB(0x0B4E92);
	
	if ([MFMailComposeViewController canSendMail]) {
		[mail setToRecipients:[NSArray arrayWithObjects:contactMail,nil]];
		[mail setSubject:sujetMail];
		[mail setMessageBody:messageMail isHTML:YES];
		//[self presentModalViewController:mail animated:YES];
        [self presentViewController:mail animated:YES completion:nil];
		
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

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[documentsDir release];
    [unitUser release];
	[emailUser release];
	[aWebView release];
	[dicoWebapp release];
	[webappTableView release];
    [super dealloc];
}


@end

