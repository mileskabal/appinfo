//
//  SpringboardTableViewController.m
//  appinfo
//
//  Created by Miles on 21/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SpringboardTableViewController.h"
#import "CustomCell.h"
#import "ALSystem.h"
#import "appinfoAppDelegate.h"
#import "AppDetailViewController.h"
#import "AppiTableViewController.h"
#import "AppleTableViewController.h"
#import "WebappTableViewController.h"
#import "IbooksTableViewController.h"
#import "ContactsTableViewController.h"
#import "SmsTableViewController.h"
#import "CalendrierTableViewController.h"
#import "NotesTableViewController.h"
#import "RemindersViewController.h"

@implementation SpringboardTableViewController

@synthesize springboardTableView;
@synthesize rubrique;
@synthesize emailUser;

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

    
	self.navigationItem.title = @"AppInfo";
	
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"Springboard";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];
	
    NSString *device = [NSString stringWithFormat:MyLocalizedString(@"__mydevice",@""),[ALHardware platformType]];
	NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:device,@"Cydia",MyLocalizedString(@"_systeme",@""),@"WebApp",MyLocalizedString(@"_contacts",@""),MyLocalizedString(@"_messages",@""),MyLocalizedString(@"_calendrier",@""),MyLocalizedString(@"_rappels",@""),MyLocalizedString(@"_notes",@""),@"iBooks", nil]; //@"My Device",
	self.rubrique = array;
	[array release];
	
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
    
	//@"Cydia",@"System",@"WebApp",@"Contacts",@"Messages",@"Calendrier",@"Notes",@"iBooks"
	
	NSString *iconePath = @"";
    if(indexPath.row == 0){
		iconePath = @"mydevice.png";
	}
	else if(indexPath.row == 1){
		iconePath = @"cydia.png";
	}
	else if(indexPath.row == 2){
		iconePath = @"appleapple.png";
	}
	else if(indexPath.row == 3){
		iconePath = @"safari.png";
	}
	else if(indexPath.row == 4){
		iconePath = @"contacts.png";
	}
	else if(indexPath.row == 5){
		iconePath = @"sms.png";
	}
	else if(indexPath.row == 6){
		iconePath = @"calendrier.png";
	}
    else if(indexPath.row == 7){
		iconePath = @"reminders.png";
	}
	else if(indexPath.row == 8){
		iconePath = @"notes.png";
	}
	else if(indexPath.row == 9){
		iconePath = @"ibooks.png";
	}
    else{
		iconePath = @"Icon.png";
	}
	
	UIImage *image;
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",path,iconePath]];
    image = [[UIImage alloc] initWithData:data];
    cell.myImageView.image = image;

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	[image release];
	image = nil;
	
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
	
	//@"Cydia",@"System",@"WebApp",@"Contacts",@"Messages",@"Calendrier",@"Notes",@"iBooks"
	
    if(indexPath.row == 0){
        
        NSArray *sectionInfoKeys = [[[NSArray alloc] initWithObjects:@"hardware",@"processor",@"memory",@"disk", @"network", @"battery", @"carrier", @"localization", @"accessories", nil] autorelease];
        NSMutableDictionary *sectionDetailsKeys = [[[NSMutableDictionary alloc] init] autorelease];
        NSArray *hardwareKeys = [[[NSArray alloc] initWithObjects:@"deviceModel",@"platformType",@"deviceName",@"systemName",@"systemVersion",@"screenWidth",@"screenHeight",@"brightness",@"bootTime",@"proximitySensor",@"multitaskingEnabled",@"sim",@"dimensions",@"weight",@"displayType",@"displayDensity",@"WLAN",@"bluetooth",@"cameraPrimary",@"cameraSecondary",@"cpu",@"gpu",@"siri",@"touchID",nil] autorelease];
        NSArray *processorKeys = [[[NSArray alloc] initWithObjects:@"processorsNumber",@"activeProcessorsNumber",@"cpuUsageForApp",@"numberOfActiveProcesses",nil] autorelease];
        NSArray *memoryKeys = [[[NSArray alloc] initWithObjects:@"totalMemory",@"freeMemory",@"usedMemory",@"activeMemory",@"wiredMemory",@"inactiveMemory",nil] autorelease];
        NSArray *diskKeys = [[[NSArray alloc] initWithObjects:@"totalDiskSpace",@"freeDiskSpace",@"usedDiskSpace",nil] autorelease];
        NSArray *networkKeys = [[[NSArray alloc] initWithObjects:@"currentIPAddress",@"connectedViaWiFi",@"connectedVia3G",@"macAddress",@"externalIPAddress",@"WiFiNetmaskAddress",@"WiFiBroadcastAddress",nil] autorelease];
        NSArray *batteryKeys = [[[NSArray alloc] initWithObjects:@"batteryFullCharged",@"inCharge",@"devicePluggedIntoPower",@"batteryState",@"batteryLevel",@"remainingHoursForStandby",@"remainingHoursFor3gConversation",@"remainingHoursFor2gConversation",@"remainingHoursForInternet3g",@"remainingHoursForInternetWiFi",@"remainingHoursForVideo",@"remainingHoursForAudio",nil] autorelease];
        NSArray *carrierKeys = [[[NSArray alloc] initWithObjects:@"carrierName",@"carrierISOCountryCode",@"carrierMobileCountryCode",@"carrierMobileNetworkCode",@"carrierAllowsVOIP",nil] autorelease];
        NSArray *localizationKeys = [[[NSArray alloc] initWithObjects:@"language",@"timeZone",@"currencySymbol",@"currencyCode",@"country",@"measurementSystem",nil] autorelease];
        NSArray *accessoriesKeys = [[[NSArray alloc] initWithObjects:@"accessoriesPluggedIn",@"numberOfAccessoriesPluggedIn",@"isHeadphonesAttached",nil] autorelease];
        [sectionDetailsKeys setObject:hardwareKeys forKey:@"hardware"];
        [sectionDetailsKeys setObject:processorKeys forKey:@"processor"];
        [sectionDetailsKeys setObject:memoryKeys forKey:@"memory"];
        [sectionDetailsKeys setObject:diskKeys forKey:@"disk"];
        [sectionDetailsKeys setObject:networkKeys forKey:@"network"];
        [sectionDetailsKeys setObject:batteryKeys forKey:@"battery"];
        [sectionDetailsKeys setObject:carrierKeys forKey:@"carrier"];
        [sectionDetailsKeys setObject:localizationKeys forKey:@"localization"];
        [sectionDetailsKeys setObject:accessoriesKeys forKey:@"accessories"];
        
        NSDictionary *deviceInfo = [self getDeviceInfo];
        NSString *deviceInfoHtml = @"";
        for(id typeinfo in sectionInfoKeys){
            NSString *lgkey = [NSString stringWithFormat:@"__%@",typeinfo];
            deviceInfoHtml = [deviceInfoHtml stringByAppendingFormat:@"<h1 style=\"position:relative;padding-left:20px;\"><img src=\"device_%@.png\" style=\"position:absolute; top: -6px;left: -7px;width:30px\"/>%@</h1><p style=\"margin-bottom:10px;\">",typeinfo,MyLocalizedString(lgkey, @"")];
            if([deviceInfo objectForKey:typeinfo]){
                if([sectionDetailsKeys objectForKey:typeinfo]){
                    for(id infos in [sectionDetailsKeys objectForKey:typeinfo]){
                        if([[NSString stringWithFormat:@"%@",infos] compare:@"remainingHoursForStandby"] == NSOrderedSame){
                            deviceInfoHtml = [deviceInfoHtml stringByAppendingFormat:@"<b>- %@</b><br />", MyLocalizedString(@"__remainingHours", @"")];
                        }
                        NSString *lkey = [NSString stringWithFormat:@"__%@",infos];
                        deviceInfoHtml = [deviceInfoHtml stringByAppendingFormat:@"<b>%@:</b> %@<br />", MyLocalizedString(lkey, @""), [[deviceInfo objectForKey:typeinfo] objectForKey:infos]];
                        if([[NSString stringWithFormat:@"%@",infos] compare:@"numberOfActiveProcesses"] == NSOrderedSame){
                            deviceInfoHtml = [deviceInfoHtml stringByAppendingFormat:@"<span style=\"position:relative;padding-left:25px;\"><img src=\"device_processor.png\" style=\"width:25px;position:absolute; top: -2px;left: -3px;\"/> <a href=\"process:\">%@</a></span>",MyLocalizedString(@"_viewallprocess", @"")];
                        }
                    }
                }
            }
            deviceInfoHtml = [deviceInfoHtml stringByAppendingFormat:@"</p>"];
        }
        
        NSString *myHTML = [NSString stringWithFormat:@"<html><head><link href=\"Render.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body> <div id=\"WebApp\"><div id=\"iGroup\"><div class=\"iBlock\" style=\"margin-bottom:10px;\">%@</div></p></div></div></body></html>",deviceInfoHtml];
        
        AppDetailViewController *appDetailViewController = [[AppDetailViewController alloc] initWithNibName:@"AppDetailViewController" bundle:nil];
        NSString *device = [NSString stringWithFormat:MyLocalizedString(@"__mydevice",@""),[ALHardware platformType]];
        appDetailViewController.title = device;
        
        UIWebView *aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];//init and create the UIWebView
        aWebView.autoresizesSubviews = YES;
        aWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        aWebView.delegate = self;
        [aWebView loadHTMLString:myHTML baseURL:baseURL];
        [appDetailViewController.view addSubview:aWebView];
        [aWebView release];
        aWebView = nil;
        //alsystem = nil;
        deviceInfoHtml = nil;
        myHTML = nil;
        
        UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] init];
        exportButton.title = MyLocalizedString(@"_export",@"");
        appDetailViewController.navigationItem.rightBarButtonItem = exportButton;
        [exportButton setTarget:self];
        [exportButton setAction:@selector(exportAction:)];
        [exportButton release];
        
        
        [self.navigationController pushViewController:appDetailViewController animated:YES];
        [appDetailViewController release];
        appDetailViewController = nil;
    }
	else if(indexPath.row == 1){
		AppiTableViewController *apiViewCont = [[AppiTableViewController alloc] initWithNibName:@"AppiTableView" bundle:nil];
		apiViewCont.tableView.delegate = apiViewCont;
		apiViewCont.tableView.dataSource = apiViewCont;
		[self.navigationController pushViewController:apiViewCont animated:YES];
		[apiViewCont release];
		
	}
	else if(indexPath.row == 2){
		AppleTableViewController *apiViewCont = [[AppleTableViewController alloc] initWithNibName:@"AppleTableView" bundle:nil];
		apiViewCont.tableView.delegate = apiViewCont;
		apiViewCont.tableView.dataSource = apiViewCont;
		[self.navigationController pushViewController:apiViewCont animated:YES];
		[apiViewCont release];
	}
	else if(indexPath.row == 3){
		WebappTableViewController *apiViewCont = [[WebappTableViewController alloc] initWithNibName:@"WebappTableView" bundle:nil];
		apiViewCont.tableView.delegate = apiViewCont;
		apiViewCont.tableView.dataSource = apiViewCont;
		[self.navigationController pushViewController:apiViewCont animated:YES];
		[apiViewCont release];
	}
	else if(indexPath.row == 4){
		ContactsTableViewController *apiViewCont = [[ContactsTableViewController alloc] initWithNibName:@"ContactsTableView" bundle:nil];
		apiViewCont.tableView.delegate = apiViewCont;
		apiViewCont.tableView.dataSource = apiViewCont;
		[self.navigationController pushViewController:apiViewCont animated:YES];
		[apiViewCont release];
	}
	else if(indexPath.row == 5){
		SmsTableViewController *apiViewCont = [[SmsTableViewController alloc] initWithNibName:@"SmsTableView" bundle:nil];
		apiViewCont.tableView.delegate = apiViewCont;
		apiViewCont.tableView.dataSource = apiViewCont;
		[self.navigationController pushViewController:apiViewCont animated:YES];
		[apiViewCont release];
	}
	else if(indexPath.row == 6){
		CalendrierTableViewController *apiViewCont = [[CalendrierTableViewController alloc] initWithNibName:@"CalendrierTableView" bundle:nil];
		apiViewCont.tableView.delegate = apiViewCont;
		apiViewCont.tableView.dataSource = apiViewCont;
		[self.navigationController pushViewController:apiViewCont animated:YES];
		[apiViewCont release];
	}
    else if(indexPath.row == 7){
        RemindersViewController *apiViewCont = [[RemindersViewController alloc] initWithNibName:@"RemindersViewController" bundle:nil];
		apiViewCont.tableView.delegate = apiViewCont;
		apiViewCont.tableView.dataSource = apiViewCont;
		[self.navigationController pushViewController:apiViewCont animated:YES];
		[apiViewCont release];
	}
	else if(indexPath.row == 8){
		NotesTableViewController *apiViewCont = [[NotesTableViewController alloc] initWithNibName:@"NotesTableView" bundle:nil];
		apiViewCont.tableView.delegate = apiViewCont;
		apiViewCont.tableView.dataSource = apiViewCont;
		[self.navigationController pushViewController:apiViewCont animated:YES];
		[apiViewCont release];
	}
	else if(indexPath.row == 9){
		IbooksTableViewController *apiViewCont = [[IbooksTableViewController alloc] initWithNibName:@"IbooksTableView" bundle:nil];
		apiViewCont.tableView.delegate = apiViewCont;
		apiViewCont.tableView.dataSource = apiViewCont;
		[self.navigationController pushViewController:apiViewCont animated:YES];
		[apiViewCont release];
	}
}

#pragma mark -
#pragma mark Other Functions
- (void)exportAction:(id)sender{
    NSArray *sectionInfoKeys = [[[NSArray alloc] initWithObjects:@"hardware",@"processor",@"memory",@"disk", @"network", @"battery", @"carrier", @"localization", @"accessories", nil] autorelease];
    NSMutableDictionary *sectionDetailsKeys = [[[NSMutableDictionary alloc] init] autorelease];
    NSArray *hardwareKeys = [[[NSArray alloc] initWithObjects:@"deviceModel",@"platformType",@"deviceName",@"systemName",@"systemVersion",@"screenWidth",@"screenHeight",@"brightness",@"bootTime",@"proximitySensor",@"multitaskingEnabled",@"sim",@"dimensions",@"weight",@"displayType",@"displayDensity",@"WLAN",@"bluetooth",@"cameraPrimary",@"cameraSecondary",@"cpu",@"gpu",@"siri",@"touchID",nil] autorelease];
    NSArray *processorKeys = [[[NSArray alloc] initWithObjects:@"processorsNumber",@"activeProcessorsNumber",@"cpuUsageForApp",@"numberOfActiveProcesses",nil] autorelease];
    NSArray *memoryKeys = [[[NSArray alloc] initWithObjects:@"totalMemory",@"freeMemory",@"usedMemory",@"activeMemory",@"wiredMemory",@"inactiveMemory",nil] autorelease];
    NSArray *diskKeys = [[[NSArray alloc] initWithObjects:@"totalDiskSpace",@"freeDiskSpace",@"usedDiskSpace",nil] autorelease];
    NSArray *networkKeys = [[[NSArray alloc] initWithObjects:@"currentIPAddress",@"connectedViaWiFi",@"connectedVia3G",@"macAddress",@"externalIPAddress",@"WiFiNetmaskAddress",@"WiFiBroadcastAddress",nil] autorelease];
    NSArray *batteryKeys = [[[NSArray alloc] initWithObjects:@"batteryFullCharged",@"inCharge",@"devicePluggedIntoPower",@"batteryState",@"batteryLevel",@"remainingHoursForStandby",@"remainingHoursFor3gConversation",@"remainingHoursFor2gConversation",@"remainingHoursForInternet3g",@"remainingHoursForInternetWiFi",@"remainingHoursForVideo",@"remainingHoursForAudio",nil] autorelease];
    NSArray *carrierKeys = [[[NSArray alloc] initWithObjects:@"carrierName",@"carrierISOCountryCode",@"carrierMobileCountryCode",@"carrierMobileNetworkCode",@"carrierAllowsVOIP",nil] autorelease];
    NSArray *localizationKeys = [[[NSArray alloc] initWithObjects:@"language",@"timeZone",@"currencySymbol",@"currencyCode",@"country",@"measurementSystem",nil] autorelease];
    NSArray *accessoriesKeys = [[[NSArray alloc] initWithObjects:@"accessoriesPluggedIn",@"numberOfAccessoriesPluggedIn",@"isHeadphonesAttached",nil] autorelease];
    [sectionDetailsKeys setObject:hardwareKeys forKey:@"hardware"];
    [sectionDetailsKeys setObject:processorKeys forKey:@"processor"];
    [sectionDetailsKeys setObject:memoryKeys forKey:@"memory"];
    [sectionDetailsKeys setObject:diskKeys forKey:@"disk"];
    [sectionDetailsKeys setObject:networkKeys forKey:@"network"];
    [sectionDetailsKeys setObject:batteryKeys forKey:@"battery"];
    [sectionDetailsKeys setObject:carrierKeys forKey:@"carrier"];
    [sectionDetailsKeys setObject:localizationKeys forKey:@"localization"];
    [sectionDetailsKeys setObject:accessoriesKeys forKey:@"accessories"];
    
    NSDictionary *deviceInfo = [self getDeviceInfo];
    NSString *deviceInfoHtml = @"";
    for(id typeinfo in sectionInfoKeys){
        NSString *lgkey = [NSString stringWithFormat:@"__%@",typeinfo];
        deviceInfoHtml = [deviceInfoHtml stringByAppendingFormat:@"<h2>%@</h2><p style=\"margin-bottom:10px;\">\n",MyLocalizedString(lgkey, @"")];
        if([deviceInfo objectForKey:typeinfo]){
            if([sectionDetailsKeys objectForKey:typeinfo]){
                for(id infos in [sectionDetailsKeys objectForKey:typeinfo]){
                    if([[NSString stringWithFormat:@"%@",infos] compare:@"remainingHoursForStandby"] == NSOrderedSame){
                        deviceInfoHtml = [deviceInfoHtml stringByAppendingFormat:@"<b>- %@</b><br />", MyLocalizedString(@"__remainingHours", @"")];
                    }
                    NSString *lkey = [NSString stringWithFormat:@"__%@",infos];
                    deviceInfoHtml = [deviceInfoHtml stringByAppendingFormat:@"<b>%@:</b> %@<br />\n", MyLocalizedString(lkey, @""), [[deviceInfo objectForKey:typeinfo] objectForKey:infos]];
                }
            }
        }
        deviceInfoHtml = [deviceInfoHtml stringByAppendingFormat:@"</p>"];
    }
	
    [self  pushEmail:(self.emailUser) andSubject:[NSString stringWithFormat:MyLocalizedString(@"_exportmaildetails",@""),MyLocalizedString(@"__monappareil",@"")] andBody:deviceInfoHtml];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	
    NSURL *URL = [request URL];
	NSString *urlString = [URL absoluteString];
	if(navigationType == UIWebViewNavigationTypeLinkClicked) {
		if([urlString hasPrefix:@"process"]){
            
            AppDetailViewController *appDetailViewController = [[AppDetailViewController alloc] initWithNibName:@"AppDetailViewController" bundle:nil];
            appDetailViewController.title = MyLocalizedString(@"__processus",@"");
            
            UIWebView *aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];//init and create the UIWebView
            aWebView.autoresizesSubviews = YES;
            aWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
            NSString *path = [[NSBundle mainBundle] bundlePath];
            NSURL *baseURL = [NSURL fileURLWithPath:path];
            NSString *myHTML = @"";
            
            myHTML = [myHTML stringByAppendingString:@"<table><tr><th style=\"width:45px;text-align:left\">ID</th><th style=\"text-align:left\">Process</th></tr>"];
        
            for(int i = 0;i<[[ALProcessor activeProcesses] count];i++){
                myHTML = [myHTML stringByAppendingFormat:@"<tr><td  style=\"width:45px;text-align:left\">%@</td>",[[[ALProcessor activeProcesses] objectAtIndex:i] objectForKey:@"ProcessID"]];
                myHTML = [myHTML stringByAppendingFormat:@"<td style=\"text-align:left\">%@</td></tr>",[[[ALProcessor activeProcesses] objectAtIndex:i] objectForKey:@"ProcessName"]];
                i++;
            }
            
            myHTML = [myHTML stringByAppendingString:@"</table>"];
            
            NSString *myHTMLFinal = [NSString stringWithFormat:@"<html><head><link href=\"Render.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body> <div id=\"WebApp\"><div id=\"iGroup\"><div class=\"iBlock\" style=\"margin-bottom:10px;\"><h1>%@</h1><p>%@</p></div></div></div></body></html>",MyLocalizedString(@"__processus",@""),myHTML];
            
            
            aWebView.delegate = self;
            [aWebView loadHTMLString:myHTMLFinal baseURL:baseURL];
            [appDetailViewController.view addSubview:aWebView];
            [aWebView release];
            aWebView = nil;
            myHTML = nil;
            
            UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] init];
            exportButton.title = MyLocalizedString(@"_export",@"");
            appDetailViewController.navigationItem.rightBarButtonItem = exportButton;
            [exportButton setTarget:self];
            [exportButton setAction:@selector(exportActionProcess)];
            [exportButton release];
            
            [self.navigationController pushViewController:appDetailViewController animated:YES];
            [appDetailViewController release];
            appDetailViewController = nil;

		}
    }
    return YES;
}

- (void) exportActionProcess{
    NSString *myHTML = @"";
    for(int i = 0;i<[[ALProcessor activeProcesses] count];i++){
        myHTML = [myHTML stringByAppendingFormat:@"<b>ID:</b> %@ - <b>Process:</b> ",[[[ALProcessor activeProcesses] objectAtIndex:i] objectForKey:@"ProcessID"]];
        myHTML = [myHTML stringByAppendingFormat:@"%@<br />",[[[ALProcessor activeProcesses] objectAtIndex:i] objectForKey:@"ProcessName"]];
        i++;
    }
    [self  pushEmail:(self.emailUser) andSubject:[NSString stringWithFormat:MyLocalizedString(@"_exportmaildetails",@""),MyLocalizedString(@"__processus",@"")] andBody:myHTML];
}


- (NSDictionary *) getDeviceInfo{
    
    //Hardware
    NSMutableDictionary *hardware = [[[NSMutableDictionary alloc] init] autorelease];
    [hardware setObject:[NSString stringWithFormat:@"%@",[ALHardware deviceModel]] forKey:@"deviceModel"];
    [hardware setObject:[NSString stringWithFormat:@"%@",[ALHardware platformType]] forKey:@"platformType"];
    [hardware setObject:[NSString stringWithFormat:@"%@",[ALHardware deviceName]] forKey:@"deviceName"];
    [hardware setObject:[NSString stringWithFormat:@"%@",[ALHardware systemName]] forKey:@"systemName"];
    [hardware setObject:[NSString stringWithFormat:@"%@",[ALHardware systemVersion]] forKey:@"systemVersion"];
    [hardware setObject:[NSString stringWithFormat:@"%i",[ALHardware screenWidth]] forKey:@"screenWidth"];
    [hardware setObject:[NSString stringWithFormat:@"%i",[ALHardware screenHeight]] forKey:@"screenHeight"];
    [hardware setObject:[NSString stringWithFormat:@"%f",[ALHardware brightness]] forKey:@"brightness"];
    [hardware setObject:[NSString stringWithFormat:@"%@",[ALHardware bootTime]] forKey:@"bootTime"];
    [hardware setObject:[NSString stringWithFormat:@"%hhd",[ALHardware proximitySensor]] forKey:@"proximitySensor"];
    [hardware setObject:[NSString stringWithFormat:@"%hhd",[ALHardware multitaskingEnabled]] forKey:@"multitaskingEnabled"];
    [hardware setObject:[NSString stringWithFormat:@"%@",[ALHardware sim]] forKey:@"sim"];
    [hardware setObject:[NSString stringWithFormat:@"%@",[ALHardware dimensions]] forKey:@"dimensions"];
    [hardware setObject:[NSString stringWithFormat:@"%@",[ALHardware weight]] forKey:@"weight"];
    [hardware setObject:[NSString stringWithFormat:@"%@",[ALHardware displayType]] forKey:@"displayType"];
    [hardware setObject:[NSString stringWithFormat:@"%@",[ALHardware displayDensity]] forKey:@"displayDensity"];
    [hardware setObject:[NSString stringWithFormat:@"%@",[ALHardware WLAN]] forKey:@"WLAN"];
    [hardware setObject:[NSString stringWithFormat:@"%@",[ALHardware bluetooth]] forKey:@"bluetooth"];
    [hardware setObject:[NSString stringWithFormat:@"%@",[ALHardware cameraPrimary]] forKey:@"cameraPrimary"];
    [hardware setObject:[NSString stringWithFormat:@"%@",[ALHardware cameraSecondary]] forKey:@"cameraSecondary"];
    [hardware setObject:[NSString stringWithFormat:@"%@",[ALHardware cpu]] forKey:@"cpu"];
    [hardware setObject:[NSString stringWithFormat:@"%@",[ALHardware gpu]] forKey:@"gpu"];
    [hardware setObject:[NSString stringWithFormat:@"%hhd",[ALHardware siri]] forKey:@"siri"];
    [hardware setObject:[NSString stringWithFormat:@"%hhd",[ALHardware touchID]] forKey:@"touchID"];
    //Processor
    NSMutableDictionary *processor = [[[NSMutableDictionary alloc] init] autorelease];
    [processor setObject:[NSString stringWithFormat:@"%i",[ALProcessor processorsNumber]] forKey:@"processorsNumber"];
    [processor setObject:[NSString stringWithFormat:@"%i",[ALProcessor activeProcessorsNumber]] forKey:@"activeProcessorsNumber"];
    [processor setObject:[NSString stringWithFormat:@"%f",[ALProcessor cpuUsageForApp]] forKey:@"cpuUsageForApp"];
    [processor setObject:[NSString stringWithFormat:@"%i",[ALProcessor numberOfActiveProcesses]] forKey:@"numberOfActiveProcesses"];
    //[processor setObject:[ALProcessor activeProcesses] forKey:@"activeProcesses"];
    //Memory
    NSMutableDictionary *memory = [[[NSMutableDictionary alloc] init] autorelease];
    [memory setObject:[NSString stringWithFormat:@"%i",[ALMemory totalMemory]] forKey:@"totalMemory"];
    [memory setObject:[NSString stringWithFormat:@"%f",[ALMemory freeMemory]] forKey:@"freeMemory"];
    [memory setObject:[NSString stringWithFormat:@"%f",[ALMemory usedMemory]] forKey:@"usedMemory"];
    [memory setObject:[NSString stringWithFormat:@"%f",[ALMemory activeMemory]] forKey:@"activeMemory"];
    [memory setObject:[NSString stringWithFormat:@"%f",[ALMemory wiredMemory]] forKey:@"wiredMemory"];
    [memory setObject:[NSString stringWithFormat:@"%f",[ALMemory inactiveMemory]] forKey:@"inactiveMemory"];
    //Disk
    NSMutableDictionary *disk = [[[NSMutableDictionary alloc] init] autorelease];
    [disk setObject:[NSString stringWithFormat:@"%@",[ALDisk totalDiskSpace]] forKey:@"totalDiskSpace"];
    [disk setObject:[NSString stringWithFormat:@"%@",[ALDisk freeDiskSpace]] forKey:@"freeDiskSpace"];
    [disk setObject:[NSString stringWithFormat:@"%@",[ALDisk usedDiskSpace]] forKey:@"usedDiskSpace"];
    //Network
    NSMutableDictionary *network = [[[NSMutableDictionary alloc] init] autorelease];
    [network setObject:[NSString stringWithFormat:@"%@",[ALNetwork currentIPAddress]] forKey:@"currentIPAddress"];
    [network setObject:[NSString stringWithFormat:@"%hhd",[ALNetwork connectedViaWiFi]] forKey:@"connectedViaWiFi"];
    [network setObject:[NSString stringWithFormat:@"%hhd",[ALNetwork connectedVia3G]] forKey:@"connectedVia3G"];
    [network setObject:[NSString stringWithFormat:@"%@",[ALNetwork macAddress]] forKey:@"macAddress"];
    [network setObject:[NSString stringWithFormat:@"%@",[ALNetwork externalIPAddress]] forKey:@"externalIPAddress"];
    [network setObject:[NSString stringWithFormat:@"%@",[ALNetwork WiFiNetmaskAddress]] forKey:@"WiFiNetmaskAddress"];
    [network setObject:[NSString stringWithFormat:@"%@",[ALNetwork WiFiBroadcastAddress]] forKey:@"WiFiBroadcastAddress"];
    //Battery
    NSMutableDictionary *battery = [[[NSMutableDictionary alloc] init] autorelease];
    [battery setObject:[NSString stringWithFormat:@"%hhd",[ALBattery batteryFullCharged]] forKey:@"batteryFullCharged"];
    [battery setObject:[NSString stringWithFormat:@"%hhd",[ALBattery inCharge]] forKey:@"inCharge"];
    [battery setObject:[NSString stringWithFormat:@"%hhd",[ALBattery devicePluggedIntoPower]] forKey:@"devicePluggedIntoPower"];
    [battery setObject:[NSString stringWithFormat:@"%d",[ALBattery batteryState]] forKey:@"batteryState"];
    [battery setObject:[NSString stringWithFormat:@"%f",[ALBattery batteryLevel]] forKey:@"batteryLevel"];
    [battery setObject:[NSString stringWithFormat:@"%@",[ALBattery remainingHoursForStandby]] forKey:@"remainingHoursForStandby"];
    [battery setObject:[NSString stringWithFormat:@"%@",[ALBattery remainingHoursFor3gConversation]] forKey:@"remainingHoursFor3gConversation"];
    [battery setObject:[NSString stringWithFormat:@"%@",[ALBattery remainingHoursFor2gConversation]] forKey:@"remainingHoursFor2gConversation"];
    [battery setObject:[NSString stringWithFormat:@"%@",[ALBattery remainingHoursForInternet3g]] forKey:@"remainingHoursForInternet3g"];
    [battery setObject:[NSString stringWithFormat:@"%@",[ALBattery remainingHoursForInternetWiFi]] forKey:@"remainingHoursForInternetWiFi"];
    [battery setObject:[NSString stringWithFormat:@"%@",[ALBattery remainingHoursForVideo]] forKey:@"remainingHoursForVideo"];
    [battery setObject:[NSString stringWithFormat:@"%@",[ALBattery remainingHoursForAudio]] forKey:@"remainingHoursForAudio"];
    //Carrier
    NSMutableDictionary *carrier = [[[NSMutableDictionary alloc] init] autorelease];
    [carrier setObject:[NSString stringWithFormat:@"%@",[ALCarrier carrierName]] forKey:@"carrierName"];
    [carrier setObject:[NSString stringWithFormat:@"%@",[ALCarrier carrierISOCountryCode]] forKey:@"carrierISOCountryCode"];
    [carrier setObject:[NSString stringWithFormat:@"%@",[ALCarrier carrierMobileCountryCode]] forKey:@"carrierMobileCountryCode"];
    [carrier setObject:[NSString stringWithFormat:@"%@",[ALCarrier carrierMobileNetworkCode]] forKey:@"carrierMobileNetworkCode"];
    [carrier setObject:[NSString stringWithFormat:@"%hhd",[ALCarrier carrierAllowsVOIP]] forKey:@"carrierAllowsVOIP"];
    //Localization
    NSMutableDictionary *localization = [[[NSMutableDictionary alloc] init] autorelease];
    [localization setObject:[NSString stringWithFormat:@"%@",[ALLocalization language]] forKey:@"language"];
    [localization setObject:[NSString stringWithFormat:@"%@",[ALLocalization timeZone]] forKey:@"timeZone"];
    [localization setObject:[NSString stringWithFormat:@"%@",[ALLocalization currencySymbol]] forKey:@"currencySymbol"];
    [localization setObject:[NSString stringWithFormat:@"%@",[ALLocalization currencyCode]] forKey:@"currencyCode"];
    [localization setObject:[NSString stringWithFormat:@"%@",[ALLocalization country]] forKey:@"country"];
    [localization setObject:[NSString stringWithFormat:@"%@",[ALLocalization measurementSystem]] forKey:@"measurementSystem"];
    //Accessories
    NSMutableDictionary *accessories = [[[NSMutableDictionary alloc] init] autorelease];
    [accessories setObject:[NSString stringWithFormat:@"%hhd",[ALAccessory accessoriesPluggedIn]] forKey:@"accessoriesPluggedIn"];
    [accessories setObject:[NSString stringWithFormat:@"%i",[ALAccessory numberOfAccessoriesPluggedIn]] forKey:@"numberOfAccessoriesPluggedIn"];
    [accessories setObject:[NSString stringWithFormat:@"%hhd",[ALAccessory isHeadphonesAttached]] forKey:@"isHeadphonesAttached"];
    
    NSMutableDictionary *deviceinfos = [[[NSMutableDictionary alloc] init] autorelease];
    [deviceinfos setObject:hardware forKey:@"hardware"];
    [deviceinfos setObject:processor forKey:@"processor"];
    [deviceinfos setObject:memory forKey:@"memory"];
    [deviceinfos setObject:disk forKey:@"disk"];
    [deviceinfos setObject:network forKey:@"network"];
    [deviceinfos setObject:battery forKey:@"battery"];
    [deviceinfos setObject:carrier forKey:@"carrier"];
    [deviceinfos setObject:localization forKey:@"localization"];
    [deviceinfos setObject:accessories forKey:@"accessories"];
    
    return deviceinfos;
}
    
-(void)pushEmail:(NSString*)contactMail andSubject:(NSString*)sujetMail andBody:(NSString*)messageMail {
	
	MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
	mail.mailComposeDelegate = self;
    mail.navigationBar.tintColor = UIColorFromRGB(0x0B4E92);
	
	if ([MFMailComposeViewController canSendMail]) {
		[mail setToRecipients:[NSArray arrayWithObjects:contactMail,nil]];
		[mail setSubject:sujetMail];
		[mail setMessageBody:messageMail isHTML:YES];
        [self presentViewController:mail animated:YES completion:nil];
	}
	
	[mail release];
}
    
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	
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
	[rubrique release];
	[springboardTableView release];
    [super dealloc];
}


@end

