//
//  IpodTableViewController.m
//  appinfo
//
//  Created by Miles on 25/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IpodTableViewController.h"
#import "CustomCell.h"
#import "MorceauxTableViewController.h"
#import "AlbumsTableViewController.h"
#import "ArtistsTableViewController.h"
#import "GenresTableViewController.h"
#import "iPodSearchViewController.h"
#import "appinfoAppDelegate.h"

@implementation IpodTableViewController

@synthesize ipodTableView;
@synthesize rubrique;
@synthesize morceauxTable;
@synthesize albumsTable;
@synthesize artistsTable;
@synthesize genresTable;
@synthesize ipodSearch;
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

	self.navigationItem.title = @"AppInfo";
	
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"iPod";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];
	temporaryBarButtonItem = nil;
	
    
	verifios5 = FALSE; 
	NSString *reqSysVer = @"5";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending){
		verifios5 = TRUE;
	}
    
    appinfoAppDelegate *delegate = (appinfoAppDelegate*)[[UIApplication sharedApplication] delegate];
    if(verifios5){
        databasePath = [[NSString stringWithFormat:@"%@/iTunes_Control/iTunes/MediaLibrary.sqlitedb",delegate.pathMedia] retain];
    }
    else {
        databasePath = [[NSString stringWithFormat:@"%@/iTunes_Control/iTunes/iTunes Library.itlp/Library.itdb",delegate.pathMedia] retain];
    }
	
	NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:MyLocalizedString(@"_search",@""),MyLocalizedString(@"_genresM",@""),MyLocalizedString(@"_artistesM",@""),MyLocalizedString(@"_albumsM",@""),MyLocalizedString(@"_morceauxM",@""),nil]; //@"Search",
	self.rubrique = array;
	[array release];
	array = nil;
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
    return [self.rubrique count];
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
	
	cell.primaryLabel.text = [self.rubrique objectAtIndex:indexPath.row];
	cell.secondaryLabel.text = @"";
    
	NSString *iconePath = @"";
	if(indexPath.row == 0){
		iconePath = @"searchipod.png";
	}
    else if(indexPath.row == 1){
		iconePath = @"genres.png";
	}
	else if(indexPath.row == 2){
		iconePath = @"artistes.png";
	}
	else if(indexPath.row == 3){
		iconePath = @"albums.png";
	}
	else if(indexPath.row == 4){
		iconePath = @"morceaux.png";
	}
	else{
		iconePath = @"ipod.png";
	}
	
	UIImage *image;
	NSData *data;
	if([iconePath compare:@""] != NSOrderedSame){
		NSString *path = [[NSBundle mainBundle] bundlePath];
		data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",path,iconePath]];
		image = [[UIImage alloc] initWithData:data];
		cell.myImageView.image = image;
	}
	
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

	NSString *requete = @"";
	
    //SEARCH
    if(indexPath.row == 0){
        
        iPodSearchViewController *search = [[iPodSearchViewController alloc] initWithNibName:@"iPodSearchViewController" bundle:nil];
        self.ipodSearch = search;
        [search release];
        self.ipodSearch.navigationItem.title = MyLocalizedString(@"_search",@"");
		[self.navigationController pushViewController:self.ipodSearch animated:YES];
        
    }
	//GENRES
	if(indexPath.row == 1){
		
		GenresTableViewController *detailViewController = [[GenresTableViewController alloc] initWithNibName:@"ArtistsTableView" bundle:nil];
		self.genresTable.tableView.delegate = self.genresTable;
		self.genresTable.tableView.dataSource = self.genresTable;
		self.genresTable = detailViewController;
		[detailViewController release];
		
		
		self.genresTable.genreNom = [[NSMutableArray alloc] init];
		self.genresTable.genrePid = [[NSMutableArray alloc] init];
		
		sqlite3 *database;
        
		if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
			
			
			if(verifios5){
				requete = @"SELECT genre_id, genre FROM genre ORDER BY genre COLLATE NOCASE";
			}
			else {
				requete = @"SELECT id,genre FROM genre_map ORDER BY genre_order";
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
					
					NSString *nom = @"";
					const char* nomChar = (const char*)sqlite3_column_text(compiledStatement, 1);
					if(nomChar != NULL){
						nom = [NSString stringWithUTF8String:nomChar];
					}
					
					/*
					NSString *pid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
					NSString *nom = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
					 */

					[self.genresTable.genreNom addObject:nom];
					[self.genresTable.genrePid addObject:pid];
				}
			}
			
			sqlite3_finalize(compiledStatement);
			compiledStatement = nil;
			
		}
		sqlite3_close(database);
		database = nil;
		
		self.genresTable.navigationItem.title = MyLocalizedString(@"_genresM",@"");
		
		[self.navigationController pushViewController:self.genresTable animated:YES];
		
	}
	//ARTISTES
	if(indexPath.row == 2){
		
		ArtistsTableViewController *detailViewController = [[ArtistsTableViewController alloc] initWithNibName:@"ArtistsTableView" bundle:nil];
		self.artistsTable.tableView.delegate = self.artistsTable;
		self.albumsTable.tableView.dataSource = self.artistsTable;
		self.artistsTable = detailViewController;
		[detailViewController release];
		
		self.artistsTable.artistPid = [[NSMutableArray alloc] init];
		self.artistsTable.artistArtiste = [[NSMutableArray alloc] init];
		
		sqlite3 *database;
		
		if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
			
			/*Requete quequette*/
			//NSString *requete = @"SELECT pid, name FROM item_artist WHERE name !='' ORDER BY sort_name";
			
			if(verifios5){
				requete = @"SELECT item_artist, item_artist_pid FROM item_artist ORDER BY item_artist COLLATE NOCASE";
			}
			else {
				requete = @"SELECT artist,artist_pid FROM item GROUP BY artist ORDER BY artist_order";
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
					
					[self.artistsTable.artistPid addObject:pid];
					[self.artistsTable.artistArtiste addObject:artist];
				}
			}
			
			sqlite3_finalize(compiledStatement);
			compiledStatement = nil;
			
		}
		sqlite3_close(database);
		database = nil;
		
		self.artistsTable.navigationItem.title = MyLocalizedString(@"_artistesM",@"");
		
		[self.navigationController pushViewController:self.artistsTable animated:YES];
		
	}
	//ALBUMS
	if(indexPath.row == 3){
		
		AlbumsTableViewController *detailViewController = [[AlbumsTableViewController alloc] initWithNibName:@"AlbumsTableView" bundle:nil];
		self.albumsTable.tableView.delegate = self.albumsTable;
		self.albumsTable.tableView.dataSource = self.albumsTable;
		self.albumsTable = detailViewController;
		[detailViewController release];
		
		self.albumsTable.albumPid = [[NSMutableArray alloc] init];
		self.albumsTable.albumArtiste = [[NSMutableArray alloc] init];
		self.albumsTable.albumAlbum = [[NSMutableArray alloc] init];
		
		sqlite3 *database;
		
		if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
			
			if(verifios5){
				requete = @"SELECT a.album_pid, a.album, aa.album_artist FROM album_artist aa, album a WHERE a.album_artist_pid=aa.album_artist_pid AND a.album !='' ORDER BY a.album COLLATE NOCASE";
			}
			else {
				requete = @"SELECT pid, name, artist FROM album WHERE name !='' ORDER BY name_order";
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
					
					[self.albumsTable.albumPid addObject:pid];
					[self.albumsTable.albumAlbum addObject:album];
					[self.albumsTable.albumArtiste addObject:artist];
				}
			}
			
			sqlite3_finalize(compiledStatement);
			compiledStatement = nil;
			
		}
		sqlite3_close(database);
		database = nil;
		
		self.albumsTable.navigationItem.title = MyLocalizedString(@"_albumsM",@"");
		
		[self.navigationController pushViewController:self.albumsTable animated:YES];
		
	}
	//MORCEAUX
	if(indexPath.row == 4){
		
		MorceauxTableViewController *detailViewController = [[MorceauxTableViewController alloc] initWithNibName:@"MorceauxTableView" bundle:nil];
		self.morceauxTable.tableView.delegate = self.morceauxTable;
		self.morceauxTable.tableView.dataSource = self.morceauxTable;
		self.morceauxTable = detailViewController;
		[detailViewController release];
		
		self.morceauxTable.chansonTitre = [[NSMutableArray alloc] init];
		self.morceauxTable.chansonPid = [[NSMutableArray alloc] init];
		self.morceauxTable.chansonArtiste = [[NSMutableArray alloc] init];
		self.morceauxTable.chansonAlbum = [[NSMutableArray alloc] init];
		self.morceauxTable.chansonInfos = [[NSMutableArray alloc] init];
		self.morceauxTable.chansonTotalTime = [[NSMutableArray alloc] init];
		self.morceauxTable.chansonComment = [[NSMutableArray alloc] init];
		self.morceauxTable.chansonGrouping = [[NSMutableArray alloc] init];
		
		sqlite3 *database;
		
		if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
			
			
			if(verifios5){
				requete = @"SELECT it.item_pid, ite.title, ita.item_artist, a.album, ite.total_time_ms,ite.comment, ite.grouping FROM item it, item_extra ite, item_artist ita, album a WHERE it.item_pid=ite.item_pid AND it.item_artist_pid=ita.item_artist_pid AND it.album_pid=a.album_pid ORDER BY ite.title COLLATE NOCASE";
			}
			else {
				requete = @"SELECT pid, title, artist, album, total_time_ms, comment, grouping FROM item ORDER BY sort_title";
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
					
					/*
					NSString *pid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
					NSString *titre = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
					NSString *artist = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
					NSString *album = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
					*/
					
					
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
					
					
					
					[self.morceauxTable.chansonPid addObject:pid];
					[self.morceauxTable.chansonTitre addObject:titre];
					[self.morceauxTable.chansonArtiste addObject:artist];
					[self.morceauxTable.chansonAlbum addObject:album];
					[self.morceauxTable.chansonInfos addObject:infos];
					[self.morceauxTable.chansonTotalTime addObject:totalTime];
					[self.morceauxTable.chansonComment addObject:comment];
					[self.morceauxTable.chansonGrouping addObject:grouping];
					
				}
			}
			
			sqlite3_finalize(compiledStatement);
			compiledStatement = nil;
			
		}
		sqlite3_close(database);
		database = nil;
		
		self.morceauxTable.navigationItem.title = MyLocalizedString(@"_morceauxM",@"");
		
		self.morceauxTable.isAlbum = @"all";
		
		[self.navigationController pushViewController:self.morceauxTable animated:YES];
		
		[self.morceauxTable.chansonTitre release];
		[self.morceauxTable.chansonPid release];
		[self.morceauxTable.chansonArtiste release];
		[self.morceauxTable.chansonAlbum release];
		[self.morceauxTable.chansonInfos release];
		[self.morceauxTable.chansonTotalTime release];
		[self.morceauxTable.chansonComment release];
		[self.morceauxTable.chansonGrouping release];
		
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
    [ipodSearch release];
	[genresTable release];
	[artistsTable release];
	[albumsTable release];
	[morceauxTable release];
	[rubrique release];
    [databasePath release];
	[ipodTableView release];
    [super dealloc];
}


@end

