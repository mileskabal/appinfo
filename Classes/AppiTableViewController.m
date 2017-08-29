//
//  AppleTableViewController.m
//  appinfo
//
//  Created by Miles on 14/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "appinfoAppDelegate.h"
#import "AppiTableViewController.h"
#import "AppDetailViewController.h"
#import "CustomCell.h"

@implementation AppiTableViewController


@synthesize documentsDir;
@synthesize dicoApp;
@synthesize appDetailViewController;
@synthesize emailUser;
@synthesize unitUser;
@synthesize aWebView;
@synthesize appiTableView;

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 if (self = [super initWithStyle:style]) {
 }
 return self;
 }
 */


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
	
	self.navigationItem.title = @"Cydia";
	
	UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] init];
	exportButton.title = MyLocalizedString(@"_export",@"");
	self.navigationItem.rightBarButtonItem = exportButton;
	[exportButton setTarget:self];
	[exportButton setAction:@selector(exportAction:)];
	[exportButton release]; 
	
	NSArray *files;
	NSString *file;
	dicoApp = [[NSMutableDictionary alloc] init];
	
	
	documentsDir = delegate.pathAppSystem;
	
	files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDir error:nil];
	for(file in files){
		NSString *infoPlistPath = [NSString stringWithFormat:@"%@/%@/Info.plist", documentsDir,file];
		
		if([[NSFileManager defaultManager] fileExistsAtPath:infoPlistPath] == YES){			
			
			NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:infoPlistPath];
			
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
						CFBundleDisplayName = file;
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
			if([plistDict objectForKey:@"CFBundleIconFile"]){
				CFBundleIconFile = [plistDict objectForKey:@"CFBundleIconFile"];
			}
			else{
				if([plistDict objectForKey:@"CFBundleIconFiles"]){
					
					NSString *classIcons = [[[plistDict objectForKey:@"CFBundleIconFiles"] class] description];
					if([classIcons compare:@"__NSCFArray"] == NSOrderedSame){
						NSArray *arrayIcon = [plistDict objectForKey:@"CFBundleIconFiles"];
						if([arrayIcon count]){
							CFBundleIconFile = [arrayIcon objectAtIndex:0];
						}
					}
					else if([classIcons compare:@"NSCFString"] == NSOrderedSame){
						CFBundleIconFile = [plistDict objectForKey:@"CFBundleIconFiles"];
					}
					else{
						CFBundleIconFile = @"Icon.png";
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
			
			
			NSString *imageText = [NSString stringWithFormat:@"%@/%@/%@",documentsDir,file,CFBundleIconFile];
			
			NSMutableDictionary *app = [[NSMutableDictionary alloc] init];
			[app setObject:CFBundleIconFile forKey:@"icon"];
			[app setObject:CFBundleDisplayName forKey:@"nom"];
			[app setObject:CFBundleVersion forKey:@"version"];
			[app setObject:CFBundleIdentifier forKey:@"identifiant"];
			[app setObject:file forKey:@"dossier"];
			[app setObject:MinimumOSVersion forKey:@"minos"];
			[app setObject:imageText forKey:@"image"];
			
			if(![CFBundleIdentifier hasPrefix:@"com.apple"]){
				[dicoApp setObject:app forKey:[NSString stringWithFormat:@"%@",CFBundleDisplayName]];
			}
			
		}
		
	}
	
	[super viewDidLoad];
	
}


- (void)viewWillAppear:(BOOL)animated {
    [appiTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [appiTableView reloadData];
}
- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [appiTableView reloadData];
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

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dicoApp count];
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
	NSArray *nomApp = [dicoApp allKeys];
	NSArray *nomAppAlpha = [nomApp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	value = [dicoApp objectForKey:[nomAppAlpha objectAtIndex:indexPath.row]];
	
	
	cell.primaryLabel.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"nom"]];	
	cell.secondaryLabel.text = [NSString stringWithFormat:@"%@ : %@", MyLocalizedString(@"_version", @""), [value objectForKey: @"version"]];	 
	
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
			NSString *imageReTest = [NSString stringWithFormat:@"%@/%@/icon.png", documentsDir, [NSString stringWithFormat:@"%@", [value objectForKey: @"dossier"]]];
			if([[NSFileManager defaultManager] fileExistsAtPath:imageReTest] == YES){
				NSData *data = [NSData dataWithContentsOfFile:imageReTest];
				image = [[UIImage alloc] initWithData:data];
				cell.myImageView.image = image;
			}
			else{
				NSString *imageTT = [NSString stringWithFormat:@"%@/%@/Icon.png", documentsDir, [NSString stringWithFormat:@"%@", [value objectForKey: @"dossier"]]];
				if([[NSFileManager defaultManager] fileExistsAtPath:imageTT] == YES){
					NSData *data = [NSData dataWithContentsOfFile:imageTT];
					image = [[UIImage alloc] initWithData:data];
					cell.myImageView.image = image;
				}
				else{
                    NSString *donnees_nom = [value objectForKey: @"nom"];
					if([donnees_nom compare:[NSString stringWithFormat:@"MobileMusicPlayer"]] == NSOrderedSame){
						NSString *imageMMP = [NSString stringWithFormat:@"%@/%@/icon-MediaPlayer.png", documentsDir, [value objectForKey: @"dossier"]];
						if([[NSFileManager defaultManager] fileExistsAtPath:imageMMP] == YES){
							NSData *data = [NSData dataWithContentsOfFile:imageMMP];
							image = [[UIImage alloc] initWithData:data];
							cell.myImageView.image = image;
						}
					}
					else if([donnees_nom compare:[NSString stringWithFormat:@"MobileSlideShow"]] == NSOrderedSame){
						NSString *imageMSS = [NSString stringWithFormat:@"%@/%@/icon-Photos.png", documentsDir, [value objectForKey: @"dossier"]];
						if([[NSFileManager defaultManager] fileExistsAtPath:imageMSS] == YES){
							NSData *data = [NSData dataWithContentsOfFile:imageMSS];
							image = [[UIImage alloc] initWithData:data];
							cell.myImageView.image = image;
						}
					}
					else{
						NSString *path = [[NSBundle mainBundle] bundlePath];
						NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/iconCydia.png",path]];
						image = [[UIImage alloc] initWithData:data];
						cell.myImageView.image = image;
						
					}
				}
				
			}
		}
		
	}
	
	[cell.contentView addSubview: [self getDetailDiscolosureIndicatorForIndexPath:indexPath]];
	
	[image release];
	image = nil;
	
    return cell;
}

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
	
	NSArray *nomAppAlpha;
	NSArray *nomApp = [dicoApp allKeys];
	nomAppAlpha = [nomApp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	id value = [dicoApp objectForKey:[nomAppAlpha objectAtIndex:sender.tag]];	
	
	NSString *dossierApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"dossier"]];
	
	NSString *pathBundle = [NSString stringWithFormat:@"%@/%@",documentsDir,dossierApplication];
	NSArray *subPath = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:pathBundle error:nil];
	NSString *contentPath;
	NSDictionary *attributes;
	NSNumber *fileSize;
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
		tailleApp = [NSString stringWithFormat:@"%@ : %.2f G%@", MyLocalizedString(@"_tailletotale",@""), [gigabytes floatValue], self.unitUser];
	}
	else if([kilobytes intValue] > 1024){
		tailleApp = [NSString stringWithFormat:@"%@ : %.2f M%@", MyLocalizedString(@"_tailletotale",@""), [megabytes floatValue], self.unitUser];
	}
	else{
		tailleApp = [NSString stringWithFormat:@"%@ : %i K%@", MyLocalizedString(@"_tailletotale",@""), [kilobytes intValue], self.unitUser];
	}
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@", [nomAppAlpha objectAtIndex:sender.tag]] message:[NSString stringWithFormat:@"%@", tailleApp] delegate:self cancelButtonTitle:MyLocalizedString(@"_fermer",@"") otherButtonTitles:nil];
	alert.delegate = self;
	[alert show];
	[alert release];
	
} 



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
	if(self.appDetailViewController == nil){
		AppDetailViewController *aAppDetail = [[AppDetailViewController alloc] initWithNibName:@"AppDetailViewController" bundle:nil];
		self.appDetailViewController = aAppDetail;
		[aAppDetail release];
	}
	 */
	
	self.appDetailViewController = nil;
	AppDetailViewController *aAppDetail = [[AppDetailViewController alloc] initWithNibName:@"AppDetailViewController" bundle:nil];
	self.appDetailViewController = aAppDetail;
	[aAppDetail release];
	
	
	id value;
	NSArray *nomAppAlpha;
	NSArray *nomApp = [dicoApp allKeys];
	nomAppAlpha = [nomApp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	value = [dicoApp objectForKey:[nomAppAlpha objectAtIndex:indexPath.row]];
	
	NSString *nomApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"nom"]];
	NSString *iconApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"icon"]];
	NSString *versionApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"version"]];
	NSString *dossierApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"dossier"]];
	NSString *minosApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"minos"]];
	NSString *identifiantApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"identifiant"]];
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
			NSString *imageReTest = [NSString stringWithFormat:@"%@/%@/icon.png", documentsDir, [NSString stringWithFormat:@"%@", [value objectForKey: @"dossier"]]];
			if([[NSFileManager defaultManager] fileExistsAtPath:imageReTest] == YES){
				imageApplication = imageReTest;
			}
			else{
				NSString *imageTT = [NSString stringWithFormat:@"%@/%@/Icon.png", documentsDir, [NSString stringWithFormat:@"%@", [value objectForKey: @"dossier"]]];
				if([[NSFileManager defaultManager] fileExistsAtPath:imageTT] == YES){
					imageApplication = imageTT;
				}
				else{
                    NSString *donnees_nom = [value objectForKey: @"nom"];
					if([donnees_nom compare:[NSString stringWithFormat:@"MobileMusicPlayer"]] == NSOrderedSame){
						NSString *imageMMP = [NSString stringWithFormat:@"%@/%@/icon-MediaPlayer.png", documentsDir, [value objectForKey: @"dossier"]];
						if([[NSFileManager defaultManager] fileExistsAtPath:imageMMP] == YES){
							imageApplication = imageMMP;
						}
					}
					else if([donnees_nom compare:[NSString stringWithFormat:@"MobileSlideShow"]] == NSOrderedSame){
						NSString *imageMSS = [NSString stringWithFormat:@"%@/%@/icon-Photos.png", documentsDir, [value objectForKey: @"dossier"]];
						if([[NSFileManager defaultManager] fileExistsAtPath:imageMSS] == YES){
							imageApplication = imageMSS;
						}
					}
					else{
						NSString *path = [[NSBundle mainBundle] bundlePath];
						imageApplication = [NSString stringWithFormat:@"%@/apple.png",path];
						
					}
				}
				
			}
		}
		
	}
	
    NSString *posInSB = [self findPositionInSpringboard:identifiantApplication];
    if([posInSB compare:@""] != NSOrderedSame){
        posInSB = [NSString stringWithFormat:@"<b>%@ :</b> %@<br />",MyLocalizedString(@"_positionspringboard", @""),posInSB];
    }
    
	NSString *cheminCydia = @"";
	cheminCydia = [NSString stringWithFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"cydia://package/%@\"><img src=\"cydia.png\" style=\"float:left;margin:0 5px\" width=\"25\" />%@</a></li>", identifiantApplication, MyLocalizedString(@"_ouvrircydia",@"")];
	
	NSString *calculTailleApp;
	calculTailleApp = [NSString stringWithFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"browse:%@\"><img src=\"disque.png\" style=\"float:left;margin:0 5px\" width=\"25\" />%@</a></li>", [nomAppAlpha objectAtIndex:indexPath.row], MyLocalizedString(@"_calcultaille",@"")];
	
	NSString *cheminiFile;
	cheminiFile = [NSString stringWithFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"ifile://file%@/%@\"><img src=\"ifile.png\" style=\"float:left;margin:0 5px\" width=\"25\" />%@</a></li>",documentsDir,dossierApplication, MyLocalizedString(@"_ouvririfile",@"")];
	
	NSString *lienExterne;
	lienExterne = [NSString stringWithFormat:@"<div class=\"iMenu\"><ul class=\"iArrow\">%@%@%@</ul></div>",calculTailleApp,cheminiFile,cheminCydia];
	
	
	appDetailViewController.title = nomApplication;
	
	aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];//init and create the UIWebView
	aWebView.autoresizesSubviews = YES;
	aWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	[aWebView setDelegate:self];
	
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	NSString *bundleInfo = [NSString stringWithFormat:@"<b>%@ :</b> %@<br /><b>%@ :</b> %@<br /><b>%@ :</b> %@<br /><b>%@ :</b> %@<br /><b>IconFile :</b> %@<br />%@", MyLocalizedString(@"_version",@""), versionApplication, MyLocalizedString(@"_dossier",@""), dossierApplication, MyLocalizedString(@"_minos",@""),minosApplication,MyLocalizedString(@"_identifiant",@""), identifiantApplication,iconApplication,posInSB];
	
	NSString *myHTML = [NSString stringWithFormat:@"<html><head><link href=\"Render.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body> <div id=\"WebApp\"><div id=\"iGroup\"><div class=\"iBlock\" style=\"margin-bottom:10px;\"><h1>%@</h1><p><img src=\"/../../../..%@\" style=\"float:left;margin:0 5px\" />%@</p></div> %@ </div></div></body></html>",nomApplication,imageApplication,bundleInfo,lienExterne];
	[aWebView loadHTMLString:myHTML baseURL:baseURL];
	
	[appDetailViewController.view addSubview:aWebView];
	
	UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] init];
	exportButton.title = MyLocalizedString(@"_export",@"");
	appDetailViewController.navigationItem.rightBarButtonItem = exportButton;
	[exportButton setTarget:self];
	[exportButton setAction:@selector(exportActionApp:)];
	exportButton.tag = indexPath.row;
	[exportButton release];
	
	
	[self.navigationController pushViewController:appDetailViewController animated:YES];
	
	//appinfoAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	//[delegate.appiNavController pushViewController:appDetailViewController animated:YES];
	
	
	value = nil;
	self.appDetailViewController = nil;
	self.aWebView = nil;
}



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



- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	NSURL *URL = [request URL];	
	NSString *urlString = [URL absoluteString];
	
	
	if(navigationType == UIWebViewNavigationTypeLinkClicked) {
		if([urlString hasPrefix:@"ifile"] || [urlString hasPrefix:@"http"] || [urlString hasPrefix:@"cydia"]){
			return ![[UIApplication sharedApplication] openURL:URL]; 
		}
		else if([urlString hasPrefix:@"browse"]){
			
			NSMutableString *keyApp = [[NSMutableString alloc] initWithString:urlString];
			[keyApp replaceOccurrencesOfString:@"browse:" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
			[keyApp replaceOccurrencesOfString:@"\%20" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
			NSString *keyID = [keyApp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			//[keyId replaceOccurrencesOfString:@"\%20" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyID length])];
			[keyApp release];
			
			id value;
			value = [dicoApp objectForKey:keyID];
			
			
			NSString *dossierApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"dossier"]];
			
			NSString *pathBundle = [NSString stringWithFormat:@"%@/%@",documentsDir,dossierApplication];
			NSArray *subPath = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:pathBundle error:nil];
			NSString *contentPath;
			NSDictionary *attributes;
			NSNumber *fileSize;
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
				tailleApp = [NSString stringWithFormat:@"%@ : %.2f G%@", MyLocalizedString(@"_tailletotale",@""), [gigabytes floatValue], self.unitUser];
			}
			else if([kilobytes intValue] > 1024){
				tailleApp = [NSString stringWithFormat:@"%@ : %.2f M%@", MyLocalizedString(@"_tailletotale",@""), [megabytes floatValue], self.unitUser];
			}
			else{
				tailleApp = [NSString stringWithFormat:@"%@ : %i K%@", MyLocalizedString(@"_tailletotale",@""), [kilobytes intValue], self.unitUser];
			}
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@", keyID] message:[NSString stringWithFormat:@"%@", tailleApp] delegate:self cancelButtonTitle:MyLocalizedString(@"_fermer",@"") otherButtonTitles:nil];
			alert.delegate = self;
			[alert show];
			[alert release];
			
		}
	}
	
	return YES;
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

- (void)exportAction:(id)sender{
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:MyLocalizedString(@"_exportliste",@"") delegate:self cancelButtonTitle:nil destructiveButtonTitle:MyLocalizedString(@"_annuler",@"") otherButtonTitles:MyLocalizedString(@"_exportdetails",@""), nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	actionSheet.destructiveButtonIndex = 0;
	[actionSheet showInView:self.parentViewController.tabBarController.view]; 
	[actionSheet release];
	
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	NSArray *nomAppAlpha = [[dicoApp allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	NSString *exportContents = @"";
	NSMutableArray *arrayFull = [[NSMutableArray alloc] init];
	
	
	for(id app in nomAppAlpha){		
		
		NSString *nomApp = [[dicoApp objectForKey:app] objectForKey:@"nom"];
		NSString *versionApp = [[dicoApp objectForKey:app] objectForKey:@"version"];
		NSString *idApp = [[dicoApp objectForKey:app] objectForKey:@"identifiant"];
		NSString *dossierApp = [[dicoApp objectForKey:app] objectForKey:@"dossier"];
		NSString *minosApp = [[dicoApp objectForKey:app] objectForKey:@"minos"];
		NSString *iconApp = [[dicoApp objectForKey:app] objectForKey:@"icon"];
					
			NSString *exportContentFull = @"";
			
			exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<h3 style=\"margin-bottom:0px;font-size:16px;\">%@</h3>\n<ul style=\"margin-top:0px;font-size:7px;\">\n",nomApp]];
			
			exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>%@ : </strong>%@</li>\n",MyLocalizedString(@"_version",@""),versionApp]];
			exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>%@ : </strong>%@</li>\n",MyLocalizedString(@"_identifiant",@""),idApp]];
			exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>%@ : </strong>%@</li>\n",MyLocalizedString(@"_dossier",@""),dossierApp]];
			exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>%@ : </strong>%@</li>\n",MyLocalizedString(@"_minos",@""),minosApp]];
			exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<li><strong>IconFile : </strong>%@</li>\n",iconApp]];
			
			
			exportContentFull = [exportContentFull stringByAppendingString:@"</ul><hr />\n"];
			[arrayFull addObject:exportContentFull];
			
		
	}
	
	
	for(id value in arrayFull){
		exportContents = [exportContents stringByAppendingString:value];
	}
	[arrayFull release];
	

	if (buttonIndex == 1) {
	[self  pushEmail:(self.emailUser) andSubject:[NSString stringWithFormat:MyLocalizedString(@"_exportmaildetails",@""),MyLocalizedString(@"_cydia",@"")] andBody:[NSString stringWithFormat:@"%@", exportContents]];
	}

}


- (void)exportActionApp:(id)sender {
	
	NSArray *nomApp = [dicoApp allKeys];
	NSArray *nomAppAlpha = [nomApp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	id value = [dicoApp objectForKey:[nomAppAlpha objectAtIndex:[sender tag]]];
	
	NSString *nomApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"nom"]];
	NSString *versionApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"version"]];
	NSString *dossierApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"dossier"]];
	NSString *identifiantApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"identifiant"]];
	NSString *minosApplication = [NSString stringWithFormat:@"%@", [value objectForKey: @"minos"]];
	
	
	NSString *bundleInfo = [NSString stringWithFormat:@"<b>%@ :</b> %@<br /><b>%@ :</b> %@<br /><b>%@ :</b> %@<br /><b>%@ :</b> %@<br />", MyLocalizedString(@"_version",@""), versionApplication,MyLocalizedString(@"_dossier",@""), dossierApplication,MyLocalizedString(@"_identifiant",@""), identifiantApplication, MyLocalizedString(@"_minos",@""), minosApplication];
	
	NSString *myHTML = [NSString stringWithFormat:@"<h1>%@</h1><p>%@</p>",nomApplication,bundleInfo];
	
	
	
	[self  pushEmail:(self.emailUser) andSubject:[NSString stringWithFormat:@"%@ - AppInfo",nomApplication] andBody:myHTML];
	
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

- (void)dealloc {
	[appiTableView release];
	[unitUser release];
	[emailUser release];
	[aWebView release];
	[detailDisclosureButtonType release];
	[appDetailViewController release];
	[dicoApp release];
	[documentsDir release];
    [super dealloc];
}


@end

