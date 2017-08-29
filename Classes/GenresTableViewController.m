//
//  GenresTableViewController.m
//  appinfo
//
//  Created by Miles on 26/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GenresTableViewController.h"
#import "CustomCell.h"
#import "ArtistsTableViewController.h"
#import "AlbumsTableViewController.h"
#import "MorceauxTableViewController.h"
#import "appinfoAppDelegate.h"


@implementation GenresTableViewController


@synthesize genreNom;
@synthesize genrePid;
@synthesize emailUser;
@synthesize databasePath;


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
	
	verifios5 = FALSE; 
	NSString *reqSysVer = @"5";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending){
		verifios5 = TRUE;
	}
	
    if(verifios5){
        databasePath = [[NSString stringWithFormat:@"%@/iTunes_Control/iTunes/MediaLibrary.sqlitedb",delegate.pathMedia] retain];
    }
    else {
        databasePath = [[NSString stringWithFormat:@"%@/iTunes_Control/iTunes/iTunes Library.itlp/Library.itdb",delegate.pathMedia] retain];
    }
    
    
	UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] init];
	exportButton.title = MyLocalizedString(@"_export",@"");
	self.navigationItem.rightBarButtonItem = exportButton;
	[exportButton setTarget:self];
	[exportButton setAction:@selector(exportAction:)];
	[exportButton release];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [self.genreNom count];
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
    
    // Configure the cell...
	CGRect f = cell.primaryLabel.frame;
	f.origin.y = 10;
	cell.primaryLabel.frame = f;
	cell.primaryLabel.text = [self.genreNom objectAtIndex:indexPath.row];
	cell.secondaryLabel.text = @"";
	
	UIImage *image;
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/genres.png",path]];
	image = [[UIImage alloc] initWithData:data];
	cell.myImageView.image = image;
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	[image release];
	image = nil;
	data = nil;
	
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
    
	ArtistsTableViewController *detailViewController = [[ArtistsTableViewController alloc] initWithNibName:@"MorceauxTableView" bundle:nil];
	detailViewController.tableView.delegate = detailViewController;
	detailViewController.tableView.dataSource = detailViewController;
	
	detailViewController.artistPid = [[NSMutableArray alloc] init];
	detailViewController.artistArtiste = [[NSMutableArray alloc] init];
	
	sqlite3 *database;
	
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		NSString *pid = [NSString stringWithFormat:@"%@",[self.genrePid objectAtIndex:indexPath.row]];
		
		NSString *requete = @"";
		if(verifios5){
			requete = [NSString stringWithFormat:@"SELECT DISTINCT ita.item_artist, ita.item_artist_pid FROM item it, item_artist ita WHERE it.item_artist_pid=ita.item_artist_pid AND it.genre_id='%@' ORDER BY ita.item_artist COLLATE NOCASE",pid];
		}
		else{
			requete = [NSString stringWithFormat:@"SELECT artist,artist_pid FROM item WHERE genre_id='%@' GROUP BY artist ORDER BY artist_order",pid];
		}
		const char *sqlStatement = [requete cStringUsingEncoding:[NSString defaultCStringEncoding]];
		
		sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				
				NSString *pid = @"";
				const char* pidChar = (const char*)sqlite3_column_text(compiledStatement, 1);
				if(pidChar != NULL){
					pid = [NSString stringWithUTF8String:pidChar];
				}
				
				NSString *artist = @"";
				const char* artistChar = (const char*)sqlite3_column_text(compiledStatement, 0);
				if(artistChar != NULL){
					artist = [NSString stringWithUTF8String:artistChar];
				}
				
				/*
				NSString *pid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				NSString *artist = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				 */
				
				[detailViewController.artistPid addObject:pid];
				[detailViewController.artistArtiste addObject:artist];
			}
		}
		
		sqlite3_finalize(compiledStatement);
		compiledStatement = nil;
		
	}
	sqlite3_close(database);
	database = nil;
	
	detailViewController.navigationItem.title = [self.genreNom objectAtIndex:indexPath.row];
	
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
	detailViewController = nil;
	[detailViewController.artistPid release];
	[detailViewController.artistArtiste release];
	
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
		
		NSString *exportContents = @"";
		
		
		for (int i=0; i<[self.genreNom count]; i++) {
			
			exportContents = [exportContents stringByAppendingString:[NSString stringWithFormat:@"<p><b>%@</b></p>",[self.genreNom objectAtIndex:i]]];
		}
		
		
		//[self  pushEmail:(self.emailUser) andSubject:[NSString stringWithFormat:MyLocalizedString(@"_exportmaildetails",@""),MyLocalizedString(@"_morceauxM",@"")] andBody:[NSString stringWithFormat:@"%@", self.chansonTitre]];
		
		[self  pushEmail:(self.emailUser) andSubject:[NSString stringWithFormat:MyLocalizedString(@"_exportmaildetails",@""),self.navigationItem.title] andBody:[NSString stringWithFormat:@"<h3>%@</h3>%@", self.navigationItem.title,exportContents]];
		
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
	[genrePid release];
	[genreNom release];
    [databasePath release];
    [super dealloc];
}


@end

