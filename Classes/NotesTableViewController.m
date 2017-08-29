//
//  NotesTableViewController.m
//  appinfo
//
//  Created by Miles on 22/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NotesTableViewController.h"
#import "appinfoAppDelegate.h"
#import "AppDetailViewController.h"
#import "CustomCell.h"

@implementation NotesTableViewController

@synthesize notesTableView;
@synthesize dicoNotes;
@synthesize aWebView;
@synthesize emailUser;
@synthesize notesPath;


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
	
    self.navigationItem.title = MyLocalizedString(@"_notes",@"");
	
	
	dicoNotes = [[NSMutableDictionary alloc] init];
	
	notesPath = delegate.pathNotes;
	
	sqlite3 *database;
	
	if(sqlite3_open([notesPath UTF8String], &database) == SQLITE_OK) {
		
		NSString *requete = @"SELECT Z_PK,ZTITLE,ZMODIFICATIONDATE,ZSUMMARY FROM ZNOTE ORDER BY ZMODIFICATIONDATE DESC";
		const char *sqlStatement = [requete cStringUsingEncoding:[NSString defaultCStringEncoding]];
		
		sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				
				//NSString *rid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				
				NSString *rid = @"";
				const char* ridChar = (const char*)sqlite3_column_text(compiledStatement, 0);
				if(ridChar != NULL){
					rid = [NSString stringWithUTF8String:ridChar];
				}
				
				NSString *nom = @"";
				const char* nomChar = (const char*)sqlite3_column_text(compiledStatement, 1);
				if(nomChar != NULL){
					nom = [NSString stringWithUTF8String:nomChar];
				}
				
				NSString *creationdate = @"";
				const char* creationdateChar = (const char*)sqlite3_column_text(compiledStatement, 2);
				if(creationdateChar != NULL){
					creationdate = [NSString stringWithUTF8String:creationdateChar];
				}
				
				NSString *summary = @"";
				const char* summaryChar = (const char*)sqlite3_column_text(compiledStatement, 3);
				if(summaryChar != NULL){
					summary = [NSString stringWithUTF8String:summaryChar];
				}
				
				
				NSMutableDictionary *app = [[NSMutableDictionary alloc] init];
				[app setObject:nom forKey:@"nom"];
				[app setObject:creationdate forKey:@"creationdate"];
				[app setObject:summary forKey:@"description"];
				[app setObject:rid forKey:@"id"];
				[dicoNotes setObject:app forKey:creationdate];
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
    return [dicoNotes count];
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
	NSArray *nomApp = [dicoNotes allKeys];
	
	//NSArray *nomAppAlpha = [nomApp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	
	NSSortDescriptor *mySorter = [[NSSortDescriptor alloc] initWithKey:@"floatValue" ascending:NO];
	NSMutableArray *nomAppAlpha = [[NSMutableArray alloc] initWithArray:nomApp];
	[nomAppAlpha sortUsingDescriptors:[NSArray arrayWithObject:mySorter]];	
	
	value = [dicoNotes objectForKey:[nomAppAlpha objectAtIndex:indexPath.row]];
	
	cell.primaryLabel.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"nom"]];
	cell.secondaryLabel.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"description"]];
	
	UIImage *image;
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/notes.png",path]];
	image = [[UIImage alloc] initWithData:data];
	cell.myImageView.image = image;	
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	[nomAppAlpha release];
	[mySorter release];	
	[image release];
	image = nil;
	nomApp = nil;
	nomAppAlpha = nil;
	mySorter = nil;
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
	AppDetailViewController *appDetailViewController = [[AppDetailViewController alloc] initWithNibName:@"AppDetailViewController" bundle:nil];
	//self.appDetailViewController = appDetailViewController;
	//[aAppDetail release];
	
	id value;
	NSArray *nomApp = [dicoNotes allKeys];
	
	//NSArray *nomAppAlpha = [nomApp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	
	NSSortDescriptor *mySorter = [[NSSortDescriptor alloc] initWithKey:@"floatValue" ascending:NO];
	NSMutableArray *nomAppAlpha = [[NSMutableArray alloc] initWithArray:nomApp];
	[nomAppAlpha sortUsingDescriptors:[NSArray arrayWithObject:mySorter]];	
	
	value = [dicoNotes objectForKey:[nomAppAlpha objectAtIndex:indexPath.row]];
	
	/*
	 [app setObject:nom forKey:@"nom"];
	 [app setObject:creationdate forKey:@"creationdate"];
	 [app setObject:summary forKey:@"description"];
	 [app setObject:rid forKey:@"id"];
	 */

	
	NSString *bodyNotes = @"";
 	
	sqlite3 *databaseL;
	if(sqlite3_open([notesPath UTF8String], &databaseL) == SQLITE_OK) {
		
		NSString *requeteL = [NSString stringWithFormat:@"SELECT ZCONTENT FROM ZNOTEBODY WHERE ZOWNER=%@",[value objectForKey:@"id"]];
		
		const char *sqlStatementL = [requeteL cStringUsingEncoding:[NSString defaultCStringEncoding]];
		sqlite3_stmt *compiledStatementL;
		
		if(sqlite3_prepare_v2(databaseL, sqlStatementL, -1, &compiledStatementL, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStatementL) == SQLITE_ROW) {
				
				NSString *bodyContent = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementL, 0)];
				bodyNotes = [bodyNotes stringByAppendingString:bodyContent];
				
			}
		}
		
		sqlite3_finalize(compiledStatementL);
		compiledStatementL = nil;
	}
	sqlite3_close(databaseL);
	databaseL = nil;
		
	NSString *nomNotes = [NSString stringWithFormat:@"%@", [value objectForKey: @"nom"]];
	//NSString *dateNotes = [NSString stringWithFormat:@"%@", [value objectForKey: @"creationdate"]];
	
	/*
	NSMutableString *temp = [[NSMutableString alloc] initWithString:bodyNotes];
	[temp replaceOccurrencesOfString:@"<div>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [temp length])];
	[temp replaceOccurrencesOfString:@"&nbsp;" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [temp length])];
	[temp replaceOccurrencesOfString:@"</div>" withString:@"<br />" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [temp length])];
	[temp replaceOccurrencesOfString:nomNotes withString:[NSString stringWithFormat:@"%@<br />",nomNotes] options:NSCaseInsensitiveSearch range:NSMakeRange(0, [temp length])];
	bodyNotes = [NSString stringWithFormat:@"%@",temp];
	[temp release];
	 */
	
	appDetailViewController.title = nomNotes;
	
	aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];//init and create the UIWebView
	aWebView.autoresizesSubviews = YES;
	aWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	[aWebView setDelegate:self];
	
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	
	NSString *myHTML = [NSString stringWithFormat:@"<html><head><link href=\"Notes.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body> <div id=\"WebApp\"><h1>%@</h1><div id=\"Contenu\">%@</div></div></body></html>",nomNotes,bodyNotes];
	[aWebView loadHTMLString:myHTML baseURL:baseURL];
	
	[appDetailViewController.view addSubview:aWebView];
	
	[self.navigationController pushViewController:appDetailViewController animated:YES];
	
	
	[appDetailViewController release];
	[nomAppAlpha release];
	[mySorter release];	
	nomApp = nil;
	nomAppAlpha = nil;
	mySorter = nil;
	value = nil;
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
	
		NSArray *nomApp = [dicoNotes allKeys];
		NSSortDescriptor *mySorter = [[NSSortDescriptor alloc] initWithKey:@"floatValue" ascending:NO];
		NSMutableArray *nomAppAlpha = [[NSMutableArray alloc] initWithArray:nomApp];
		[nomAppAlpha sortUsingDescriptors:[NSArray arrayWithObject:mySorter]];		
		
		
		NSString *exportContents = @"";
		NSMutableArray *arrayFull = [[NSMutableArray alloc] init];
		
		
		for(id app in nomAppAlpha){
			

			//[app setObject:nom forKey:@"nom"];
			//[app setObject:creationdate forKey:@"creationdate"];
			//[app setObject:summary forKey:@"description"];
			//[app setObject:rid forKey:@"id"];
			
			NSString *nomApp = [[dicoNotes objectForKey:app] objectForKey:@"nom"];
			NSString *idApp = [[dicoNotes objectForKey:app] objectForKey:@"id"];
			//NSString *descriptionApp = [[dicoNotes objectForKey:app] objectForKey:@"description"];
			//NSString *creationdateApp = [[dicoNotes objectForKey:app] objectForKey:@"creationdate"];
			
			NSString *bodyNotes = @"";
			
			sqlite3 *databaseL;
			if(sqlite3_open([notesPath UTF8String], &databaseL) == SQLITE_OK) {
				
				NSString *requeteL = [NSString stringWithFormat:@"SELECT ZCONTENT FROM ZNOTEBODY WHERE ZOWNER=%@",idApp];
				
				const char *sqlStatementL = [requeteL cStringUsingEncoding:[NSString defaultCStringEncoding]];
				sqlite3_stmt *compiledStatementL;
				
				if(sqlite3_prepare_v2(databaseL, sqlStatementL, -1, &compiledStatementL, NULL) == SQLITE_OK) {
					while(sqlite3_step(compiledStatementL) == SQLITE_ROW) {
						
						NSString *bodyContent = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementL, 0)];
						bodyNotes = [bodyNotes stringByAppendingString:bodyContent];
						
					}
				}
				
				sqlite3_finalize(compiledStatementL);
				compiledStatementL = nil;
			}
			sqlite3_close(databaseL);
			databaseL = nil;
			
			
			
			NSString *exportContentFull = @"";
			
			exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<h3 style=\"margin-bottom:0px;font-size:16px;\">%@</h3>\n",nomApp]];
			
			exportContentFull = [exportContentFull stringByAppendingFormat:@"<p>%@</p>",bodyNotes];
			exportContentFull = [exportContentFull stringByAppendingString:@"<hr />\n"];
			
			/*
			exportContentFull = [exportContentFull stringByAppendingString:@"<ul style=\"margin-top:0px;font-size:7px;\">\n"];
			
			exportContentFull = [exportContentFull stringByAppendingFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\">%@</li>",stringFromDate];
			exportContentFull = [exportContentFull stringByAppendingFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\">%@</li>",stringFromDate2];
			
			if([locationApp compare:@""] != NSOrderedSame){
				exportContentFull = [exportContentFull stringByAppendingFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\">%@</li>",locationApp];
			}
			if([descriptionApp compare:@""] != NSOrderedSame){
				exportContentFull = [exportContentFull stringByAppendingFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\">%@</li>",descriptionApp];
			}
			
			exportContentFull = [exportContentFull stringByAppendingString:@"</ul>\n"];
			exportContentFull = [exportContentFull stringByAppendingString:@"<hr />\n"];
			*/
			
			[arrayFull addObject:exportContentFull];
			
		}
		
		for(id value in arrayFull){
			exportContents = [exportContents stringByAppendingString:value];
		}
		
		
		//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"YO" message:exportContents delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		//[alert show];
		//[alert release];
		
		
		[self  pushEmail:(self.emailUser) andSubject:[NSString stringWithFormat:MyLocalizedString(@"_exportmaildetails",@""),MyLocalizedString(@"_notes",@"")] andBody:[NSString stringWithFormat:@"%@", exportContents]];
		
		
		[arrayFull release];
		[mySorter release];
		[nomAppAlpha release];
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
    [notesPath release];
	[notesTableView release];
	[dicoNotes release];
    [super dealloc];
}


@end

