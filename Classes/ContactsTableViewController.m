//
//  ContactsTableViewController.m
//  appinfo
//
//  Created by Miles on 22/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "appinfoAppDelegate.h"
#import "AppDetailViewController.h"
#import "CustomCell.h"


@implementation ContactsTableViewController


@synthesize contactsTableView;
@synthesize dicoContacts;
@synthesize aWebView;
@synthesize emailUser;
@synthesize contactsPath;

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
	
	self.navigationItem.title = MyLocalizedString(@"_contacts",@"");
	
	UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] init];
	exportButton.title = MyLocalizedString(@"_export",@"");
	self.navigationItem.rightBarButtonItem = exportButton;
	[exportButton setTarget:self];
	[exportButton setAction:@selector(exportAction:)];
	[exportButton release]; 
	
	
	dicoContacts = [[NSMutableDictionary alloc] init];
	
	contactsPath = delegate.pathContacts;
	
	sqlite3 *database;
	
	if(sqlite3_open([contactsPath UTF8String], &database) == SQLITE_OK) {
		
		NSString *requete = @"SELECT ROWID,First,Last,Organization FROM ABPerson ORDER BY First";
		const char *sqlStatement = [requete cStringUsingEncoding:[NSString defaultCStringEncoding]];
		
		sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				
				NSString *rid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				
				NSString *prenom = @"";
				const char* prenomChar = (const char*)sqlite3_column_text(compiledStatement, 1);
				if(prenomChar != NULL){
				prenom = [NSString stringWithUTF8String:prenomChar];
				}
				
				NSString *nom = @"";
				const char* nomChar = (const char*)sqlite3_column_text(compiledStatement, 2);
				if(nomChar != NULL){
					nom = [NSString stringWithUTF8String:nomChar];
				}
				
				NSString *organisation = @"";
				const char* organisationChar = (const char*)sqlite3_column_text(compiledStatement, 3);
				if(organisationChar != NULL){
					organisation = [NSString stringWithUTF8String:organisationChar];
				}
				
				
				NSMutableDictionary *app = [[NSMutableDictionary alloc] init];
				[app setObject:prenom forKey:@"prenom"];
				[app setObject:nom forKey:@"nom"];
				[app setObject:organisation forKey:@"organisation"];
				//[app setObject:telephone forKey:@"telephone"];
				[app setObject:rid forKey:@"rid"];
				[dicoContacts setObject:app forKey:prenom];
				[app release];
				app = nil;
				
			}
		}
		
		sqlite3_finalize(compiledStatement);
		compiledStatement = nil;
		
	}
	sqlite3_close(database);
	database = nil;
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
    return [dicoContacts count];
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
	NSArray *nomApp = [dicoContacts allKeys];
	NSArray *nomAppAlpha = [nomApp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	value = [dicoContacts objectForKey:[nomAppAlpha objectAtIndex:indexPath.row]];
	
	
	cell.primaryLabel.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"prenom"]];
	
	NSString *nomC = [NSString stringWithFormat:@"%@",[value objectForKey: @"nom"]];
	NSString *organisationC = [NSString stringWithFormat:@"%@",[value objectForKey: @"organisation"]];
	
	if([nomC compare:@""] != NSOrderedSame){
		cell.secondaryLabel.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"nom"]];
	}
	else if([organisationC compare:@""] != NSOrderedSame){
		cell.secondaryLabel.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"organisation"]];
	}
	else{
		CGRect f = cell.primaryLabel.frame;
		f.origin.y = 10;
		cell.primaryLabel.frame = f;
		cell.secondaryLabel.text = @"";
	}
    
	UIImage *image;
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/contacts.png",path]];
	image = [[UIImage alloc] initWithData:data];
	cell.myImageView.image = image;	
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	[image release];
	value = nil;
	image = nil;
	data = nil;
	nomApp = nil;
	nomAppAlpha = nil;
	
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
    
	AppDetailViewController *appDetailViewController = [[AppDetailViewController alloc] initWithNibName:@"AppDetailViewController" bundle:nil];

	
	id value;
	NSArray *nomAppAlpha;
	NSArray *nomApp = [dicoContacts allKeys];
	nomAppAlpha = [nomApp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	value = [dicoContacts objectForKey:[nomAppAlpha objectAtIndex:indexPath.row]];
	
	
	NSMutableArray *labelA = [[NSMutableArray alloc] init];
	NSMutableArray *valueA = [[NSMutableArray alloc] init];
		
	sqlite3 *databaseL;
	if(sqlite3_open([contactsPath UTF8String], &databaseL) == SQLITE_OK) {
		
		NSString *requeteL = [NSString stringWithFormat:@"SELECT label,value FROM ABMultiValue WHERE record_id=%@ ORDER BY label",[value objectForKey:@"rid"]];
		
		const char *sqlStatementL = [requeteL cStringUsingEncoding:[NSString defaultCStringEncoding]];
		sqlite3_stmt *compiledStatementL;
		
		if(sqlite3_prepare_v2(databaseL, sqlStatementL, -1, &compiledStatementL, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStatementL) == SQLITE_ROW) {
				
				
				NSString *label = @"";
				const char* labelChar = (const char*)sqlite3_column_text(compiledStatementL, 0);
				if(labelChar != NULL){
					label = [NSString stringWithUTF8String:labelChar];
				}
				 
				NSString *value = @"";
				const char* valueChar = (const char*)sqlite3_column_text(compiledStatementL, 1);
				if(valueChar != NULL){
					value = [NSString stringWithUTF8String:valueChar];
				}
				
				/*
				NSString *label = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementL, 0)];
				NSString *value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementL, 1)];
				*/
				 
				[labelA addObject:label];
				[valueA addObject:value];
				
				//NSString *yo = [NSString stringWithFormat:@"%@ : %@\n",[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementL, 0)],[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementL, 1)] ];
				//telephone = [telephone stringByAppendingString:yo];
				//telephone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementL, 1)];
				
			}
		}
		
		sqlite3_finalize(compiledStatementL);
		compiledStatementL = nil;
	}
	sqlite3_close(databaseL);
	databaseL = nil;
	
	NSString *nomContact = [NSString stringWithFormat:@"%@", [value objectForKey: @"nom"]];
	NSString *prenomContact = [NSString stringWithFormat:@"%@", [value objectForKey: @"prenom"]];
	NSString *organisationContact = [NSString stringWithFormat:@"%@", [value objectForKey: @"organisation"]];
	NSString *imageApplication = @"contacts.png";
	
	
	NSString *bundleInfo = [NSString stringWithFormat:@"<b>%@ :</b> %@<br /><b>%@ :</b> %@<br /><b>%@ :</b> %@<br />",MyLocalizedString(@"_prenomC",@""),prenomContact,MyLocalizedString(@"_nomC",@""),nomContact,MyLocalizedString(@"_organisationC",@""),organisationContact];
	
	NSString *telephone = @"";
	
	//int cpt=0;
	for(id valuess in valueA){
		
	telephone = [telephone stringByAppendingFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"%@\"><img src=\"contacts.png\" style=\"float:left;margin:0 5px\" width=\"25\" />%@</a></li>",valuess,valuess];
		//cpt++;
	}
	
	NSString *lienExterne;
	lienExterne = [NSString stringWithFormat:@"<div class=\"iMenu\"><ul class=\"iArrow\">%@</ul></div>",telephone];	
	
	appDetailViewController.title = prenomContact;
	
	aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];//init and create the UIWebView
	aWebView.autoresizesSubviews = YES;
	aWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	[aWebView setDelegate:self];
	
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	
	NSString *myHTML = [NSString stringWithFormat:@"<html><head><link href=\"Render.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body> <div id=\"WebApp\"><div id=\"iGroup\"><div class=\"iBlock\" style=\"margin-bottom:10px;\"><h1>%@</h1><p style=\"padding-bottom:10px\"><img src=\"%@\" style=\"float:left;margin:0 5px\" width=\"60\" />%@</p></div> %@ </div></div></body></html>",prenomContact,imageApplication,bundleInfo,lienExterne];
	[aWebView loadHTMLString:myHTML baseURL:baseURL];
	
	UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] init];
	exportButton.title = MyLocalizedString(@"_export",@"");
	appDetailViewController.navigationItem.rightBarButtonItem = exportButton;
	[exportButton setTarget:self];
	[exportButton setAction:@selector(exportActionApp:)];
	exportButton.tag = indexPath.row;
	[exportButton release];
	
	[appDetailViewController.view addSubview:aWebView];
	
	[self.navigationController pushViewController:appDetailViewController animated:YES];

	
	value = nil;
	nomApp = nil;
	nomAppAlpha = nil;
	appDetailViewController = nil;
	[appDetailViewController release];
	[labelA release];
	[valueA release];
	self.aWebView = nil;
	
}

#pragma mark -
#pragma mark Others Functions

- (void)exportActionApp:(id)sender {
	
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	
	id value;
	NSArray *nomAppAlpha;
	NSArray *nomApp = [dicoContacts allKeys];
	nomAppAlpha = [nomApp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	value = [dicoContacts objectForKey:[nomAppAlpha objectAtIndex:indexPath.row]];
	
	
	NSMutableArray *labelA = [[NSMutableArray alloc] init];
	NSMutableArray *valueA = [[NSMutableArray alloc] init];
	
	sqlite3 *databaseL;
	if(sqlite3_open([contactsPath UTF8String], &databaseL) == SQLITE_OK) {
		
		NSString *requeteL = [NSString stringWithFormat:@"SELECT label,value FROM ABMultiValue WHERE record_id=%@ ORDER BY label",[value objectForKey:@"rid"]];
		
		const char *sqlStatementL = [requeteL cStringUsingEncoding:[NSString defaultCStringEncoding]];
		sqlite3_stmt *compiledStatementL;
		
		if(sqlite3_prepare_v2(databaseL, sqlStatementL, -1, &compiledStatementL, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStatementL) == SQLITE_ROW) {
				
				
				NSString *label = @"";
				const char* labelChar = (const char*)sqlite3_column_text(compiledStatementL, 0);
				if(labelChar != NULL){
					label = [NSString stringWithUTF8String:labelChar];
				}
				
				NSString *value = @"";
				const char* valueChar = (const char*)sqlite3_column_text(compiledStatementL, 1);
				if(valueChar != NULL){
					value = [NSString stringWithUTF8String:valueChar];
				}
				
								
				[labelA addObject:label];
				[valueA addObject:value];
				
			}
		}
		
		sqlite3_finalize(compiledStatementL);
		compiledStatementL = nil;
	}
	sqlite3_close(databaseL);
	databaseL = nil;
	
	NSString *nomContact = [NSString stringWithFormat:@"%@", [value objectForKey: @"nom"]];
	NSString *prenomContact = [NSString stringWithFormat:@"%@", [value objectForKey: @"prenom"]];
	NSString *organisationContact = [NSString stringWithFormat:@"%@", [value objectForKey: @"organisation"]];
	
	
	
	NSString *telephone = @"";
	
	for(id valuess in valueA){
		telephone = [telephone stringByAppendingFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\">%@</li>",valuess];
	}
	
	
	NSString *exportContentFull = @"";
	
	exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<h3 style=\"margin-bottom:0px;font-size:16px;\">%@ %@</h3>\n<ul style=\"margin-top:0px;font-size:7px;\">\n",prenomContact,nomContact]];
	
	if([organisationContact compare:@""] != NSOrderedSame){
		exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>%@ : </strong>%@</li>\n",@"Organisation",organisationContact]];
	}
	
	if([telephone compare:@""] != NSOrderedSame){
		exportContentFull = [exportContentFull stringByAppendingString:telephone];
	}
	
	
	exportContentFull = [exportContentFull stringByAppendingString:@"</ul><hr />\n"];
	
	
	[self  pushEmail:(self.emailUser) andSubject:[NSString stringWithFormat:MyLocalizedString(@"_exportmaildetails",@""),MyLocalizedString(@"_contacts",@"")] andBody:[NSString stringWithFormat:@"%@", exportContentFull]];
	
	
	value = nil;
	nomApp = nil;
	nomAppAlpha = nil;
	[labelA release];
	[valueA release];

	
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
		
		NSArray *nomAppAlpha;
		NSArray *nomApp = [dicoContacts allKeys];
		nomAppAlpha = [nomApp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
		
		NSString *exportContents = @"";
		NSMutableArray *arrayFull = [[NSMutableArray alloc] init];
		
		
		for(id app in nomAppAlpha){
			
			NSString *prenomApp = [[dicoContacts objectForKey:app] objectForKey:@"prenom"];
			NSString *nomApp = [[dicoContacts objectForKey:app] objectForKey:@"nom"];
			NSString *organisationApp = [[dicoContacts objectForKey:app] objectForKey:@"organisation"];
			NSString *ridApp = [[dicoContacts objectForKey:app] objectForKey:@"rid"];
			
			NSString *exportContentFull = @"";
			
			exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<h3 style=\"margin-bottom:0px;font-size:16px;\">%@ %@</h3>\n<ul style=\"margin-top:0px;font-size:7px;\">\n",prenomApp,nomApp]];
			
			if([organisationApp compare:@""] != NSOrderedSame){
				exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>%@ : </strong>%@</li>\n",@"Organisation",organisationApp]];
			}
			
			
			
			
			NSMutableArray *labelA = [[NSMutableArray alloc] init];
			NSMutableArray *valueA = [[NSMutableArray alloc] init];
			
			sqlite3 *databaseL;
			if(sqlite3_open([contactsPath UTF8String], &databaseL) == SQLITE_OK) {
				
				NSString *requeteL = [NSString stringWithFormat:@"SELECT label,value FROM ABMultiValue WHERE record_id=%@ ORDER BY label",ridApp];
				
				const char *sqlStatementL = [requeteL cStringUsingEncoding:[NSString defaultCStringEncoding]];
				sqlite3_stmt *compiledStatementL;
				
				if(sqlite3_prepare_v2(databaseL, sqlStatementL, -1, &compiledStatementL, NULL) == SQLITE_OK) {
					while(sqlite3_step(compiledStatementL) == SQLITE_ROW) {
						
						
						NSString *label = @"";
						const char* labelChar = (const char*)sqlite3_column_text(compiledStatementL, 0);
						if(labelChar != NULL){
							label = [NSString stringWithUTF8String:labelChar];
						}
						
						NSString *value = @"";
						const char* valueChar = (const char*)sqlite3_column_text(compiledStatementL, 1);
						if(valueChar != NULL){
							value = [NSString stringWithUTF8String:valueChar];
						}
						
						[labelA addObject:label];
						[valueA addObject:value];
						
					}
				}
				
				sqlite3_finalize(compiledStatementL);
				compiledStatementL = nil;
			}
			sqlite3_close(databaseL);
			databaseL = nil;
			
			NSString *telephone = @"";
			
			for(id valuess in valueA){
				
				telephone = [telephone stringByAppendingFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"%@\">%@</a></li>",valuess,valuess];
			}
			
			if([telephone compare:@""] != NSOrderedSame){
				exportContentFull = [exportContentFull stringByAppendingString:telephone];
			}
			
			
			exportContentFull = [exportContentFull stringByAppendingString:@"</ul><hr />\n"];
			[arrayFull addObject:exportContentFull];
			
			[labelA release];
			[valueA release];
			
		}
		
		for(id value in arrayFull){
			exportContents = [exportContents stringByAppendingString:value];
		}
		
		/*
		 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"YO" message:exportContents delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		 [alert show];
		 [alert release];
		 */
		 
		[self  pushEmail:(self.emailUser) andSubject:[NSString stringWithFormat:MyLocalizedString(@"_exportmaildetails",@""),MyLocalizedString(@"_contacts",@"")] andBody:[NSString stringWithFormat:@"%@", exportContents]];
		
		
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
	[aWebView release];
    [contactsPath release];
	[dicoContacts release];
	[contactsTableView release];
    [super dealloc];
}


@end

