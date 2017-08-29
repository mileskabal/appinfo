//
//  ArtistsTableViewController.m
//  appinfo
//
//  Created by Miles on 26/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ArtistsTableViewController.h"
#import "CustomCell.h"
#import "AlbumsTableViewController.h"
#import "appinfoAppDelegate.h"
#import "MorceauxTableViewController.h"

@implementation ArtistsTableViewController

@synthesize artistArtiste;
@synthesize artistPid;
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
    return [self.artistArtiste count];
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
	cell.primaryLabel.text = [self.artistArtiste objectAtIndex:indexPath.row];
	cell.secondaryLabel.text = @"";
	
	UIImage *image;
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/artistes.png",path]];
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
	
    NSString *pidArtist = [NSString stringWithFormat:@"%@",[self.artistPid objectAtIndex:indexPath.row]];
	NSString *artArtist = [NSString stringWithFormat:@"%@",[self.artistArtiste objectAtIndex:indexPath.row]];
	
	
    
	NSMutableArray *detailAPid = [[NSMutableArray alloc] init];
	NSMutableArray *detailAArtiste = [[NSMutableArray alloc] init];
	NSMutableArray *detailAAlbum = [[NSMutableArray alloc] init];

	sqlite3 *database;
	int cpt = 0;
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		
		NSString *requete = @"";
		if(verifios5){
			requete = [NSString stringWithFormat:@"SELECT DISTINCT a.album_pid, a.album, ita.item_artist FROM album a, item it, item_artist ita WHERE a.album_pid=it.album_pid AND it.item_artist_pid=ita.item_artist_pid AND it.item_artist_pid='%@' ORDER BY a.album COLLATE NOCASE",pidArtist];
		}
		else{
			requete = [NSString stringWithFormat:@"SELECT pid, name, artist FROM album WHERE artist=\"%@\" ORDER BY name_order",artArtist];
		}
        
		const char *sqlStatement = [requete cStringUsingEncoding:[NSString defaultCStringEncoding]];
		
		sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				
				
				
				NSString *pid = @"";
				const char* pidChar = (const char*)sqlite3_column_text(compiledStatement, 0);
				if(pidChar != NULL){
					pid = [NSString stringWithUTF8String:pidChar];
				}
				
				NSString *album = @"";
				const char* albumChar = (const char*)sqlite3_column_text(compiledStatement, 1);
				if(albumChar != NULL){
					album = [NSString stringWithUTF8String:albumChar];
				}

				NSString *artist = @"";
				const char* artistChar = (const char*)sqlite3_column_text(compiledStatement, 2);
				if(artistChar != NULL){
					artist = [NSString stringWithUTF8String:artistChar];
				}
				

				/*
				NSString *pid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				NSString *album = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				NSString *artist = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
				 */
				
				[detailAPid addObject:pid];
				[detailAArtiste addObject:artist];
				if([album compare:@""] != NSOrderedSame){
					[detailAAlbum addObject:album];
					cpt++;
				}
				else {
					[detailAAlbum addObject:@"Autres"];
				}

			}
		}
		sqlite3_finalize(compiledStatement);
		
		
		if(cpt){
			
			AlbumsTableViewController *detailViewController = [[AlbumsTableViewController alloc] initWithNibName:@"AlbumsTableView" bundle:nil];
			detailViewController.tableView.delegate = detailViewController;
			detailViewController.tableView.dataSource = detailViewController;
			
			detailViewController.albumPid = detailAPid;
			detailViewController.albumArtiste = detailAArtiste;
			detailViewController.albumAlbum = detailAAlbum;
			
			detailViewController.navigationItem.title = [self.artistArtiste objectAtIndex:indexPath.row];
			[self.navigationController pushViewController:detailViewController animated:YES];
			[detailViewController release];
			detailViewController = nil;

			
		}
		else{
			
			MorceauxTableViewController *detailViewController = [[MorceauxTableViewController alloc] initWithNibName:@"MorceauxTableView" bundle:nil];
			detailViewController.tableView.delegate = detailViewController;
			detailViewController.tableView.dataSource = detailViewController;
			
			detailViewController.chansonTitre = [[NSMutableArray alloc] init];
			detailViewController.chansonPid = [[NSMutableArray alloc] init];
			detailViewController.chansonArtiste = [[NSMutableArray alloc] init];
			detailViewController.chansonAlbum = [[NSMutableArray alloc] init];
			detailViewController.chansonInfos = [[NSMutableArray alloc] init];
			detailViewController.chansonTotalTime = [[NSMutableArray alloc] init];
			detailViewController.chansonComment = [[NSMutableArray alloc] init];
			detailViewController.chansonGrouping = [[NSMutableArray alloc] init];
			
			NSString *requeteM = @"";
			if(verifios5){
				requeteM = [NSString stringWithFormat:@"SELECT it.item_pid, ite.title, ita.item_artist, a.album, ite.total_time_ms,ite.comment, ite.grouping FROM item it, item_extra ite, item_artist ita, album a WHERE it.item_pid=ite.item_pid AND it.item_artist_pid=ita.item_artist_pid AND it.album_pid=a.album_pid AND ita.item_artist_pid='%@'",pidArtist];
			}
			else{
				requeteM = [NSString stringWithFormat:@"SELECT pid, title, artist, album,total_time_ms, comment, grouping FROM item WHERE artist_pid='%@' ORDER BY sort_title",pidArtist];
			}
			const char *sqlStatementM = [requeteM cStringUsingEncoding:[NSString defaultCStringEncoding]];
			
			sqlite3_stmt *compiledStatementM;
			
			if(sqlite3_prepare_v2(database, sqlStatementM, -1, &compiledStatementM, NULL) == SQLITE_OK) {
				
				while(sqlite3_step(compiledStatementM) == SQLITE_ROW) {
					
					
					NSString *pid = @"";
					const char* pidChar = (const char*)sqlite3_column_text(compiledStatement, 0);
					if(pidChar != NULL){
						pid = [NSString stringWithUTF8String:pidChar];
					}
					
					NSString *titre = @"";
					const char* titreChar = (const char*)sqlite3_column_text(compiledStatement, 1);
					if(titreChar != NULL){
						titre = [NSString stringWithUTF8String:titreChar];
					}
					
					NSString *artist = @"";
					const char* artistChar = (const char*)sqlite3_column_text(compiledStatement, 2);
					if(artistChar != NULL){
						artist = [NSString stringWithUTF8String:artistChar];
					}
					
					NSString *album = @"";
					const char* albumChar = (const char*)sqlite3_column_text(compiledStatement, 3);
					if(albumChar != NULL){
						album = [NSString stringWithUTF8String:albumChar];
					}
					
					NSString *totalTime = @"";
					const char* totalTimeChar = (const char*)sqlite3_column_text(compiledStatement, 4);
					if(totalTimeChar != NULL){
						totalTime = [NSString stringWithUTF8String:totalTimeChar];
					}
					
					NSString *comment = @"";
					const char* commentChar = (const char*)sqlite3_column_text(compiledStatement, 5);
					if(commentChar != NULL){
						comment = [NSString stringWithUTF8String:commentChar];
					}
					
					NSString *grouping = @"";
					const char* groupingChar = (const char*)sqlite3_column_text(compiledStatement, 6);
					if(groupingChar != NULL){
						grouping = [NSString stringWithUTF8String:groupingChar];
					}
					
					
					
					NSString *infos = @"";
					if([artist compare:@""] != NSOrderedSame){
						infos = [infos stringByAppendingString:artist];
						if([album compare:@""] != NSOrderedSame){
							infos = [infos stringByAppendingFormat:@" - %@",album];
						}
					}
					else{
						if([album compare:@""] != NSOrderedSame){
							infos = [infos stringByAppendingString:album];
						}
					}
					
					/*
					NSString *pid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
					NSString *titre = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
					NSString *artist = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
					NSString *album = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
					 */
					
					[detailViewController.chansonPid addObject:pid];
					[detailViewController.chansonTitre addObject:titre];
					[detailViewController.chansonArtiste addObject:artist];
					[detailViewController.chansonAlbum addObject:album];
					[detailViewController.chansonInfos addObject:infos];
					[detailViewController.chansonTotalTime addObject:totalTime];
					[detailViewController.chansonComment addObject:comment];
					[detailViewController.chansonGrouping addObject:grouping];
					
				}
			}
			sqlite3_finalize(compiledStatementM);
			compiledStatementM = nil;
			
			detailViewController.isAlbum = @"artiste";
			
			detailViewController.navigationItem.title = [self.artistArtiste objectAtIndex:indexPath.row];
			[self.navigationController pushViewController:detailViewController animated:YES];
			
			[detailViewController.chansonPid release];
			[detailViewController.chansonTitre release];
			[detailViewController.chansonArtiste release];
			[detailViewController.chansonAlbum release];
			[detailViewController.chansonInfos release];
			[detailViewController.chansonTotalTime release];
			[detailViewController.chansonComment release];
			[detailViewController.chansonGrouping release];
			
			[detailViewController release];
			detailViewController = nil;
		}
		
		compiledStatement = nil;
	}
	sqlite3_close(database);
	database = nil;
	
	[detailAPid release];
	[detailAAlbum release];
	[detailAArtiste release];
	detailAPid = nil;
	detailAAlbum = nil;
	detailAArtiste = nil;
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
		
		
		for (int i=0; i<[self.artistArtiste count]; i++) {
			
			exportContents = [exportContents stringByAppendingString:[NSString stringWithFormat:@"<p><b>%@</b></p>",[self.artistArtiste objectAtIndex:i]]];
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
	[artistArtiste release];
	[artistPid release];
    [databasePath release];
    [super dealloc];
}


@end

