//
//  IbooksTableViewController.m
//  appinfo
//
//  Created by Miles on 22/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "IbooksTableViewController.h"
#import "appinfoAppDelegate.h"
#import "AppDetailViewController.h"
#import "CustomCell.h"


@implementation IbooksTableViewController


@synthesize ibooksTableView;
@synthesize dicoIbooks;
@synthesize aWebView;
@synthesize emailUser;
@synthesize ibooksPath;

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
	
	UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] init];
	exportButton.title = MyLocalizedString(@"_export",@"");
	self.navigationItem.rightBarButtonItem = exportButton;
	[exportButton setTarget:self];
	[exportButton setAction:@selector(exportAction:)];
	[exportButton release]; 
	
	
	self.navigationItem.title = @"iBooks";
	
	dicoIbooks = [[NSMutableDictionary alloc] init];
	
    ibooksPath = delegate.pathIbooks;
    
	//NSString *plistPath = [NSString stringWithFormat:@"%@/Books.plist",ibooksPath];
    NSString *plistPath = [NSString stringWithFormat:@"%@/Purchases.plist",ibooksPath];
	if([[NSFileManager defaultManager] fileExistsAtPath:plistPath] == YES){			
		
		NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
		
		if([plistDict objectForKey:@"Books"]){
			NSString *classB = [[[plistDict objectForKey:@"Books"] class] description];
			if([classB compare:@"__NSCFArray"] == NSOrderedSame){
				NSArray *booksArray = [[NSArray alloc] initWithArray:[plistDict objectForKey:@"Books"]];
				
				for(id value in booksArray){
					
					if([value objectForKey:@"Name"]){
						[dicoIbooks setObject:value forKey:[value objectForKey:@"Name"]];
					}
					
				}
				
				[booksArray release];
				booksArray = nil;
			}
				
		}
		
		[plistDict release];
		plistDict = nil;
		
	}
	
	
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
    return [self.dicoIbooks count];;
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
	NSArray *nomApp = [dicoIbooks allKeys];
	NSArray *nomAppAlpha = [nomApp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	value = [dicoIbooks objectForKey:[nomAppAlpha objectAtIndex:indexPath.row]];
	
	
	cell.primaryLabel.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"Name"]];	
	cell.secondaryLabel.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"Artist"]];
    
	UIImage *image;
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/ibooks.png",path]];
	image = [[UIImage alloc] initWithData:data];
	cell.myImageView.image = image;
	
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	[image release];
	image = nil;
	nomApp = nil;
	nomAppAlpha = nil;
	value = nil;
	
	
    return cell;

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
	
	AppDetailViewController *appDetailViewController = [[AppDetailViewController alloc] initWithNibName:@"AppDetailViewController" bundle:nil];
	//self.appDetailViewController = appDetailViewController;
	//[aAppDetail release];
	
	
	id value;
	NSArray *nomApp = [dicoIbooks allKeys];
	NSArray *nomAppAlpha = [nomApp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	value = [dicoIbooks objectForKey:[nomAppAlpha objectAtIndex:indexPath.row]];
	
	NSString *nameIbooks = [NSString stringWithFormat:@"%@", [value objectForKey: @"Name"]];
	NSString *artistIbooks = [NSString stringWithFormat:@"%@", [value objectForKey: @"Artist"]];
	NSString *genreIbooks = [NSString stringWithFormat:@"%@", [value objectForKey: @"Genre"]];
	NSString *pathIbooks = [NSString stringWithFormat:@"%@", [value objectForKey: @"Path"]];
	NSString *imageApplication = @"ibooks.png";
	
	
	NSString *cheminiFile;
	cheminiFile = [NSString stringWithFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"ifile://file%@/%@/\"><img src=\"ifile.png\" style=\"float:left;margin:0 5px\" width=\"25\" />%@</a></li>",ibooksPath,pathIbooks, MyLocalizedString(@"_ouvririfile",@"")];
	
	NSString *lienExterne = @"";
	
	lienExterne = [NSString stringWithFormat:@"<div class=\"iMenu\"><ul class=\"iArrow\">%@</ul></div>",cheminiFile];
	
	
	appDetailViewController.title = nameIbooks;
	
	aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];//init and create the UIWebView
	aWebView.autoresizesSubviews = YES;
	aWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	[aWebView setDelegate:self];
	
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	NSString *bundleInfo = [NSString stringWithFormat:@"<b>Name :</b> %@<br /><b>Artist :</b> %@<br /><b>Genre :</b> %@<br /><b>Path :</b> %@<br />",nameIbooks,artistIbooks,genreIbooks,pathIbooks];
	
	NSString *myHTML = [NSString stringWithFormat:@"<html><head><link href=\"Render.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body> <div id=\"WebApp\"><div id=\"iGroup\"><div class=\"iBlock\" style=\"margin-bottom:10px;\"><h1>%@</h1><p style=\"padding-bottom:10px\"><img src=\"%@\" style=\"float:left;margin:0 5px\" width=\"60\" />%@</p></div> %@ </div></div></body></html>",nameIbooks,imageApplication,bundleInfo,lienExterne];
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


#pragma mark -
#pragma mark Others Functions
- (void)exportAction:(id)sender{
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:MyLocalizedString(@"_exportliste",@"") delegate:self cancelButtonTitle:nil destructiveButtonTitle:MyLocalizedString(@"_annuler",@"") otherButtonTitles:MyLocalizedString(@"_exportdetails",@""), nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	actionSheet.destructiveButtonIndex = 0;
	[actionSheet showInView:self.parentViewController.tabBarController.view]; 
	[actionSheet release];
	
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == 1) {
		
		NSArray *nomApp = [dicoIbooks allKeys];
		NSArray *nomAppAlpha = [nomApp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
		//value = [dicoIbooks objectForKey:[nomAppAlpha objectAtIndex:indexPath.row]];	
		
		
		NSString *exportContents = @"";
		NSMutableArray *arrayFull = [[NSMutableArray alloc] init];
		
		
		for(id app in nomAppAlpha){
			
			
			//[app setObject:nom forKey:@"nom"];
			//[app setObject:creationdate forKey:@"creationdate"];
			//[app setObject:summary forKey:@"description"];
			//[app setObject:rid forKey:@"id"];
			
			//NSString *nomApp = [[dicoNotes objectForKey:app] objectForKey:@"nom"];
			//NSString *idApp = [[dicoNotes objectForKey:app] objectForKey:@"id"];
			//NSString *descriptionApp = [[dicoNotes objectForKey:app] objectForKey:@"description"];
			//NSString *creationdateApp = [[dicoNotes objectForKey:app] objectForKey:@"creationdate"];
			
			/*
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"YO" message:nameIbooks
														   delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
			[alert show];
			[alert release];
			*/
			
			
			NSString *nameIbooks = [NSString stringWithFormat:@"%@", [[dicoIbooks objectForKey:app] objectForKey: @"Name"]];
			NSString *artistIbooks = [NSString stringWithFormat:@"%@", [[dicoIbooks objectForKey:app] objectForKey: @"Artist"]];
			NSString *genreIbooks = [NSString stringWithFormat:@"%@", [[dicoIbooks objectForKey:app] objectForKey: @"Genre"]];
			NSString *pathIbooks = [NSString stringWithFormat:@"%@", [[dicoIbooks objectForKey:app] objectForKey: @"Path"]];
			
			
			
			NSString *exportContentFull = @"";
			
			exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<h3 style=\"margin-bottom:0px;font-size:16px;\">%@</h3>\n",nameIbooks]];
			
			 exportContentFull = [exportContentFull stringByAppendingString:@"<ul style=\"margin-top:0px;font-size:7px;\">\n"];
			
			 if([nameIbooks compare:@""] != NSOrderedSame){
			 exportContentFull = [exportContentFull stringByAppendingFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\">%@</li>",nameIbooks];
			 }
			 if([artistIbooks compare:@""] != NSOrderedSame){
			 exportContentFull = [exportContentFull stringByAppendingFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\">%@</li>",artistIbooks];
			 }
			 if([genreIbooks compare:@""] != NSOrderedSame){
			 exportContentFull = [exportContentFull stringByAppendingFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\">%@</li>",genreIbooks];
			 }
			 if([pathIbooks compare:@""] != NSOrderedSame){
			 exportContentFull = [exportContentFull stringByAppendingFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\">%@/%@</li>",ibooksPath,pathIbooks];
			 }
			 
			 exportContentFull = [exportContentFull stringByAppendingString:@"</ul>\n"];
			 exportContentFull = [exportContentFull stringByAppendingString:@"<hr />\n"];
			[arrayFull addObject:exportContentFull];
			 
			
		}
		
		
		for(id value in arrayFull){
			exportContents = [exportContents stringByAppendingString:value];
		}
		
		
		[self  pushEmail:(self.emailUser) andSubject:[NSString stringWithFormat:MyLocalizedString(@"_exportmaildetails",@""),@"iBooks"] andBody:[NSString stringWithFormat:@"%@", exportContents]];
		
		
		[arrayFull release];
		arrayFull = nil;
		nomApp = nil;
		nomAppAlpha = nil;
		exportContents = nil;
	}
	
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
	[emailUser release];
	[dicoIbooks release];
    [ibooksPath release];
	[ibooksTableView release];
	[aWebView release];
    [super dealloc];
}


@end

