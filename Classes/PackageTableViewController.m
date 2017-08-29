//
//  PackageTableViewController.m
//  appinfo
//
//  Created by Miles on 26/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PackageTableViewController.h"
#import "appinfoAppDelegate.h"
#import "CustomCell.h"
#import "AppDetailViewController.h"


@implementation PackageTableViewController

@synthesize dicoPackage;
@synthesize dicoSource;
@synthesize appDetailViewController;
@synthesize emailUser;
@synthesize unitUser;
@synthesize aWebView;
@synthesize packageTableView;
@synthesize pathCydia;
@synthesize datetimeFormat;

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
	
	self.unitUser = [NSString stringWithFormat:@"%@", delegate.unitConfig];
	
    self.datetimeFormat = [delegate.dateFormatter stringByAppendingString:@" - HH:mm"];
    
	NSString *proPackage = delegate.packageConfig;
	
	self.navigationItem.title = @"AppInfo";
	
	UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] init];
	exportButton.title = MyLocalizedString(@"_action",@"");
	self.navigationItem.rightBarButtonItem = exportButton;
	[exportButton setTarget:self];
	[exportButton setAction:@selector(exportAction:)];
	[exportButton release]; 
	
    
    pathCydia = delegate.pathCydia;
    
    sortByDate = NO;
    sortByDateDispo = NO;
	
	dicoSource  = [[NSMutableDictionary alloc] init];
	
    NSString *metadataPlist =  delegate.pathCydiaMetadata;
	NSMutableDictionary *metaCydia;
	NSMutableDictionary *sourcesDico;
	NSMutableArray *arrayUrl;
	arrayUrl = [[[NSMutableArray alloc] init] autorelease];
	
	if([[NSFileManager defaultManager] fileExistsAtPath:metadataPlist] == YES){
		
		metaCydia = [[NSMutableDictionary alloc] initWithContentsOfFile:metadataPlist];
		sourcesDico = [metaCydia objectForKey:@"Sources"];
		for(id debSource in sourcesDico){
			NSMutableDictionary *debFile = [sourcesDico objectForKey:debSource];
			[arrayUrl addObject:[NSString stringWithFormat:@"%@",[debFile objectForKey:@"URI"]]];
		}
		[metaCydia release];
	}
    
    NSString *list_apt_path = delegate.pathAptLists;
	NSString *file;
	NSArray *filesSource = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:list_apt_path error:nil];
	for(file in filesSource){
		if([file hasSuffix:@"Release"]){
			NSMutableString *key = [[NSMutableString alloc] initWithString:file];
			[key replaceOccurrencesOfString:@"._Release" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [key length])];
			[key replaceOccurrencesOfString:@"_Release" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [key length])];
			[key replaceOccurrencesOfString:@"_" withString:@"/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [key length])];
			NSString *url = @"http://";
			url = [url stringByAppendingString:key];
			
            NSString *fileSourceContent = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",list_apt_path,file] encoding:NSUTF8StringEncoding error:nil];
			NSArray *sourceArray = [fileSourceContent componentsSeparatedByString:@"\n"];
			
			NSString *originSource = @"";
			NSString *originStr = @"Origin: ";
			
			NSString *labelSource = @"";
			NSString *labelStr = @"Label: ";
			
			NSString *suiteSource = @"";
			NSString *suiteStr = @"Suite: ";
			
			NSString *versionSource = @"";
			NSString *versionStr = @"Version: ";
			
			NSString *codenameSource = @"";
			NSString *codenameStr = @"Codename: ";
			
			NSString *architectureSource = @"";
			NSString *architectureStr = @"Architectures: ";
			
			NSString *componentsSource = @"";
			NSString *componentsStr = @"Components: ";
			
			NSString *descriptionSource = @"";
			NSString *descriptionStr = @"Description: ";
			
			for(id lineSource in sourceArray){
				
				NSRange rangeOrigin = [lineSource rangeOfString:originStr];
				NSRange rangeLabel = [lineSource rangeOfString:labelStr];
				NSRange rangeSuite = [lineSource rangeOfString:suiteStr];
				NSRange rangeVersion = [lineSource rangeOfString:versionStr];
				NSRange rangeCN = [lineSource rangeOfString:codenameStr];
				NSRange rangeArchi = [lineSource rangeOfString:architectureStr];
				NSRange rangeCompo = [lineSource rangeOfString:componentsStr];
				NSRange rangeDesc = [lineSource rangeOfString:descriptionStr];
				
				if (rangeOrigin.length > 0){
					originSource = [lineSource stringByReplacingOccurrencesOfString:originStr withString:@""]; 
				}
				else if (rangeLabel.length > 0){
					labelSource = [lineSource stringByReplacingOccurrencesOfString:labelStr withString:@""]; 
				}
				else if (rangeSuite.length > 0){
					suiteSource = [lineSource stringByReplacingOccurrencesOfString:suiteStr withString:@""]; 
				}
				else if (rangeVersion.length > 0){
					versionSource = [lineSource stringByReplacingOccurrencesOfString:versionStr withString:@""]; 
				}
				else if (rangeCN.length > 0){
					codenameSource = [lineSource stringByReplacingOccurrencesOfString:codenameStr withString:@""]; 
				}
				else if (rangeArchi.length > 0){
					architectureSource = [lineSource stringByReplacingOccurrencesOfString:architectureStr withString:@""]; 
				}
				else if (rangeCompo.length > 0){
					componentsSource = [lineSource stringByReplacingOccurrencesOfString:componentsStr withString:@""]; 
				}
				else if (rangeDesc.length > 0){
					descriptionSource = [lineSource stringByReplacingOccurrencesOfString:descriptionStr withString:@""]; 
				}
				
			}
			
			NSMutableDictionary *sourced = [[NSMutableDictionary alloc] init];
			[sourced setObject:url forKey:@"Url"];
			[sourced setObject:originSource forKey:@"Origin"];
			[sourced setObject:labelSource forKey:@"Label"];
			[sourced setObject:suiteSource forKey:@"Suite"];
			[sourced setObject:versionSource forKey:@"Version"];
			[sourced setObject:codenameSource forKey:@"Codename"];
			[sourced setObject:architectureSource forKey:@"Architectures"];
			[sourced setObject:componentsSource forKey:@"Components"];
			[sourced setObject:descriptionSource forKey:@"Description"];
            [sourced setObject:[NSNumber numberWithBool:NO] forKey:@"erased"];
			[dicoSource setObject:sourced forKey:originSource];
		
			
			[key release];
			[sourced release];
		}
	}
    
	//NSLog(@"DICOSOURCE COUNT: %i %@/n/n",[dicoSource count],dicoSource);
    //NSLog(@"ARRAYURL COUNT: %i %@/n/n",[arrayUrl count],arrayUrl);

    for(id source in [dicoSource allKeys]){
        id value = [dicoSource objectForKey:source];
        NSString *urlRecord = [value objectForKey:@"Url"];
        NSString *urlToRecord = @"";
        BOOL okSource = FALSE;
        
        
        //NSLog(@"urlRecord: %@",urlRecord);
        
        NSURL *urlR = [NSURL URLWithString:urlRecord];
        if(![[urlR host] isEqualToString:@"nix.howett.net"] && ![[urlR host] isEqualToString:@"coredev.nl"] && ![[urlR host] isEqualToString:@"apt.saurik.com"]){
            for(id urlComplete in arrayUrl){
                NSURL *urlC = [NSURL URLWithString:urlComplete];
                if([[urlR host] isEqualToString:[urlC host]]){
                    //NSLog(@"PRESENT !!!!!! %@",urlRecord);
                    urlToRecord = urlComplete;
                    okSource = TRUE;
                }
            }
        }
        else{
            okSource = TRUE;
        }

        if(!okSource){
            [[dicoSource objectForKey:source] setObject:[NSNumber numberWithBool:YES] forKey:@"erased"];
        }
                
    }
 
	/*
	NSString *urlComplete;
	NSArray *nomApp = [dicoSource allKeys];
	NSString *keyDico;
	for(urlComplete in arrayUrl){
		
        NSLog(@"_______0");
        NSLog(@"_______");
        NSLog(@"urlComplete %@",urlComplete);
		int i = 0;
		
		for(keyDico in nomApp){

            NSLog(@"keyDico %@",keyDico);
            
			id value = [dicoSource objectForKey:keyDico];
			NSString *urlRecord = [value objectForKey:@"Url"];
			
            NSLog(@"urlRecord %@",urlRecord);
            NSLog(@"bool %hhd",[urlRecord hasPrefix:urlComplete]);
			if ([urlRecord hasPrefix:urlComplete]) {
				i++;
			}
			
		}
		
		if(!i){
			
             NSLog(@"Coucou");
            
			NSMutableString *key = [[NSMutableString alloc] initWithString:urlComplete];
			[key replaceOccurrencesOfString:@"http://" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [key length])];
			[key replaceOccurrencesOfString:@"/" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [key length])];
			
			NSMutableDictionary *sourced = [[NSMutableDictionary alloc] init];
			[sourced setObject:urlComplete forKey:@"Url"];
			[sourced setObject:key forKey:@"Origin"];
			[sourced setObject:@"" forKey:@"Label"];
			[sourced setObject:@"" forKey:@"Suite"];
			[sourced setObject:@"" forKey:@"Version"];
			[sourced setObject:@"" forKey:@"Codename"];
			[sourced setObject:@"" forKey:@"Architectures"];
			[sourced setObject:@"" forKey:@"Components"];
			[sourced setObject:@"" forKey:@"Description"];
			[dicoSource setObject:sourced forKey:key];
			
			[key release];
			[sourced release];
			
		}
		
	}
	[arrayUrl release];
    */
	
	
	//on initialise le dictionary
	dicoPackage = [[NSMutableDictionary alloc] init];
	
	//On recupere le contenu du fichier Available
	NSError *errorFile = nil;
    
    NSString *pathStatus = delegate.pathDpkgStatus;
	NSString *fileContent = [NSString stringWithContentsOfFile:pathStatus encoding:NSUTF8StringEncoding error:&errorFile];
	
	//On decoupe le fichier par package
	NSArray *packageArray = [fileContent componentsSeparatedByString:@"\n\n"];

	//on boucle les package
	for(id linePack in packageArray){
		
		//On découpe le package par ligne
		NSArray *linePackage = [linePack componentsSeparatedByString:@"\n"];
		
		//on initialise les valeurs d'un package
		NSString *namePackage = @"";
		NSString *packagePackage = @"";
		NSString *sectionPackage = @"";
		NSString *maintainerPackage = @"";
		NSString *architecturePackage = @"";
		NSString *versionPackage = @"";
		NSString *dependsPackage = @"";
		NSString *sizePackage = @"";
		NSString *descriptionPackage = @"";
		NSString *sponsorPackage = @"";
		NSString *depictionPackage = @"";
		NSString *authorPackage = @"";
		NSString *conflictsPackage = @"";
		NSString *homepagePackage = @"";
		NSString *devPackage = @"";
		NSString *tagPackage = @"";
		NSString *priorityPackage = @"";
		NSString *installedSizePackage = @"";
		NSString *replacesPackage = @"";
		NSString *providesPackage = @"";
		NSString *preDependsPackage = @"";
		NSString *essentialPackage = @"";
		NSString *statusPackage = @"";
		
		//On check chaque ligne du Package
		for(id lineType in linePackage){
			NSRange rangeName = [lineType rangeOfString:@"Name: "];
			NSRange rangePackage = [lineType rangeOfString:@"Package: "];
			NSRange rangeSection = [lineType rangeOfString:@"Section: "];
			NSRange rangeMaintainer = [lineType rangeOfString:@"Maintainer: "];
			NSRange rangeArchitecture = [lineType rangeOfString:@"Architecture: "];
			NSRange rangeVersion = [lineType rangeOfString:@"Version: "];
			NSRange rangeDepends = [lineType rangeOfString:@"Depends: "];
			NSRange rangeSize = [lineType rangeOfString:@"Size: "];
			NSRange rangeDescription = [lineType rangeOfString:@"Description: "];
			NSRange rangeSponsor = [lineType rangeOfString:@"Sponsor: "];
			NSRange rangeDepiction = [lineType rangeOfString:@"Depiction: "];
			NSRange rangeAuthor = [lineType rangeOfString:@"Author: "];
			NSRange rangeConflicts = [lineType rangeOfString:@"Conflicts: "];
			NSRange rangeHomepage = [lineType rangeOfString:@"Homepage: "];
			NSRange rangeDev = [lineType rangeOfString:@"dev: "];
			NSRange rangeTag = [lineType rangeOfString:@"Tag: "];
			NSRange rangePriority = [lineType rangeOfString:@"Priority: "];
			NSRange rangeInstalledSize = [lineType rangeOfString:@"Installed-Size: "];
			NSRange rangeReplaces = [lineType rangeOfString:@"Replaces: "];
			NSRange rangeProvides = [lineType rangeOfString:@"Provides: "];
			NSRange rangePreDepends = [lineType rangeOfString:@"Pre-Depends: "];
			NSRange rangeEssential = [lineType rangeOfString:@"Essential: "];
			NSRange rangeStatus = [lineType rangeOfString:@"Status: "];
			
			if (rangeName.length > 0){
				namePackage = [lineType stringByReplacingOccurrencesOfString:@"Name: " withString:@""]; 
			}
			else if (rangePackage.length > 0){
				packagePackage = [lineType stringByReplacingOccurrencesOfString:@"Package: " withString:@""]; 
			}
			else if (rangeSection.length > 0){
				sectionPackage = [lineType stringByReplacingOccurrencesOfString:@"Section: " withString:@""]; 
			}
			else if (rangeMaintainer.length > 0){
				maintainerPackage = [lineType stringByReplacingOccurrencesOfString:@"Maintainer: " withString:@""]; 
			}
			else if (rangeArchitecture.length > 0){
				architecturePackage = [lineType stringByReplacingOccurrencesOfString:@"Architecture: " withString:@""]; 
			}
			else if (rangeVersion.length > 0){
				versionPackage = [lineType stringByReplacingOccurrencesOfString:@"Version: " withString:@""]; 
			}
			else if (rangeDepends.length > 0 && !rangePreDepends.length){
				dependsPackage = [lineType stringByReplacingOccurrencesOfString:@"Depends: " withString:@""]; 
			}
			else if (rangeSize.length > 0 && !rangeInstalledSize.length){
				sizePackage = [lineType stringByReplacingOccurrencesOfString:@"Size: " withString:@""]; 
			}
			else if (rangeDescription.length > 0){
				descriptionPackage = [lineType stringByReplacingOccurrencesOfString:@"Description: " withString:@""]; 
			}
			else if (rangeSponsor.length > 0){
				sponsorPackage = [lineType stringByReplacingOccurrencesOfString:@"Sponsor: " withString:@""]; 
			}
			else if (rangeDepiction.length > 0){
				depictionPackage = [lineType stringByReplacingOccurrencesOfString:@"Depiction: " withString:@""]; 
			}
			else if (rangeAuthor.length > 0){
				authorPackage = [lineType stringByReplacingOccurrencesOfString:@"Author: " withString:@""]; 
			}
			else if (rangeConflicts.length > 0){
				conflictsPackage = [lineType stringByReplacingOccurrencesOfString:@"Conflicts: " withString:@""]; 
			}
			else if (rangeHomepage.length > 0){
				homepagePackage = [lineType stringByReplacingOccurrencesOfString:@"Homepage: " withString:@""]; 
			}
			else if (rangeDev.length > 0){
				devPackage = [lineType stringByReplacingOccurrencesOfString:@"dev: " withString:@""]; 
			}
			else if (rangeTag.length > 0){
				tagPackage = [lineType stringByReplacingOccurrencesOfString:@"Tag: " withString:@""]; 
			}
			else if (rangePriority.length > 0){
				priorityPackage = [lineType stringByReplacingOccurrencesOfString:@"Priority: " withString:@""]; 
			}
			else if (rangeInstalledSize.length > 0){
				installedSizePackage = [lineType stringByReplacingOccurrencesOfString:@"Installed-Size: " withString:@""]; 
			}
			else if (rangeReplaces.length > 0){
				replacesPackage = [lineType stringByReplacingOccurrencesOfString:@"Replaces: " withString:@""]; 
			}
			else if (rangeProvides.length > 0){
				providesPackage = [lineType stringByReplacingOccurrencesOfString:@"Provides: " withString:@""]; 
			}
			else if (rangePreDepends.length > 0){
				preDependsPackage = [lineType stringByReplacingOccurrencesOfString:@"Pre-Depends: " withString:@""]; 
			}
			else if (rangeEssential.length > 0){
				essentialPackage = [lineType stringByReplacingOccurrencesOfString:@"Essential: " withString:@""]; 
			}
			else if (rangeStatus.length > 0){
				statusPackage = [lineType stringByReplacingOccurrencesOfString:@"Status: " withString:@""]; 
			}
			
			
			
			
			
		}
		
		
		/*
	section:
		Archiving
		Development
		Packaging
		Security
		 Administration
		 Multimedia
		 Data_Storage
		
	Priority:required
		*/

        
		BOOL pasdenom = FALSE;
		
		//si y'a pas de nom on met le package comme nom - Et on affiche pas les gsc. et cy+
		if([namePackage compare:@""] == NSOrderedSame){
			pasdenom = TRUE;
			if([packagePackage compare:@""] != NSOrderedSame){
				if(![packagePackage hasPrefix:@"gsc."] && ![packagePackage hasPrefix:@"cy+"]){
					namePackage = packagePackage;
                    pasdenom = FALSE;
                }
			}
		}
        
		
		//on crée un dictionaire qui va contenir les infos des packages si le nom n'est pas vide et si le status est installed !
		NSRange rangeInstalled = [statusPackage rangeOfString:@"install ok installed"];
		if([namePackage compare:@""] != NSOrderedSame && rangeInstalled.length > 0){
			NSMutableDictionary *paquet = [[NSMutableDictionary alloc] init];
			[paquet setObject:namePackage forKey:@"Name"];
			[paquet setObject:packagePackage forKey:@"Package"];
			[paquet setObject:sectionPackage forKey:@"Section"];
			[paquet setObject:maintainerPackage forKey:@"Maintainer"];
			[paquet setObject:architecturePackage forKey:@"Architecture"];
			[paquet setObject:versionPackage forKey:@"Version"];
			[paquet setObject:dependsPackage forKey:@"Depends"];
			[paquet setObject:sizePackage forKey:@"Size"];
			[paquet setObject:descriptionPackage forKey:@"Description"];
			[paquet setObject:sponsorPackage forKey:@"Sponsor"];
			[paquet setObject:depictionPackage forKey:@"Depiction"];
			[paquet setObject:authorPackage forKey:@"Author"];
			[paquet setObject:conflictsPackage forKey:@"Conflicts"];
			[paquet setObject:homepagePackage forKey:@"Homepage"];
			[paquet setObject:devPackage forKey:@"dev"];
			[paquet setObject:tagPackage forKey:@"Tag"];
			[paquet setObject:priorityPackage forKey:@"Priority"];
			[paquet setObject:installedSizePackage forKey:@"Installed-Size"];
			[paquet setObject:replacesPackage forKey:@"Replaces"];
			[paquet setObject:providesPackage forKey:@"Provides"];
			[paquet setObject:preDependsPackage forKey:@"Pre-Depends"];
			[paquet setObject:essentialPackage forKey:@"Essential"];
			[paquet setObject:statusPackage forKey:@"Status"];
            [paquet setObject:@"" forKey:@"date"];
			
			if([sectionPackage compare:@"Archiving"] == NSOrderedSame || [sectionPackage compare:@"Development"] == NSOrderedSame || [sectionPackage compare:@"Packaging"] == NSOrderedSame || [sectionPackage compare:@"Security"] == NSOrderedSame || [sectionPackage compare:@"Administration"] == NSOrderedSame || [sectionPackage compare:@"Multimedia"] == NSOrderedSame || [sectionPackage compare:@"Data_Storage"] == NSOrderedSame || [sectionPackage compare:@"perl"] == NSOrderedSame || [priorityPackage compare:@"required"] == NSOrderedSame){
				
				if([proPackage compare:@"1"] == NSOrderedSame){
					[dicoPackage setObject:paquet forKey:namePackage];
				}
				
			}
			else {
				if(!pasdenom)
				[dicoPackage setObject:paquet forKey:namePackage];
			}

			
			//[dicoPackage setObject:paquet forKey:namePackage];
			
			[paquet release];
		}
		
	}

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    if(([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)){
        // Text Color
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        [header.textLabel setTextColor:UIColorFromRGB(0x7E7E84)];
        [header.textLabel setFont:[UIFont systemFontOfSize:16]];
        [header.textLabel setText:[header.textLabel.text uppercaseString]];
    }
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
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
	
	if(section == 0){
		return [self.dicoSource count];
	}
	else {
		return [self.dicoPackage count];
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {	
	if(section == 0){
		return @"Sources";
	}
	else {
        if(sortByDate){
            return [NSString stringWithFormat:@"Packages (%@)", MyLocalizedString(@"_pardate", @"")];
        }
        else{
            return @"Packages";
        }
	}

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
    
    
	//Sources
	if(indexPath.section == 0){
		NSArray *nomApp = [dicoSource allKeys];
		NSArray *nomAppAlpha = [nomApp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
		id value = [dicoSource objectForKey:[nomAppAlpha objectAtIndex:indexPath.row]];
		
		cell.primaryLabel.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"Origin"]];
        if([[value objectForKey: @"erased"] boolValue]){
            cell.primaryLabel.textColor = UIColorFromRGB(0xB22222);
        }
		cell.secondaryLabel.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"Url"]];
		
		UIImage *image;
		NSString *urlStr = [value objectForKey: @"Url"];
		NSMutableString *key = [[NSMutableString alloc] initWithString:urlStr];
		[key replaceOccurrencesOfString:@"http://" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [key length])];
		NSArray *urlX = [key componentsSeparatedByString:@"/"];
		if([urlX count]){
			NSString *urlImg = [urlX objectAtIndex:0];
			if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/Sources/%@.png", pathCydia,urlImg]] == YES){
				NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/Sources/%@.png", pathCydia,urlImg]];
				image = [[UIImage alloc] initWithData:data];
				cell.myImageView.image = image;
			}
			else if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/Sections/Repositories.png",pathCydia]] == YES){
				NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/Sections/Repositories.png",pathCydia]];
				image = [[UIImage alloc] initWithData:data];
				cell.myImageView.image = image;
			}
			else{
				NSString *path = [[NSBundle mainBundle] bundlePath];
				NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/iconCydia.png",path]];
				image = [[UIImage alloc] initWithData:data];
				cell.myImageView.image = image;
			}
		}
		else {
			NSString *path = [[NSBundle mainBundle] bundlePath];
			NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/iconCydia.png",path]];
			image = [[UIImage alloc] initWithData:data];
			cell.myImageView.image = image;
		}
		
		[image release];
		image = nil;


	}
	//Packages
    else {
	
        id value;
        NSString *secondLabel;
        if(sortByDate){
            NSMutableArray *dictValues = [[dicoPackage allValues] mutableCopy];
            [dictValues autorelease]; //only needed for manual reference counting
            [dictValues sortUsingComparator: (NSComparator)^(NSDictionary *a, NSDictionary *b){
                NSString *key1 = [b objectForKey: @"date"];
                NSString *key2 = [a objectForKey: @"date"];
                return [key1 compare: key2];
            }];
            value = [dicoPackage objectForKey:[[dictValues objectAtIndex:indexPath.row] objectForKey:@"Name"]];
            NSString *madate = [self stringFromDateIsoString:[NSString stringWithFormat:@"%@",[value objectForKey:@"date"]] withFormat:datetimeFormat];
            if([madate compare:@"(null)"] == NSOrderedSame) madate = MyLocalizedString(@"_inconnu", @"");
            secondLabel = [NSString stringWithFormat:@"%@ : %@ | %@", MyLocalizedString(@"_version", @""), [value objectForKey: @"Version"],madate];
        }
        else{
            NSArray *nomAppAlpha = [[dicoPackage allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            value = [dicoPackage objectForKey:[nomAppAlpha objectAtIndex:indexPath.row]];
            secondLabel = [NSString stringWithFormat:@"%@ : %@", MyLocalizedString(@"_version", @""), [value objectForKey: @"Version"]];
        }
        
        
        /*
        if(indexPath.row == 1){
        
            //NSLog(@"%@",dictValues);
            NSLog(@"%@",[dictValues objectAtIndex:indexPath.row]);
            NSLog(@"%@",[[dictValues objectAtIndex:indexPath.row] objectForKey:@"Name"]);
        }
        */
        
		//NSArray *nomAppAlpha = [[dicoPackage allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
		//id value = [dicoPackage objectForKey:[nomAppAlpha objectAtIndex:indexPath.row]];
		
		cell.primaryLabel.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"Name"]];
		cell.secondaryLabel.text = secondLabel;
		
		UIImage *image;
		NSString *imageSauve = [NSString stringWithFormat:@"%@/Sections/%@.png", pathCydia, [value objectForKey: @"Section"]];
		if([[NSFileManager defaultManager] fileExistsAtPath:imageSauve] == YES){
			NSData *data = [NSData dataWithContentsOfFile:imageSauve];
			image = [[UIImage alloc] initWithData:data];
			cell.myImageView.image = image;
		}
		else {
			NSString *compareSection = [NSString stringWithFormat:@"%@",[value objectForKey: @"Section"]];
			NSRange rangeThemes = [compareSection rangeOfString:@"Themes"];
			NSRange rangeTerminal = [compareSection rangeOfString:@"Terminal"];
			NSRange rangeData = [compareSection rangeOfString:@"Data_Storage"];
			NSRange rangeBENM = [compareSection rangeOfString:@"BENM"];
            
            
			if([compareSection compare:@"SBSettings Addons"] == NSOrderedSame && [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/Sections/Addons (SBSettings).png",pathCydia]] == YES){
				NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/Sections/Addons (SBSettings).png",pathCydia]];
				image = [[UIImage alloc] initWithData:data];
				cell.myImageView.image = image;
			}
			else if(rangeTerminal.length > 0 && [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/Sections/Terminal Support.png",pathCydia]] == YES){
				NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/Sections/Terminal Support.png",pathCydia]];
				image = [[UIImage alloc] initWithData:data];
				cell.myImageView.image = image;
				
			}
			else if(rangeThemes.length > 0 && [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/Sections/Themes.png",pathCydia]] == YES){
				NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/Sections/Themes.png",pathCydia]];
				image = [[UIImage alloc] initWithData:data];
				cell.myImageView.image = image;
				
			}
			else if(rangeData.length > 0 && [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/Sections/Data Storage.png",pathCydia]] == YES){
				NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/Sections/Data Storage.png",pathCydia]];
				image = [[UIImage alloc] initWithData:data];
				cell.myImageView.image = image;
				
			}
			else if(rangeBENM.length > 0 && [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/Sections/BENM Tweaks.png",pathCydia]] == YES){
				NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/Sections/BENM Tweaks.png",pathCydia]];
				image = [[UIImage alloc] initWithData:data];
				cell.myImageView.image = image;
				
			}
			else{
				
				NSString *path = [[NSBundle mainBundle] bundlePath];
				NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/iconCydia.png",path]];
				image = [[UIImage alloc] initWithData:data];
				cell.myImageView.image = image;
			}
		}
		
		[image release];
		image = nil;
    
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
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
	
	if(indexPath.section == 0){
		id value;
		NSArray *nomAppAlpha;
		NSArray *nomApp = [dicoSource allKeys];
		nomAppAlpha = [nomApp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
		value = [dicoSource objectForKey:[nomAppAlpha objectAtIndex:indexPath.row]];
		
		appDetailViewController.title = [value objectForKey:@"Origin"];
		
		aWebView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)] autorelease];//init and create the UIWebView
		aWebView.autoresizesSubviews = YES;
		aWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
		[aWebView setDelegate:self];
		
		NSString *path = [[NSBundle mainBundle] bundlePath];
		NSURL *baseURL = [NSURL fileURLWithPath:path];
		
		NSString *imagePath = @"";
		NSString *urlStr = [value objectForKey: @"Url"];
		NSMutableString *key = [[NSMutableString alloc] initWithString:urlStr];
		[key replaceOccurrencesOfString:@"http://" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [key length])];
		NSArray *urlX = [key componentsSeparatedByString:@"/"];
		if([urlX count]){
			NSString *urlImg = [urlX objectAtIndex:0];
			if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/Sources/%@.png", pathCydia, urlImg]] == YES){
				imagePath = [NSString stringWithFormat:@"%@/Sources/%@.png", pathCydia, urlImg];
			}
			else if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/Sections/Repositories.png",pathCydia]] == YES){
				imagePath = [NSString stringWithFormat:@"%@/Sections/Repositories.png",pathCydia];
			}
			else{
				NSString *path = [[NSBundle mainBundle] bundlePath];
				imagePath = [NSString stringWithFormat:@"%@/iconCydia.png",path];
			}
		}
		else {
			NSString *path = [[NSBundle mainBundle] bundlePath];
			imagePath = [NSString stringWithFormat:@"%@/iconCydia.png",path];		
		}
		
		NSString *infoSource = @"";
		//Url Origin Label Suite Version Codename Architectures Components Description
		
		NSString *packageSource = [NSString stringWithFormat:@"%@",[value objectForKey:@"Url"]];
		if([packageSource compare:@""] != NSOrderedSame)
			infoSource = [infoSource stringByAppendingString:[NSString stringWithFormat:@"<b>Url&nbsp;:</b>&nbsp;%@<br />",[value objectForKey:@"Url"]]];
		
		packageSource = [NSString stringWithFormat:@"%@",[value objectForKey:@"Origin"]];
		if([packageSource compare:@""] != NSOrderedSame)
			infoSource = [infoSource stringByAppendingString:[NSString stringWithFormat:@"<b>Origin :</b> %@<br />",[value objectForKey:@"Origin"]]];
		
		packageSource = [NSString stringWithFormat:@"%@",[value objectForKey:@"Label"]];
		if([packageSource compare:@""] != NSOrderedSame)
			infoSource = [infoSource stringByAppendingString:[NSString stringWithFormat:@"<b>Label :</b> %@<br />",[value objectForKey:@"Label"]]];
		
		packageSource = [NSString stringWithFormat:@"%@",[value objectForKey:@"Suite"]];
		if([packageSource compare:@""] != NSOrderedSame)
			infoSource = [infoSource stringByAppendingString:[NSString stringWithFormat:@"<b>Suite :</b> %@<br />",[value objectForKey:@"Suite"]]];
		
		packageSource = [NSString stringWithFormat:@"%@",[value objectForKey:@"Version"]];
		if([packageSource compare:@""] != NSOrderedSame)
			infoSource = [infoSource stringByAppendingString:[NSString stringWithFormat:@"<b>Version :</b> %@<br />",[value objectForKey:@"Version"]]];
		
		packageSource = [NSString stringWithFormat:@"%@",[value objectForKey:@"Codename"]];
		if([packageSource compare:@""] != NSOrderedSame)
			infoSource = [infoSource stringByAppendingString:[NSString stringWithFormat:@"<b>Codename :</b> %@<br />",[value objectForKey:@"Codename"]]];
		
		packageSource = [NSString stringWithFormat:@"%@",[value objectForKey:@"Architectures"]];
		if([packageSource compare:@""] != NSOrderedSame)
			infoSource = [infoSource stringByAppendingString:[NSString stringWithFormat:@"<b>Architectures :</b> %@<br />",[value objectForKey:@"Architectures"]]];
		
		packageSource = [NSString stringWithFormat:@"%@",[value objectForKey:@"Components"]];
		if([packageSource compare:@""] != NSOrderedSame)
			infoSource = [infoSource stringByAppendingString:[NSString stringWithFormat:@"<b>Components :</b> %@<br />",[value objectForKey:@"Components"]]];
		
        NSString *erasedtext = @"";
        if([[value objectForKey:@"erased"] boolValue]){
            erasedtext = @"<span style=\"color:#B22222;\">Source deleted !!</span><br />";
        }
        
		NSString *headerSource = @"";
		headerSource = [NSString stringWithFormat:@"<img src=\"file://%@\" style=\"float:left;margin:0 5px\" width=\"60\"/> %@<b>Description :</b> %@",imagePath,erasedtext,[value objectForKey:@"Description"]];

		
		NSString *myHTML = [NSString stringWithFormat:@"<html><head><link href=\"Render.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body> <div id=\"WebApp\"><div id=\"iGroup\"><div class=\"iBlock\" style=\"margin-bottom:10px;\"><h1>%@</h1><p style=\"min-height:60px;word-wrap: break-word;\">%@</p><p style=\"word-wrap: break-word;\">%@</p></div></div></div></body></html>",[value objectForKey:@"Origin"],headerSource,infoSource];
		[aWebView loadHTMLString:myHTML baseURL:baseURL];
		
		[appDetailViewController.view addSubview:aWebView];
		
		appinfoAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		[delegate.packageNavController pushViewController:appDetailViewController animated:YES];
		
		value = nil;
		
	}
	else {

	
		/*id value;
		NSArray *nomAppAlpha;
		NSArray *nomApp = [dicoPackage allKeys];
		nomAppAlpha = [nomApp sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
		value = [dicoPackage objectForKey:[nomAppAlpha objectAtIndex:indexPath.row]];
        */
        
        id value;
        
        if(sortByDate){
            NSMutableArray *dictValues = [[dicoPackage allValues] mutableCopy];
            [dictValues autorelease]; //only needed for manual reference counting
            [dictValues sortUsingComparator: (NSComparator)^(NSDictionary *a, NSDictionary *b){
                NSString *key1 = [b objectForKey: @"date"];
                NSString *key2 = [a objectForKey: @"date"];
                return [key1 compare: key2];
            }];
            value = [dicoPackage objectForKey:[[dictValues objectAtIndex:indexPath.row] objectForKey:@"Name"]];
        }
        else{
            NSArray *nomAppAlpha = [[dicoPackage allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            value = [dicoPackage objectForKey:[nomAppAlpha objectAtIndex:indexPath.row]];
        }
        
        
        appinfoAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		
		appDetailViewController.title = [value objectForKey:@"Name"];
		
		aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];//init and create the UIWebView
		aWebView.autoresizesSubviews = YES;
		aWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
		[aWebView setDelegate:self];
		
		NSString *path = [[NSBundle mainBundle] bundlePath];
		NSURL *baseURL = [NSURL fileURLWithPath:path];
		
		NSString *imagePath = @"";
		NSString *imageSauve = [NSString stringWithFormat:@"%@/Sections/%@.png", pathCydia, [value objectForKey: @"Section"]];
		if([[NSFileManager defaultManager] fileExistsAtPath:imageSauve] == YES){
			imagePath = imageSauve; 
		}
		else {
			NSString *compareSection = [NSString stringWithFormat:@"%@",[value objectForKey: @"Section"]];
			NSRange rangeThemes = [compareSection rangeOfString:@"Themes"];
			NSRange rangeTerminal = [compareSection rangeOfString:@"Terminal"];
			NSRange rangeData = [compareSection rangeOfString:@"Data_Storage"];
			NSRange rangeBENM = [compareSection rangeOfString:@"BENM"];
           
			if([compareSection compare:@"SBSettings Addons"] == NSOrderedSame && [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/Sections/Addons (SBSettings).png",pathCydia]] == YES){
				imagePath = [NSString stringWithFormat:@"%@/Sections/Addons (SBSettings).png",pathCydia];
			}
			else if(rangeTerminal.length > 0 && [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/Sections/Terminal Support.png",pathCydia]] == YES){
				imagePath = [NSString stringWithFormat:@"%@/Sections/Terminal Support.png",pathCydia];
				
			}
			else if(rangeThemes.length > 0 && [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/Sections/Themes.png",pathCydia]] == YES){
				imagePath = [NSString stringWithFormat:@"%@/Sections/Themes.png",pathCydia];
				
			}
			else if(rangeData.length > 0 && [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/Sections/Data Storage.png",pathCydia]] == YES){
				imagePath = [NSString stringWithFormat:@"%@/Sections/Data Storage.png",pathCydia];
				
			}
			else if(rangeBENM.length > 0 && [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/Sections/BENM Tweaks.png",pathCydia]] == YES){
				imagePath = [NSString stringWithFormat:@"%@/Sections/BENM Tweaks.png",pathCydia];
				
			}
			else{
				
				NSString *path = [[NSBundle mainBundle] bundlePath];
				imagePath = [NSString stringWithFormat:@"%@/iconCydia.png",path];
			}
		}
		
		
		NSString *infoPackage = @"";
		//Name Package Section Maintainer Architecture Version Depends Size Description Sponsor Depiction Author Conflicts Homepage dev Tag Priority Installed-Size Replaces Provides Pre-Depends Essential Status
		NSString *madate = [self stringFromDateIsoString:[NSString stringWithFormat:@"%@",[value objectForKey:@"date"]] withFormat:datetimeFormat];
        if([madate compare:@"(null)"] == NSOrderedSame) madate = MyLocalizedString(@"_inconnu", @"");
        
        
		NSString *packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Package"]];
		if([packagePackage compare:@""] != NSOrderedSame)
			infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Package :</b> %@<br />",[value objectForKey:@"Package"]]];
		
		packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Version"]];
		if([packagePackage compare:@""] != NSOrderedSame)
			infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Version :</b> %@<br />",[value objectForKey:@"Version"]]];
        
        packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"date"]];
		if([packagePackage compare:@""] != NSOrderedSame)
			infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Date :</b> %@<br />",madate]];
		
		packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Section"]];
		if([packagePackage compare:@""] != NSOrderedSame)
			infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Section :</b> %@<br />",[value objectForKey:@"Section"]]];
		
		packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Author"]];
		if([packagePackage compare:@""] != NSOrderedSame)
			infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Author :</b> %@<br />",[value objectForKey:@"Author"]]];
		
		packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"dev"]];
		if([packagePackage compare:@""] != NSOrderedSame)
			infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>dev :</b> %@<br />",[value objectForKey:@"dev"]]];
		
		packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Maintainer"]];
		if([packagePackage compare:@""] != NSOrderedSame)
			infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Maintainer :</b> %@<br />",[value objectForKey:@"Maintainer"]]];
		
		packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Sponsor"]];
		if([packagePackage compare:@""] != NSOrderedSame)
			infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Sponsor :</b> %@<br />",[value objectForKey:@"Sponsor"]]];
		
		packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Replaces"]];
		if([packagePackage compare:@""] != NSOrderedSame)
			infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Replaces :</b> %@<br />",[value objectForKey:@"Replaces"]]];
		
		packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Depends"]];
		if([packagePackage compare:@""] != NSOrderedSame)
			infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Depends :</b> %@<br />",[value objectForKey:@"Depends"]]];
		
		packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Pre-Depends"]];
		if([packagePackage compare:@""] != NSOrderedSame)
			infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Pre-Depends :</b> %@<br />",[value objectForKey:@"Pre-Depends"]]];
		
		packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Conflicts"]];
		if([packagePackage compare:@""] != NSOrderedSame)
			infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Conflicts :</b> %@<br />",[value objectForKey:@"Conflicts"]]];
		
		packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Provides"]];
		if([packagePackage compare:@""] != NSOrderedSame)
			infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Provides :</b> %@<br />",[value objectForKey:@"Provides"]]];
		
		packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Architecture"]];
		if([packagePackage compare:@""] != NSOrderedSame)
			infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Architecture :</b> %@<br />",[value objectForKey:@"Architecture"]]];
		
		packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Size"]];
		if([packagePackage compare:@""] != NSOrderedSame)
			infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Size :</b> %@<br />",[value objectForKey:@"Size"]]];
		
		packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Installed-Size"]];
		if([packagePackage compare:@""] != NSOrderedSame)
			infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Installed-Size :</b> %@<br />",[value objectForKey:@"Installed-Size"]]];
		
		packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Essential"]];
		if([packagePackage compare:@""] != NSOrderedSame)
			infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Essential :</b> %@<br />",[value objectForKey:@"Essential"]]];
		
		packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Priority"]];
		if([packagePackage compare:@""] != NSOrderedSame)
			infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Priority :</b> %@<br />",[value objectForKey:@"Priority"]]];
		
		/*packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Status"]];
		if([packagePackage compare:@""] != NSOrderedSame)
			infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Status :</b> %@<br />",[value objectForKey:@"Status"]]];*/
		
		packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Tag"]];
		if([packagePackage compare:@""] != NSOrderedSame)
			infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Tag :</b> %@<br />",[value objectForKey:@"Tag"]]];
		
		NSString *headerPackage = @"";
		headerPackage = [NSString stringWithFormat:@"<img src=\"file://%@\" style=\"float:left;margin:0 5px\" width=\"60\"/> <b>Description :</b> %@",imagePath,[NSString stringWithFormat:@"%@",[value objectForKey:@"Description"]]];
		
		
		NSString *cheminCydia = @"";
		packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Package"]];
		if([packagePackage compare:@""] != NSOrderedSame){
			cheminCydia = [NSString stringWithFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"cydia://package/%@\"><img src=\"cydia.png\" style=\"float:left;margin:0 5px\" width=\"25\" />%@</a></li>", [value objectForKey:@"Package"], MyLocalizedString(@"_ouvrircydia",@"")];
		}
		
		NSString *cheminHomepage = @"";
		packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Homepage"]];
		if([packagePackage compare:@""] != NSOrderedSame){
			cheminHomepage = [NSString stringWithFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"homepage:%@\"><img src=\"homepage.png\" style=\"float:left;margin:0 5px\" width=\"25\" />Homepage</a></li>", [value objectForKey:@"Homepage"]];
		}
		NSString *cheminDepiction = @"";
		packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Depiction"]];
		if([packagePackage compare:@""] != NSOrderedSame){
			cheminDepiction = [NSString stringWithFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"depiction:%@\"><img src=\"depiction.png\" style=\"float:left;margin:0 5px\" width=\"25\" />Depiction</a></li>", [value objectForKey:@"Depiction"]];
		}
		
		NSString *fileSystem = @"";
		NSString *listing = [NSString stringWithFormat:@"%@/%@.list",delegate.pathDpkgInfo, [value objectForKey: @"Package"]];
		if([[NSFileManager defaultManager] fileExistsAtPath:listing] == YES){
			fileSystem = [NSString stringWithFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"listing:%@\"><img src=\"filepackage.png\" style=\"float:left;margin:0 5px\" width=\"25\" />%@</a></li>", [value objectForKey:@"Package"],MyLocalizedString(@"_fichiersinstalles",@"")]; 
		}
		
        NSString *rebuildpackage = [NSString stringWithFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\"><a href=\"rebuild:%@\"><img src=\"rebuilddeb.png\" style=\"float:left;margin:0 5px\" width=\"25\" />%@</a></li>", [value objectForKey:@"Package"],MyLocalizedString(@"_rebuild",@"")];
		
        
        NSString *debsaved = @"";
        NSString *displaydebemail = @"none";
        NSString *pathFolder = [NSString stringWithFormat:@"%@/deb",delegate.pathAppInfoSavedFolder];
        NSString *foldername = [NSString stringWithFormat:@"%@_%@",[value objectForKey:@"Package"],[value objectForKey:@"Version"]];
        NSString *debpath = [NSString stringWithFormat:@"%@/%@.deb",pathFolder,foldername];
        if([[NSFileManager defaultManager] fileExistsAtPath:debpath] == YES){
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:debpath error:nil];
            NSDate *date = [attributes fileModificationDate];
            NSString *madate = [self stringFromDateIsoString:[NSString stringWithFormat:@"%@",date] withFormat:datetimeFormat];
            debsaved = [NSString stringWithFormat:@"%@ : %@",MyLocalizedString(@"_debsaved", @""),madate];
            displaydebemail = @"block";
        }

        NSString *debbyemail;
        debbyemail = [NSString stringWithFormat:@"<li id=\"debbyemail\" style=\"display:%@;position:relative;padding-top:10px;padding-bottom:10px;\"><a href=\"debemail:%@\"><img src=\"mail.png\" style=\"float:left;margin:0 5px\" width=\"25\" /><div style=\"position:absolute;display:inline-block;top:5px\">%@</div><div id=\"debsavedate\" style=\"position:absolute;display:inline-block;top:20px;font-size:0.7em;color:#777\">%@</div></a></li>", displaydebemail,[value objectForKey:@"Package"], MyLocalizedString(@"_debbyemail",@""),debsaved];
        
		
		NSString *lienExterne;
		lienExterne = [NSString stringWithFormat:@"<div class=\"iMenu\"><ul class=\"iArrow\">%@%@%@%@%@%@</ul></div>",debbyemail,rebuildpackage,fileSystem,cheminDepiction,cheminHomepage,cheminCydia];
		
        
		NSString *myHTML = [NSString stringWithFormat:@"<html><head><link href=\"Render.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body> <div id=\"WebApp\"><div id=\"iGroup\"><div class=\"iBlock\" style=\"margin-bottom:10px;\"><h1>%@</h1><p style=\"min-height:60px;\">%@</p><p>%@</p></div>%@</div></div></body></html>",[value objectForKey:@"Name"],headerPackage,infoPackage,lienExterne];
		[aWebView loadHTMLString:myHTML baseURL:baseURL];
		
		[appDetailViewController.view addSubview:aWebView];
		
		UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] init];
		exportButton.title = MyLocalizedString(@"_export",@"");
		appDetailViewController.navigationItem.rightBarButtonItem = exportButton;
		[exportButton setTarget:self];
		[exportButton setAction:@selector(exportActionApp:)];
		exportButton.tag = indexPath.row;
		[exportButton release];
		
		[delegate.packageNavController pushViewController:appDetailViewController animated:YES];
		
		value = nil;
		
	}
	
	self.appDetailViewController = nil;
	
}


- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	NSURL *URL = [request URL];	
	NSString *urlString = [URL absoluteString];
	
	
	if(navigationType == UIWebViewNavigationTypeLinkClicked) {
		if([urlString hasPrefix:@"ifile"] || [urlString hasPrefix:@"cydia"]){
			return ![[UIApplication sharedApplication] openURL:URL]; 
		}
        else if([urlString hasPrefix:@"debemail"]){
            
            NSMutableString *keyApp = [[NSMutableString alloc] initWithString:urlString];
            [keyApp replaceOccurrencesOfString:@"debemail:" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
            [keyApp replaceOccurrencesOfString:@"\%20" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
            NSString *package = [keyApp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *version = @"";
            NSString *name = package;
            for(id pck in dicoPackage){
                if([[NSString stringWithFormat:@"%@",[[dicoPackage valueForKey:pck] valueForKey:@"Package"]] compare:package] == NSOrderedSame){
                    for(id label in [dicoPackage valueForKey:pck]){
                        if([[NSString stringWithFormat:@"%@",[[dicoPackage valueForKey:pck] valueForKey:label]] compare:@""] != NSOrderedSame){
                            if([[NSString stringWithFormat:@"%@",label] compare:@"Version"] == NSOrderedSame){
                                version = [NSString stringWithFormat:@"%@",[[dicoPackage valueForKey:pck] valueForKey:label]];
                            }
                            if([[NSString stringWithFormat:@"%@",label] compare:@"Name"] == NSOrderedSame){
                                name = [NSString stringWithFormat:@"%@",[[dicoPackage valueForKey:pck] valueForKey:label]];
                            }
                        }
                    }
                }
            }
            
            NSString *foldername = [NSString stringWithFormat:@"%@%@",package,version];
            appinfoAppDelegate *delegate = (appinfoAppDelegate*)[[UIApplication sharedApplication] delegate];
            NSString *pathFolder = [NSString stringWithFormat:@"%@/deb",delegate.pathAppInfoSavedFolder];
            NSString *srcPath = [NSString stringWithFormat:@"%@/%@.deb",pathFolder,foldername];
            NSString *extension = @"deb";
			[self  pushEmailAttachments:(delegate.emailConfigF) andSubject:[NSString stringWithFormat:@"%@.deb",foldername] andBody:[NSString stringWithFormat:@"%@ - %@<br /><br />%@",name,version,srcPath] andAttachments:srcPath andExtension:extension];
            
        }
        else if([urlString hasPrefix:@"rebuild"]){
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
            label.text = MyLocalizedString(@"_rebuilddeb", @"");
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
            
            NSMutableString *keyApp = [[NSMutableString alloc] initWithString:urlString];
            [keyApp replaceOccurrencesOfString:@"rebuild:" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
            aWebView.superview.superview.userInteractionEnabled = NO;
            [self performSelector:@selector(rebuidPackage:) withObject:keyApp afterDelay:0.5 ];
            
            
            
            
            //[self rebuidPackage:keyApp];
            
            //[NSThread detachNewThreadSelector:@selector(rebuidPackage:) toTarget:self withObject:keyApp];
            
            //[[NSFileManager defaultManager] createDirectoryAtPath:documentPath withIntermediateDirectories:NO attributes:nil error:nil];
			//[[NSFileManager defaultManager] createDirectoryAtPath:createdFolder withIntermediateDirectories:NO attributes:nil error:nil];
        }
		else if([urlString hasPrefix:@"depiction"]){
			
			NSMutableString *keyApp = [[NSMutableString alloc] initWithString:urlString];
			[keyApp replaceOccurrencesOfString:@"depiction:" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
			
			
				AppDetailViewController *aAppDetail = [[AppDetailViewController alloc] initWithNibName:@"AppDetailViewController" bundle:nil];
				self.appDetailViewController = aAppDetail;
				[aAppDetail release];
			
			appDetailViewController.title = @"Depiction";
			UIWebView *uneWebView;
			uneWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];//init and create the UIWebView
			uneWebView.autoresizesSubviews = YES;
			uneWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
			[uneWebView setDelegate:self];
			
			NSURL *urlD = [NSURL URLWithString:keyApp];
			NSURLRequest *requestObj = [NSURLRequest requestWithURL:urlD];
			[uneWebView loadRequest:requestObj];
			
			[appDetailViewController.view addSubview:uneWebView];
			
			appinfoAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
			[delegate.packageNavController pushViewController:appDetailViewController animated:YES];
			
			[keyApp release];
			return NO;
		}
		else if([urlString hasPrefix:@"homepage"]){
			
			NSMutableString *keyApp = [[NSMutableString alloc] initWithString:urlString];
			[keyApp replaceOccurrencesOfString:@"homepage:" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
			
			
			AppDetailViewController *aAppDetail = [[AppDetailViewController alloc] initWithNibName:@"AppDetailViewController" bundle:nil];
			self.appDetailViewController = aAppDetail;
			[aAppDetail release];
			
			appDetailViewController.title = @"Homepage";
			UIWebView *uneWebView;
			uneWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];//init and create the UIWebView
			uneWebView.autoresizesSubviews = YES;
			uneWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
			[uneWebView setDelegate:self];
			
			NSURL *urlD = [NSURL URLWithString:keyApp];
			NSURLRequest *requestObj = [NSURLRequest requestWithURL:urlD];
			[uneWebView loadRequest:requestObj];
			
			[appDetailViewController.view addSubview:uneWebView];
			
			appinfoAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
			[delegate.packageNavController pushViewController:appDetailViewController animated:YES];
			
			[keyApp release];
			return NO;
		}
		else if([urlString hasPrefix:@"listing"]){
			
            appinfoAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            
			NSMutableString *keyApp = [[NSMutableString alloc] initWithString:urlString];
			[keyApp replaceOccurrencesOfString:@"listing:" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [keyApp length])];
			
			
			AppDetailViewController *aAppDetail = [[AppDetailViewController alloc] initWithNibName:@"AppDetailViewController" bundle:nil];
			self.appDetailViewController = aAppDetail;
			[aAppDetail release];
			
			appDetailViewController.title = MyLocalizedString(@"_fichiersinstalles",@"");
			UIWebView *uneWebView;
			uneWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];//init and create the UIWebView
			uneWebView.autoresizesSubviews = YES;
			uneWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
			[uneWebView setDelegate:self];
			
			NSString *fileContenu = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.list",delegate.pathDpkgInfo, keyApp] encoding:NSUTF8StringEncoding error:nil];
			NSMutableString *fileContent = [[NSMutableString alloc] initWithString:fileContenu];
			[fileContent replaceOccurrencesOfString:@"\n" withString:@"<br />" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [fileContent length])];

			
			NSString *myHTML = [NSString stringWithFormat:@"<html><head><link href=\"Render.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body> <div id=\"WebApp\"><div id=\"iGroup\"><div class=\"iBlock\" style=\"margin-bottom:10px;\"><h1>%@</h1><p style=\"word-wrap: break-word;\">%@</p></div></div></div></body></html>",MyLocalizedString(@"_fichiersinstalles",@""),fileContent];
			
			NSString *path = [[NSBundle mainBundle] bundlePath];
			NSURL *baseURL = [NSURL fileURLWithPath:path];
			[uneWebView loadHTMLString:myHTML baseURL:baseURL];
			
			
			
			[appDetailViewController.view addSubview:uneWebView];
			
			
			[delegate.packageNavController pushViewController:appDetailViewController animated:YES];
			
			[keyApp release];
			return NO;
		}
	}
	
	return YES;
}

- (void) rebuidPackage:(NSString *) package{
    appinfoAppDelegate *delegate = [[UIApplication sharedApplication] delegate];

    NSString *fileContenu = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.list",delegate.pathDpkgInfo, package] encoding:NSUTF8StringEncoding error:nil];
    NSMutableString *fileContent = [[NSMutableString alloc] initWithString:fileContenu];
    NSArray *listfiles = [fileContent componentsSeparatedByString:@"\n"];
    NSString *version = @"";
    NSString *control = @"";
    for(id pck in dicoPackage){
        if([[NSString stringWithFormat:@"%@",[[dicoPackage valueForKey:pck] valueForKey:@"Package"]] compare:package] == NSOrderedSame){
            for(id label in [dicoPackage valueForKey:pck]){
                if([[NSString stringWithFormat:@"%@",[[dicoPackage valueForKey:pck] valueForKey:label]] compare:@""] != NSOrderedSame){
                    if([[NSString stringWithFormat:@"%@",label] compare:@"Status"] != NSOrderedSame){
                        control = [control stringByAppendingFormat:@"%@: %@\n",label,[[dicoPackage valueForKey:pck] valueForKey:label]];
                    }
                    if([[NSString stringWithFormat:@"%@",label] compare:@"Version"] == NSOrderedSame){
                        version = [NSString stringWithFormat:@"_%@",[[dicoPackage valueForKey:pck] valueForKey:label]];
                    }
                }
            }
        }
    }
    

    NSString *pathFolderAppInfo = delegate.pathAppInfoSavedFolder;
    [[NSFileManager defaultManager] createDirectoryAtPath:pathFolderAppInfo withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSString *documentPath = [NSString stringWithFormat:@"%@/deb",delegate.pathAppInfoSavedFolder];
    [[NSFileManager defaultManager] createDirectoryAtPath:documentPath withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSString *foldername = [NSString stringWithFormat:@"%@%@",package,version];
    const char *cmd;
    NSString *cmdString = @"";
    cmdString = [NSString stringWithFormat:@"mkdir %@",documentPath];
    cmd = [cmdString UTF8String];
    system(cmd);
    if([documentPath compare:@""] != NSOrderedSame && [foldername compare:@""] != NSOrderedSame){
        cmdString = [NSString stringWithFormat:@"rm -rf %@/%@/", documentPath, foldername];
        cmd = [cmdString UTF8String];
        system(cmd);
    }
    cmdString = [NSString stringWithFormat:@"mkdir %@/%@/", documentPath, foldername];
    cmd = [cmdString UTF8String];
    system(cmd);
    cmdString = [NSString stringWithFormat:@"mkdir %@/%@/DEBIAN", documentPath, foldername];
    cmd = [cmdString UTF8String];
    system(cmd);
    NSError *error;
    [control writeToFile:[NSString stringWithFormat:@"%@/%@/DEBIAN/control", documentPath, foldername] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    BOOL isDir;
    for(NSString *file in listfiles){
        if([file compare:@""] != NSOrderedSame){
            
            if([[NSFileManager defaultManager] fileExistsAtPath:file isDirectory:&isDir] && isDir){
                cmdString = [NSString stringWithFormat:@"mkdir %@/%@%@", documentPath, foldername,file];
            }
            else{
                cmdString = [NSString stringWithFormat:@"cp %@ %@/%@%@",file,documentPath, foldername,file];
            }
            cmd = [cmdString UTF8String];
            system(cmd);
        }
    }
    
    cmdString = [NSString stringWithFormat:@"dpkg-deb -b --nocheck %@/%@", documentPath, foldername];
    cmd = [cmdString UTF8String];
    system(cmd);
    
    if([documentPath compare:@""] != NSOrderedSame && [foldername compare:@""] != NSOrderedSame){
        cmdString = [NSString stringWithFormat:@"rm -rf %@/%@", documentPath, foldername];
        cmd = [cmdString UTF8String];
        system(cmd);
    }

    if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.deb",documentPath,foldername]] == YES){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:MyLocalizedString(@"_rebuildcompleted",@"") message:[NSString stringWithFormat:@"%@.deb %@ %@",foldername, MyLocalizedString(@"_createdin",@""), documentPath] delegate:nil cancelButtonTitle:MyLocalizedString(@"_fermer",@"") otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        [alert release];
        
        NSString *debpath = [NSString stringWithFormat:@"%@/%@.deb",documentPath,foldername];
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:debpath error:nil];
        NSDate *date = [attributes fileModificationDate];
        NSString *madate = [self stringFromDateIsoString:[NSString stringWithFormat:@"%@",date] withFormat:datetimeFormat];
        NSString *debsaved = [NSString stringWithFormat:@"%@ : %@",MyLocalizedString(@"_debsaved", @""),madate];
        NSString *js = [NSString stringWithFormat:@"document.getElementById('debsavedate').innerHTML = '%@'",debsaved];
        
        [aWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('debbyemail').style.display = 'block'"];
        [aWebView stringByEvaluatingJavaScriptFromString:js];
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:MyLocalizedString(@"_rebuildfailed",@"") message:[NSString stringWithFormat:@"%@ %@.deb",MyLocalizedString(@"_failedcreate",@""),foldername] delegate:nil cancelButtonTitle:MyLocalizedString(@"_fermer",@"") otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        [alert release];
    }

    
    UIView *v = [aWebView.superview viewWithTag:1];
    v.hidden = YES;
    [aWebView.superview bringSubviewToFront:v];
    [v removeFromSuperview];
    aWebView.superview.superview.userInteractionEnabled = YES;
}

- (void)exportAction:(id)sender{
	
    NSString *boutonOrder = @"";
    if(sortByDate){
        boutonOrder = MyLocalizedString(@"_trialpha",@"");
    }
    else{
        boutonOrder = MyLocalizedString(@"_tridate",@"");
    }
    
    NSString *boutonSimple = [NSString stringWithFormat:@"%@ - %@",MyLocalizedString(@"_export",@""),MyLocalizedString(@"_exportsimple",@"")];
    NSString *boutonDetails = [NSString stringWithFormat:@"%@ - %@",MyLocalizedString(@"_export",@""),MyLocalizedString(@"_exportdetails",@"")];
    
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:MyLocalizedString(@"_action",@"") delegate:self cancelButtonTitle:nil destructiveButtonTitle:MyLocalizedString(@"_annuler",@"") otherButtonTitles:boutonOrder,boutonSimple,boutonDetails, nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	actionSheet.destructiveButtonIndex = 0;
	[actionSheet showInView:self.parentViewController.tabBarController.view]; 
	[actionSheet release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
    NSArray *nomAppAlphaS = [[dicoSource allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	NSArray *nomAppAlpha;
    
	if(sortByDate){
        NSMutableArray *dictValues = [[dicoPackage allValues] mutableCopy];
        [dictValues autorelease]; //only needed for manual reference counting
        [dictValues sortUsingComparator: (NSComparator)^(NSDictionary *a, NSDictionary *b){
            NSString *key1 = [b objectForKey: @"date"];
            NSString *key2 = [a objectForKey: @"date"];
            return [key1 compare: key2];
        }];
        NSMutableArray *sortdate = [[NSMutableArray alloc] init];;
        for(id app in dictValues)[sortdate addObject:[app objectForKey:@"Name"]];
        nomAppAlpha = [sortdate copy];
        [sortdate release];
        sortdate = nil;
    }
    else{
        nomAppAlpha = [[dicoPackage allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    }
	
	if (buttonIndex == 1) {
        
        if(!sortByDateDispo){
            appinfoAppDelegate *delegate = (appinfoAppDelegate*)[[UIApplication sharedApplication] delegate];
            NSString *pathInfo = delegate.pathDpkgInfo;
            for(id package in dicoPackage){
                NSString *packagePackage = [NSString stringWithFormat:@"%@",[[dicoPackage objectForKey:package] objectForKey:@"Package"]];
                NSString *listfilePackagePath = [NSString stringWithFormat:@"%@/%@.list",pathInfo,packagePackage];
                NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:listfilePackagePath error:nil];
                NSDate *date = [attributes fileModificationDate];
                [[dicoPackage objectForKey:package] setObject:date forKey:@"date"];
            }
            sortByDateDispo = YES;
        }
        
        if(sortByDate){
            sortByDate = NO;
        }
        else{
            sortByDate = YES;
        }
        [packageTableView reloadData];
    }
    if (buttonIndex == 2) {
		
		
		NSMutableArray *arraySimpleS = [[NSMutableArray alloc] init];
		
		for(id appS in nomAppAlphaS){		
			NSString *erasedtext = @"";
            if([[[dicoSource objectForKey:appS] objectForKey:@"erased"] boolValue]){
                erasedtext = @"<span style=\"color:#B22222;\">Source deleted !!</span>";
            }
			NSString *infoSimple = @"";
			infoSimple = [infoSimple stringByAppendingString:[NSString stringWithFormat:@"<b>%@</b><br />%@ (%@)<br /><br />\n",[[dicoSource objectForKey:appS] objectForKey:@"Origin"], [[dicoSource objectForKey:appS] objectForKey:@"Url"],erasedtext ] ];
			[arraySimpleS addObject:infoSimple];
		}
		
		
		NSMutableArray *arraySimple = [[NSMutableArray alloc] init];
		
		for(id app in nomAppAlpha){		
			
			NSString *infoSimple = @"";
			infoSimple = [infoSimple stringByAppendingString:[NSString stringWithFormat:@"<b>%@</b> - %@<br />\n",[[dicoPackage objectForKey:app] objectForKey:@"Name"], [[dicoPackage objectForKey:app] objectForKey:@"Version"] ] ];
			[arraySimple addObject:infoSimple];
		}
		
		
		NSString *exportSimple = @"<h3>Sources</h3>";
		
		for(id value in arraySimpleS){
			exportSimple = [exportSimple stringByAppendingString:value];
		}
		
		exportSimple = [exportSimple stringByAppendingString:@"<h3>Packages</h3>"];
		
		for(id value in arraySimple){
			exportSimple = [exportSimple stringByAppendingString:value];
		}
		
		[arraySimple release];
		
		[self  pushEmail:(self.emailUser) andSubject:[NSString stringWithFormat:MyLocalizedString(@"_exportmailsimple",@""),MyLocalizedString(@"_packages",@"")] andBody:[NSString stringWithFormat:@"%@", exportSimple]];
	}
	
	if (buttonIndex == 3) {
		
		NSMutableArray *arrayFullS = [[NSMutableArray alloc] init];
		
		for(id appS in nomAppAlphaS){
			
            
            NSString *erasedtext = @"";
            if([[[dicoSource objectForKey:appS] objectForKey:@"erased"] boolValue]){
                erasedtext = @"<span style=\"color:#B22222;\">Source deleted !!</span><br />";
            }
            
			NSString *infoPackage = @"";
			infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<h4>%@</h4>\n %@",[[dicoSource objectForKey:appS] objectForKey:@"Origin"],erasedtext]];
			
			//Url Origin Label Suite Version Codename Architectures Components Description
            
			NSString *packagePackage = [NSString stringWithFormat:@"%@",[[dicoSource objectForKey:appS] objectForKey:@"Url"]];
			if([packagePackage compare:@""] != NSOrderedSame)
				infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Url :</b> %@<br />",[[dicoSource objectForKey:appS] objectForKey:@"Url"]]];
			
			packagePackage = [NSString stringWithFormat:@"%@",[[dicoSource objectForKey:appS] objectForKey:@"Description"]];
			if([packagePackage compare:@""] != NSOrderedSame)
				infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Description :</b> %@<br />",[[dicoSource objectForKey:appS] objectForKey:@"Description"]]];
			
			packagePackage = [NSString stringWithFormat:@"%@",[[dicoSource objectForKey:appS] objectForKey:@"Label"]];
			if([packagePackage compare:@""] != NSOrderedSame)
				infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Label :</b> %@<br />",[[dicoSource objectForKey:appS] objectForKey:@"Label"]]];
			
			packagePackage = [NSString stringWithFormat:@"%@",[[dicoSource objectForKey:appS] objectForKey:@"Suite"]];
			if([packagePackage compare:@""] != NSOrderedSame)
				infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Suite :</b> %@<br />",[[dicoSource objectForKey:appS] objectForKey:@"Suite"]]];
			
			packagePackage = [NSString stringWithFormat:@"%@",[[dicoSource objectForKey:appS] objectForKey:@"Version"]];
			if([packagePackage compare:@""] != NSOrderedSame)
				infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Version :</b> %@<br />",[[dicoSource objectForKey:appS] objectForKey:@"Version"]]];
			
			packagePackage = [NSString stringWithFormat:@"%@",[[dicoSource objectForKey:appS] objectForKey:@"Codename"]];
			if([packagePackage compare:@""] != NSOrderedSame)
				infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Codename :</b> %@<br />",[[dicoSource objectForKey:appS] objectForKey:@"Codename"]]];
			
			packagePackage = [NSString stringWithFormat:@"%@",[[dicoSource objectForKey:appS] objectForKey:@"Architectures"]];
			if([packagePackage compare:@""] != NSOrderedSame)
				infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Architectures :</b> %@<br />",[[dicoSource objectForKey:appS] objectForKey:@"Architectures"]]];
			
			packagePackage = [NSString stringWithFormat:@"%@",[[dicoSource objectForKey:appS] objectForKey:@"Components"]];
			if([packagePackage compare:@""] != NSOrderedSame)
				infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Components :</b> %@<br />",[[dicoSource objectForKey:appS] objectForKey:@"Components"]]];
			
			[arrayFullS addObject:infoPackage];
			
		}
		
		NSMutableArray *arrayFull = [[NSMutableArray alloc] init];
		
		for(id app in nomAppAlpha){		
			
			NSString *infoPackage = @"";
			infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<h4>%@</h4>\n",[[dicoPackage objectForKey:app] objectForKey:@"Name"]]];
			//Name Package Section Maintainer Architecture Version Depends Size Description Sponsor Depiction Author Conflicts Homepage dev Tag Priority Installed-Size Replaces Provides Pre-Depends Essential Status
            
			
			NSString *packagePackage = [NSString stringWithFormat:@"%@",[[dicoPackage objectForKey:app] objectForKey:@"Description"]];
			if([packagePackage compare:@""] != NSOrderedSame)
				infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Description :</b> %@<br />",[[dicoPackage objectForKey:app] objectForKey:@"Description"]]];
			
			packagePackage = [NSString stringWithFormat:@"%@",[[dicoPackage objectForKey:app] objectForKey:@"Package"]];
			if([packagePackage compare:@""] != NSOrderedSame)
				infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Package :</b> %@<br />",[[dicoPackage objectForKey:app] objectForKey:@"Package"]]];
			
			packagePackage = [NSString stringWithFormat:@"%@",[[dicoPackage objectForKey:app] objectForKey:@"Version"]];
			if([packagePackage compare:@""] != NSOrderedSame)
				infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Version :</b> %@<br />",[[dicoPackage objectForKey:app] objectForKey:@"Version"]]];
			
            NSString *madate = [self stringFromDateIsoString:[NSString stringWithFormat:@"%@",[[dicoPackage objectForKey:app] objectForKey:@"date"]] withFormat:datetimeFormat];
            if([madate compare:@"(null)"] != NSOrderedSame)
                infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Date :</b> %@<br />",madate]];
            
			packagePackage = [NSString stringWithFormat:@"%@",[[dicoPackage objectForKey:app] objectForKey:@"Section"]];
			if([packagePackage compare:@""] != NSOrderedSame)
				infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Section :</b> %@<br />",[[dicoPackage objectForKey:app] objectForKey:@"Section"]]];
			
			packagePackage = [NSString stringWithFormat:@"%@",[[dicoPackage objectForKey:app] objectForKey:@"Author"]];
			if([packagePackage compare:@""] != NSOrderedSame)
				infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Author :</b> %@<br />",[[dicoPackage objectForKey:app] objectForKey:@"Author"]]];
			
			packagePackage = [NSString stringWithFormat:@"%@",[[dicoPackage objectForKey:app] objectForKey:@"Maintainer"]];
			if([packagePackage compare:@""] != NSOrderedSame)
				infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Maintainer :</b> %@<br />",[[dicoPackage objectForKey:app] objectForKey:@"Maintainer"]]];
			
			packagePackage = [NSString stringWithFormat:@"%@",[[dicoPackage objectForKey:app] objectForKey:@"Replaces"]];
			if([packagePackage compare:@""] != NSOrderedSame)
				infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Replaces :</b> %@<br />",[[dicoPackage objectForKey:app] objectForKey:@"Replaces"]]];
			
			packagePackage = [NSString stringWithFormat:@"%@",[[dicoPackage objectForKey:app] objectForKey:@"Depends"]];
			if([packagePackage compare:@""] != NSOrderedSame)
				infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Depends :</b> %@<br />",[[dicoPackage objectForKey:app] objectForKey:@"Depends"]]];
			
			packagePackage = [NSString stringWithFormat:@"%@",[[dicoPackage objectForKey:app] objectForKey:@"Pre-Depends"]];
			if([packagePackage compare:@""] != NSOrderedSame)
				infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Pre-Depends :</b> %@<br />",[[dicoPackage objectForKey:app] objectForKey:@"Pre-Depends"]]];
			
			packagePackage = [NSString stringWithFormat:@"%@",[[dicoPackage objectForKey:app] objectForKey:@"Conflicts"]];
			if([packagePackage compare:@""] != NSOrderedSame)
				infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Conflicts :</b> %@<br />",[[dicoPackage objectForKey:app] objectForKey:@"Conflicts"]]];
			
			packagePackage = [NSString stringWithFormat:@"%@",[[dicoPackage objectForKey:app] objectForKey:@"Provides"]];
			if([packagePackage compare:@""] != NSOrderedSame)
				infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Provides :</b> %@<br />",[[dicoPackage objectForKey:app] objectForKey:@"Provides"]]];
			
			packagePackage = [NSString stringWithFormat:@"%@",[[dicoPackage objectForKey:app] objectForKey:@"Architecture"]];
			if([packagePackage compare:@""] != NSOrderedSame)
				infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Architecture :</b> %@<br />",[[dicoPackage objectForKey:app] objectForKey:@"Architecture"]]];
			
			packagePackage = [NSString stringWithFormat:@"%@",[[dicoPackage objectForKey:app] objectForKey:@"Size"]];
			if([packagePackage compare:@""] != NSOrderedSame)
				infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Size :</b> %@<br />",[[dicoPackage objectForKey:app] objectForKey:@"Size"]]];
			
			packagePackage = [NSString stringWithFormat:@"%@",[[dicoPackage objectForKey:app] objectForKey:@"Installed-Size"]];
			if([packagePackage compare:@""] != NSOrderedSame)
				infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Installed-Size :</b> %@<br />",[[dicoPackage objectForKey:app] objectForKey:@"Installed-Size"]]];
			
			packagePackage = [NSString stringWithFormat:@"%@",[[dicoPackage objectForKey:app] objectForKey:@"Package"]];
			if([packagePackage compare:@""] != NSOrderedSame)
            infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Cydia link :</b> <a href=\"cydia://package/%@\">cydia://package/%@</a><br />",[[dicoPackage objectForKey:app] objectForKey:@"Package"],[[dicoPackage objectForKey:app] objectForKey:@"Package"]]];
            
            packagePackage = [NSString stringWithFormat:@"%@",[[dicoPackage objectForKey:app] objectForKey:@"Depiction"]];
			if([packagePackage compare:@""] != NSOrderedSame)
				infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Depiction :</b> <a href=\"%@\">%@</a><br />",[[dicoPackage objectForKey:app] objectForKey:@"Depiction"],[[dicoPackage objectForKey:app] objectForKey:@"Depiction"]]];
			
			packagePackage = [NSString stringWithFormat:@"%@",[[dicoPackage objectForKey:app] objectForKey:@"Homepage"]];
			if([packagePackage compare:@""] != NSOrderedSame)
				infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Homepage :</b> <a href=\"%@\">%@</a><br />",[[dicoPackage objectForKey:app] objectForKey:@"Homepage"],[[dicoPackage objectForKey:app] objectForKey:@"Homepage"]]];

			[arrayFull addObject:infoPackage];
		}
		

		NSString *exportContents = @"<h3>Sources</h3>";
		for(id value in arrayFullS){
			exportContents = [exportContents stringByAppendingString:value];
		}
		exportContents = [exportContents stringByAppendingString:@"<hr /><h3>Packages</h3>"];
		for(id value in arrayFull){
			exportContents = [exportContents stringByAppendingString:value];
		}
		[arrayFull release];
		
		[self  pushEmail:(self.emailUser) andSubject:[NSString stringWithFormat:MyLocalizedString(@"_exportmaildetails",@""),MyLocalizedString(@"_packages",@"")] andBody:[NSString stringWithFormat:@"%@", exportContents]];
	}
	
}

- (void)exportActionApp:(id)sender {
	
	//NSArray *nomApp = [dicoPackage allKeys];
    
    id value;
    
    if(sortByDate){
        NSMutableArray *dictValues = [[dicoPackage allValues] mutableCopy];
        [dictValues autorelease]; //only needed for manual reference counting
        [dictValues sortUsingComparator: (NSComparator)^(NSDictionary *a, NSDictionary *b){
            NSString *key1 = [b objectForKey: @"date"];
            NSString *key2 = [a objectForKey: @"date"];
            return [key1 compare: key2];
        }];
        value = [dicoPackage objectForKey:[[dictValues objectAtIndex:[sender tag]] objectForKey:@"Name"]];
    }
    else{
        NSArray *nomAppAlpha = [[dicoPackage allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        value = [dicoPackage objectForKey:[nomAppAlpha objectAtIndex:[sender tag]]];
    }
    
	
	NSString *infoPackage = @"";
	//Name Package Section Maintainer Architecture Version Depends Size Description Sponsor Depiction Author Conflicts Homepage dev Tag Priority Installed-Size Replaces Provides Pre-Depends Essential Status
	
	NSString *packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Description"]];
	if([packagePackage compare:@""] != NSOrderedSame)
		infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Description :</b> %@<br />",[value objectForKey:@"Description"]]];
	
	packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Package"]];
	if([packagePackage compare:@""] != NSOrderedSame)
		infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Package :</b> %@<br />",[value objectForKey:@"Package"]]];
	
	packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Version"]];
	if([packagePackage compare:@""] != NSOrderedSame)
		infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Version :</b> %@<br />",[value objectForKey:@"Version"]]];
	
	packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Section"]];
	if([packagePackage compare:@""] != NSOrderedSame)
		infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Section :</b> %@<br />",[value objectForKey:@"Section"]]];
	
	packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Author"]];
	if([packagePackage compare:@""] != NSOrderedSame)
		infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Author :</b> %@<br />",[value objectForKey:@"Author"]]];
	
	packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Maintainer"]];
	if([packagePackage compare:@""] != NSOrderedSame)
		infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Maintainer :</b> %@<br />",[value objectForKey:@"Maintainer"]]];
	
	packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Replaces"]];
	if([packagePackage compare:@""] != NSOrderedSame)
		infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Replaces :</b> %@<br />",[value objectForKey:@"Replaces"]]];
	
	packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Depends"]];
	if([packagePackage compare:@""] != NSOrderedSame)
		infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Depends :</b> %@<br />",[value objectForKey:@"Depends"]]];
	
	packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Pre-Depends"]];
	if([packagePackage compare:@""] != NSOrderedSame)
		infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Pre-Depends :</b> %@<br />",[value objectForKey:@"Pre-Depends"]]];
	
	packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Conflicts"]];
	if([packagePackage compare:@""] != NSOrderedSame)
		infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Conflicts :</b> %@<br />",[value objectForKey:@"Conflicts"]]];
	
	packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Provides"]];
	if([packagePackage compare:@""] != NSOrderedSame)
		infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Provides :</b> %@<br />",[value objectForKey:@"Provides"]]];
	
	packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Architecture"]];
	if([packagePackage compare:@""] != NSOrderedSame)
		infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Architecture :</b> %@<br />",[value objectForKey:@"Architecture"]]];
	
	packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Size"]];
	if([packagePackage compare:@""] != NSOrderedSame)
		infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Size :</b> %@<br />",[value objectForKey:@"Size"]]];
	
	packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Installed-Size"]];
	if([packagePackage compare:@""] != NSOrderedSame)
		infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Installed-Size :</b> %@<br />",[value objectForKey:@"Installed-Size"]]];

	packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Package"]];
    if([packagePackage compare:@""] != NSOrderedSame)
    infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Cydia link :</b> <a href=\"cydia://package/%@\">cydia://package/%@</a><br />",[value objectForKey:@"Package"],[value objectForKey:@"Package"]]];
    
	packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Depiction"]];
	if([packagePackage compare:@""] != NSOrderedSame)
		infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Depiction :</b> <a href=\"%@\">%@</a><br />",[value objectForKey:@"Depiction"],[value objectForKey:@"Depiction"]]];
	
	packagePackage = [NSString stringWithFormat:@"%@",[value objectForKey:@"Homepage"]];
	if([packagePackage compare:@""] != NSOrderedSame)
		infoPackage = [infoPackage stringByAppendingString:[NSString stringWithFormat:@"<b>Homepage :</b> <a href=\"%@\">%@</a><br />",[value objectForKey:@"Homepage"],[value objectForKey:@"Homepage"]]];
	
	
	NSString *myHTML = [NSString stringWithFormat:@"<h3>%@</h3><p>%@</p>",[value objectForKey:@"Name"],infoPackage];
	
	
	
	[self  pushEmail:(self.emailUser) andSubject:[NSString stringWithFormat:@"%@ - AppInfo",[value objectForKey:@"Name"]] andBody:myHTML];
	
}	

-(NSString *)stringFromDateIsoString:(NSString *)dateString withFormat:(NSString *)formater{
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
    [datetimeFormat release];
	[packageTableView release];
	[aWebView release];
	[unitUser release];
	[emailUser release];
    [pathCydia release];
	[appDetailViewController release];
	[dicoPackage release];
	[dicoSource release];
    [super dealloc];
}


@end

