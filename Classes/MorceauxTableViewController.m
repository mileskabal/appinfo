//
//  MorceauxTableViewController.m
//  iPodTest
//
//  Created by Miles on 18/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MorceauxTableViewController.h"
#import "CustomCell.h"
#import "AppDetailViewController.h"
#import "appinfoAppDelegate.h"

@implementation MorceauxTableViewController

@synthesize chansonInfos, chansonTitre, chansonArtiste, chansonAlbum, chansonPid, myIndexPath, aWebView, chansonTotalTime,chansonComment,chansonGrouping, isAlbum, emailUser, databasePath, mediafilepath,documentPath;


#pragma mark -
#pragma mark Initialization

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 if ((self = [super initWithStyle:style])) {
 }h
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
    
    documentPath = [[NSString stringWithFormat:@"%@",delegate.pathDocuments] retain];
    if(verifios5){
        databasePath = [[NSString stringWithFormat:@"%@/iTunes_Control/iTunes/MediaLibrary.sqlitedb",delegate.pathMedia] retain];
        mediafilepath = [[NSString stringWithFormat:@"%@",delegate.pathMedia] retain];
    }
    else {
        databasePath = [[NSString stringWithFormat:@"%@/iTunes_Control/iTunes/iTunes Library.itlp/Library.itdb",delegate.pathMedia] retain];
        mediafilepath = [[NSString stringWithFormat:@"%@/iTunes_Control/Music",delegate.pathMedia] retain];
    }
	
	//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Chanson" message:[NSString stringWithFormat:@"%@",chanson] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
	//[alert show];
	//[alert release];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
	
	if ([isAlbum compare:@"all"] != NSOrderedSame || [isAlbum compare:@"artiste"] == NSOrderedSame) {
		UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] init];
		if ([isAlbum compare:@"album"] != NSOrderedSame) {
			exportButton.title = MyLocalizedString(@"_export",@"");
		}
		else {
			exportButton.title = MyLocalizedString(@"_action",@"");
		}

		self.navigationItem.rightBarButtonItem = exportButton;
		[exportButton setTarget:self];
		[exportButton setAction:@selector(exportActionButton:)];
		[exportButton release];
	}
}


- (void)viewDidAppear:(BOOL)animated {
	[self.tableView reloadData];
}


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

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.chansonTitre count];
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
	cell.primaryLabel.text = [self.chansonTitre objectAtIndex:indexPath.row];
	
	//NSString *artist = [self.chansonArtiste objectAtIndex:indexPath.row];
	//NSString *album = [self.chansonAlbum objectAtIndex:indexPath.row];
	

	cell.secondaryLabel.text = [self.chansonInfos objectAtIndex:indexPath.row];
	
	UIImage *image;
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/morceaux.png",path]];
	image = [[UIImage alloc] initWithData:data];
	cell.myImageView.image = image;
	
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.contentView addSubview: [self getDetailDiscolosureIndicatorForIndexPath:indexPath]];
	
	[image release];
	image = nil;
	path = nil;
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
	
	
	AppDetailViewController *appDetailViewController = [[AppDetailViewController alloc] initWithNibName:@"AppDetailViewController" bundle:nil];
	
	self.myIndexPath = indexPath;
	
	NSString *location = @"";
	sqlite3 *databaseL;
	if(sqlite3_open([databasePath UTF8String], &databaseL) == SQLITE_OK) {
		
		NSString *requeteL = @"";
		if(verifios5){
			requeteL = [NSString stringWithFormat:@"SELECT bl.path, ite.location FROM item it, item_extra ite, base_location bl WHERE it.item_pid=ite.item_pid AND it.base_location_id=bl.base_location_id AND it.item_pid='%@'",[self.chansonPid objectAtIndex:self.myIndexPath.row]];
		}
		else{
			requeteL = [NSString stringWithFormat:@"SELECT location FROM location WHERE item_pid=%@",[self.chansonPid objectAtIndex:self.myIndexPath.row]];
		}
		
		const char *sqlStatementL = [requeteL cStringUsingEncoding:[NSString defaultCStringEncoding]];
		sqlite3_stmt *compiledStatementL;
		
		if(sqlite3_prepare_v2(databaseL, sqlStatementL, -1, &compiledStatementL, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStatementL) == SQLITE_ROW) {
				if(verifios5){
					location = [NSString stringWithFormat:@"%@/%@",[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementL, 0)],[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementL, 1)]];
					location = [location stringByReplacingOccurrencesOfString:@"iTunes_Control/Music/" withString:@""];
				}
				else{
					location = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementL, 0)];
				}
			}
		}
		
		sqlite3_finalize(compiledStatementL);
		compiledStatementL = nil;
	}
	sqlite3_close(databaseL);
	databaseL = nil;
	
	/*
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location" message:[self.chansonTotalTime objectAtIndex:self.myIndexPath.row] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
	[alert show];
	[alert release];
	*/

	
	NSString *titreSong = [NSString stringWithFormat:@"%@", [self.chansonTitre objectAtIndex:self.myIndexPath.row]];
	NSString *artisteSong = [NSString stringWithFormat:@"%@", [self.chansonArtiste objectAtIndex:self.myIndexPath.row]];
	NSString *albumSong = [NSString stringWithFormat:@"%@", [self.chansonAlbum objectAtIndex:self.myIndexPath.row]];
	NSString *timeSong = [NSString stringWithFormat:@"%@", [self.chansonTotalTime objectAtIndex:self.myIndexPath.row]];
	NSString *commentSong = [NSString stringWithFormat:@"%@", [self.chansonComment objectAtIndex:self.myIndexPath.row]];
	NSString *groupingSong = [NSString stringWithFormat:@"%@", [self.chansonGrouping objectAtIndex:self.myIndexPath.row]];
	NSString *imageApplication = @"morceaux.png";
	
	
	
	NSString *affDuree = @"";
	NSString *affMinute = @"00";
	NSString *affSeconde = @"00";
	int minute = 0;
	int seconde = 0;
	int duration = [timeSong intValue];
	duration = ceil(duration / 1000);
	if(duration > 59){
		minute = duration / 60;
		seconde = duration % 60;
		if(seconde < 10){
			affSeconde = [NSString stringWithFormat:@"0%i",seconde];
		}
		else {
			affSeconde = [NSString stringWithFormat:@"%i",seconde];
		}
		if(minute < 10){
			affMinute = [NSString stringWithFormat:@"0%i",minute];
		}
		else {
			affMinute = [NSString stringWithFormat:@"%i",minute];
		}
	}
	else {
		seconde = duration;
		if(seconde < 10){
			affSeconde = [NSString stringWithFormat:@"0%i",seconde];
		}
		else {
			affSeconde = [NSString stringWithFormat:@"%i",seconde];
		}

	}
	affDuree = [NSString stringWithFormat:@"%@:%@",affMinute,affSeconde];

	
	
	NSString *lienExterne = @"";
	//lienExterne = [NSString stringWithFormat:@"<div class=\"iMenu\"><ul class=\"iArrow\">%@</ul></div>",cheminiFile];
	
	
	appDetailViewController.title = titreSong;
	
	aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];//init and create the UIWebView
	aWebView.autoresizesSubviews = YES;
	aWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	[aWebView setDelegate:self];
	
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	
	NSString *bundleInfo = @"";
	if ([titreSong compare:@""] != NSOrderedSame) {
	bundleInfo = [bundleInfo stringByAppendingFormat:@"<b>%@ :</b> %@<br />",MyLocalizedString(@"_titreM",@""),titreSong];
	}
	if ([artisteSong compare:@""] != NSOrderedSame) {
	bundleInfo = [bundleInfo stringByAppendingFormat:@"<b>%@ :</b> %@<br />",MyLocalizedString(@"_artisteM",@""),artisteSong];
	}
	if ([albumSong compare:@""] != NSOrderedSame) {
	bundleInfo = [bundleInfo stringByAppendingFormat:@"<b>%@ :</b> %@<br />",MyLocalizedString(@"_albumM",@""),albumSong];
	}
	if ([affDuree compare:@""] != NSOrderedSame) {
	bundleInfo = [bundleInfo stringByAppendingFormat:@"<b>%@ :</b> %@<br />",MyLocalizedString(@"_duree",@""),affDuree];
	}
	if ([location compare:@""] != NSOrderedSame) {
	bundleInfo = [bundleInfo stringByAppendingFormat:@"<b>%@ :</b> %@<br />",MyLocalizedString(@"_chemin",@""),location];
	}
	if ([commentSong compare:@""] != NSOrderedSame) {
	bundleInfo = [bundleInfo stringByAppendingFormat:@"<b>%@ :</b> %@<br />",MyLocalizedString(@"_commentaire",@""),commentSong];
	}
	if ([groupingSong compare:@""] != NSOrderedSame) {
	bundleInfo = [bundleInfo stringByAppendingFormat:@"<b>%@ :</b> %@<br />",MyLocalizedString(@"_groupe",@""),groupingSong];
	}
	
	//NSString *bundleInfo = [NSString stringWithFormat:@"<b>%@ :</b> %@<br /><b>%@ :</b> %@<br /><b>%@ :</b> %@<br /><b>%@ :</b> %@<br /><b>%@ :</b> %@<br /><b>%@ :</b> %@<br />",MyLocalizedString(@"_titreM",@""),titreSong,MyLocalizedString(@"_artisteM",@""),artisteSong,MyLocalizedString(@"_albumM",@""),albumSong,MyLocalizedString(@"_duree",@""),affDuree,MyLocalizedString(@"_commentaire",@""),commentSong,MyLocalizedString(@"_groupe",@""),groupingSong];
	
	NSString *myHTML = [NSString stringWithFormat:@"<html><head><link href=\"Render.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body> <div id=\"WebApp\"><div id=\"iGroup\"><div class=\"iBlock\" style=\"margin-bottom:10px;\"><h1>%@</h1><p style=\"padding-bottom:10px\"><img src=\"%@\" style=\"float:left;margin:0 5px\" width=\"60\" />%@</p></div> %@ </div></div></body></html>",titreSong,imageApplication,bundleInfo,lienExterne];
	[aWebView loadHTMLString:myHTML baseURL:baseURL];
	
	
	UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] init];
	exportButton.title = MyLocalizedString(@"_action",@"");
	appDetailViewController.navigationItem.rightBarButtonItem = exportButton;
	[exportButton setTarget:self];
	[exportButton setAction:@selector(exportAction:)];
	exportButton.tag = indexPath.row;
	[exportButton release];	
	
	
	[appDetailViewController.view addSubview:aWebView];
	
	[self.navigationController pushViewController:appDetailViewController animated:YES];
	
	[appDetailViewController release];
	appDetailViewController = nil;
	self.aWebView = nil;
	
	
	
}

#pragma mark -
#pragma mark Others Functions

- (UIButton *)getDetailDiscolosureIndicatorForIndexPath:(NSIndexPath *)indexPath  {  
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
	//image size check.png 31x31
    [button setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight){
        if([UIScreen mainScreen].bounds.size.height == 568){
            if(([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)){
                button.frame = CGRectMake(530.0, 0.0, 40.0, 40.0);
            }
            else{
                button.frame = CGRectMake(510.0, 0.0, 40.0, 40.0);
            }
        }
        else{
            if(([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)){
                button.frame = CGRectMake(440.0, 0.0, 40.0, 40.0);
            }
            else{
                button.frame = CGRectMake(420.0, 0.0, 40.0, 40.0);
            }
        }
    }
    else if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown){
        if(([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)){
            button.frame = CGRectMake(280.0, 0.0, 40.0, 40.0);
        }
        else{
            button.frame = CGRectMake(260.0, 0.0, 40.0, 40.0);
        }
    }
	button.tag = indexPath.row;
    [button addTarget:self action:@selector(detailDiscolosureIndicatorSelected:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}  
- (void)detailDiscolosureIndicatorSelected:(UIButton *)sender  {  
	
	
    UIView *view = sender;
    while (![view isKindOfClass:[UITableViewCell class]]) {
        view = [view superview];
    }
    
	self.myIndexPath = [self.tableView indexPathForCell:(UITableViewCell *)view];
	NSString *titreDisplay =  [NSString stringWithFormat:@"%@ - %@", [self.chansonArtiste objectAtIndex:self.myIndexPath.row] ,[self.chansonTitre objectAtIndex:self.myIndexPath.row] ];
	
	
	actionSheetExport = FALSE;
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:titreDisplay delegate:self cancelButtonTitle:nil destructiveButtonTitle:MyLocalizedString(@"_annuler",@"") otherButtonTitles:MyLocalizedString(@"_voirchemin",@""),MyLocalizedString(@"_jouesonifile",@""), MyLocalizedString(@"_copiedoc",@""), MyLocalizedString(@"_ouvredoc",@""),MyLocalizedString(@"_envoiparemail",@""),nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	actionSheet.destructiveButtonIndex = 0;
	[actionSheet showInView:self.parentViewController.tabBarController.view]; 
	[actionSheet release];
	
}

- (void)exportAction:(id)sender{
	
	NSString *titreDisplay =  [NSString stringWithFormat:@"%@ - %@", [self.chansonArtiste objectAtIndex:self.myIndexPath.row] ,[self.chansonTitre objectAtIndex:self.myIndexPath.row] ];
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:titreDisplay delegate:self cancelButtonTitle:nil destructiveButtonTitle:MyLocalizedString(@"_annuler",@"") otherButtonTitles:MyLocalizedString(@"_voirchemin",@""),MyLocalizedString(@"_jouesonifile",@""), MyLocalizedString(@"_copiedoc",@""), MyLocalizedString(@"_ouvredoc",@""),MyLocalizedString(@"_envoiparemail",@""),nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	actionSheet.destructiveButtonIndex = 0;
	[actionSheet showInView:self.parentViewController.tabBarController.view]; 
	[actionSheet release];
	
}

- (void)exportActionButton:(id)sender{
	
	actionSheetExport = TRUE;
	
	UIActionSheet *actionSheet;
	
	if ([isAlbum compare:@"album"] != NSOrderedSame) {
		actionSheet = [[UIActionSheet alloc] initWithTitle:MyLocalizedString(@"_exportliste",@"") delegate:self cancelButtonTitle:nil destructiveButtonTitle:MyLocalizedString(@"_annuler",@"") otherButtonTitles:MyLocalizedString(@"_exportdetails",@""), nil];
	}
	else {
		
		NSString *boutonDetails = [NSString stringWithFormat:@"%@ - %@",MyLocalizedString(@"_export",@""),MyLocalizedString(@"_exportdetails",@"")];
		
		actionSheet = [[UIActionSheet alloc] initWithTitle:MyLocalizedString(@"_action",@"") delegate:self cancelButtonTitle:nil destructiveButtonTitle:MyLocalizedString(@"_annuler",@"") otherButtonTitles:boutonDetails,MyLocalizedString(@"_copiealbumdoc",@""),MyLocalizedString(@"_ouvredoc",@""), nil];
	}
	
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	actionSheet.destructiveButtonIndex = 0;
	[actionSheet showInView:self.parentViewController.tabBarController.view]; 
	[actionSheet release];
	
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if(actionSheetExport){
		
		if (buttonIndex == 1) {
			
			NSString *exportContents = @"";
			NSString *exportContents2 = @"";
			NSString *exportContents3 = @"";
			NSString *exportContents4 = @"";
			NSString *exportContents5 = @"";
			NSString *exportContents6 = @"";
			NSString *exportContents7 = @"";
			NSString *exportContents8 = @"";
			NSString *exportContents9 = @"";
			NSString *exportContents10 = @"";
			
			for (int i=0; i<[self.chansonTitre count]; i++) {
				
				if(i<500){
					exportContents = [exportContents stringByAppendingString:[NSString stringWithFormat:@"<p><b>%@</b><br />%@</p>",[self.chansonTitre objectAtIndex:i],[self.chansonInfos objectAtIndex:i]]];
				}
				
				if(i>499 && i<1000){
					exportContents2 = [exportContents2 stringByAppendingString:[NSString stringWithFormat:@"<p><b>%@</b><br />%@</p>",[self.chansonTitre objectAtIndex:i],[self.chansonInfos objectAtIndex:i]]];
				}
				
				if(i>999 && i<1500){
					exportContents3 = [exportContents3 stringByAppendingString:[NSString stringWithFormat:@"<p><b>%@</b><br />%@</p>",[self.chansonTitre objectAtIndex:i],[self.chansonInfos objectAtIndex:i]]];
				}
				
				if(i>1499 && i<2000){
					exportContents4 = [exportContents4 stringByAppendingString:[NSString stringWithFormat:@"<p><b>%@</b><br />%@</p>",[self.chansonTitre objectAtIndex:i],[self.chansonInfos objectAtIndex:i]]];
				}
				
				if(i>1999 && i<2500){
					exportContents5 = [exportContents5 stringByAppendingString:[NSString stringWithFormat:@"<p><b>%@</b><br />%@</p>",[self.chansonTitre objectAtIndex:i],[self.chansonInfos objectAtIndex:i]]];
				}
				
				if(i>2499 && i<3000){
					exportContents6 = [exportContents6 stringByAppendingString:[NSString stringWithFormat:@"<p><b>%@</b><br />%@</p>",[self.chansonTitre objectAtIndex:i],[self.chansonInfos objectAtIndex:i]]];
				}
				
				
				if(i>2999 && i<3500){
					exportContents7 = [exportContents7 stringByAppendingString:[NSString stringWithFormat:@"<p><b>%@</b><br />%@</p>",[self.chansonTitre objectAtIndex:i],[self.chansonInfos objectAtIndex:i]]];
				}
				
				if(i>3499 && i<4000){
					exportContents8 = [exportContents8 stringByAppendingString:[NSString stringWithFormat:@"<p><b>%@</b><br />%@</p>",[self.chansonTitre objectAtIndex:i],[self.chansonInfos objectAtIndex:i]]];
				}
				
				if(i>3999 && i<4500){
					exportContents9 = [exportContents9 stringByAppendingString:[NSString stringWithFormat:@"<p><b>%@</b><br />%@</p>",[self.chansonTitre objectAtIndex:i],[self.chansonInfos objectAtIndex:i]]];
				}
				
				if(i>4499 && i<5000){
					exportContents10 = [exportContents10 stringByAppendingString:[NSString stringWithFormat:@"<p><b>%@</b><br />%@</p>",[self.chansonTitre objectAtIndex:i],[self.chansonInfos objectAtIndex:i]]];
				}
				
			}
			
			
			//[self  pushEmail:(self.emailUser) andSubject:[NSString stringWithFormat:MyLocalizedString(@"_exportmaildetails",@""),MyLocalizedString(@"_morceauxM",@"")] andBody:[NSString stringWithFormat:@"%@", self.chansonTitre]];
			
			[self  pushEmail:(self.emailUser) andSubject:[NSString stringWithFormat:MyLocalizedString(@"_exportmaildetails",@""),self.navigationItem.title] andBody:[NSString stringWithFormat:@"<h3>%@</h3>%@%@%@%@%@%@%@%@%@%@", self.navigationItem.title,exportContents,exportContents2,exportContents3,exportContents4,exportContents5,exportContents6,exportContents7,exportContents8,exportContents9,exportContents10]];
			
			//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TEST" message:exportContents delegate:self cancelButtonTitle:MyLocalizedString(@"_fermer",@"") otherButtonTitles:nil];
			//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TEST" message:[NSString stringWithFormat:@"%@",self.chansonTitre] delegate:self cancelButtonTitle:MyLocalizedString(@"_fermer",@"") otherButtonTitles:nil];
			//[alert show];
			//[alert release];
			
		}
		if (buttonIndex == 2) {
			
						
			NSString *createdFolder = [NSString stringWithFormat:@"%@/%@/", documentPath, self.navigationItem.title];
			[[NSFileManager defaultManager] createDirectoryAtPath:createdFolder withIntermediateDirectories:NO attributes:nil error:nil];
			for (int i=0; i<[self.chansonPid count]; i++) {
				NSString *location = @"";
				sqlite3 *databaseL;
				if(sqlite3_open([databasePath UTF8String], &databaseL) == SQLITE_OK) {
					
					//NSString *requeteL = [NSString stringWithFormat:@"SELECT location FROM location WHERE item_pid=%@",[self.chansonPid objectAtIndex:i]];
					NSString *requeteL = @"";
					if(verifios5){
						requeteL = [NSString stringWithFormat:@"SELECT bl.path, ite.location FROM item it, item_extra ite, base_location bl WHERE it.item_pid=ite.item_pid AND it.base_location_id=bl.base_location_id AND it.item_pid='%@'",[self.chansonPid objectAtIndex:i]];
					}
					else{
						requeteL = [NSString stringWithFormat:@"SELECT location FROM location WHERE item_pid=%@",[self.chansonPid objectAtIndex:i]];
					}
					
					const char *sqlStatementL = [requeteL cStringUsingEncoding:[NSString defaultCStringEncoding]];
					sqlite3_stmt *compiledStatementL;
					
					if(sqlite3_prepare_v2(databaseL, sqlStatementL, -1, &compiledStatementL, NULL) == SQLITE_OK) {
						while(sqlite3_step(compiledStatementL) == SQLITE_ROW) {
							
							if(verifios5){
								location = [NSString stringWithFormat:@"%@/%@",[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementL, 0)],[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementL, 1)]];
								//location = [location stringByReplacingOccurrencesOfString:@"iTunes_Control/Music/" withString:@""];
							}
							else{
								location = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementL, 0)];
							}
							
						}
					}
					
					sqlite3_finalize(compiledStatementL);
					compiledStatementL = nil;
				}
				sqlite3_close(databaseL);
				databaseL = nil;
				
				NSString *artist = [self.chansonArtiste objectAtIndex:i];
				NSString *titre = [self.chansonTitre objectAtIndex:i];
				
				NSString *extension = @"";
				
				if([location hasSuffix:@"mp3"]){
					extension = @"mp3";
				}
				else if([location hasSuffix:@"m4a"]){
					extension = @"m4a";
				}
				else{
					extension = @"mp3";
				}
				
				NSString *srcPath = @"";
                srcPath = [NSString stringWithFormat:@"%@/%@",mediafilepath,location];
                
				NSString *dstPath = [NSString stringWithFormat:@"%@%@ - %@.%@",createdFolder,artist, titre, extension];
				[[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:dstPath error:nil];
				
				/*
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:MyLocalizedString(@"_chemin",@"") message:dstPath delegate:self cancelButtonTitle:MyLocalizedString(@"_fermer",@"") otherButtonTitles:nil];
				[alert show];
				[alert release];
				*/
				
				
			}
			
		}
		if (buttonIndex == 3) {
			NSString *stringURL = [NSString stringWithFormat:@"ifile://%@/",documentPath];
			NSURL *url = [NSURL URLWithString:stringURL];
			[[UIApplication sharedApplication] openURL:url];
		}
		
	}
	else {
		NSString *location = @"";
		sqlite3 *databaseL;
		if(sqlite3_open([databasePath UTF8String], &databaseL) == SQLITE_OK) {
			
			NSString *requeteL = @"";
			if(verifios5){
				requeteL = [NSString stringWithFormat:@"SELECT bl.path, ite.location FROM item it, item_extra ite, base_location bl WHERE it.item_pid=ite.item_pid AND it.base_location_id=bl.base_location_id AND it.item_pid='%@'",[self.chansonPid objectAtIndex:self.myIndexPath.row]];
			}
			else{
				requeteL = [NSString stringWithFormat:@"SELECT location FROM location WHERE item_pid=%@",[self.chansonPid objectAtIndex:self.myIndexPath.row]];
			}
			
			
			const char *sqlStatementL = [requeteL cStringUsingEncoding:[NSString defaultCStringEncoding]];
			sqlite3_stmt *compiledStatementL;
			
			if(sqlite3_prepare_v2(databaseL, sqlStatementL, -1, &compiledStatementL, NULL) == SQLITE_OK) {
				while(sqlite3_step(compiledStatementL) == SQLITE_ROW) {
					if(verifios5){
						location = [NSString stringWithFormat:@"%@/%@",[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementL, 0)],[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementL, 1)]];
						//location = [location stringByReplacingOccurrencesOfString:@"iTunes_Control/Music/" withString:@""];
					}
					else{
						location = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatementL, 0)];
					}
				}
			}
			
			sqlite3_finalize(compiledStatementL);
			compiledStatementL = nil;
		}
		sqlite3_close(databaseL);
		databaseL = nil;
		
		
		if (buttonIndex == 1) {
			
            NSString *stringURL = @"";
            stringURL = [NSString stringWithFormat:@"%@/%@",mediafilepath,location];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:MyLocalizedString(@"_chemin",@"") message:stringURL delegate:self cancelButtonTitle:MyLocalizedString(@"_fermer",@"") otherButtonTitles:nil];
			[alert show];
			[alert release];
			
		}
		
		if (buttonIndex == 2) {
			
			NSString *stringURL = @"";
            stringURL = [NSString stringWithFormat:@"ifile://%@/%@",mediafilepath,location];
			NSURL *url = [NSURL URLWithString:stringURL];
			[[UIApplication sharedApplication] openURL:url];
			
		}
		if (buttonIndex == 3) {
			
			
			NSString *artist = [self.chansonArtiste objectAtIndex:self.myIndexPath.row];
			NSString *titre = [self.chansonTitre objectAtIndex:self.myIndexPath.row];
			
			NSString *extension = @"";
			
			if([location hasSuffix:@"mp3"]){
				extension = @"mp3";
			}
			else if([location hasSuffix:@"m4a"]){
				extension = @"m4a";
			}
			else{
				extension = @"mp3";
			}
			
			NSString *srcPath = @"";
            srcPath = [NSString stringWithFormat:@"%@/%@",mediafilepath,location];
			NSString *dstPath = [NSString stringWithFormat:@"%@/%@ - %@.%@",documentPath, artist, titre, extension];
			[[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:dstPath error:nil];
			
			
		}
		
		if (buttonIndex == 4) {
			
			NSString *stringURL = [NSString stringWithFormat:@"ifile://%@/",documentPath];
			NSURL *url = [NSURL URLWithString:stringURL];
			[[UIApplication sharedApplication] openURL:url];
			
		}
		
		if (buttonIndex == 5) {
			
			NSString *artist = [self.chansonArtiste objectAtIndex:self.myIndexPath.row];
			NSString *titre = [self.chansonTitre objectAtIndex:self.myIndexPath.row];
			
			NSString *extension = @"";
			
			if([location hasSuffix:@"mp3"]){
				extension = @"mp3";
			}
			else if([location hasSuffix:@"m4a"]){
				extension = @"m4a";
			}
			else{
				extension = @"mp3";
			}
			
			NSString *srcPath = @"";
			srcPath = [NSString stringWithFormat:@"%@/%@",mediafilepath,location];
			[self  pushEmailAttachments:(self.emailUser) andSubject:[NSString stringWithFormat:@"%@ - %@",artist,titre] andBody:[NSString stringWithFormat:@"%@ - %@<br><br>%@",artist,titre,srcPath] andAttachments:srcPath andExtension:extension];
			
			//[self  pushEmailAttachments:(self.emailUser) andSubject:[NSString stringWithFormat:@"%@ - %@",artist,titre] andBody:@"" andAttachments:[NSString stringWithFormat:@"%@ - %@",srcPath,extension] andExtension:@""];
			
		}
		
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

-(void)pushEmailAttachments:(NSString*)contactMail andSubject:(NSString*)sujetMail andBody:(NSString*)messageMail andAttachments:(NSString*)attachmentsMail andExtension:(NSString*)extensionMail {
	
	MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
	mail.mailComposeDelegate = self;
    mail.navigationBar.tintColor = UIColorFromRGB(0x0B4E92);
	
	if ([MFMailComposeViewController canSendMail]) {
		
		NSData *fileAttach = [NSData dataWithContentsOfFile:attachmentsMail];
		
		[mail setToRecipients:[NSArray arrayWithObjects:contactMail,nil]];
		[mail setSubject:sujetMail];
		[mail setMessageBody:messageMail isHTML:YES];
		[mail addAttachmentData:fileAttach mimeType:@"audio/mpeg" fileName:[NSString stringWithFormat:@"%@.%@",sujetMail,extensionMail]];
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
    [mediafilepath release];
    [documentPath release];
    [databasePath release];
	[emailUser release];
	[isAlbum release];
	[chansonTotalTime release];
	[chansonComment release];
	[chansonGrouping release];
	[aWebView release];
	[myIndexPath release];
	[chansonInfos release];
	[chansonPid release];
	[chansonTitre release];
	[chansonArtiste release];
	[chansonAlbum release];
    [super dealloc];
}


@end

