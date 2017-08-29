//
//  IpodTableViewController.h
//  appinfo
//
//  Created by Miles on 25/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "CustomCell.h"

@class MorceauxTableViewController;
@class AlbumsTableViewController;
@class ArtistsTableViewController;
@class GenresTableViewController;
@class iPodSearchViewController;

@interface IpodTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate> {
	IBOutlet UITableView *ipodTableView;
	NSMutableArray *rubrique;
    NSString *databasePath;
	MorceauxTableViewController *morceauxTable;
	AlbumsTableViewController *albumsTable;
	ArtistsTableViewController *artistsTable;
	GenresTableViewController *genresTable;
    iPodSearchViewController *ipodSearch;
	BOOL verifios5;
	
}

@property (nonatomic, retain) IBOutlet UITableView *ipodTableView;
@property (nonatomic, retain) NSMutableArray *rubrique;
@property (nonatomic, retain) NSString *databasePath;
@property (nonatomic, retain) MorceauxTableViewController *morceauxTable;
@property (nonatomic, retain) AlbumsTableViewController *albumsTable;
@property (nonatomic, retain) ArtistsTableViewController *artistsTable;
@property (nonatomic, retain) GenresTableViewController *genresTable;
@property (nonatomic, retain) iPodSearchViewController *ipodSearch;

@end
