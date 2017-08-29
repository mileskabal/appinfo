//
//  iPodSearchViewController.m
//  appinfo
//
//  Created by Miles on 24/02/14.
//
//

#import "iPodSearchViewController.h"
#import "MorceauxTableViewController.h"
#import "appinfoAppDelegate.h"

@interface iPodSearchViewController ()

@end

@implementation iPodSearchViewController

@synthesize searchInput;
@synthesize segmentControl;
@synthesize searchButton;
@synthesize morceauxTable;
@synthesize databasePath;
@synthesize topConstraint;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

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

    
    if(([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)){
        self.view.backgroundColor = UIColorFromRGB(0xF0EFF5);
        self.segmentControl.backgroundColor = UIColorFromRGB(0xF0EFF5);
        self.searchButton.backgroundColor = UIColorFromRGB(0xF0EFF5);
    }
    
    self.searchInput.delegate = self;
    [self.searchButton setTitle:MyLocalizedString(@"_search",@"") forState:UIControlStateNormal];
    [self.searchButton setTitle:MyLocalizedString(@"_search",@"") forState:UIControlStateSelected];
    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [self refreshPosition];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.searchInput) {
        [self searchAction];
        return NO;
    }
    return YES;
}

- (void)searchAction{

    NSString *stringQuery = searchInput.text;
    
    if([stringQuery compare:@""] != NSOrderedSame){
        
        
        stringQuery = [stringQuery stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        NSString *rqtplus = @"";
        switch (segmentControl.selectedSegmentIndex) {
            case 0:
                if(verifios5){
                    rqtplus = [NSString stringWithFormat:@" AND ite.title LIKE \"%%%@%%\" ",stringQuery];
                }
                else{
                    rqtplus = [NSString stringWithFormat:@" WHERE title LIKE \"%%%@%%\" ",stringQuery];
                    
                }
                break;
            case 1:
                if(verifios5){
                    rqtplus = [NSString stringWithFormat:@" AND a.album LIKE \"%%%@%%\" ",stringQuery];
                }
                else{
                    rqtplus = [NSString stringWithFormat:@" WHERE album LIKE \"%%%@%%\" ",stringQuery];
                    
                }
                break;
            case 2:
                if(verifios5){
                    rqtplus = [NSString stringWithFormat:@" AND ita.item_artist LIKE \"%%%@%%\" ",stringQuery];
                }
                else{
                    rqtplus = [NSString stringWithFormat:@" WHERE artist LIKE \"%%%@%%\" ",stringQuery];
                    
                }
                break;
            default:
                break;
        }
        
        
        NSString *requete = @"";
        if(verifios5){
            requete = [NSString stringWithFormat:@"SELECT it.item_pid, ite.title, ita.item_artist, a.album, ite.total_time_ms,ite.comment, ite.grouping FROM item it, item_extra ite, item_artist ita, album a WHERE it.item_pid=ite.item_pid AND it.item_artist_pid=ita.item_artist_pid AND it.album_pid=a.album_pid %@ ORDER BY ite.title COLLATE NOCASE",rqtplus];
        }
        else {
            requete = [NSString stringWithFormat:@"SELECT pid, title, artist, album, total_time_ms, comment, grouping FROM item %@ ORDER BY sort_title",rqtplus];
        }
        int nbr = [self getSqliteCount:requete];
        
        if(nbr){
            
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
            
            self.morceauxTable.isAlbum = @"artiste";
            
            [self.searchInput resignFirstResponder];
            
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
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search" message:@"No results found" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
        rqtplus = nil;
        requete = nil;
    }
    
    stringQuery = nil;
}


- (int) getSqliteCount:(NSString *)requete{
    int count = 0;
    sqlite3 *database;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        const char *sqlStatement = [requete cStringUsingEncoding:[NSString defaultCStringEncoding]];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                count++;
            }
        }
        sqlite3_finalize(compiledStatement);
        compiledStatement = nil;
    }
    sqlite3_close(database);
	database = nil;
    return count;
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refreshPosition{
    if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight){
        if(([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)){
            self.topConstraint.constant = 15;
        }
        else{
            self.topConstraint.constant = 70;
        }
    }
    else if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown){
        if(([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)){
            self.topConstraint.constant = 15;
        }
        else{
            self.topConstraint.constant = 80;
        }
    }

}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self refreshPosition];
}


- (void) viewDidAppear:(BOOL)animated {
    [self refreshPosition];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [searchInput release];
    [segmentControl release];
    [searchButton release];
    [morceauxTable release];
    [databasePath release];
    [super dealloc];
}

@end
