//
//  AppsTableViewController.m
//  appinfo
//
//  Created by Miles on 07/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "appinfoAppDelegate.h"
#import "AppsTableViewController.h"
#import "AppDetailViewController.h"
#import "CustomCell.h"


@implementation AppsTableViewController

@synthesize appsTableView;
@synthesize documentsDir;
@synthesize dicoApp;
@synthesize dicoAppiTunes;
@synthesize appDetailViewController;
@synthesize emailUser;
@synthesize unitUser;
@synthesize arrayOfCharacters;
@synthesize objectsForCharacters;
@synthesize appBySize;
@synthesize aWebView;
@synthesize appByDateArray;
@synthesize dateFormat;
@synthesize datetimeFormat;


//@class SBApplicationController;
/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    
	appinfoAppDelegate *delegate = (appinfoAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSString *compareVide = [NSString stringWithFormat:@"%@", delegate.emailConfigF];
	if([compareVide compare:@""] != NSOrderedSame){
		self.emailUser = [NSString stringWithFormat:@"%@", delegate.emailConfigF];
	}
	else {
		self.emailUser = nil;
	}
	
	self.unitUser = [NSString stringWithFormat:@"%@", delegate.unitConfig];
	
	self.dateFormat = delegate.dateFormatter;
    self.datetimeFormat = [self.dateFormat stringByAppendingString:@" - HH:mm"];
    
	self.navigationItem.title = @"AppInfo";
	
	UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] init];
	exportButton.title = MyLocalizedString(@"_action",@"");
	self.navigationItem.rightBarButtonItem = exportButton;
	[exportButton setTarget:self];
	[exportButton setAction:@selector(exportAction:)];
	[exportButton release]; 
    
	/*
	copyListOfItems = [[NSMutableArray alloc] init];
	
	//Add the search bar
	self.tableView.tableHeaderView = searchBar;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	searching = NO;
	letUserSelectRow = YES;
	*/
	 
	 
	NSArray *files;
	NSString *file;
	dicoApp = [[NSMutableDictionary alloc] init];
	dicoAppiTunes = [[NSMutableDictionary alloc] init];
	appBySize = [[NSMutableArray alloc] init];
	appBySizeDispo = NO;
	appBySizeSort = NO;
    appByDate = NO;
    
    documentsDir = delegate.pathAppStoreApps;
    
	files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDir error:nil];
	for(file in files){
        
		NSString *appFolderPath = [NSString stringWithFormat:@"%@/%@", documentsDir,file];
		NSArray *appFolders = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appFolderPath error:nil];
		NSString *appFolder;
		
		for(appFolder in appFolders){
            
            
            
			NSRange range = [appFolder rangeOfString:@".app"];
			if (range.length > 0){
                
				NSString *bundleFolder = [NSString stringWithFormat:@"%@/%@",appFolderPath,appFolder];
				NSString *filePath = [NSString stringWithFormat:@"%@/Info.plist",bundleFolder];
				//NSLog(@"%@",bundleFolder);
				
				if([[NSFileManager defaultManager] fileExistsAtPath:filePath] == YES){
                    
					NSMutableDictionary* plistDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:filePath] autorelease];
					
					if([plistDict allKeys]){

						//NSLog(@"gfds");
						//NSString *classISS = [[plistDict class] description];
						//NSString *classISSS = [[[plistDict allKeys] class] description];
						//NSLog([NSString stringWithFormat:@"%@ - %@",filePath,[plistDict allKeys]]);
						//NSLog([NSString stringWithFormat:@"%i",[[plistDict allKeys] count] ]);
						//NSLog(classISSS); //__NSCFDictionary
		
						NSString *CFBundleDisplayName = @"";
						if([plistDict objectForKey:@"CFBundleDisplayName"]){
							CFBundleDisplayName = [plistDict objectForKey:@"CFBundleDisplayName"];
						}
						else{
							if([plistDict objectForKey:@"CFBundleName"]){
								CFBundleDisplayName = [plistDict objectForKey:@"CFBundleName"];
							}
							else{
								if([plistDict objectForKey:@"CFBundleExecutable"]){
									CFBundleDisplayName = [plistDict objectForKey:@"CFBundleExecutable"];
								}
								else{
									CFBundleDisplayName = MyLocalizedString(@"_inconnu",@"");
								}
							}
						}
						
						NSString *CFBundleVersion = @"";
						if([plistDict objectForKey:@"CFBundleVersion"]){
							CFBundleVersion = [plistDict objectForKey:@"CFBundleVersion"];
						}
						else{
							CFBundleVersion = MyLocalizedString(@"_inconnu",@"");
						}
						

						NSString *CFBundleIconFile = @"";
						NSString *CFBundleIconFileField = MyLocalizedString(@"_inconnu",@"");
						NSMutableArray *arrayIcon = [[NSMutableArray alloc] init];
						if([plistDict objectForKey:@"CFBundleIconFile"]){
							CFBundleIconFile = [plistDict objectForKey:@"CFBundleIconFile"];
							CFBundleIconFileField = [plistDict objectForKey:@"CFBundleIconFile"];
							
							if([plistDict objectForKey:@"CFBundleIconFiles"]){
								NSString *classIcons = [[[plistDict objectForKey:@"CFBundleIconFiles"] class] description];
								if([classIcons compare:@"__NSCFArray"] == NSOrderedSame){
									arrayIcon = [plistDict objectForKey:@"CFBundleIconFiles"];
									if([arrayIcon count]){
										if([CFBundleIconFile compare:@""] == NSOrderedSame){
											CFBundleIconFile = [arrayIcon objectAtIndex:0];
										}
									}
								}
							}
								
						}
						else{
							if([plistDict objectForKey:@"CFBundleIconFiles"]){
								NSString *classIcons = [[[plistDict objectForKey:@"CFBundleIconFiles"] class] description];
								if([classIcons compare:@"__NSCFArray"] == NSOrderedSame){
									arrayIcon = [plistDict objectForKey:@"CFBundleIconFiles"];
									if([arrayIcon count]){
										if([CFBundleIconFile compare:@""] == NSOrderedSame){
											CFBundleIconFile = [arrayIcon objectAtIndex:0];
										}
									}
								}
								else if([classIcons compare:@"NSCFString"] == NSOrderedSame){
									CFBundleIconFile = [plistDict objectForKey:@"CFBundleIconFiles"];
								}
                                if([CFBundleIconFile compare:@""] == NSOrderedSame && [plistDict objectForKey:@"CFBundleIconFiles"]){
                                    NSString *classIcons = [[[plistDict objectForKey:@"CFBundleIcons"] class] description];
                                    if([classIcons compare:@"__NSCFDictionary"] == NSOrderedSame){
                                        if([[[plistDict objectForKey:@"CFBundleIcons"] objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"CFBundleIconFiles"]){
                                            NSString *classIcons2 = [[[[[plistDict objectForKey:@"CFBundleIcons"] objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"CFBundleIconFiles"] class] description];
                                            if([classIcons2 compare:@"__NSCFArray"] == NSOrderedSame){
                                                arrayIcon = [[[plistDict objectForKey:@"CFBundleIcons"] objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"CFBundleIconFiles"];
                                                if([arrayIcon count]){
                                                    if([CFBundleIconFile compare:@""] == NSOrderedSame){
                                                        CFBundleIconFile = [arrayIcon objectAtIndex:0];
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }
                                }
							}
                            else if([plistDict objectForKey:@"CFBundleIcons"]){
                                NSString *classIcons = [[[plistDict objectForKey:@"CFBundleIcons"] class] description];
                                if([classIcons compare:@"__NSCFDictionary"] == NSOrderedSame){
                                    if([[[plistDict objectForKey:@"CFBundleIcons"] objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"CFBundleIconFiles"]){
                                        NSString *classIcons2 = [[[[[plistDict objectForKey:@"CFBundleIcons"] objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"CFBundleIconFiles"] class] description];
                                        if([classIcons2 compare:@"__NSCFArray"] == NSOrderedSame){
                                            arrayIcon = [[[plistDict objectForKey:@"CFBundleIcons"] objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"CFBundleIconFiles"];
                                            if([arrayIcon count]){
                                                if([CFBundleIconFile compare:@""] == NSOrderedSame){
                                                    CFBundleIconFile = [arrayIcon objectAtIndex:0];
                                                }
                                            }
                                        }

                                    }
								}
                            }
							else{
                                CFBundleIconFile = @"Icon.png";
							}
						}                    
						
						NSString *CFBundleIdentifier = @"";
						if([plistDict objectForKey:@"CFBundleIdentifier"]){
							CFBundleIdentifier = [plistDict objectForKey:@"CFBundleIdentifier"];
						}
						else{
							CFBundleIdentifier = MyLocalizedString(@"_inconnu",@"");
						}
						
						NSString *MinimumOSVersion = @"";
						if([plistDict objectForKey:@"MinimumOSVersion"]){
							MinimumOSVersion = [plistDict objectForKey:@"MinimumOSVersion"];
						}
						else{
							MinimumOSVersion = MyLocalizedString(@"_inconnu",@"");
						}
						
						
						NSString *imageText = [NSString stringWithFormat:@"%@/%@",bundleFolder,CFBundleIconFile];
						
						//Pour esquiver certaines applis par leur noms :)
                        if([CFBundleDisplayName compare:@"WebViewService"] != NSOrderedSame){
                            
                            NSMutableDictionary *appiTunes = [[[NSMutableDictionary alloc] init] autorelease];
                            NSString *donnees;
                            NSString *donneesSource = @"";
                            NSString *purchaseDate = [NSString stringWithFormat:@"0000-00-00 %@",MyLocalizedString(@"_inconnu",@"")];

                            BOOL itunesplist = FALSE;
                            NSString *pathiTunesmeta;
                            pathiTunesmeta = [NSString stringWithFormat:@"%@/%@/iTunesMetadata.plist", documentsDir, file];
                            if([[NSFileManager defaultManager] fileExistsAtPath:pathiTunesmeta] == YES){
                                itunesplist = YES;
                                donneesSource = @"itunes";
                            }
                            else{
                                pathiTunesmeta = [NSString stringWithFormat:@"%@/%@/iTunesMetadata.appinfo", documentsDir, file];
                                if([[NSFileManager defaultManager] fileExistsAtPath:pathiTunesmeta] == YES){
                                    itunesplist = YES;
                                    donneesSource = @"appinfo";
                                }
                            }
                            
                            if(itunesplist){

                                NSMutableDictionary* plistiTunes = [[NSMutableDictionary alloc] initWithContentsOfFile:pathiTunesmeta];
                                
                                if ([plistiTunes allKeys]) {
                                    

                                    //artistId bundleVersion copyright genre genreIf itemId priceDisplay price releaseDate
                                    // com.apple.iTunesStore.downloadInfo ==> accountInfo => appleID
                                    // com.apple.iTunesStore.downloadInfo ==> purchaseDate
                                    
                                    NSString *AppleID = MyLocalizedString(@"_inconnu",@"");
                                    
                                    if([plistiTunes objectForKey:@"com.apple.iTunesStore.downloadInfo"]){
                                        
                                        NSString *classIS = [[[plistiTunes objectForKey:@"com.apple.iTunesStore.downloadInfo"] class] description];
                                        
                                        if([classIS compare:@"__NSCFDictionary"] == NSOrderedSame){

                                            NSMutableDictionary* downloadInfo = [[NSMutableDictionary alloc] initWithDictionary:[plistiTunes objectForKey:@"com.apple.iTunesStore.downloadInfo"]];
                                            
                                            if([downloadInfo objectForKey:@"purchaseDate"]){
                                                purchaseDate = [NSString stringWithFormat:@"%@",[downloadInfo objectForKey:@"purchaseDate"]];
                                            }

                                            if([downloadInfo objectForKey:@"accountInfo"]){

                                                NSString *classAI = [[[downloadInfo objectForKey:@"accountInfo"] class] description];
                                                if([classAI compare:@"__NSCFDictionary"] == NSOrderedSame){
                                                    NSMutableDictionary* accountInfo = [[NSMutableDictionary alloc] initWithDictionary:[downloadInfo objectForKey:@"accountInfo"]];
                                                    if([accountInfo objectForKey:@"AppleID"]){
                                                        AppleID = [accountInfo objectForKey:@"AppleID"];
                                                    }
                                                    [accountInfo release];
                                                }
                                                
                                                
                                            }
                                            [downloadInfo release];
                                         
                                        }
                                     
                                        
                                    }

                                    
                                    if([purchaseDate compare:@""] == NSOrderedSame){
                                        purchaseDate = [NSString stringWithFormat:@"0000-00-00 %@",MyLocalizedString(@"_inconnu",@"")];
                                        
                                    }
                                  
                                    NSString *artistName = MyLocalizedString(@"_inconnu",@"");
                                    if([plistiTunes objectForKey:@"artistName"]){
                                        artistName = [plistiTunes objectForKey:@"artistName"];
                                    }
                                    NSString *artistId = MyLocalizedString(@"_inconnu",@"");
                                    if([plistiTunes objectForKey:@"artistId"]){
                                        artistId = [plistiTunes objectForKey:@"artistId"];
                                    }
                                    NSString *bundleVersioni = MyLocalizedString(@"_inconnu",@"");
                                    if([plistiTunes objectForKey:@"bundleVersion"]){
                                        bundleVersioni = [plistiTunes objectForKey:@"bundleVersion"];
                                    }
                                    NSString *copyright = MyLocalizedString(@"_inconnu",@"");
                                    if([plistiTunes objectForKey:@"copyright"]){
                                        copyright = [plistiTunes objectForKey:@"copyright"];
                                    }
                                    NSString *genre = MyLocalizedString(@"_inconnu",@"");
                                    if([plistiTunes objectForKey:@"genre"]){
                                        genre = [plistiTunes objectForKey:@"genre"];
                                    }
                                    NSString *genreId = MyLocalizedString(@"_inconnu",@"");
                                    if([plistiTunes objectForKey:@"genreId"]){
                                        genreId = [plistiTunes objectForKey:@"genreId"];
                                    }
                                    NSString *itemId = MyLocalizedString(@"_inconnu",@"");
                                    if([plistiTunes objectForKey:@"itemId"]){
                                        itemId = [plistiTunes objectForKey:@"itemId"];
                                    }
                                    NSString *itemName = MyLocalizedString(@"_inconnu",@"");
                                    if([plistiTunes objectForKey:@"itemName"]){
                                        itemName = [plistiTunes objectForKey:@"itemName"];
                                    }
                                    NSString *priceDisplay = MyLocalizedString(@"_inconnu",@"");
                                    if([plistiTunes objectForKey:@"priceDisplay"]){
                                        priceDisplay = [plistiTunes objectForKey:@"priceDisplay"];
                                    }
                                    
                                    //NSLog(@"%@ - %@ - %@ - %@ - %@ - %@ - %@ - %@ - %@ - %@ - %@",artistName,artistId,bundleVersioni,copyright,genre,genreId,itemId,itemName,priceDisplay,AppleID,purchaseDate);
                                    
                                    /*NSLog(@"artiste %@",artistName);
                                     NSLog(@"idartist %@",artistId);
                                     NSLog(@"bversion %@",bundleVersioni);
                                     NSLog(@"c %@",copyright);
                                     NSLog(@"genre%@",genre);
                                     NSLog(@"idgenre %@",genreId);
                                     NSLog(@"iditem %@",itemId);
                                     NSLog(@"item %@",itemName);
                                     NSLog(@"price %@",priceDisplay);
                                     NSLog(@"idapple %@",AppleID);
                                     NSLog(@"date %@",purchaseDate);*/
                                    
                                    [appiTunes setObject:artistName forKey:@"artistName"];
                                    [appiTunes setObject:artistId forKey:@"artistId"];
                                    [appiTunes setObject:bundleVersioni forKey:@"bundleVersion"];
                                    [appiTunes setObject:copyright forKey:@"copyright"];
                                    [appiTunes setObject:genre forKey:@"genre"];
                                    [appiTunes setObject:genreId forKey:@"genreId"];
                                    [appiTunes setObject:itemId forKey:@"itemId"];
                                    [appiTunes setObject:itemName forKey:@"itemName"];
                                    [appiTunes setObject:priceDisplay forKey:@"priceDisplay"];
                                    [appiTunes setObject:AppleID forKey:@"AppleID"];
                                    [appiTunes setObject:purchaseDate forKey:@"purchaseDate"];
                                    [appiTunes setObject:donneesSource forKey:@"donneesSource"];
                                    
                                    donnees = @"1";
                                    //NSLog(@"donneesPremiere %@",donnees);
                                    //[priceDisplay compare:MyLocalizedString(@"_inconnu",@"")] == NSOrderedSame
                                    if([artistName compare:MyLocalizedString(@"_inconnu",@"")] == NSOrderedSame && [artistId compare:MyLocalizedString(@"_inconnu",@"")] == NSOrderedSame && [bundleVersioni compare:MyLocalizedString(@"_inconnu",@"")] == NSOrderedSame && [copyright compare:MyLocalizedString(@"_inconnu",@"")] == NSOrderedSame && [genre compare:MyLocalizedString(@"_inconnu",@"")] == NSOrderedSame && [genreId compare:MyLocalizedString(@"_inconnu",@"")] == NSOrderedSame && [itemId compare:MyLocalizedString(@"_inconnu",@"")] == NSOrderedSame && [itemName compare:MyLocalizedString(@"_inconnu",@"")] == NSOrderedSame && [AppleID compare:MyLocalizedString(@"_inconnu",@"")] == NSOrderedSame){
                                        donnees = @"0";
                                        //NSLog(@"PENDANT--");
                                    }
                                    //NSLog(@"donneesSeconde %@",donnees);
                                    [appiTunes setObject:donnees forKey:@"donnees"];
                                    //NSLog(@"donneesTroisieme %@",donnees);
                                    
                                    [plistiTunes release];
                                    //NSLog(@"bla_____");
                                    
                                }
                                else {
                                    donnees = @"0";
                                    [appiTunes setObject:donnees forKey:@"donnees"];
                                }
                                
                            }
                            else{
                                donnees = @"0";
                                [appiTunes setObject:donnees forKey:@"donnees"];
                            }
                            
                            
                            
                            if ([dicoAppiTunes objectForKey:CFBundleDisplayName]) {
                                [appiTunes setObject:[NSString stringWithFormat:@"%@ %@",CFBundleDisplayName,appFolder] forKey:@"key"];
                                [dicoAppiTunes setObject:appiTunes forKey:[NSString stringWithFormat:@"%@ %@",CFBundleDisplayName,appFolder]];
                            }
                            else {
                                [appiTunes setObject:[NSString stringWithFormat:@"%@",CFBundleDisplayName] forKey:@"key"];
                                [dicoAppiTunes setObject:appiTunes forKey:[NSString stringWithFormat:@"%@",CFBundleDisplayName]];
                            }
                            
                            if([purchaseDate compare:@""] == NSOrderedSame){
                                purchaseDate = [NSString stringWithFormat:@"0000-00-00 %@",MyLocalizedString(@"_inconnu",@"")];
                                
                            }
                            
                            
                            //float *rep = 0;
                            //NSNumber *sizeApp = [NSNumber numberWithFloat:0.00];
                            NSNumber *sizeApp = [[NSNumber alloc] initWithFloat:0.00];
                            
                            NSMutableDictionary *app = [[[NSMutableDictionary alloc] init] autorelease];
                            [app setObject:CFBundleDisplayName forKey:@"nom"];
                            [app setObject:CFBundleVersion forKey:@"version"];
                            [app setObject:CFBundleIdentifier forKey:@"identifiant"];
                            [app setObject:file forKey:@"dossier"];
                            [app setObject:appFolder forKey:@"bundle"];
                            [app setObject:imageText forKey:@"image"];
                            [app setObject:CFBundleIconFileField forKey:@"icon"];
                            [app setObject:arrayIcon forKey:@"icons"];
                            [app setObject:MinimumOSVersion forKey:@"minos"];
                            [app setObject:sizeApp forKey:@"size"];
                            [app setObject:@"" forKey:@"sizeDisplay"];
                            [app setObject:sizeApp forKey:@"sizeDocuments"];
                            [app setObject:sizeApp forKey:@"sizeLibrary"];
                            [app setObject:sizeApp forKey:@"sizeBundle"];
                            [app setObject:sizeApp forKey:@"sizeAutres"];
                            [app setObject:purchaseDate forKey:@"date"];
                            [app setObject:donneesSource forKey:@"donneesSource"];
                            
                            
                            if ([dicoApp objectForKey:CFBundleDisplayName]) {
                                [dicoApp setObject:app forKey:[NSString stringWithFormat:@"%@ %@",CFBundleDisplayName,appFolder]];
                            }
                            else {
                                [dicoApp setObject:app forKey:[NSString stringWithFormat:@"%@",CFBundleDisplayName]];
                            }
                        }
					}
				}
			}
		}
	}
	
    
	//NSArray *nomApp = [dicoApp allKeys];
	NSArray *nomAppAlpha = [[dicoApp allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	
	static NSString *letters = @"abcdefghijklmnopqrstuvwxyz";
	arrayOfCharacters = [[NSMutableArray alloc]init];
	objectsForCharacters = [[NSMutableDictionary alloc]init];
    
	for (int i = 0; i < [letters length]; i++ ) {

		int j = 0;
		NSString *lettreEnCours = [[NSString stringWithFormat:@"%c",[letters characterAtIndex:i]] capitalizedString];
		NSMutableArray *arrayOfNames = [[NSMutableArray alloc]init];
		
		for(id value in nomAppAlpha){
			NSString *appIndex = value;
			NSString *firstLetter = @"";
			
			if([appIndex length]){
				firstLetter = [[appIndex substringToIndex:1] capitalizedString];
			}
			
			if([lettreEnCours compare:firstLetter] == NSOrderedSame){
				if(!j){
					[arrayOfCharacters addObject:lettreEnCours];
					j=1;
				}
				[arrayOfNames addObject:appIndex];
			}
			
		}
		
		if(j){
			[objectsForCharacters setObject:arrayOfNames forKey:lettreEnCours];
		}
		[arrayOfNames release];
		
	}
	
	NSMutableArray *arrayOfNamesD = [[NSMutableArray alloc]init];
	for(id value in nomAppAlpha){
		NSString *appIndex = value;
		
		NSString *firstLetter = @"";
		if([appIndex length]){
			firstLetter = [[appIndex substringToIndex:1] capitalizedString];
		}
		
		
		int cpt = 0;
		
		for (int i = 0; i < [letters length]; i++ ) {
			NSString *lettreEnCours = [[NSString stringWithFormat:@"%c",[letters characterAtIndex:i]] capitalizedString];
			if([lettreEnCours compare:firstLetter] == NSOrderedSame){
				cpt++;
			}
			
		}
		
		if(!cpt){
			[arrayOfNamesD addObject:appIndex];
		}
	}
	
	if([arrayOfNamesD count]){
		[objectsForCharacters setObject:arrayOfNamesD forKey:@"#"];
		[arrayOfCharacters addObject:@"#"];
	}
	
	[arrayOfNamesD release];
	
    appByDateArray = [[[dicoAppiTunes allValues] mutableCopy] retain];
    [appByDateArray sortUsingComparator: (NSComparator)^(NSDictionary *a, NSDictionary *b){
        NSString *key1 = [b objectForKey: @"purchaseDate"];
        NSString *key2 = [a objectForKey: @"purchaseDate"];
        return [key1 compare: key2];
    }];
    
    //NSLog(@"%@",dicoAppiTunes);
    //NSLog(@"%@",dictValues);
    
	/*
	NSString *test = @"";
	for(id value in arrayOfCharacters){
		NSString *appIndex = value;
		test = [test stringByAppendingString:appIndex];
		test = [test stringByAppendingString:@"\n"];
		NSArray *yo = [objectsForCharacters objectForKey:appIndex];
		for(id values in yo){
			NSString *valeur = values;
			test = [test stringByAppendingString:valeur];
			test = [test stringByAppendingString:@"\n"];
		}
		test = [test stringByAppendingString:@"\n\n"];
	 }
	 

	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Failed!" message:test delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
	[alert show];
	[alert release];
	*/
	
	//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AppInfo" message:@"This is a beta-test vserion\nRelease very soon on BigBoss repo" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
	//[alert show];
	//[alert release];
	
    [super viewDidLoad];

    
}


/*
- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
	searching = YES;
	letUserSelectRow = NO;
	self.tableView.scrollEnabled = NO;
	
	//Add the done button.
	//self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
	//										   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
	//										   target:self action:@selector(doneSearching_Clicked:)] autorelease];
}


- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(letUserSelectRow)
		return indexPath;
	else
		return nil;
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
	
	//Remove all objects first.
	[copyListOfItems removeAllObjects];
	
	if([searchText length] > 0) {
		
		searching = YES;
		letUserSelectRow = YES;
		self.tableView.scrollEnabled = YES;
		[self searchTableView];
	}
	else {
		
		searching = NO;
		letUserSelectRow = NO;
		self.tableView.scrollEnabled = NO;
	}
	
	[self.tableView reloadData];
}
- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	
	[self searchTableView];
}

- (void) searchTableView {
	
	NSString *searchText = searchBar.text;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];
	

	
	[searchArray release];
	searchArray = nil;
}
 
 
*/
 
- (void)viewWillAppear:(BOOL)animated {
    [appsTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [appsTableView reloadData];
}

/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [appsTableView reloadData];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return 1;
	
	if ((appBySizeDispo && appBySizeSort) || appByDate) {
		return 1;
	}
	else{	
		return [self.arrayOfCharacters count];
	}
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    //return [self.dicoApp count];
	
	if ((appBySizeDispo && appBySizeSort) || appByDate) {
		//return [self.appBySize count];
		return [self.dicoApp count];
	}
	else{
	return [[self.objectsForCharacters objectForKey:[self.arrayOfCharacters objectAtIndex:section]] count];
	}
	
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {	
	if ((appBySizeDispo && appBySizeSort) || appByDate) {
        if(appByDate){
            return MyLocalizedString(@"_pardate", @"");
        }
        else if (appBySizeSort){
            return MyLocalizedString(@"_partaille", @"");
        }
        else{
            return 0;
        }
	}
	else{
        return [self.arrayOfCharacters objectAtIndex:section];
	}
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	if ((appBySizeDispo && appBySizeSort) || appByDate) {
		return 0;
	}
	else{
	return self.arrayOfCharacters;
	}
}

#pragma mark -
#pragma mark Table view delegate

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
	//cell.text = [[objectsForCharacters objectForKey:[arrayOfCharacters objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
	
	
	//NSArray *nomApp = [dicoApp allKeys];
	//NSArray *nomAppAlpha = [nomApp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	//id value = [dicoApp objectForKey:[nomAppAlpha objectAtIndex:indexPath.row]];
	id value;
    NSString *secondLabel;
	if (appBySizeDispo && appBySizeSort) {
		value = [dicoApp objectForKey:[appBySize objectAtIndex:indexPath.row]];
        secondLabel = [NSString stringWithFormat:@"%@ : %@%@", MyLocalizedString(@"_version", @""), [value objectForKey: @"version"], [value objectForKey:@"sizeDisplay"]];
	}
    else if(appByDate){
        value = [dicoApp objectForKey:[[appByDateArray objectAtIndex:indexPath.row] objectForKey:@"key"]];
        NSString *madate = [self stringFromDateIsoString:[NSString stringWithFormat:@"%@",[value objectForKey:@"date"]] withFormat:self.datetimeFormat];
        if([madate compare:@"(null)"] == NSOrderedSame) madate = MyLocalizedString(@"_inconnu", @"");
        secondLabel = [NSString stringWithFormat:@"%@", madate];
    }
	else{
		value = [dicoApp objectForKey:[[objectsForCharacters objectForKey:[arrayOfCharacters objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]];
        secondLabel = [NSString stringWithFormat:@"%@ : %@%@", MyLocalizedString(@"_version", @""), [value objectForKey: @"version"], [value objectForKey:@"sizeDisplay"]];
	}
    /*
    NSMutableArray *dictValues = [[dicoAppiTunes allValues] mutableCopy];
    [dictValues autorelease]; //only needed for manual reference counting
    [dictValues sortUsingComparator: (NSComparator)^(NSDictionary *a, NSDictionary *b){
        NSString *key1 = [b objectForKey: @"purchaseDate"];
        NSString *key2 = [a objectForKey: @"purchaseDate"];
        return [key1 compare: key2];
    }];
    value = [dicoApp objectForKey:[[dictValues objectAtIndex:indexPath.row] objectForKey:@"key"]];
    */
	
	cell.primaryLabel.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"nom"]];
	cell.secondaryLabel.text = secondLabel;
	//[ [NSString stringWithFormat:@"%@.png", [NSString stringWithFormat:@"%@", [value objectForKey: @"image"]] ] substringFromIndex:60];
	
	UIImage *image;
	NSString *imageSauve = [NSString stringWithFormat:@"%@", [value objectForKey: @"image"]];
	if([[NSFileManager defaultManager] fileExistsAtPath:imageSauve] == YES){
		NSData *data = [NSData dataWithContentsOfFile:imageSauve];
		image = [[UIImage alloc] initWithData:data];
		cell.myImageView.image = image;
	}
	else{
		NSString *imageTest = [NSString stringWithFormat:@"%@.png", imageSauve];
		if([[NSFileManager defaultManager] fileExistsAtPath:imageTest] == YES){
			NSData *data = [NSData dataWithContentsOfFile:imageTest];
			image = [[UIImage alloc] initWithData:data];
			cell.myImageView.image = image;
		}
		else{
			NSString *imageReTest = [NSString stringWithFormat:@"%@/%@/%@/icon.png", documentsDir, [NSString stringWithFormat:@"%@", [value objectForKey: @"dossier"]] ,  [NSString stringWithFormat:@"%@", [value objectForKey: @"bundle"]] ];
			if([[NSFileManager defaultManager] fileExistsAtPath:imageReTest] == YES){
				NSData *data = [NSData dataWithContentsOfFile:imageReTest];
				image = [[UIImage alloc] initWithData:data];
				cell.myImageView.image = image;
			}
			else{
				NSString *path = [[NSBundle mainBundle] bundlePath];
				NSString *imageApplication = [NSString stringWithFormat:@"%@/apple.png",path];
				NSData *data = [NSData dataWithContentsOfFile:imageApplication];
				image = [[UIImage alloc] initWithData:data];
				cell.myImageView.image = image;
			}
			//cell.secondaryLabel.text = @"wesh";
		}
		
		
	}
	[image release];
	image = nil;
	
	[cell.contentView addSubview: [self getDetailDiscolosureIndicatorForIndexPath:indexPath enableOrDisable:[NSString stringWithFormat:@"%@", [value objectForKey: @"donneesSource"]]]];
	
    return cell;
}

#pragma mark -
#pragma mark Table view cell data

// On ajouter le bouton disclosure à la cellule et le place en fonction du device
- (UIButton *)getDetailDiscolosureIndicatorForIndexPath:(NSIndexPath *)indexPath enableOrDisable:(NSString *)disaenable {
    
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    //button.frame = CGRectMake(320.0 - 44.0, 0.0, 44.0, 44.0);
	//button.backgroundColor = [UIColor blackColor];
    //button.contentEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);

	//image size check.png 31x31
    if([disaenable compare:@"appinfo"] == NSOrderedSame){
        [button setImage:[UIImage imageNamed:@"check_disable"] forState:UIControlStateNormal];
    }
    else{
        [button setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }
    
    if ((appBySizeDispo && appBySizeSort) || appByDate) {
		button.frame = CGRectMake(276.0, 0.0, 40.0, 40.0);
        if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight){
            if([UIScreen mainScreen].bounds.size.height == 568){
                button.frame = CGRectMake(530.0, 0.0, 40.0, 40.0);
            }
            else{
                button.frame = CGRectMake(440.0, 0.0, 40.0, 40.0);
            }
        }
        else if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown){
            button.frame = CGRectMake(280.0, 0.0, 40.0, 40.0);
        }

	}
	else{
		if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight){
            if([UIScreen mainScreen].bounds.size.height == 568){
                if(([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)){
                    button.frame = CGRectMake(515.0, 0.0, 40.0, 40.0);
                }
                else{
                    button.frame = CGRectMake(505.0, 0.0, 40.0, 40.0);
                }
            }
            else{
                if(([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)){
                    button.frame = CGRectMake(425.0, 0.0, 40.0, 40.0);
                }
                else{
                    button.frame = CGRectMake(415.0, 0.0, 40.0, 40.0);
                }
            }
        }
        else if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown){
            if(([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)){
                button.frame = CGRectMake(265.0, 0.0, 40.0, 40.0);
            }
            else{
                button.frame = CGRectMake(255.0, 0.0, 40.0, 40.0);
            }
            
            
        }
	}
    
	button.tag = indexPath.row;//[[objectsForCharacters objectForKey:[arrayOfCharacters objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    [button addTarget:self action:@selector(detailDiscolosureIndicatorSelected:) forControlEvents:UIControlEventTouchUpInside];  
    
    return button;
    
}

// Function qui envoie le calcul de la taille de l'appli en background
- (void)detailDiscolosureIndicatorSelected:(UIButton *)sender  {
    //
    // Obtain a reference to the selected cell
    //
    // UITableViewCell *cell = [self.tableView cellForRowAtIndexPath: [self.tableView indexPathForSelectedRow]];
	//sender.tag
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    UIView *view = sender;
    while (![view isKindOfClass:[UITableViewCell class]]) {
        view = [view superview];
    }
    NSIndexPath *indexPath = [appsTableView indexPathForCell:(UITableViewCell *)view];
	//NSIndexPath *indexPath = [appsTableView indexPathForCell:(UITableViewCell *)	[[sender superview] superview]];
    //[self actionDetailDiscolosureIndicatorSelected:indexPath];
    [NSThread detachNewThreadSelector:@selector(actionDetailDiscolosureIndicatorSelected:) toTarget:self withObject:indexPath];
}


// Calcul de la taille d'une application
- (void)actionDetailDiscolosureIndicatorSelected:(NSIndexPath *)indexPath {
    
    //NSArray *nomApp = [dicoApp allKeys];
	//NSArray *nomAppAlpha = [nomApp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	//id value = [dicoApp objectForKey:[nomAppAlpha objectAtIndex:sender.tag]];
	//id value = [dicoApp objectForKey:sender.tag];
	id value;
	NSString *nomAppi = @"";
	NSString *nomAppiX;
	if (appBySizeDispo && appBySizeSort) {
		value = [dicoApp objectForKey:[appBySize objectAtIndex:indexPath.row]];
		nomAppiX = [NSString stringWithFormat:@"%@",[appBySize objectAtIndex:indexPath.row]];
		NSMutableString *keyApp = [[NSMutableString alloc] initWithString:nomAppiX];
		[keyApp replaceOccurrencesOfString:@" #2" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
		nomAppi = [NSString stringWithFormat:@"%@",keyApp];
		[keyApp release];
		
		
	}
    else if(appByDate){
        value = [dicoApp objectForKey:[[appByDateArray objectAtIndex:indexPath.row] objectForKey:@"key"]];
        nomAppiX = [NSString stringWithFormat:@"%@",[[appByDateArray objectAtIndex:indexPath.row] objectForKey:@"key"]];
        NSMutableString *keyApp = [[NSMutableString alloc] initWithString:nomAppiX];
		[keyApp replaceOccurrencesOfString:@" #2" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
		nomAppi = [NSString stringWithFormat:@"%@",keyApp];
		[keyApp release];
    }
	else{
        value = [dicoApp objectForKey:[[objectsForCharacters objectForKey:[arrayOfCharacters objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]];
		nomAppiX = [NSString stringWithFormat:@"%@",[[objectsForCharacters objectForKey:[arrayOfCharacters objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]];
		NSMutableString *keyApp = [[NSMutableString alloc] initWithString:nomAppiX];
		[keyApp replaceOccurrencesOfString:@" #2" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
		nomAppi = [NSString stringWithFormat:@"%@",keyApp];
		[keyApp release];
	}
    
	NSString *dossierApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"dossier"]];
	NSString *pathBundle = [NSString stringWithFormat:@"%@/%@",documentsDir,dossierApplication];
	
    
	NSArray *subPath = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:pathBundle error:nil];
	NSString *contentPath;
	NSDictionary *attributes;
	NSNumber *fileSize;
	NSNumber *documentsSize = 0;
	NSNumber *librarySize = 0;
	NSNumber *bundleSize = 0;
	NSNumber *autreSize = 0;
	NSNumber *totalSize = 0;
	
    
    NSString *testAlreadyCheck = [NSString stringWithFormat:@"%@",[[self.dicoApp objectForKey:nomAppiX] objectForKey:@"sizeBundle"]];
     if([testAlreadyCheck compare:@"0"] == NSOrderedSame){
        
        for(contentPath in subPath){
            //yo = [NSString stringWithFormat:@"%@%@\n",yo,contentPath];
            
            //attributes = [[NSFileManager defaultManager] fileAttributesAtPath:[pathBundle stringByAppendingPathComponent:contentPath] traverseLink:NO];
            attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[pathBundle stringByAppendingPathComponent:contentPath] error:nil];
            
            if([attributes objectForKey:NSFileSize]){
                fileSize = [attributes objectForKey:NSFileSize];
            }
            else{
                fileSize = 0;
            }
            
            if([contentPath hasPrefix:@"Documents"]){
                documentsSize = [NSNumber numberWithFloat:([documentsSize floatValue] + [fileSize floatValue])];
            }
            else if([contentPath hasPrefix:@"Library"]){
                librarySize = [NSNumber numberWithFloat:([librarySize floatValue] + [fileSize floatValue])];
            }
            else if([contentPath hasPrefix:[value objectForKey: @"bundle"]]){
                bundleSize = [NSNumber numberWithFloat:([bundleSize floatValue] + [fileSize floatValue])];
            }
            else{
                autreSize = [NSNumber numberWithFloat:([autreSize floatValue] + [fileSize floatValue])];
            }
            
            totalSize = [NSNumber numberWithFloat:([totalSize floatValue] + [fileSize floatValue])];
        }
         
    }
    else{
        
        totalSize = [[self.dicoApp objectForKey:nomAppiX] objectForKey:@"size"];
        documentsSize = [[self.dicoApp objectForKey:nomAppiX] objectForKey:@"sizeDocuments"];
        librarySize = [[self.dicoApp objectForKey:nomAppiX] objectForKey:@"sizeLibrary"];
        bundleSize = [[self.dicoApp objectForKey:nomAppiX] objectForKey:@"sizeBundle"];
        autreSize = [[self.dicoApp objectForKey:nomAppiX] objectForKey:@"sizeAutres"];
    }
    
    
    
	
	float bytes = 1024;
	float bytesM = 1048576;
	float bytesG = 1073741824;
	NSString *tailleApp = @"";
	
	NSNumber *kilobytesB = [NSNumber numberWithFloat:([bundleSize floatValue] / bytes)];
	NSNumber *megabytesB = [NSNumber numberWithFloat:([bundleSize floatValue] / bytesM)];
	NSNumber *gigabytesB = [NSNumber numberWithFloat:([bundleSize floatValue] / bytesG)];
	if([kilobytesB intValue] > 1048576){
		tailleApp = [NSString stringWithFormat:@"%@Bundle : %.2f G%@\n", tailleApp, [gigabytesB floatValue],self.unitUser];
	}
	else if([kilobytesB intValue] > 1024){
		tailleApp = [NSString stringWithFormat:@"%@Bundle : %.2f M%@\n", tailleApp, [megabytesB floatValue],self.unitUser];
	}
	else{
		tailleApp = [NSString stringWithFormat:@"%@Bundle : %i K%@\n", tailleApp, [kilobytesB intValue],self.unitUser];
	}
	
	NSNumber *kilobytesD = [NSNumber numberWithFloat:([documentsSize floatValue] / bytes)];
	NSNumber *megabytesD = [NSNumber numberWithFloat:([documentsSize floatValue] / bytesM)];
	NSNumber *gigabytesD = [NSNumber numberWithFloat:([documentsSize floatValue] / bytesG)];
	if([kilobytesD intValue] > 1048576){
		tailleApp = [NSString stringWithFormat:@"%@Documents : %.2f G%@\n", tailleApp, [gigabytesD floatValue],self.unitUser];
	}
	else if([kilobytesD intValue] > 1024){
		tailleApp = [NSString stringWithFormat:@"%@Documents : %.2f M%@\n", tailleApp, [megabytesD floatValue],self.unitUser];
	}
	else{
		tailleApp = [NSString stringWithFormat:@"%@Documents : %i K%@\n", tailleApp, [kilobytesD intValue],self.unitUser];
	}
	
	NSNumber *kilobytesL = [NSNumber numberWithFloat:([librarySize floatValue] / bytes)];
	NSNumber *megabytesL = [NSNumber numberWithFloat:([librarySize floatValue] / bytesM)];
	NSNumber *gigabytesL = [NSNumber numberWithFloat:([librarySize floatValue] / bytesG)];
	if([kilobytesL intValue] > 1048576){
		tailleApp = [NSString stringWithFormat:@"%@Library : %.2f G%@\n", tailleApp, [gigabytesL floatValue],self.unitUser];
	}
	else if([kilobytesL intValue] > 1024){
		tailleApp = [NSString stringWithFormat:@"%@Library : %.2f M%@\n", tailleApp, [megabytesL floatValue],self.unitUser];
	}
	else{
		tailleApp = [NSString stringWithFormat:@"%@Library : %i K%@\n", tailleApp, [kilobytesL intValue],self.unitUser];
	}
	
	NSNumber *kilobytesA = [NSNumber numberWithFloat:([autreSize floatValue] / bytes)];
	NSNumber *megabytesA = [NSNumber numberWithFloat:([autreSize floatValue] / bytesM)];
	NSNumber *gigabytesA = [NSNumber numberWithFloat:([autreSize floatValue] / bytesG)];
	if([kilobytesA intValue] > 1048576){
		tailleApp = [NSString stringWithFormat:@"%@%@ : %.2f G%@\n", tailleApp, MyLocalizedString(@"_autres",@""), [gigabytesA floatValue],self.unitUser];
	}
	else if([kilobytesA intValue] > 1024){
		tailleApp = [NSString stringWithFormat:@"%@%@ : %.2f M%@\n", tailleApp, MyLocalizedString(@"_autres",@""), [megabytesA floatValue],self.unitUser];
	}
	else{
		tailleApp = [NSString stringWithFormat:@"%@%@ : %i K%@\n", tailleApp, MyLocalizedString(@"_autres",@""), [kilobytesA intValue],self.unitUser];
	}
	
	
	NSNumber *kilobytes = [NSNumber numberWithFloat:([totalSize floatValue] / bytes)];
	NSNumber *megabytes = [NSNumber numberWithFloat:([totalSize floatValue] / bytesM)];
	NSNumber *gigabytes = [NSNumber numberWithFloat:([totalSize floatValue] / bytesG)];
	if([kilobytes intValue] > 1048576){
		tailleApp = [NSString stringWithFormat:@"%@----------------\n %@ : %.2f G%@", tailleApp,MyLocalizedString(@"_tailletotale",@""), [gigabytes floatValue],self.unitUser];
	}
	else if([kilobytes intValue] > 1024){
		tailleApp = [NSString stringWithFormat:@"%@----------------\n %@ : %.2f M%@", tailleApp,MyLocalizedString(@"_tailletotale",@""), [megabytes floatValue],self.unitUser];
	}
	else{
		tailleApp = [NSString stringWithFormat:@"%@-----------------\n %@ : %i K%@", tailleApp,MyLocalizedString(@"_tailletotale",@""), [kilobytes intValue],self.unitUser];
	}
	
	if([testAlreadyCheck compare:@"0"] == NSOrderedSame){
        NSMutableArray *ajoutSize = [[NSMutableArray alloc]init];
        NSString *keyDico = [NSString stringWithFormat:@"%@", nomAppiX];
        [ajoutSize addObject:keyDico];
        [ajoutSize addObject:totalSize];
        [ajoutSize addObject:bundleSize];
        [ajoutSize addObject:documentsSize];
        [ajoutSize addObject:librarySize];
        [ajoutSize addObject:autreSize];
        
        [self performSelectorOnMainThread:@selector(ajoutSizeDico:) withObject:ajoutSize waitUntilDone:NO];
        [ajoutSize release];
        ajoutSize = nil;
    }
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",nomAppi] message:[NSString stringWithFormat:@"%@", tailleApp] delegate:nil cancelButtonTitle:MyLocalizedString(@"_fermer",@"") otherButtonTitles:nil];
	[alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
	[alert release];
    

}

//Au clic sur une appli, on crée la webview du detail de l'app et on la push
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    	
	self.appDetailViewController = nil;
	AppDetailViewController *aAppDetail = [[AppDetailViewController alloc] initWithNibName:@"AppDetailViewController" bundle:nil];
	self.appDetailViewController = aAppDetail;
	[aAppDetail release];
	
	//NSArray *nomApp = [dicoApp allKeys];
	//NSArray *nomAppAlpha = [nomApp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	//id value = [dicoApp objectForKey:[nomAppAlpha objectAtIndex:indexPath.row]];
	id value;
	if (appBySizeDispo && appBySizeSort) {
		value = [dicoApp objectForKey:[appBySize objectAtIndex:indexPath.row]];
	}
    else if(appByDate){
        value = [dicoApp objectForKey:[[appByDateArray objectAtIndex:indexPath.row] objectForKey:@"key"]];
    }
	else{
		value = [dicoApp objectForKey:[[objectsForCharacters objectForKey:[arrayOfCharacters objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]];
	}
	
	NSString *nomApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"nom"]];
	NSString *versionApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"version"]];
	NSString *dossierApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"dossier"]];
	NSString *bundleApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"bundle"]];
	NSString *identifiantApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"identifiant"]];
	NSString *minosApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"minos"]];
	NSString *iconApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"icon"]];
	NSString *tailleApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"sizeDisplay"]];

	NSString *affSize = @"";
	if([tailleApplication compare:@""] != NSOrderedSame){
		NSMutableString *keyApp = [[NSMutableString alloc] initWithString:tailleApplication];
		[keyApp replaceOccurrencesOfString:@" - " withString:[NSString stringWithFormat:@"<b>%@ :</b> ",MyLocalizedString(@"_poids",@"")] options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
		affSize = [NSString stringWithFormat:@"%@<br />",keyApp];
		[keyApp release];
		
	}
	
	NSString *iconsApplication = @""; // = [NSString stringWithFormat:@"%@", [value objectForKey: @"icons"]];
	NSArray *arrayIcon = [value objectForKey: @"icons"];
	if([arrayIcon count]){
		int cpt = 1;
		for(id value in arrayIcon){
			iconsApplication = [iconsApplication stringByAppendingString:[NSString stringWithFormat:@"%@", value]];
			
			if(cpt != [arrayIcon count]){
			iconsApplication = [iconsApplication stringByAppendingString:[NSString stringWithFormat:@" | "]];
			}
			cpt++;
		}
	}
	if([iconsApplication compare:@""] == NSOrderedSame){
		iconsApplication = MyLocalizedString(@"_inconnu",@"");
	}
	
	NSString *imageApplication = @"";
	
	NSString *imageSauve = [NSString stringWithFormat:@"%@", [value objectForKey: @"image"]];
	if([[NSFileManager defaultManager] fileExistsAtPath:imageSauve] == YES){
		
		imageApplication = imageSauve;
	}
	else{
		NSString *imageTest = [NSString stringWithFormat:@"%@.png", imageSauve];
		if([[NSFileManager defaultManager] fileExistsAtPath:imageTest] == YES){
			imageApplication = imageTest;
		}
		else{
			NSString *imageReTest = [NSString stringWithFormat:@"%@/%@/%@/icon.png", documentsDir, [NSString stringWithFormat:@"%@", [value objectForKey: @"dossier"]] ,  [NSString stringWithFormat:@"%@", [value objectForKey: @"bundle"]] ];
			if([[NSFileManager defaultManager] fileExistsAtPath:imageReTest] == YES){
				imageApplication = imageReTest;
			}
			else{
				NSString *path = [[NSBundle mainBundle] bundlePath];
				imageApplication = [NSString stringWithFormat:@"%@/apple.png",path];
			}
		}
		
	}
	
	
	//NSArray *nomAppitunes = [dicoAppiTunes allKeys];
	//NSArray *nomAppAlphaitunes = [nomAppitunes sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	//id valueitunes = [dicoAppiTunes objectForKey:[nomAppAlphaitunes objectAtIndex:indexPath.row]];
	id valueitunes;
	NSString *keyApli;
	if (appBySizeDispo && appBySizeSort) {
		valueitunes = [dicoAppiTunes objectForKey:[appBySize objectAtIndex:indexPath.row]];
		keyApli = [appBySize objectAtIndex:indexPath.row];
	}
    else if(appByDate){
        valueitunes = [dicoAppiTunes objectForKey:[[appByDateArray objectAtIndex:indexPath.row] objectForKey:@"key"]];
        keyApli = [[appByDateArray objectAtIndex:indexPath.row] objectForKey:@"key"];
    }
	else{
		valueitunes = [dicoAppiTunes objectForKey:[[objectsForCharacters objectForKey:[arrayOfCharacters objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]];
		keyApli = [[objectsForCharacters objectForKey:[arrayOfCharacters objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
	}
	
	
	NSString *donnees = [valueitunes objectForKey: @"donnees"];
    NSString *donneesSource = [valueitunes objectForKey: @"donneesSource"];
	NSString *itunesMetadataFile = @"";
	NSString *cheminAppstore = @"";
	if([donnees compare:@"1"] == NSOrderedSame){
        NSString *madate = [self stringFromDateIsoString:[NSString stringWithFormat:@"%@",[valueitunes objectForKey:@"purchaseDate"]] withFormat:self.datetimeFormat];
        if([madate compare:@"(null)"] == NSOrderedSame) madate = MyLocalizedString(@"_inconnu", @"");
		//artistId bundleVersion copyright genre genreIf itemId priceDisplay
		itunesMetadataFile = [NSString stringWithFormat:@"%@<b>%@ :</b> %@<br />",itunesMetadataFile,MyLocalizedString(@"_nom", @""),[valueitunes objectForKey:@"itemName"]];
		itunesMetadataFile = [NSString stringWithFormat:@"%@<b>%@ :</b> %@<br />",itunesMetadataFile,MyLocalizedString(@"_auteur", @""),[valueitunes objectForKey:@"artistName"]];
		itunesMetadataFile = [NSString stringWithFormat:@"%@<b>%@ :</b> %@<br />",itunesMetadataFile,MyLocalizedString(@"_genre", @""),[valueitunes objectForKey:@"genre"]];
		itunesMetadataFile = [NSString stringWithFormat:@"%@<b>%@ :</b> %@<br />",itunesMetadataFile,MyLocalizedString(@"_copyright", @""),[valueitunes objectForKey:@"copyright"]];
		//itunesMetadataFile = [NSString stringWithFormat:@"%@<b>%@ :</b> %@<br />",itunesMetadataFile,MyLocalizedString(@"_prix", @""),[valueitunes objectForKey:@"priceDisplay"]];
		itunesMetadataFile = [NSString stringWithFormat:@"%@<b>%@ :</b> %@<br />",itunesMetadataFile,MyLocalizedString(@"_itunesid", @""),[valueitunes objectForKey:@"AppleID"]];
		itunesMetadataFile = [NSString stringWithFormat:@"%@<b>%@ :</b> %@<br />",itunesMetadataFile,MyLocalizedString(@"_dateachat", @""),madate];
		itunesMetadataFile = [NSString stringWithFormat:@"%@<b>%@ :</b> %@<br />",itunesMetadataFile,MyLocalizedString(@"_artistid", @""),[valueitunes objectForKey:@"artistId"]];
		itunesMetadataFile = [NSString stringWithFormat:@"%@<b>%@ :</b> %@<br />",itunesMetadataFile,MyLocalizedString(@"_genreid", @""),[valueitunes objectForKey:@"genreId"]];
		itunesMetadataFile = [NSString stringWithFormat:@"%@<b>%@ :</b> %@<br />",itunesMetadataFile,MyLocalizedString(@"_itemid", @""),[valueitunes objectForKey:@"itemId"]];
		itunesMetadataFile = [NSString stringWithFormat:@"%@<b>%@ :</b> %@<br />",itunesMetadataFile,MyLocalizedString(@"_bundleversion", @""),[valueitunes objectForKey:@"bundleVersion"]];
		cheminAppstore = [NSString stringWithFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"http://itunes.apple.com/app/application/id%@?mt=8\"><img src=\"appstore.png\" style=\"float:left;margin:0 5px\" width=\"25\" />%@</a></li>",[valueitunes objectForKey:@"itemId"],MyLocalizedString(@"_ouvrirappstore", @"")];
	}
	else{
		itunesMetadataFile = MyLocalizedString(@"_pasdefichiersitunes", @"");
	}
	
    NSString *appstoreUpdate;
    if([donnees compare:@"1"] == NSOrderedSame){
        if([donneesSource compare:@"itunes"] == NSOrderedSame){
            appstoreUpdate = [NSString stringWithFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"appstoreupdate:%@\" id=\"appstoreupdate\"><img src=\"updateappstore.png\" style=\"float:left;margin:0 5px\" width=\"25\" /><font color=\"#B22222\">%@</font></a></li>", keyApli, MyLocalizedString(@"_desactivemaj", @"")];
        }
        else if([donneesSource compare:@"appinfo"] == NSOrderedSame){
            appstoreUpdate = [NSString stringWithFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"appstoreupdate:%@\" id=\"appstoreupdate\"><img src=\"updateappstore.png\" style=\"float:left;margin:0 5px\" width=\"25\" /><font color=\"#146FDF\">%@</font></a></li>", keyApli, MyLocalizedString(@"_activemaj", @"")];
        }
        else{
            appstoreUpdate = @"";
        }
    }
    else{
        appstoreUpdate = @"";
    }
    
	NSString *calculTailleApp;
	calculTailleApp = [NSString stringWithFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"browse:%@\"><img src=\"disque.png\" style=\"float:left;margin:0 5px\" width=\"25\" />%@</a></li>", keyApli, MyLocalizedString(@"_calcultaille",@"")];
	
	NSString *cheminiFile;
	cheminiFile = [NSString stringWithFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"ifile://file%@/%@\"><img src=\"ifile.png\" style=\"float:left;margin:0 5px\" width=\"25\" />%@</a></li>",documentsDir, dossierApplication, MyLocalizedString(@"_ouvririfile",@"")];
    
    
    appinfoAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    NSString *ipasaved = @"";
    NSString *displayipaemail = @"none";
    NSString *pathFolder = [NSString stringWithFormat:@"%@/ipa",delegate.pathAppInfoSavedFolder];
    NSString *ipapath = [NSString stringWithFormat:@"%@/%@_%@.ipa",pathFolder,nomApplication,versionApplication];
    if([[NSFileManager defaultManager] fileExistsAtPath:ipapath] == YES){
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:ipapath error:nil];
        NSDate *date = [attributes fileModificationDate];
        NSString *madate = [self stringFromDateIsoString2:[NSString stringWithFormat:@"%@",date] withFormat:datetimeFormat];
        ipasaved = [NSString stringWithFormat:@"%@ : %@",MyLocalizedString(@"_ipasaved", @""),madate];
        displayipaemail = @"block";
    }
    
    NSString *ipabyemail;
	ipabyemail = [NSString stringWithFormat:@"<li id=\"ipabyemail\" style=\"display:%@;position:relative;padding-top:10px;padding-bottom:10px;\"><a href=\"ipaemail:%@\"><img src=\"mail.png\" style=\"float:left;margin:0 5px\" width=\"25\" /><div style=\"position:absolute;display:inline-block;top:5px\">%@</div><div id=\"ipasavedate\" style=\"position:absolute;display:inline-block;top:20px;font-size:0.7em;color:#777\">%@</div></a></li>", displayipaemail,keyApli, MyLocalizedString(@"_ipabyemail",@""),ipasaved];
    
    NSString *makeipa;
	makeipa = [NSString stringWithFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"makeipa:%@\"><img src=\"makeipa.png\" style=\"float:left;margin:0 5px\" width=\"25\" />%@</a></li>", keyApli, MyLocalizedString(@"_makeipa",@"")];
	
	NSString *lienExterne;
	lienExterne = [NSString stringWithFormat:@"<div class=\"iMenu\"><ul class=\"iArrow\">%@%@%@%@%@%@</ul></div>",appstoreUpdate,ipabyemail,makeipa,cheminiFile,cheminAppstore,calculTailleApp];
	
    
    NSString *posInSB = [self findPositionInSpringboard:identifiantApplication];
    if([posInSB compare:@""] != NSOrderedSame){
        posInSB = [NSString stringWithFormat:@"<b>%@ :</b> %@<br />",MyLocalizedString(@"_positionspringboard", @""),posInSB];
    }

	appDetailViewController.title = nomApplication;
	
	aWebView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)]autorelease];//init and create the UIWebView
	aWebView.autoresizesSubviews = YES;
	aWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	[aWebView setDelegate:self];
	
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	
	NSString *bundleInfo = [NSString stringWithFormat:@"<b>%@ :</b> %@<br /><b>%@ :</b> %@<br /><b>%@ :</b> %@<br /><b>%@ :</b> %@<br /><b>%@ :</b> %@<br /><b>IconFile :</b> %@<br /><b>IconFiles :</b> %@<br />%@%@", MyLocalizedString(@"_version",@""), versionApplication,MyLocalizedString(@"_dossier",@""), dossierApplication,MyLocalizedString(@"_bundle",@""), bundleApplication,MyLocalizedString(@"_identifiant",@""), identifiantApplication, MyLocalizedString(@"_minos",@""), minosApplication,iconApplication, iconsApplication,affSize,posInSB];
	
	NSString *myHTML = [NSString stringWithFormat:@"<html><head><link href=\"Render.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body> <div id=\"WebApp\"><div id=\"iGroup\"><div class=\"iBlock\" style=\"margin-bottom:10px;\"><h1>%@</h1><p><img src=\"/../../../..%@\" style=\"float:left;margin:0 5px\" width=\"60\"/>%@</p><p>%@</p></div> %@ </div></div></body></html>",nomApplication,imageApplication,bundleInfo,itunesMetadataFile,lienExterne];
	[aWebView loadHTMLString:myHTML baseURL:baseURL];
	
	
	UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] init];
	exportButton.title = MyLocalizedString(@"_export",@"");
	appDetailViewController.navigationItem.rightBarButtonItem = exportButton;
	[exportButton setTarget:self];
	[exportButton setAction:@selector(exportActionApp:)];
	exportButton.tag = indexPath.row;
	[exportButton release];
	
	
	[appDetailViewController.view addSubview:aWebView];
	
	
	[delegate.appsNavController pushViewController:appDetailViewController animated:YES];
	
	value = nil;
	valueitunes = nil;
	self.appDetailViewController = nil;
}


//Pour récupérer les clics dans la webview du détail d'une app (ouvrir dans iFile, l'appstore et calcul de taille)
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	
    NSURL *URL = [request URL];
	NSString *urlString = [URL absoluteString];
	
	/*
	NSMutableString *keyApp = [[NSMutableString alloc] initWithString:urlString];
	[keyApp replaceOccurrencesOfString:@"browse:" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
	[keyApp replaceOccurrencesOfString:@"\%20" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
	NSString *keyID = [keyApp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[keyApp release];
	
	id value = [dicoApp objectForKey:keyID];
	NSString *dossierApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"dossier"]];
	NSString *pathBundle = [NSString stringWithFormat:@"%@/%@",documentsDir,dossierApplication];
	
	NSArray *subPath = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:pathBundle error:nil];
	NSString *contentPath;
	NSDictionary *attributes;
	NSNumber *fileSize;
	NSNumber *documentsSize = 0;
	NSNumber *librarySize = 0;
	NSNumber *bundleSize = 0;
	NSNumber *autreSize = 0;
	NSNumber *totalSize = 0;
	for(contentPath in subPath){
		//attributes = [[NSFileManager defaultManager] fileAttributesAtPath:[pathBundle stringByAppendingPathComponent:contentPath] traverseLink:NO];
		attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[pathBundle stringByAppendingPathComponent:contentPath] error:nil];
		
		
		if([attributes objectForKey:NSFileSize]){
			fileSize = [attributes objectForKey:NSFileSize];
		}
		else{
			fileSize = 0;
		}
		
		if([contentPath hasPrefix:@"Documents"]){
			documentsSize = [NSNumber numberWithFloat:([documentsSize floatValue] + [fileSize floatValue])];
		}
		else if([contentPath hasPrefix:@"Library"]){
			librarySize = [NSNumber numberWithFloat:([librarySize floatValue] + [fileSize floatValue])];
		}
		else if([contentPath hasPrefix:[value objectForKey: @"bundle"]]){
			bundleSize = [NSNumber numberWithFloat:([bundleSize floatValue] + [fileSize floatValue])];
		}
		else{
			autreSize = [NSNumber numberWithFloat:([autreSize floatValue] + [fileSize floatValue])];
		}
		
		
		
		
		totalSize = [NSNumber numberWithFloat:([totalSize floatValue] + [fileSize floatValue])];
	}
    
	float bytes = 1024;
	float bytesM = 1048576;
	float bytesG = 1073741824;
	NSString *tailleApp = @"";
	
	NSNumber *kilobytesB = [NSNumber numberWithFloat:([bundleSize floatValue] / bytes)];
	NSNumber *megabytesB = [NSNumber numberWithFloat:([bundleSize floatValue] / bytesM)];
	NSNumber *gigabytesB = [NSNumber numberWithFloat:([bundleSize floatValue] / bytesG)];
	if([kilobytesB intValue] > 1048576){
		tailleApp = [NSString stringWithFormat:@"%@Bundle : %.2f G%@\n", tailleApp, [gigabytesB floatValue],self.unitUser];
	}
	else if([kilobytesB intValue] > 1024){
		tailleApp = [NSString stringWithFormat:@"%@Bundle : %.2f M%@\n", tailleApp, [megabytesB floatValue],self.unitUser];
	}
	else{
		tailleApp = [NSString stringWithFormat:@"%@Bundle : %i K%@\n", tailleApp, [kilobytesB intValue],self.unitUser];
	}
	
	NSNumber *kilobytesD = [NSNumber numberWithFloat:([documentsSize floatValue] / bytes)];
	NSNumber *megabytesD = [NSNumber numberWithFloat:([documentsSize floatValue] / bytesM)];
	NSNumber *gigabytesD = [NSNumber numberWithFloat:([documentsSize floatValue] / bytesG)];
	if([kilobytesD intValue] > 1048576){
		tailleApp = [NSString stringWithFormat:@"%@Documents : %.2f G%@\n", tailleApp, [gigabytesD floatValue],self.unitUser];
	}
	else if([kilobytesD intValue] > 1024){
		tailleApp = [NSString stringWithFormat:@"%@Documents : %.2f M%@\n", tailleApp, [megabytesD floatValue],self.unitUser];
	}
	else{
		tailleApp = [NSString stringWithFormat:@"%@Documents : %i K%@\n", tailleApp, [kilobytesD intValue],self.unitUser];
	}
	
	NSNumber *kilobytesL = [NSNumber numberWithFloat:([librarySize floatValue] / bytes)];
	NSNumber *megabytesL = [NSNumber numberWithFloat:([librarySize floatValue] / bytesM)];
	NSNumber *gigabytesL = [NSNumber numberWithFloat:([librarySize floatValue] / bytesG)];
	if([kilobytesL intValue] > 1048576){
		tailleApp = [NSString stringWithFormat:@"%@Library : %.2f G%@\n", tailleApp, [gigabytesL floatValue],self.unitUser];
	}
	else if([kilobytesL intValue] > 1024){
		tailleApp = [NSString stringWithFormat:@"%@Library : %.2f M%@\n", tailleApp, [megabytesL floatValue],self.unitUser];
	}
	else{
		tailleApp = [NSString stringWithFormat:@"%@Library : %i K%@\n", tailleApp, [kilobytesL intValue],self.unitUser];
	}
	
	NSNumber *kilobytesA = [NSNumber numberWithFloat:([autreSize floatValue] / bytes)];
	NSNumber *megabytesA = [NSNumber numberWithFloat:([autreSize floatValue] / bytesM)];
	NSNumber *gigabytesA = [NSNumber numberWithFloat:([autreSize floatValue] / bytesG)];
	if([kilobytesA intValue] > 1048576){
		tailleApp = [NSString stringWithFormat:@"%@%@ : %.2f G%@\n", tailleApp, MyLocalizedString(@"_autres",@""), [gigabytesA floatValue],self.unitUser];
	}
	else if([kilobytesA intValue] > 1024){
		tailleApp = [NSString stringWithFormat:@"%@%@ : %.2f M%@\n", tailleApp, MyLocalizedString(@"_autres",@""), [megabytesA floatValue],self.unitUser];
	}
	else{
		tailleApp = [NSString stringWithFormat:@"%@%@ : %i K%@\n", tailleApp, MyLocalizedString(@"_autres",@""), [kilobytesA intValue],self.unitUser];
	}
	
	
	NSNumber *kilobytes = [NSNumber numberWithFloat:([totalSize floatValue] / bytes)];
	NSNumber *megabytes = [NSNumber numberWithFloat:([totalSize floatValue] / bytesM)];
	NSNumber *gigabytes = [NSNumber numberWithFloat:([totalSize floatValue] / bytesG)];
	if([kilobytes intValue] > 1048576){
		tailleApp = [NSString stringWithFormat:@"%@----------------\n %@ : %.2f G%@", tailleApp,MyLocalizedString(@"_tailletotale",@""), [gigabytes floatValue],self.unitUser];
	}
	else if([kilobytes intValue] > 1024){
		tailleApp = [NSString stringWithFormat:@"%@----------------\n %@ : %.2f M%@", tailleApp,MyLocalizedString(@"_tailletotale",@""), [megabytes floatValue],self.unitUser];
	}
	else{
		tailleApp = [NSString stringWithFormat:@"%@-----------------\n %@ : %i K%@", tailleApp,MyLocalizedString(@"_tailletotale",@""), [kilobytes intValue],self.unitUser];
	}
    */
	
	//NSLog([NSString stringWithFormat:@"Bundle: %i Ko\nDocuments: %i Ko\nLibrary: %i Ko", [[NSNumber numberWithFloat:([bundleSize floatValue] / bytes)] intValue],[[NSNumber numberWithFloat:([documentsSize floatValue] / bytes)] intValue],[[NSNumber numberWithFloat:([librarySize floatValue] / bytes)] intValue]]);
	/*
     UIAlertView *alerte = [[UIAlertView alloc] initWithTitle:@"String" message:[NSString stringWithFormat:@"%@\n %i %@",tailleApp,[totalSize intValue], yo] delegate:self cancelButtonTitle:@"Fermer" otherButtonTitles:nil];
     alerte.delegate = self;
     [alerte show];
     [alerte release];
	 */
	
	
	if(navigationType == UIWebViewNavigationTypeLinkClicked) {
		if([urlString hasPrefix:@"ifile"] || [urlString hasPrefix:@"http"] || [urlString hasPrefix:@"cydia"]){
			return ![[UIApplication sharedApplication] openURL:URL];
		}
        else if([urlString hasPrefix:@"ipaemail"]){
            
            NSMutableString *keyApp = [[NSMutableString alloc] initWithString:urlString];
            [keyApp replaceOccurrencesOfString:@"ipaemail:" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
            [keyApp replaceOccurrencesOfString:@"\%20" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
            NSString *keyID = [keyApp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [keyApp release];
            id value = [dicoApp objectForKey:keyID];
            
            appinfoAppDelegate *delegate = (appinfoAppDelegate*)[[UIApplication sharedApplication] delegate];
            NSString *pathFolder = [NSString stringWithFormat:@"%@/ipa",delegate.pathAppInfoSavedFolder];
            NSString *srcPath = [NSString stringWithFormat:@"%@/%@_%@.ipa",pathFolder,[value objectForKey:@"nom"],[value objectForKey:@"version"]];
            NSString *extension = @"ipa";
			[self  pushEmailAttachments:(delegate.emailConfigF) andSubject:[NSString stringWithFormat:@"%@_%@.ipa",[value objectForKey:@"nom"],[value objectForKey:@"version"]] andBody:[NSString stringWithFormat:@"%@ - %@<br /><br />%@",[value objectForKey:@"nom"],[value objectForKey:@"version"],srcPath] andAttachments:srcPath andExtension:extension];
            
        }
        else if([urlString hasPrefix:@"makeipa"]){
            NSMutableString *keyApp = [[NSMutableString alloc] initWithString:urlString];
            [keyApp replaceOccurrencesOfString:@"makeipa:" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
            [keyApp replaceOccurrencesOfString:@"\%20" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
            NSString *keyID = [keyApp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [keyApp release];
            id value = [dicoApp objectForKey:keyID];
            
            UIView *paintView=[[UIView alloc]initWithFrame:CGRectMake(aWebView.superview.frame.size.width/2-85, aWebView.superview.frame.size.height/2-85, 170, 150)];
            [paintView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
            [paintView.layer setCornerRadius:15.0f];
            paintView.tag = 1;
            UIActivityIndicatorView *spinner= [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(70, 30, 24, 24)];
            spinner.transform = CGAffineTransformMakeScale(2, 2);
            [spinner startAnimating];
            [paintView addSubview:spinner];
            UILabel* label = [UILabel new];
            label.frame = CGRectMake(0, 75, 170, 20);
            label.font = [UIFont systemFontOfSize:14];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = MyLocalizedString(@"_makingipa", @"");
            [paintView addSubview:label];
            UILabel* label2 = [UILabel new];
            label2.frame = CGRectMake(0, 95, 170, 20);
            label2.font = [UIFont systemFontOfSize:14];
            label2.backgroundColor = [UIColor clearColor];
            label2.textColor = [UIColor whiteColor];
            label2.textAlignment = NSTextAlignmentCenter;
            label2.text = MyLocalizedString(@"_dontquit", @"");
            [paintView addSubview:label2];
            UILabel* label3 = [UILabel new];
            label3.frame = CGRectMake(0, 115, 170, 20);
            label3.font = [UIFont systemFontOfSize:14];
            label3.backgroundColor = [UIColor clearColor];
            label3.textColor = [UIColor whiteColor];
            label3.textAlignment = NSTextAlignmentCenter;
            label3.text = MyLocalizedString(@"_pleasewait", @"");
            [paintView addSubview:label3];
            [aWebView.superview addSubview:paintView];
            [spinner release];
            [paintView release];
            aWebView.superview.superview.userInteractionEnabled = NO;
            [self performSelector:@selector(makeIpa:) withObject:value afterDelay:0.5 ];
            
            
        }
		else if([urlString hasPrefix:@"browse"]){
			/*
             NSMutableString *keyApp = [[NSMutableString alloc] initWithString:urlString];
             [keyApp replaceOccurrencesOfString:@"browse:" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
             [keyApp replaceOccurrencesOfString:@"\%20" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
             NSString *keyID = [keyApp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
             //[keyId replaceOccurrencesOfString:@"\%20" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyID length])];
             [keyApp release];
             
             id value = [dicoApp objectForKey:keyID];
             NSString *dossierApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"dossier"]];
             
             NSString *pathBundle = [NSString stringWithFormat:@"%@/%@",documentsDir,dossierApplication];
             NSArray *subPath = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:pathBundle error:nil];
             NSString *contentPath;
             NSDictionary *attributes;
             NSNumber *fileSize;
             NSNumber *totalSize = 0;
             
             for(contentPath in subPath){
             attributes = [[NSFileManager defaultManager] fileAttributesAtPath:[pathBundle stringByAppendingPathComponent:contentPath] traverseLink:NO];
             if([attributes objectForKey:NSFileSize]){
             fileSize = [attributes objectForKey:NSFileSize];
             }
             else{
             fileSize = 0;
             }
             totalSize = [NSNumber numberWithFloat:([totalSize floatValue] + [fileSize floatValue])];
             }
             float bytes = 1024;
             float bytesM = 1048576;
             float bytesG = 1073741824;
             NSString *tailleApp;
             NSNumber *kilobytes = [NSNumber numberWithFloat:([totalSize floatValue] / bytes)];
             NSNumber *megabytes = [NSNumber numberWithFloat:([totalSize floatValue] / bytesM)];
             NSNumber *gigabytes = [NSNumber numberWithFloat:([totalSize floatValue] / bytesG)];
             if([kilobytes intValue] > 1048576){
             tailleApp = [NSString stringWithFormat:@"Taille Totale : %.2f Go", [gigabytes floatValue]];
             }
             else if([kilobytes intValue] > 1024){
             tailleApp = [NSString stringWithFormat:@"Taille Totale : %.2f Mo", [megabytes floatValue]];
             }
             else{
             tailleApp = [NSString stringWithFormat:@"Taille Totale : %i Ko", [kilobytes intValue]];
             }
             */
            
            
            NSMutableString *keyApp = [[NSMutableString alloc] initWithString:urlString];
            [keyApp replaceOccurrencesOfString:@"browse:" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
            [keyApp replaceOccurrencesOfString:@"\%20" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
            NSString *keyID = [keyApp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [keyApp release];
            
            id value = [dicoApp objectForKey:keyID];
            NSString *dossierApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"dossier"]];
            NSString *pathBundle = [NSString stringWithFormat:@"%@/%@",documentsDir,dossierApplication];
            
            
            NSString *nomAppi = @"";
			NSString *nomAppiX = [NSString stringWithFormat:@"%@", keyID];
			keyApp = [[NSMutableString alloc] initWithString:nomAppiX];
			[keyApp replaceOccurrencesOfString:@" #2" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
			nomAppi = [NSString stringWithFormat:@"%@",keyApp];
			[keyApp release];
            
            NSArray *subPath = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:pathBundle error:nil];
            NSString *contentPath;
            NSDictionary *attributes;
            NSNumber *fileSize;
            NSNumber *documentsSize = 0;
            NSNumber *librarySize = 0;
            NSNumber *bundleSize = 0;
            NSNumber *autreSize = 0;
            NSNumber *totalSize = 0;
            
            NSString *testAlreadyCheck = [NSString stringWithFormat:@"%@",[[self.dicoApp objectForKey:nomAppiX] objectForKey:@"sizeBundle"]];
            if([testAlreadyCheck compare:@"0"] == NSOrderedSame){
                for(contentPath in subPath){
                    //attributes = [[NSFileManager defaultManager] fileAttributesAtPath:[pathBundle stringByAppendingPathComponent:contentPath] traverseLink:NO];
                    attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[pathBundle stringByAppendingPathComponent:contentPath] error:nil];
                    
                    
                    if([attributes objectForKey:NSFileSize]){
                        fileSize = [attributes objectForKey:NSFileSize];
                    }
                    else{
                        fileSize = 0;
                    }
                    
                    if([contentPath hasPrefix:@"Documents"]){
                        documentsSize = [NSNumber numberWithFloat:([documentsSize floatValue] + [fileSize floatValue])];
                    }
                    else if([contentPath hasPrefix:@"Library"]){
                        librarySize = [NSNumber numberWithFloat:([librarySize floatValue] + [fileSize floatValue])];
                    }
                    else if([contentPath hasPrefix:[value objectForKey: @"bundle"]]){
                        bundleSize = [NSNumber numberWithFloat:([bundleSize floatValue] + [fileSize floatValue])];
                    }
                    else{
                        autreSize = [NSNumber numberWithFloat:([autreSize floatValue] + [fileSize floatValue])];
                    }
                    totalSize = [NSNumber numberWithFloat:([totalSize floatValue] + [fileSize floatValue])];
                }
                
            }
            else{
                
                totalSize = [[self.dicoApp objectForKey:nomAppiX] objectForKey:@"size"];
                documentsSize = [[self.dicoApp objectForKey:nomAppiX] objectForKey:@"sizeDocuments"];
                librarySize = [[self.dicoApp objectForKey:nomAppiX] objectForKey:@"sizeLibrary"];
                bundleSize = [[self.dicoApp objectForKey:nomAppiX] objectForKey:@"sizeBundle"];
                autreSize = [[self.dicoApp objectForKey:nomAppiX] objectForKey:@"sizeAutres"];
            }
            
            float bytes = 1024;
            float bytesM = 1048576;
            float bytesG = 1073741824;
            NSString *tailleApp = @"";
            
            NSNumber *kilobytesB = [NSNumber numberWithFloat:([bundleSize floatValue] / bytes)];
            NSNumber *megabytesB = [NSNumber numberWithFloat:([bundleSize floatValue] / bytesM)];
            NSNumber *gigabytesB = [NSNumber numberWithFloat:([bundleSize floatValue] / bytesG)];
            if([kilobytesB intValue] > 1048576){
                tailleApp = [NSString stringWithFormat:@"%@Bundle : %.2f G%@\n", tailleApp, [gigabytesB floatValue],self.unitUser];
            }
            else if([kilobytesB intValue] > 1024){
                tailleApp = [NSString stringWithFormat:@"%@Bundle : %.2f M%@\n", tailleApp, [megabytesB floatValue],self.unitUser];
            }
            else{
                tailleApp = [NSString stringWithFormat:@"%@Bundle : %i K%@\n", tailleApp, [kilobytesB intValue],self.unitUser];
            }
            
            NSNumber *kilobytesD = [NSNumber numberWithFloat:([documentsSize floatValue] / bytes)];
            NSNumber *megabytesD = [NSNumber numberWithFloat:([documentsSize floatValue] / bytesM)];
            NSNumber *gigabytesD = [NSNumber numberWithFloat:([documentsSize floatValue] / bytesG)];
            if([kilobytesD intValue] > 1048576){
                tailleApp = [NSString stringWithFormat:@"%@Documents : %.2f G%@\n", tailleApp, [gigabytesD floatValue],self.unitUser];
            }
            else if([kilobytesD intValue] > 1024){
                tailleApp = [NSString stringWithFormat:@"%@Documents : %.2f M%@\n", tailleApp, [megabytesD floatValue],self.unitUser];
            }
            else{
                tailleApp = [NSString stringWithFormat:@"%@Documents : %i K%@\n", tailleApp, [kilobytesD intValue],self.unitUser];
            }
            
            NSNumber *kilobytesL = [NSNumber numberWithFloat:([librarySize floatValue] / bytes)];
            NSNumber *megabytesL = [NSNumber numberWithFloat:([librarySize floatValue] / bytesM)];
            NSNumber *gigabytesL = [NSNumber numberWithFloat:([librarySize floatValue] / bytesG)];
            if([kilobytesL intValue] > 1048576){
                tailleApp = [NSString stringWithFormat:@"%@Library : %.2f G%@\n", tailleApp, [gigabytesL floatValue],self.unitUser];
            }
            else if([kilobytesL intValue] > 1024){
                tailleApp = [NSString stringWithFormat:@"%@Library : %.2f M%@\n", tailleApp, [megabytesL floatValue],self.unitUser];
            }
            else{
                tailleApp = [NSString stringWithFormat:@"%@Library : %i K%@\n", tailleApp, [kilobytesL intValue],self.unitUser];
            }
            
            NSNumber *kilobytesA = [NSNumber numberWithFloat:([autreSize floatValue] / bytes)];
            NSNumber *megabytesA = [NSNumber numberWithFloat:([autreSize floatValue] / bytesM)];
            NSNumber *gigabytesA = [NSNumber numberWithFloat:([autreSize floatValue] / bytesG)];
            if([kilobytesA intValue] > 1048576){
                tailleApp = [NSString stringWithFormat:@"%@%@ : %.2f G%@\n", tailleApp, MyLocalizedString(@"_autres",@""), [gigabytesA floatValue],self.unitUser];
            }
            else if([kilobytesA intValue] > 1024){
                tailleApp = [NSString stringWithFormat:@"%@%@ : %.2f M%@\n", tailleApp, MyLocalizedString(@"_autres",@""), [megabytesA floatValue],self.unitUser];
            }
            else{
                tailleApp = [NSString stringWithFormat:@"%@%@ : %i K%@\n", tailleApp, MyLocalizedString(@"_autres",@""), [kilobytesA intValue],self.unitUser];
            }
            
            
            NSNumber *kilobytes = [NSNumber numberWithFloat:([totalSize floatValue] / bytes)];
            NSNumber *megabytes = [NSNumber numberWithFloat:([totalSize floatValue] / bytesM)];
            NSNumber *gigabytes = [NSNumber numberWithFloat:([totalSize floatValue] / bytesG)];
            if([kilobytes intValue] > 1048576){
                tailleApp = [NSString stringWithFormat:@"%@----------------\n %@ : %.2f G%@", tailleApp,MyLocalizedString(@"_tailletotale",@""), [gigabytes floatValue],self.unitUser];
            }
            else if([kilobytes intValue] > 1024){
                tailleApp = [NSString stringWithFormat:@"%@----------------\n %@ : %.2f M%@", tailleApp,MyLocalizedString(@"_tailletotale",@""), [megabytes floatValue],self.unitUser];
            }
            else{
                tailleApp = [NSString stringWithFormat:@"%@-----------------\n %@ : %i K%@", tailleApp,MyLocalizedString(@"_tailletotale",@""), [kilobytes intValue],self.unitUser];
            }
            
			
            if([testAlreadyCheck compare:@"0"] == NSOrderedSame){
                NSMutableArray *ajoutSize = [[NSMutableArray alloc]init];
                NSString *keyDico = [NSString stringWithFormat:@"%@", nomAppiX];
                [ajoutSize addObject:keyDico];
                [ajoutSize addObject:totalSize];
                [ajoutSize addObject:bundleSize];
                [ajoutSize addObject:documentsSize];
                [ajoutSize addObject:librarySize];
                [ajoutSize addObject:autreSize];
                
                [self performSelectorOnMainThread:@selector(ajoutSizeDico:) withObject:ajoutSize waitUntilDone:NO];
                [ajoutSize release];
                ajoutSize = nil;
            }
            
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nomAppi message:[NSString stringWithFormat:@"%@", tailleApp] delegate:self cancelButtonTitle:MyLocalizedString(@"_fermer",@"") otherButtonTitles:nil];
			alert.delegate = self;
			[alert show];
			[alert release];
            
            
		}
        else if([urlString hasPrefix:@"appstoreupdate"]){
            NSString *cleanstring = [[[NSString stringWithFormat:@"%@",URL] stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *key = [cleanstring stringByReplacingOccurrencesOfString:@"appstoreupdate:" withString:@""];
            id value = [dicoApp objectForKey:key];
            id valueiTunes = [dicoAppiTunes objectForKey:key];
            NSString *cheminMetadata = [NSString stringWithFormat:@"%@/%@/iTunesMetadata.", documentsDir,[value objectForKey:@"dossier"]];
            NSString *donneesSource = [valueiTunes objectForKey:@"donneesSource"];
            NSString *initPath;
            NSString *newPath;
            NSString *newSource;
            NSString *disaenable;
            NSString *color;
            if([donneesSource compare:@"itunes"] == NSOrderedSame){
                initPath = [NSString stringWithFormat:@"%@plist",cheminMetadata];
                newPath = [NSString stringWithFormat:@"%@appinfo",cheminMetadata];
                newSource = @"appinfo";
                disaenable = MyLocalizedString(@"_activemaj",@"");
                color = @"#146FDF";
            }
            else{
                initPath = [NSString stringWithFormat:@"%@appinfo",cheminMetadata];
                newPath = [NSString stringWithFormat:@"%@plist",cheminMetadata];
                newSource = @"itunes";
                disaenable = MyLocalizedString(@"_desactivemaj",@"");
                color = @"#B22222";
            }
            
            NSError *error = nil;
            [[NSFileManager defaultManager] moveItemAtPath:initPath toPath:newPath error:&error];
            if(!error){
                [[dicoAppiTunes objectForKey:key] setObject:newSource forKey:@"donneesSource"];
                [[dicoApp objectForKey:key] setObject:newSource forKey:@"donneesSource"];
                NSString *js = [NSString stringWithFormat:@"document.getElementById('appstoreupdate').innerHTML = '<img src=\"updateappstore.png\" style=\"float:left;margin:0 5px\" width=\"25\" /><font color=\"%@\">%@</font>'",color,disaenable];
                [webView stringByEvaluatingJavaScriptFromString:js];
            }

        }
	}
	
	return YES;
}

- (void) makeIpa:(id)value{
    appinfoAppDelegate *delegate = (appinfoAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSString *pathFolderAppInfo = delegate.pathAppInfoSavedFolder;
    [[NSFileManager defaultManager] createDirectoryAtPath:pathFolderAppInfo withIntermediateDirectories:NO attributes:nil error:nil];

    NSString *pathFolder = [NSString stringWithFormat:@"%@/ipa",delegate.pathAppInfoSavedFolder];
    [[NSFileManager defaultManager] createDirectoryAtPath:pathFolder withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSString *cmdString = @"";
    if([pathFolder compare:@""] != NSOrderedSame && [[NSString stringWithFormat:@"%@",[value objectForKey:@"nom"]] compare:@""] != NSOrderedSame){
        cmdString = [NSString stringWithFormat:@"rm -rf %@/\"%@_%@\"",pathFolder,[value objectForKey:@"nom"],[value objectForKey:@"version"]];
        system([cmdString UTF8String]);
        cmdString = [NSString stringWithFormat:@"rm -rf %@/\"%@_%@.ipa\"",pathFolder,[value objectForKey:@"nom"],[value objectForKey:@"version"]];
        system([cmdString UTF8String]);
    }
    
    [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@_%@",pathFolder,[value objectForKey:@"nom"],[value objectForKey:@"version"]] withIntermediateDirectories:NO attributes:nil error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@_%@/Payload",pathFolder,[value objectForKey:@"nom"],[value objectForKey:@"version"]] withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSError *copyError = nil;
    [[NSFileManager defaultManager]
     copyItemAtPath:[NSString stringWithFormat:@"%@/%@/%@",delegate.pathAppStoreApps,[value objectForKey:@"dossier"],[value objectForKey:@"bundle"]]
     toPath:[NSString stringWithFormat:@"%@/%@_%@/Payload/%@",pathFolder,[value objectForKey:@"nom"],[value objectForKey:@"version"],[value objectForKey:@"bundle"]]
     error:&copyError];
    
    BOOL itunesok = TRUE;
    NSString *imtdt = [NSString stringWithFormat:@"%@/%@/iTunesMetadata.plist",delegate.pathAppStoreApps,[value objectForKey:@"dossier"]];
    if([[NSFileManager defaultManager] fileExistsAtPath:imtdt] == NO){
        imtdt = [NSString stringWithFormat:@"%@/%@/iTunesMetadata.appinfo",delegate.pathAppStoreApps,[value objectForKey:@"dossier"]];
        if([[NSFileManager defaultManager] fileExistsAtPath:imtdt] == NO){
            itunesok = FALSE;
        }
    }

    if(itunesok){
        BOOL changeItunesID = FALSE;
        if([delegate.iIdHidden compare:@"1"] == NSOrderedSame){
            changeItunesID = TRUE;
        }
        if(changeItunesID){
            NSMutableDictionary *itunesnew = [[NSMutableDictionary alloc] initWithContentsOfFile:imtdt];
            [[[itunesnew objectForKey:@"com.apple.iTunesStore.downloadInfo"] objectForKey:@"accountInfo"] setObject:@"" forKey:@"AppleID"];
            [[[itunesnew objectForKey:@"com.apple.iTunesStore.downloadInfo"] objectForKey:@"accountInfo"] setObject:@"" forKey:@"DSPersonID"];
            [[[itunesnew objectForKey:@"com.apple.iTunesStore.downloadInfo"] objectForKey:@"accountInfo"] setObject:@"" forKey:@"AccountStoreFront"];
            [itunesnew writeToFile:[NSString stringWithFormat:@"%@/%@_%@/iTunesMetadata.plist",pathFolder,[value objectForKey:@"nom"],[value objectForKey:@"version"]] atomically:YES];
        }
        else{
        [[NSFileManager defaultManager]
         copyItemAtPath:imtdt
         toPath:[NSString stringWithFormat:@"%@/%@_%@/iTunesMetadata.plist",pathFolder,[value objectForKey:@"nom"],[value objectForKey:@"version"]]
         error:&copyError];
        }
    }
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@/iTunesArtwork",delegate.pathAppStoreApps,[value objectForKey:@"dossier"]]] == YES){
        [[NSFileManager defaultManager]
         copyItemAtPath:[NSString stringWithFormat:@"%@/%@/iTunesArtwork",delegate.pathAppStoreApps,[value objectForKey:@"dossier"]]
         toPath:[NSString stringWithFormat:@"%@/%@_%@/iTunesArtwork",pathFolder,[value objectForKey:@"nom"],[value objectForKey:@"version"]]
         error:&copyError];
    }
    
    cmdString = [NSString stringWithFormat:@"7z a -tzip %@/\"%@_%@\".ipa %@/\"%@_%@\"/*",pathFolder,[value objectForKey:@"nom"],[value objectForKey:@"version"],pathFolder,[value objectForKey:@"nom"],[value objectForKey:@"version"]];
    system([cmdString UTF8String]);
    
    
    if([pathFolder compare:@""] != NSOrderedSame && [[NSString stringWithFormat:@"%@",[value objectForKey:@"nom"]] compare:@""] != NSOrderedSame){
        cmdString = [NSString stringWithFormat:@"rm -rf %@/\"%@_%@\"",pathFolder,[value objectForKey:@"nom"],[value objectForKey:@"version"]];
        system([cmdString UTF8String]);
    }
    
    NSString *ipapath = [NSString stringWithFormat:@"%@/%@_%@.ipa",pathFolder,[value objectForKey:@"nom"],[value objectForKey:@"version"]];
    if([[NSFileManager defaultManager] fileExistsAtPath:ipapath] == YES){

        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:ipapath error:nil];
        NSDate *date = [attributes fileModificationDate];
        NSString *madate = [self stringFromDateIsoString2:[NSString stringWithFormat:@"%@",date] withFormat:datetimeFormat];
        NSString *ipasaved = [NSString stringWithFormat:@"%@ : %@",MyLocalizedString(@"_ipasaved", @""),madate];
        NSString *js = [NSString stringWithFormat:@"document.getElementById('ipasavedate').innerHTML = '%@'",ipasaved];
        
        [aWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('ipabyemail').style.display = 'block'"];
        [aWebView stringByEvaluatingJavaScriptFromString:js];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:MyLocalizedString(@"_makeipacompleted",@"") message:[NSString stringWithFormat:@"%@_%@.ipa %@ %@",[value objectForKey:@"nom"],[value objectForKey:@"version"],MyLocalizedString(@"_createdin",@""),pathFolder] delegate:nil cancelButtonTitle:MyLocalizedString(@"_fermer",@"") otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        [alert release];
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:MyLocalizedString(@"_makeipafailed",@"") message:[NSString stringWithFormat:@"%@ %@_%@.ipa",MyLocalizedString(@"_failedcreate",@""),[value objectForKey:@"nom"],[value objectForKey:@"version"]] delegate:nil cancelButtonTitle:MyLocalizedString(@"_fermer",@"") otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        [alert release];
    }

    UIView *v = [aWebView.superview viewWithTag:1];
    v.hidden = YES;
    [aWebView.superview bringSubviewToFront:v];
    [v removeFromSuperview];
    aWebView.superview.superview.userInteractionEnabled = YES;
    
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
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
#pragma mark Other Functions


//Pour trouver la position dans le springboard
- (NSString *) findPositionInSpringboard:(NSString *)idapp{
    //NSLog(@"%@",idapp);
    
    NSString *posInSB = @"";
    
    appinfoAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    NSString *IconPlistPath  = [NSString stringWithFormat:@"%@/IconState.plist",delegate.pathSpringboardPosition];
    //NSLog(@"%@",IconPlistPath);
    if([[NSFileManager defaultManager] fileExistsAtPath:IconPlistPath] == YES){
        NSMutableDictionary* IconPlist = [[[NSMutableDictionary alloc] initWithContentsOfFile:IconPlistPath] autorelease];
        //NSLog(@"%@",IconPlist);
        
        if([IconPlist objectForKey:@"iconLists"]){
            for(int i=0;i<[[IconPlist objectForKey:@"iconLists"] count];i++){
                //NSLog(@"Page %i",i+1);
                //NSLog(@"%@",[[IconPlist objectForKey:@"iconLists"] objectAtIndex:i]);
                for(int j=0;j<[[[IconPlist objectForKey:@"iconLists"] objectAtIndex:i] count];j++){
                    //NSLog(@"Pos %i",j+1);
                    //NSLog(@"%@",[NSString stringWithFormat:@"%@",[[[IconPlist objectForKey:@"iconLists"] objectAtIndex:i] objectAtIndex:j]]);
                    //NSLog(@"%@",[NSString stringWithFormat:@"%@",[[[[IconPlist objectForKey:@"iconLists"] objectAtIndex:i] objectAtIndex:j] class]]);
                    if([[NSString stringWithFormat:@"%@",[[[[IconPlist objectForKey:@"iconLists"] objectAtIndex:i] objectAtIndex:j] class]] compare:@"__NSCFString"] == NSOrderedSame || [[NSString stringWithFormat:@"%@",[[[[IconPlist objectForKey:@"iconLists"] objectAtIndex:i] objectAtIndex:j] class]] compare:@"__NSCFConstantString"] == NSOrderedSame){
                        NSString *appid = [NSString stringWithFormat:@"%@",[[[IconPlist objectForKey:@"iconLists"] objectAtIndex:i] objectAtIndex:j]];
                        //NSLog(@"STRING %@",appid);
                        if([idapp compare:appid] == NSOrderedSame){
                            posInSB = [NSString stringWithFormat:@"Page %i - Pos %i",i+1,j+1];
                        }
                        
                    }
                    if([[NSString stringWithFormat:@"%@",[[[[IconPlist objectForKey:@"iconLists"] objectAtIndex:i] objectAtIndex:j] class]] compare:@"__NSCFDictionary"] == NSOrderedSame){
                        NSMutableDictionary* dico = [[[NSMutableDictionary alloc] init] autorelease];
                        dico = [[[IconPlist objectForKey:@"iconLists"] objectAtIndex:i] objectAtIndex:j];
                        //NSLog(@"DICO %@",dico);
                        if([dico objectForKey:@"iconLists"]){
                            //NSLog(@"%i",[[dico objectForKey:@"iconLists"] count]);
                            //NSLog(@"%@",[dico objectForKey:@"iconLists"]);
                            for(int k=0;k<[[[dico objectForKey:@"iconLists"] objectAtIndex:0] count];k++){
                                //NSLog(@"-- %i %@",k,[[[dico objectForKey:@"iconLists"] objectAtIndex:0] objectAtIndex:k]);
                                if([[NSString stringWithFormat:@"%@",[[[[dico objectForKey:@"iconLists"] objectAtIndex:0] objectAtIndex:k] class]] compare:@"__NSCFString"] == NSOrderedSame || [[NSString stringWithFormat:@"%@",[[[[dico objectForKey:@"iconLists"] objectAtIndex:0] objectAtIndex:k] class]] compare:@"__NSCFConstantString"] == NSOrderedSame){
                                    NSString *appid = [NSString stringWithFormat:@"%@",[[[dico objectForKey:@"iconLists"] objectAtIndex:0] objectAtIndex:k]];
                                    //NSLog(@"STRING %@",appid);
                                    if([idapp compare:appid] == NSOrderedSame){
                                        posInSB = [NSString stringWithFormat:@"Page %i - FolderPos %i - Pos %i",i+1,j+1,k+1];
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if([IconPlist objectForKey:@"buttonBar"]){
            for(int i=0;i<[[IconPlist objectForKey:@"buttonBar"] count];i++){
                
                
                if([[NSString stringWithFormat:@"%@",[[[IconPlist objectForKey:@"buttonBar"] objectAtIndex:i] class]] compare:@"__NSCFString"] == NSOrderedSame || [[NSString stringWithFormat:@"%@",[[[IconPlist objectForKey:@"buttonBar"] objectAtIndex:i] class]] compare:@"__NSCFConstantString"] == NSOrderedSame){
                    NSString *appid = [NSString stringWithFormat:@"%@",[[IconPlist objectForKey:@"buttonBar"] objectAtIndex:i]];
                    if([idapp compare:appid] == NSOrderedSame){
                        posInSB = [NSString stringWithFormat:@"Dock Pos %i",i+1];
                    }
                }
                if([[NSString stringWithFormat:@"%@",[[[IconPlist objectForKey:@"buttonBar"] objectAtIndex:i] class]] compare:@"__NSCFDictionary"] == NSOrderedSame){
                    NSMutableDictionary* dico = [[[NSMutableDictionary alloc] init] autorelease];
                    dico = [[IconPlist objectForKey:@"buttonBar"] objectAtIndex:i];
                    
                    if([dico objectForKey:@"iconLists"]){
                        //NSLog(@"%i",[[dico objectForKey:@"iconLists"] count]);
                        //NSLog(@"%@",[dico objectForKey:@"iconLists"]);
                        for(int k=0;k<[[[dico objectForKey:@"iconLists"] objectAtIndex:0] count];k++){
                            //NSLog(@"-- %i %@",k,[[[dico objectForKey:@"iconLists"] objectAtIndex:0] objectAtIndex:k]);
                            if([[NSString stringWithFormat:@"%@",[[[[dico objectForKey:@"iconLists"] objectAtIndex:0] objectAtIndex:k] class]] compare:@"__NSCFString"] == NSOrderedSame || [[NSString stringWithFormat:@"%@",[[[[dico objectForKey:@"iconLists"] objectAtIndex:0] objectAtIndex:k] class]] compare:@"__NSCFConstantString"] == NSOrderedSame){
                                NSString *appid = [NSString stringWithFormat:@"%@",[[[dico objectForKey:@"iconLists"] objectAtIndex:0] objectAtIndex:k]];
                                //NSLog(@"STRING %@",appid);
                                if([idapp compare:appid] == NSOrderedSame){
                                    posInSB = [NSString stringWithFormat:@"Dock FolderPos %i - Pos %i",i+1,k+1];
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    //NSLog(@"%@",posInSB);
    return posInSB;
}

//Pour lancer l'actionsheet au clic du bouton action
- (void)exportAction:(id)sender{
	
	
	NSString *boutonOrder = @"";
	if(appBySizeDispo){

        // pas Size, pas Date --> Alpha
        if(!appBySizeSort && !appByDate){
            boutonOrder = MyLocalizedString(@"_tripoids",@"");
        }
        else{
            //Si Size
            if(appBySizeSort){
                boutonOrder = MyLocalizedString(@"_tridate",@"");
            }
            //Si Date
            else if(appByDate){
                boutonOrder = MyLocalizedString(@"_trialpha",@"");
            }
        }
	}
	else{
        if(appByDate){
            boutonOrder = MyLocalizedString(@"_trialpha",@"");
        }
        else{
            boutonOrder = MyLocalizedString(@"_tridate",@"");
        }
	}
    
    NSString *boutonSimple = [NSString stringWithFormat:@"%@ - %@",MyLocalizedString(@"_export",@""),MyLocalizedString(@"_exportsimple",@"")];
    NSString *boutonDetails = [NSString stringWithFormat:@"%@ - %@",MyLocalizedString(@"_export",@""),MyLocalizedString(@"_exportdetails",@"")];
    
    UIActionSheet *actionSheet;
    if(appBySizeDispo){
        actionSheet = [[UIActionSheet alloc] initWithTitle:MyLocalizedString(@"_action",@"") delegate:self cancelButtonTitle:nil destructiveButtonTitle:MyLocalizedString(@"_annuler",@"") otherButtonTitles:boutonOrder,boutonSimple, boutonDetails,nil];
    }
    else{
        NSString *calculTotal = MyLocalizedString(@"_calcultotal",@"");
        actionSheet = [[UIActionSheet alloc] initWithTitle:MyLocalizedString(@"_action",@"") delegate:self cancelButtonTitle:nil destructiveButtonTitle:MyLocalizedString(@"_annuler",@"") otherButtonTitles:boutonOrder,boutonSimple, boutonDetails,calculTotal, nil];
    }
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.destructiveButtonIndex = 0;
    [actionSheet showInView:self.parentViewController.tabBarController.view];
    [actionSheet release];
	
}

// Les actions de l'actionsheet (lancement du Cacul des tailles ou Modification du Tri || Export simple ou détaillé)
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	/*
	if (buttonIndex == 2) {
		NSString *log;
		if([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Library/appinfo/package.deb"] == YES){
			system("dpkg-deb -i \"/User/Library/appinfo/package.deb\" > /User/Library/appinfo/log.txt");
			log = [[NSString alloc] initWithContentsOfFile:@"/User/Library/appinfo/log.txt" encoding:NSASCIIStringEncoding error:NULL];
		}
		else {
			log = @"Pas de fichiers Deb";
		}
	
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Console" message:log delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	*/
	
	if (buttonIndex == 1) {
		
		if(appBySizeDispo){
			
            // pas Size, pas Date --> Alpha
            if(!appBySizeSort && !appByDate){
                appBySizeSort = YES;
            }
            else{
                //Si Size
                if(appBySizeSort){
                    appBySizeSort = NO;
                    appByDate = YES;
                }
                //Si Date
                else if(appByDate){
                    appBySizeSort = NO;
                    appByDate = NO;
                }
            }
  
		}
        else{
            if(appByDate){
                appByDate = NO;
            }
            else{
                appByDate = YES;
            }
        
        }
        [appsTableView reloadData];
        
        
	}
	else if(buttonIndex == 2 || buttonIndex == 3){
		


		
        NSArray *nomAppAlpha;
        if (appBySizeDispo && appBySizeSort) {
            nomAppAlpha = [appBySize copy];
            //value = [dicoApp objectForKey:[appBySize objectAtIndex:indexPath.row]];
            //secondLabel = [NSString stringWithFormat:@"%@ : %@%@", MyLocalizedString(@"_version", @""), [value objectForKey: @"version"], [value objectForKey:@"sizeDisplay"]];
        }
        else if(appByDate){
            NSMutableArray *sortdate = [[NSMutableArray alloc] init];;
            for(id app in appByDateArray)[sortdate addObject:[app objectForKey:@"key"]];
            nomAppAlpha = [sortdate copy];
            [sortdate release];
        }
        else{
            nomAppAlpha = [[dicoApp allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        }

        
        NSString *exportContent = @"";
		NSString *exportContents = @"";
		NSMutableArray *arrayFull = [[NSMutableArray alloc] init];
        
        
        
		for(id app in nomAppAlpha){		
			
			NSString *nomApp = [[dicoApp objectForKey:app] objectForKey:@"nom"];
			NSString *versionApp = [[dicoApp objectForKey:app] objectForKey:@"version"];
			NSString *idApp = [[dicoApp objectForKey:app] objectForKey:@"identifiant"];
			NSString *dossierApp = [[dicoApp objectForKey:app] objectForKey:@"dossier"];
			NSString *bundleApp = [[dicoApp objectForKey:app] objectForKey:@"bundle"];
			NSString *tailleApplication = [[dicoApp objectForKey:app] objectForKey: @"sizeDisplay"];
            NSString *dateApplication = [[dicoApp objectForKey:app] objectForKey: @"date"];
			
			if (buttonIndex == 2) {
                if (appBySizeDispo && appBySizeSort) {
                    exportContent = [exportContent stringByAppendingString:[NSString stringWithFormat:@"<strong>%@</strong> - %@<i>%@</i><br />\n",nomApp,versionApp, tailleApplication]];
                }
                else if(appByDate){
                    NSString *madate = [self stringFromDateIsoString:dateApplication withFormat:self.datetimeFormat];
                    if([madate compare:@"(null)"] == NSOrderedSame) madate = MyLocalizedString(@"_inconnu", @"");
                    exportContent = [exportContent stringByAppendingString:[NSString stringWithFormat:@"<strong>%@</strong> - %@ <i>%@</i><br />\n",nomApp,versionApp,madate]];
                }
                else{
                    exportContent = [exportContent stringByAppendingString:[NSString stringWithFormat:@"<strong>%@</strong> - %@<br />\n",nomApp,versionApp]];
                }
			} 
			else if (buttonIndex == 3) {
				
				NSString *exportContentFull = @"";
				
				/*
				NSString *imageApplication = @"";
				
				NSString *imageSauve = [NSString stringWithFormat:@"%@", [[dicoApp objectForKey:app] objectForKey: @"image"]];
				if([[NSFileManager defaultManager] fileExistsAtPath:imageSauve] == YES){
					
					imageApplication = imageSauve;
				}
				else{
					NSString *imageTest = [NSString stringWithFormat:@"%@.png", imageSauve];
					if([[NSFileManager defaultManager] fileExistsAtPath:imageTest] == YES){
						imageApplication = imageTest;
					}
					else{
						NSString *imageReTest = [NSString stringWithFormat:@"/User/Applications/%@/%@/icon.png",  [NSString stringWithFormat:@"%@", [[dicoApp objectForKey:app] objectForKey: @"dossier"]] ,  [NSString stringWithFormat:@"%@", [[dicoApp objectForKey:app] objectForKey: @"bundle"]] ];
						if([[NSFileManager defaultManager] fileExistsAtPath:imageReTest] == YES){
							imageApplication = imageReTest;
						}
						else{
							NSString *path = [[NSBundle mainBundle] bundlePath];
							imageApplication = [NSString stringWithFormat:@"%@/apple.png",path];
						}
					}
					
				}
				
				
				exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<h3 style=\"margin-bottom:0px;font-size:16px;\">%@</h3>\n<ul style=\"margin-top:0px;font-size:7px;\">%@<img src=\"/%@\" />\n",nomApp,imageApplication,imageApplication]];
				*/
				exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<h3 style=\"margin-bottom:0px;font-size:16px;\">%@</h3>\n<ul style=\"margin-top:0px;font-size:7px;\">\n",nomApp]];
				
				exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>%@ : </strong>%@</li>\n",MyLocalizedString(@"_version",@""),versionApp]];
				exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>%@ : </strong>%@</li>\n",MyLocalizedString(@"_identifiant",@""),idApp]];
				exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>%@ : </strong>%@</li>\n",MyLocalizedString(@"_dossier",@""),dossierApp]];
				exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>%@ : </strong>%@</li>\n",MyLocalizedString(@"_bundle",@""),bundleApp]];
				
				
				NSString *affSize = @"";
				if([tailleApplication compare:@""] != NSOrderedSame){
					NSMutableString *keyApp = [[NSMutableString alloc] initWithString:tailleApplication];
					[keyApp replaceOccurrencesOfString:@" - " withString:[NSString stringWithFormat:@"<b>%@ :</b> ",MyLocalizedString(@"_poids",@"")] options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
					affSize = [NSString stringWithFormat:@"<li>%@</li>\n",keyApp];
					[keyApp release];
					
				}
				if([affSize compare:@""] != NSOrderedSame){
					exportContentFull = [exportContentFull stringByAppendingString:affSize];
				}
				
				NSString *donneess = [[dicoAppiTunes objectForKey:app]  objectForKey: @"donnees"];
				if([donneess compare:@"1"] == NSOrderedSame){
					
					if([[dicoAppiTunes objectForKey:app] objectForKey:@"itemName"]){
						exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>%@ : </strong>%@</li>\n",MyLocalizedString(@"_nom",@""),  [[dicoAppiTunes objectForKey:app] objectForKey:@"itemName"] ]];
					}
					
					if([[dicoAppiTunes objectForKey:app] objectForKey:@"artistName"]){
						exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>%@ : </strong>%@</li>\n",MyLocalizedString(@"_auteur",@""),  [[dicoAppiTunes objectForKey:app] objectForKey:@"artistName"] ]];
					}
					
					if([[dicoAppiTunes objectForKey:app] objectForKey:@"genre"]){
						exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>%@ : </strong>%@</li>\n",MyLocalizedString(@"_genre",@""), [[dicoAppiTunes objectForKey:app] objectForKey:@"genre"] ]];
					}
					
					if([[dicoAppiTunes objectForKey:app] objectForKey:@"copyright"]){
						exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>%@ : </strong>%@</li>\n",MyLocalizedString(@"_copyright",@""), [[dicoAppiTunes objectForKey:app] objectForKey:@"copyright"] ]];
					}
					
					//if([[dicoAppiTunes objectForKey:app] objectForKey:@"priceDisplay"]){
					//	exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>%@ : </strong>%@</li>\n",MyLocalizedString(@"_prix",@""),  [[dicoAppiTunes objectForKey:app] objectForKey:@"priceDisplay"] ]];
					//}
					
					if([[dicoAppiTunes objectForKey:app] objectForKey:@"bundleVersion"]){
						exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>%@ : </strong>%@</li>\n",MyLocalizedString(@"_bundleversion",@""),  [[dicoAppiTunes objectForKey:app] objectForKey:@"bundleVersion"] ]];
					}
					
					if([[dicoAppiTunes objectForKey:app] objectForKey:@"appleId"]){
						exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>%@ : </strong>%@</li>\n",MyLocalizedString(@"_appleid",@""), [[dicoAppiTunes objectForKey:app] objectForKey:@"appleId"] ]];
					}
					if([[dicoAppiTunes objectForKey:app] objectForKey:@"purchaseDate"]){
                        NSString *madate = [self stringFromDateIsoString:[NSString stringWithFormat:@"%@",[[dicoAppiTunes objectForKey:app] objectForKey:@"purchaseDate"]] withFormat:self.datetimeFormat];
                        if([madate compare:@"(null)"] == NSOrderedSame) madate = MyLocalizedString(@"_inconnu", @"");
						exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>%@ : </strong>%@</li>\n",MyLocalizedString(@"_dateachat",@""), madate]];
					}
					
					if([[dicoAppiTunes objectForKey:app] objectForKey:@"artistID"]){
						exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>%@ : </strong>%@</li>\n",MyLocalizedString(@"_artistid",@""),  [[dicoAppiTunes objectForKey:app] objectForKey:@"artistID"] ]];
					}
					
					if([[dicoAppiTunes objectForKey:app] objectForKey:@"genreId"]){
						exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>%@ : </strong>%@</li>\n",MyLocalizedString(@"_genreid",@""), [[dicoAppiTunes objectForKey:app] objectForKey:@"genreId"] ]];
					}
					
					if([[dicoAppiTunes objectForKey:app] objectForKey:@"itemId"]){
						exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><a href=\"http://itunes.apple.com/app/app/id%@?mt=8\">%@</a></li>\n",  [[dicoAppiTunes objectForKey:app] objectForKey:@"itemId"],  MyLocalizedString(@"_ouvrirappstore",@"") ]];
						
					}
					
				}
				
				
				exportContentFull = [exportContentFull stringByAppendingString:@"</ul><hr />\n"];
				[arrayFull addObject:exportContentFull];
				
			}
			
		}
		
		
		for(id value in arrayFull){
			exportContents = [exportContents stringByAppendingString:value];
		}
		[arrayFull release];
		
		
		
		if (buttonIndex == 2) {		
			[self  pushEmail:(self.emailUser) andSubject:[NSString stringWithFormat:MyLocalizedString(@"_exportmailsimple",@""),MyLocalizedString(@"_appstore",@"")] andBody:[NSString stringWithFormat:@"%@", exportContent]];
		} else if (buttonIndex == 3) {
			[self  pushEmail:(self.emailUser) andSubject:[NSString stringWithFormat:MyLocalizedString(@"_exportmaildetails",@""),MyLocalizedString(@"_appstore",@"")] andBody:[NSString stringWithFormat:@"%@", exportContents]];
		}
	}
    else if(buttonIndex == 4){
        if(!appBySizeDispo){
            [NSThread detachNewThreadSelector:@selector(startTheBackgroundJob) toTarget:self withObject:nil];
            UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] init];
            exportButton.title = @"0 %";
            self.navigationItem.leftBarButtonItem = exportButton;
            [exportButton setTarget:self];
            //[exportButton setAction:@selector(exportAction:)];
            [exportButton release];
        }
    }
	
	
}

/*
- (void)testExec {  
	
   NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
	//obj_getClass("SBApplicationController");
	
	//%class SBApplicationController;
	//SBApplication* app = [[$SBApplicationController sharedInstance] applicationWithDisplayIdentifier:@"com.apple.weather"];
	//system("dpkg-deb -b /User/Documents/Miles/appinfo");
//SBApplication *theTargetApp = [SBApplication applicationWithBundleIdentifier:"com.apple.weather"]; 
	//%c(SBApplicationController);
	//SBApplication* app = [[%c(SBApplicationController) sharedInstance] applicationWithDisplayIdentifier:@"com.apple.weather"];
	//SBApplication* app = [[SBApplicationController sharedInstance] applicationWithDisplayIdentifier:@"com.apple.weather"];
	//[SBApplication applicationWithBundleIdentifier:"com.apple.weather"];
	//system("/Applications/Calculator.app/Calculator");
	
	// Get the desired SBApplication object
	//Class $SBApplicationController { objc_getClass("SBApplicationController") };

	NSMutableArray *displayStacks = nil;
	
	// Display stack names
	#define SBWPreActivateDisplayStack        [displayStacks objectAtIndex:0]
	#define SBWActiveDisplayStack             [displayStacks objectAtIndex:1]
	
	SBApplicationController *appCont = [SBApplicationController sharedInstance];
    SBApplication *app = [appCont applicationWithDisplayIdentifier:@"com.apple.weather"];
	
    // Enable the "animated" flag
    [app setActivationSetting:0x4 flag:YES];
	
    // Push the application onto the PreActivate stack
    [[displayStacks objectAtIndex:1] pushDisplay:app];
	
	 
	 
	[pool release];
	
}
*/


//Calcul de toutes les tailles
- (void)startTheBackgroundJob {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];  
	
    // wait for 3 seconds  
    //[NSThread sleepForTimeInterval:3];
	
    //[self performSelectorOnMainThread:@selector(calculatingAllSize) withObject:nil waitUntilDone:NO];  
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES; 
	NSNumber *totalAllSize = 0;
	int cpt = 0;
	int test = (unsigned int)[dicoApp count];
	NSArray *dicoAllKey = [dicoApp allKeys];
	NSMutableArray *arrayGlobal = [[NSMutableArray alloc] init];
	
	for(id values in dicoAllKey){
		id value = [dicoApp objectForKey:values];
        
		NSString *dossierApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"dossier"]];
		NSString *pathBundle = [NSString stringWithFormat:@"%@/%@",documentsDir,dossierApplication];
		
		NSArray *subPath = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:pathBundle error:nil];
		NSString *contentPath;
		NSDictionary *attributes;
		NSNumber *fileSize;
		NSNumber *totalSize = 0;
        NSNumber *sizeDocuments = [NSNumber numberWithInt:0];
        NSNumber *sizeLibrary = [NSNumber numberWithInt:0];
        NSNumber *sizeBundle = [NSNumber numberWithInt:0];
        NSNumber *sizeAutres = [NSNumber numberWithInt:0];
		
        NSString *nomAppiX = [NSString stringWithFormat:@"%@",values];
        NSString *testAlreadyCheck = [NSString stringWithFormat:@"%@",[[self.dicoApp objectForKey:nomAppiX] objectForKey:@"size"]];
        if([testAlreadyCheck compare:@"0"] == NSOrderedSame){
            for(contentPath in subPath){
                
                attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[pathBundle stringByAppendingPathComponent:contentPath] error:nil];
                
                if([attributes objectForKey:NSFileSize]){
                    fileSize = [attributes objectForKey:NSFileSize];
                }
                else{
                    fileSize = 0;
                }
                
                totalSize = [NSNumber numberWithFloat:([totalSize floatValue] + [fileSize floatValue])];
            }

        }
        else{
            totalSize = [[self.dicoApp objectForKey:nomAppiX] objectForKey:@"size"];
            sizeDocuments = [[self.dicoApp objectForKey:nomAppiX] objectForKey:@"sizeDocuments"];
            sizeLibrary = [[self.dicoApp objectForKey:nomAppiX] objectForKey:@"sizeLibrary"];
            sizeBundle = [[self.dicoApp objectForKey:nomAppiX] objectForKey:@"sizeBundle"];
            sizeAutres = [[self.dicoApp objectForKey:nomAppiX] objectForKey:@"sizeAutres"];
        }
        
				
		totalAllSize = [NSNumber numberWithFloat:([totalAllSize floatValue] + [totalSize floatValue])];
		
		
		int perc = ceil(cpt*100/test);
		NSString *pourcent = [NSString stringWithFormat:@"%i %%",perc];
		[self performSelectorOnMainThread:@selector(pourcentage:) withObject:pourcent waitUntilDone:NO];

		NSMutableArray *ajoutSize = [[NSMutableArray alloc]init];
		NSString *keyDico = [NSString stringWithFormat:@"%@", values];
		[ajoutSize addObject:keyDico];
		[ajoutSize addObject:totalSize];
        [ajoutSize addObject:sizeBundle];
        [ajoutSize addObject:sizeDocuments];
        [ajoutSize addObject:sizeLibrary];
        [ajoutSize addObject:sizeAutres];
		
		//[self performSelectorOnMainThread:@selector(ajoutSizeDico:) withObject:ajoutSize waitUntilDone:NO];
		[arrayGlobal addObject:ajoutSize];
		
		[ajoutSize release];
		ajoutSize = nil;
		attributes = nil;
		subPath = nil;
		value = nil;
		
		cpt++;
		
		
	}
	
	
	for(id value in arrayGlobal){
		[self performSelectorOnMainThread:@selector(ajoutSizeDico:) withObject:value waitUntilDone:NO];
	}
	[arrayGlobal release];

	

	[self performSelectorOnMainThread:@selector(pourcentage:) withObject:@"AppInfoFin" waitUntilDone:NO];
	
	float bytes = 1024;
	float bytesM = 1048576;
	float bytesG = 1073741824;

	NSNumber *kilobytes = [NSNumber numberWithFloat:([totalAllSize floatValue] / bytes)];
	NSNumber *megabytes = [NSNumber numberWithFloat:([totalAllSize floatValue] / bytesM)];
	NSNumber *gigabytes = [NSNumber numberWithFloat:([totalAllSize floatValue] / bytesG)];
	
	
	NSString *totalApplic = [NSString stringWithFormat:@"%i %@", (unsigned int)[dicoApp count],MyLocalizedString(@"_applications",@"")];
	NSString *tailleApp = [NSString stringWithFormat:@"%@\n", totalApplic];
	
	
	if([kilobytes intValue] > 1048576){
		tailleApp = [tailleApp stringByAppendingString:[NSString stringWithFormat:@"%.2f G%@", [gigabytes floatValue],self.unitUser]];
	}
	else if([kilobytes intValue] > 1024){
		tailleApp = [tailleApp stringByAppendingString:[NSString stringWithFormat:@"%.2f M%@", [megabytes floatValue],self.unitUser]];
	}
	else{
		tailleApp = [tailleApp stringByAppendingString:[NSString stringWithFormat:@"%i K%@", [kilobytes intValue],self.unitUser]];
	}
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:MyLocalizedString(@"_toutetaille",@"") message:tailleApp delegate:nil cancelButtonTitle:MyLocalizedString(@"_fermer",@"") otherButtonTitles:nil];
	//[alert show];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
	[alert release];
	
	[self performSelectorOnMainThread:@selector(finiTaff) withObject:nil waitUntilDone:NO];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	dicoAllKey = nil;
	[pool release];
}

// Rafrachissement et enregistrement après le Calcul de toutes les tailles
- (void)finiTaff {
	NSArray *nomApp = [self.dicoApp allKeys];
	NSMutableArray *sizeArray = [[NSMutableArray alloc] init];
	NSMutableArray *nameSizeArray = [[NSMutableArray alloc] init];
	
	for(id value in nomApp){
		NSNumber *sizeBytes = [[self.dicoApp objectForKey:value] objectForKey:@"size"];
		[sizeArray addObject:sizeBytes];
	}
	
	// Bug sur iPod 3.1.3 (spirit)
	//NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey:@"floatValue" ascending:NO];
	//NSArray *nomAppSize = [sizeArray sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]];
	
	NSSortDescriptor *mySorter = [[NSSortDescriptor alloc] initWithKey:@"floatValue" ascending:NO];
	NSMutableArray *nomAppSize = sizeArray;
	[nomAppSize sortUsingDescriptors:[NSArray arrayWithObject:mySorter]];

	for(id values in nomAppSize){
		NSNumber *valeurActu = values;
		for(id value in nomApp){
			NSNumber *sizeBytes = [[self.dicoApp objectForKey:value] objectForKey:@"size"];
			if([sizeBytes compare:valeurActu]== NSOrderedSame){
				[nameSizeArray addObject:value];
				break;
			}
		}
	}
	
	//nameSizeArray contient les keyApp par ordre de taille
	/*
	UIAlertView *alerti = [[UIAlertView alloc] initWithTitle:@"Apps by size" message:[NSString stringWithFormat:@"%@", nameSizeArray] delegate:self cancelButtonTitle:MyLocalizedString(@"_fermer",@"") otherButtonTitles:nil];
	[alerti show];
	[alerti release];
	*/
	
	//MILES
	appBySize = nameSizeArray;
	appBySizeDispo = YES;
	appBySizeSort = NO;
	
	
	[sizeArray release];
	[mySorter release];
	//[nameSizeArray release];
	[appsTableView reloadData];
	
}

// Fundtion pour ajouter la taille de l'appli dans le Dictionary dicoApp
- (void)ajoutSizeDico:(NSMutableArray *)ajoutSize {
    
	NSString *appName = [ajoutSize objectAtIndex:0];
	NSNumber *sizeApp = [ajoutSize objectAtIndex:1];
    NSNumber *sizeBundle = [ajoutSize objectAtIndex:2];
    NSNumber *sizeDocuments = [ajoutSize objectAtIndex:3];
    NSNumber *sizeLibrary = [ajoutSize objectAtIndex:4];
    NSNumber *sizeAutres = [ajoutSize objectAtIndex:5];
	
	 float bytes = 1024;
	 float bytesM = 1048576;
	 float bytesG = 1073741824;
	 
	 NSString *tailleApp = @"";
	 
	 NSNumber *kilobytes = [NSNumber numberWithFloat:([sizeApp floatValue] / bytes)];
	 NSNumber *megabytes = [NSNumber numberWithFloat:([sizeApp floatValue] / bytesM)];
	 NSNumber *gigabytes = [NSNumber numberWithFloat:([sizeApp floatValue] / bytesG)];
	 
	 
	 if([kilobytes intValue] > 1048576){
	 tailleApp = [NSString stringWithFormat:@" - %.2f G%@", [gigabytes floatValue],self.unitUser];
	 }
	 else if([kilobytes intValue] > 1024){
	 tailleApp = [NSString stringWithFormat:@" - %.2f M%@", [megabytes floatValue],self.unitUser];
	 }
	 else{
	 tailleApp = [NSString stringWithFormat:@" - %i K%@", [kilobytes intValue],self.unitUser];
	 }

	
	
	[[self.dicoApp objectForKey:appName] setValue:sizeApp forKey:@"size"];
    [[self.dicoApp objectForKey:appName] setValue:sizeBundle forKey:@"sizeBundle"];
    [[self.dicoApp objectForKey:appName] setValue:sizeDocuments forKey:@"sizeDocuments"];
    [[self.dicoApp objectForKey:appName] setValue:sizeLibrary forKey:@"sizeLibrary"];
    [[self.dicoApp objectForKey:appName] setValue:sizeAutres forKey:@"sizeAutres"];
	[[self.dicoApp objectForKey:appName] setValue:tailleApp forKey:@"sizeDisplay"];
	[appsTableView reloadData];
		
}

//Function pour mettre à jour le pourcentage pendant le Calcul de toutes les tailles appelé dans startTheBackgroundJob
- (void) pourcentage:(NSString *)pourcentActu {
	
	if([pourcentActu compare:@"AppInfoFin"] != NSOrderedSame){
	UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] init];
	exportButton.title = pourcentActu;
	self.navigationItem.leftBarButtonItem = exportButton;
	[exportButton setTarget:self];
	//[exportButton setAction:@selector(exportAction:)];
	[exportButton release];
	}
	else {
		self.navigationItem.leftBarButtonItem = nil;
	}

}

- (NSString *)stringFromDateIsoString:(NSString *)dateString withFormat:(NSString *)formater{
    if ([dateString hasSuffix:@"Z"]) {
        dateString = [[dateString substringToIndex:(dateString.length-1)] stringByAppendingString:@"-0000"];
    }
    dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HHmmssZ";
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSDateFormatter *anotherDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [anotherDateFormatter setDateFormat:formater];
    //[anotherDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *retour = [NSString stringWithFormat:@"%@",[anotherDateFormatter stringFromDate:date]];
    return retour;
}

-(NSString *)stringFromDateIsoString2:(NSString *)dateString withFormat:(NSString *)formater{
    if ([dateString hasSuffix:@"Z"]) {
        dateString = [[dateString substringToIndex:(dateString.length-1)] stringByAppendingString:@"-0000"];
    }
    dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.dateFormat = @"yyyy-MM-dd' 'HHmmssZ";
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSDateFormatter *anotherDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [anotherDateFormatter setDateFormat:formater];
    //[anotherDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *retour = [NSString stringWithFormat:@"%@",[anotherDateFormatter stringFromDate:date]];
    return retour;
}


// Au clic de l'export dans le détail d'une application
- (void)exportActionApp:(id)sender {
	
	
	NSIndexPath *indexPath = [appsTableView indexPathForSelectedRow];
	
	//NSArray *nomApp = [dicoApp allKeys];
	//NSArray *nomAppAlpha = [nomApp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	//id value = [dicoApp objectForKey:[nomAppAlpha objectAtIndex:[sender tag]]];
	id value;
	if (appBySizeDispo && appBySizeSort) {
		value = [dicoApp objectForKey:[appBySize objectAtIndex:indexPath.row]];
	}
    else if(appByDate){
        value = [dicoApp objectForKey:[[appByDateArray objectAtIndex:indexPath.row] objectForKey:@"key"]];
    }
	else{
	 value = [dicoApp objectForKey:[[objectsForCharacters objectForKey:[arrayOfCharacters objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]];
	}
	
	NSString *nomApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"nom"]];
	NSString *versionApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"version"]];
	NSString *dossierApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"dossier"]];
	NSString *bundleApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"bundle"]];
	NSString *identifiantApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"identifiant"]];
	NSString *minosApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"minos"]];
	NSString *iconApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"icon"]];
	NSString *tailleApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"sizeDisplay"]];
	
	
	
	
	NSString *iconsApplication = @""; // = [NSString stringWithFormat:@"%@", [value objectForKey: @"icons"]];
	NSArray *arrayIcon = [value objectForKey: @"icons"];
	if([arrayIcon count]){
		int cpt = 1;
		for(id value in arrayIcon){
			iconsApplication = [iconsApplication stringByAppendingString:[NSString stringWithFormat:@"%@", value]];
			
			if(cpt != [arrayIcon count]){
				iconsApplication = [iconsApplication stringByAppendingString:[NSString stringWithFormat:@" | "]];
			}
			cpt++;
		}
	}
	if([iconsApplication compare:@""] == NSOrderedSame){
		iconsApplication = MyLocalizedString(@"_inconnu",@"");
	}
	
    /*
	NSString *imageApplication = @"";
	
	NSString *imageSauve = [NSString stringWithFormat:@"%@", [value objectForKey: @"image"]];
	if([[NSFileManager defaultManager] fileExistsAtPath:imageSauve] == YES){
		
		imageApplication = imageSauve;
	}
	else{
		NSString *imageTest = [NSString stringWithFormat:@"%@.png", imageSauve];
		if([[NSFileManager defaultManager] fileExistsAtPath:imageTest] == YES){
			imageApplication = imageTest;
		}
		else{
			NSString *imageReTest = [NSString stringWithFormat:@"%@/%@/%@/icon.png", documentsDir, [NSString stringWithFormat:@"%@", [value objectForKey: @"dossier"]] ,  [NSString stringWithFormat:@"%@", [value objectForKey: @"bundle"]] ];
			if([[NSFileManager defaultManager] fileExistsAtPath:imageReTest] == YES){
				imageApplication = imageReTest;
			}
			else{
				NSString *path = [[NSBundle mainBundle] bundlePath];
				imageApplication = [NSString stringWithFormat:@"%@/apple.png",path];
			}
		}
		
	}
	*/
	
	//NSArray *nomAppitunes = [dicoAppiTunes allKeys];
	//NSArray *nomAppAlphaitunes = [nomAppitunes sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	//id valueitunes = [dicoAppiTunes objectForKey:[nomAppAlphaitunes objectAtIndex:[sender tag]]];
	id valueitunes;
	if (appBySizeDispo && appBySizeSort) {
		valueitunes = [dicoAppiTunes objectForKey:[appBySize objectAtIndex:indexPath.row]];
	}
    else if(appByDate){
        valueitunes = [dicoAppiTunes objectForKey:[[appByDateArray objectAtIndex:indexPath.row] objectForKey:@"key"]];
    }
	else{
		valueitunes = [dicoAppiTunes objectForKey:[[objectsForCharacters objectForKey:[arrayOfCharacters objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]];
	}
	
	NSString *donnees = [valueitunes objectForKey: @"donnees"];
	NSString *itunesMetadataFile = @"";
	NSString *cheminAppstore = @"";
	if([donnees compare:@"1"] == NSOrderedSame){
        NSString *madate = [self stringFromDateIsoString:[NSString stringWithFormat:@"%@",[valueitunes objectForKey:@"purchaseDate"]] withFormat:self.datetimeFormat];
        if([madate compare:@"(null)"] == NSOrderedSame) madate = MyLocalizedString(@"_inconnu", @"");
		//artistId bundleVersion copyright genre genreIf itemId priceDisplay
		itunesMetadataFile = [NSString stringWithFormat:@"%@<b>%@ :</b> %@<br />",itunesMetadataFile,MyLocalizedString(@"_nom", @""),[valueitunes objectForKey:@"itemName"]];
		itunesMetadataFile = [NSString stringWithFormat:@"%@<b>%@ :</b> %@<br />",itunesMetadataFile,MyLocalizedString(@"_auteur", @""),[valueitunes objectForKey:@"artistName"]];
		itunesMetadataFile = [NSString stringWithFormat:@"%@<b>%@ :</b> %@<br />",itunesMetadataFile,MyLocalizedString(@"_genre", @""),[valueitunes objectForKey:@"genre"]];
		itunesMetadataFile = [NSString stringWithFormat:@"%@<b>%@ :</b> %@<br />",itunesMetadataFile,MyLocalizedString(@"_copyright", @""),[valueitunes objectForKey:@"copyright"]];
		//itunesMetadataFile = [NSString stringWithFormat:@"%@<b>%@ :</b> %@<br />",itunesMetadataFile,MyLocalizedString(@"_prix", @""),[valueitunes objectForKey:@"priceDisplay"]];
		itunesMetadataFile = [NSString stringWithFormat:@"%@<b>%@ :</b> %@<br />",itunesMetadataFile,MyLocalizedString(@"_itunesid", @""),[valueitunes objectForKey:@"AppleID"]];
		itunesMetadataFile = [NSString stringWithFormat:@"%@<b>%@ :</b> %@<br />",itunesMetadataFile,MyLocalizedString(@"_dateachat", @""),madate];
		itunesMetadataFile = [NSString stringWithFormat:@"%@<b>%@ :</b> %@<br />",itunesMetadataFile,MyLocalizedString(@"_artistid", @""),[valueitunes objectForKey:@"artistId"]];
		itunesMetadataFile = [NSString stringWithFormat:@"%@<b>%@ :</b> %@<br />",itunesMetadataFile,MyLocalizedString(@"_genreid", @""),[valueitunes objectForKey:@"genreId"]];
		itunesMetadataFile = [NSString stringWithFormat:@"%@<b>%@ :</b> %@<br />",itunesMetadataFile,MyLocalizedString(@"_itemid", @""),[valueitunes objectForKey:@"itemId"]];
		itunesMetadataFile = [NSString stringWithFormat:@"%@<b>%@ :</b> %@<br />",itunesMetadataFile,MyLocalizedString(@"_bundleversion", @""),[valueitunes objectForKey:@"bundleVersion"]];
		cheminAppstore = [NSString stringWithFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"http://itunes.apple.com/app/application/id%@?mt=8\"><img src=\"appstore.png\" style=\"float:left;margin:0 5px\" width=\"25\" />%@</a></li>",[valueitunes objectForKey:@"itemId"],MyLocalizedString(@"_ouvrirappstore", @"")];
		
	}
	else{
		itunesMetadataFile = MyLocalizedString(@"_pasdefichiersitunes", @"");
	}

	
	
	NSString *affSize = @"";
	if([tailleApplication compare:@""] != NSOrderedSame){
		NSMutableString *keyApp = [[NSMutableString alloc] initWithString:tailleApplication];
		[keyApp replaceOccurrencesOfString:@" - " withString:[NSString stringWithFormat:@"<b>%@ :</b> ",MyLocalizedString(@"_poids",@"")] options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
		affSize = [NSString stringWithFormat:@"%@<br />",keyApp];
		[keyApp release];
		
	}

		
	NSString *bundleInfo = [NSString stringWithFormat:@"<b>%@ :</b> %@<br /><b>%@ :</b> %@<br /><b>%@ :</b> %@<br /><b>%@ :</b> %@<br /><b>%@ :</b> %@<br /><b>IconFile :</b> %@<br /><b>IconFiles :</b> %@<br />%@", MyLocalizedString(@"_version",@""), versionApplication,MyLocalizedString(@"_dossier",@""), dossierApplication,MyLocalizedString(@"_bundle",@""), bundleApplication,MyLocalizedString(@"_identifiant",@""), identifiantApplication, MyLocalizedString(@"_minos",@""), minosApplication,iconApplication, iconsApplication,affSize];
	
	NSString *myHTML = [NSString stringWithFormat:@"<h1>%@</h1><p>%@</p><p>%@</p>",nomApplication,bundleInfo,itunesMetadataFile];
	
	
	
	[self  pushEmail:(self.emailUser) andSubject:[NSString stringWithFormat:@"%@ - AppInfo",nomApplication] andBody:myHTML];	
}

#pragma mark -
#pragma mark Function Email

// Fonction pour ouvrir une popup Mail
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
		[mail addAttachmentData:fileAttach mimeType:@"application/octet-stream" fileName:sujetMail];
		//[self presentModalViewController:mail animated:YES];
        [self presentViewController:mail animated:YES completion:nil];
		
	}
	
	[mail release];
    
}

// Fonction à l'envoi via la popup Mail
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

- (void)dealloc {
    [dateFormat release];
    [datetimeFormat release];
    [aWebView release];
    [appByDateArray release];
	[appBySize release];
	[arrayOfCharacters release];
	[objectsForCharacters release];
	[emailUser release];
	[unitUser release];
	[appsTableView release];
	[appDetailViewController release];
	[dicoApp release];
	[aWebView release];
	[dicoAppiTunes release];
	[documentsDir release];
    [super dealloc];
}


@end

