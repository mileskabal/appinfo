//
//  CalendrierTableViewController.m
//  appinfo
//
//  Created by Miles on 22/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalendrierTableViewController.h"
#import "appinfoAppDelegate.h"
#import "AppDetailViewController.h"
#import "CustomCell.h"

@implementation CalendrierTableViewController

@synthesize calTableView;
@synthesize aWebView;
@synthesize emailUser;
@synthesize dicoCalendar;
@synthesize dicoCalendarFiltered;
@synthesize id_calendar_event;
@synthesize calendarPath;
@synthesize calendar_id_hidden;
@synthesize calendar_id_all;
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
	
    self.datetimeFormat = [delegate.dateFormatter stringByAppendingString:@" - HH:mm"];
    
    
    self.navigationItem.title = MyLocalizedString(@"_calendrier",@"");
	
	UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] init];
	exportButton.title = MyLocalizedString(@"_action",@"");
	self.navigationItem.rightBarButtonItem = exportButton;
	[exportButton setTarget:self];
	[exportButton setAction:@selector(exportAction:)];
	[exportButton release]; 
	
    dicoCalendar = [[NSMutableArray alloc] init];
    dicoCalendarFiltered = [[NSMutableArray alloc] init];
	
	calendarPath = delegate.pathCalendar;
    id_calendar_event = @"";
	calendar_id_hidden = [[NSMutableArray alloc] init];
    calendar_id_all = [[NSMutableArray alloc] init];
    
	sqlite3 *database;
	
	if(sqlite3_open([calendarPath UTF8String], &database) == SQLITE_OK) {
		
        NSString *requeteInit = @"SELECT supported_entity_types FROM Calendar WHERE title='DEFAULT_CALENDAR_NAME'";
        const char *sqlStatementInit = [requeteInit cStringUsingEncoding:[NSString defaultCStringEncoding]];
        sqlite3_stmt *compiledStatementInit;
        if(sqlite3_prepare_v2(database, sqlStatementInit, -1, &compiledStatementInit, NULL) == SQLITE_OK) {
            if(sqlite3_step(compiledStatementInit) == SQLITE_ROW){
				const char* id_calendar_eventChar = (const char*)sqlite3_column_text(compiledStatementInit, 0);
				if(id_calendar_eventChar != NULL){
					id_calendar_event = [[NSString stringWithUTF8String:id_calendar_eventChar] retain];
				}
            }
        }
        NSString *requete = [NSString stringWithFormat:@"SELECT ci.ROWID, ci.summary,ci.location_id,ci.description,ci.start_date,ci.end_date, l.title, ci.calendar_id, c.title, c.supported_entity_types FROM CalendarItem ci LEFT JOIN Calendar c ON c.ROWID=ci.calendar_id LEFT JOIN Location l ON l.ROWID=ci.location_id WHERE c.supported_entity_types='%@' ORDER BY ci.start_date DESC",id_calendar_event];
		const char *sqlStatement = [requete cStringUsingEncoding:[NSString defaultCStringEncoding]];
		
		sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				
                NSString *rowid = @"";
				const char* rowidChar = (const char*)sqlite3_column_text(compiledStatement, 0);
				if(rowidChar != NULL){
					rowid = [NSString stringWithUTF8String:rowidChar];
				}
				
				NSString *nom = @"";
				const char* nomChar = (const char*)sqlite3_column_text(compiledStatement, 1);
				if(nomChar != NULL){
					nom = [NSString stringWithUTF8String:nomChar];
				}
                
				NSString *location = @"";
				const char* locationChar = (const char*)sqlite3_column_text(compiledStatement, 2);
				if(locationChar != NULL){
					location = [NSString stringWithUTF8String:locationChar];
				}
				
				NSString *description = @"";
				const char* descriptionChar = (const char*)sqlite3_column_text(compiledStatement, 3);
				if(descriptionChar != NULL){
					description = [NSString stringWithUTF8String:descriptionChar];
				}
				
				NSString *startdate = @"";
				const char* startdateChar = (const char*)sqlite3_column_text(compiledStatement, 4);
				if(startdateChar != NULL){
					startdate = [NSString stringWithUTF8String:startdateChar];
				}
				
				NSString *enddate = @"";
				const char* enddateChar = (const char*)sqlite3_column_text(compiledStatement, 5);
				if(enddateChar != NULL){
					enddate = [NSString stringWithUTF8String:enddateChar];
				}
				
                if([location compare:@"0"] != NSOrderedSame){
                    locationChar = (const char*)sqlite3_column_text(compiledStatement, 6);
                    if(locationChar != NULL){
                        location = [NSString stringWithUTF8String:locationChar];
                    }
                }
                NSString *cowid = @"";
				const char* cowidChar = (const char*)sqlite3_column_text(compiledStatement, 7);
				if(cowidChar != NULL){
					cowid = [NSString stringWithUTF8String:cowidChar];
				}
                
                if(![calendar_id_all containsObject: cowid]){
                    [calendar_id_all addObject:cowid];
                }
				
				NSMutableDictionary *app = [[NSMutableDictionary alloc] init];
				[app setObject:rowid forKey:@"rowid"];
                [app setObject:nom forKey:@"nom"];
				[app setObject:location forKey:@"location"];
				[app setObject:description forKey:@"description"];
				[app setObject:enddate forKey:@"enddate"];
				[app setObject:startdate forKey:@"startdate"];
                [app setObject:cowid forKey:@"cowid"];
                [dicoCalendar addObject:app];
				[app release];
				app = nil;
				
			}
		}
		
		sqlite3_finalize(compiledStatement);
		compiledStatement = nil;
		
	}
	sqlite3_close(database);
	database = nil;
    
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
    if([dicoCalendarFiltered count]){
        return [dicoCalendarFiltered count];
    }
    else{
        return [dicoCalendar count];
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

    id value;
    if([dicoCalendarFiltered count]){
        value = [dicoCalendarFiltered objectAtIndex:indexPath.row];
    }
    else{
        value = [dicoCalendar objectAtIndex:indexPath.row];
    }
       
	cell.primaryLabel.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"nom"]];
	
	/* dans mon cas il faut ajouter 978307200 au timestamp (31 ans) les dates sont 1980->2011 */
	//[inputFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
	//[outputFormatter setDateFormat:@"HH:mm 'on' EEEE MMMM d"];
	
    NSString *stringFromDate;
    if([[value objectForKey: @"startdate"]intValue]){
        int timestamp = [[value objectForKey: @"startdate"]intValue] + 978307200;
        NSDate *ladate = [NSDate dateWithTimeIntervalSince1970:timestamp];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:datetimeFormat];
        //[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
        stringFromDate = [formatter stringFromDate:ladate];
        [formatter release];
        ladate = nil;
    }
    else{
        stringFromDate = MyLocalizedString(@"_inconnu",@"");
    }
	
	
	NSString  *location = [NSString stringWithFormat:@"%@", [value objectForKey: @"location"]];
	if([location compare:@"0"] != NSOrderedSame){
		stringFromDate = [stringFromDate stringByAppendingFormat:@" | %@",location];
	}
	
	
	cell.secondaryLabel.text = [NSString stringWithFormat:@"%@", stringFromDate];
	
	
	UIImage *image;
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/calendrier.png",path]];
	image = [[UIImage alloc] initWithData:data];
	cell.myImageView.image = image;	
	
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    [image release];
	image = nil;
	value = nil;
	
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

    id value;
    if([dicoCalendarFiltered count]){
        value = [dicoCalendarFiltered objectAtIndex:indexPath.row];
    }
    else{
        value = [dicoCalendar objectAtIndex:indexPath.row];
    }
	
	NSString *nom = [NSString stringWithFormat:@"%@", [value objectForKey: @"nom"]];
	NSString  *location = [NSString stringWithFormat:@"%@", [value objectForKey: @"location"]];
	NSString  *description = [NSString stringWithFormat:@"%@", [value objectForKey: @"description"]];
	
	/* dans mon cas il faut ajouter 978307200 au timestamp (31 ans) les dates sont 1980->2011 */
	int timestamp = [[value objectForKey: @"startdate"]intValue] + 978307200;
	int timestamp2 = [[value objectForKey: @"enddate"]intValue] + 978307200;
	NSDate *ladate = [NSDate dateWithTimeIntervalSince1970:timestamp];
	NSDate *ladate2 = [NSDate dateWithTimeIntervalSince1970:timestamp2];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:datetimeFormat];	
	//[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
	NSString *stringFromDate = [formatter stringFromDate:ladate];
	NSString *stringFromDate2 = [formatter stringFromDate:ladate2];
	[formatter release];
	
	NSString *messageA = @"";
	if([stringFromDate compare:@""] != NSOrderedSame){
		messageA = [messageA stringByAppendingFormat:@"%@\n",stringFromDate];
	}
	if([stringFromDate2 compare:@""] != NSOrderedSame){
		messageA = [messageA stringByAppendingFormat:@"%@\n",stringFromDate2];
	}
	if([location compare:@"0"] != NSOrderedSame){
		messageA = [messageA stringByAppendingFormat:@"%@\n",location];
	}
	if([description compare:@""] != NSOrderedSame){
		messageA = [messageA stringByAppendingFormat:@"%@\n",description];
	}
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nom message:messageA delegate:self cancelButtonTitle:MyLocalizedString(@"_fermer",@"") otherButtonTitles:nil];
	[alert show];
	[alert release];

	ladate = nil;
	ladate2 = nil;
	value = nil;
	
}


#pragma mark -
#pragma mark Others Functions
- (void)exportAction:(id)sender{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:MyLocalizedString(@"_action",@"") delegate:self cancelButtonTitle:nil destructiveButtonTitle:MyLocalizedString(@"_annuler",@"") otherButtonTitles:MyLocalizedString(@"_calendriers",@""),MyLocalizedString(@"_exportdetails",@""), nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	actionSheet.destructiveButtonIndex = 0;
	[actionSheet showInView:self.parentViewController.tabBarController.view]; 
	[actionSheet release];
	
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

	if (buttonIndex == 1) {
        
        AppDetailViewController *appDetailViewController = [[AppDetailViewController alloc] initWithNibName:@"AppDetailViewController" bundle:nil];
        appDetailViewController.title = MyLocalizedString(@"_calendriers", @"");
        
        NSString *allCalendar = @"";
        NSString *requete = [NSString stringWithFormat:@"SELECT c.ROWID, c.title, c.color FROM Calendar c, CalendarItem ci WHERE c.ROWID=ci.calendar_id AND c.supported_entity_types='%@' GROUP BY c.ROWID",id_calendar_event];
        sqlite3 *database;
        if(sqlite3_open([calendarPath UTF8String], &database) == SQLITE_OK) {
            
            const char *sqlStatement = [requete cStringUsingEncoding:[NSString defaultCStringEncoding]];
            sqlite3_stmt *compiledStatement;
            
            if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    NSString *rowid = @"";
                    const char* rowidChar = (const char*)sqlite3_column_text(compiledStatement, 0);
                    if(rowidChar != NULL){
                        rowid = [NSString stringWithUTF8String:rowidChar];
                    }
                    NSString *title = @"";
                    const char* titleChar = (const char*)sqlite3_column_text(compiledStatement, 1);
                    if(titleChar != NULL){
                        title = [NSString stringWithUTF8String:titleChar];
                    }
                    NSString *color = @"";
                    const char* colorChar = (const char*)sqlite3_column_text(compiledStatement, 2);
                    if(colorChar != NULL){
                        color = [NSString stringWithUTF8String:colorChar];
                    }
                    
                    NSString *checked = @"checked=\"checked\"";
                    if([calendar_id_hidden containsObject:rowid]){
                        checked = @"";
                    }
                    allCalendar = [allCalendar stringByAppendingFormat:@"<li style=\"padding:0px 5px\"><label style=\"width:100%%;padding-top:10px;padding-bottom:10px;color:%@;display:inline-block;\"><input type=\"checkbox\" id=\"cal_%@\" %@ /> %@</label></li>", color, rowid, checked, title];
                    
                }
            }
            sqlite3_finalize(compiledStatement);
            compiledStatement = nil;
            sqlStatement = nil;
        }
        
        sqlite3_close(database);
        database = nil;
        
        aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];//init and create the UIWebView
        aWebView.autoresizesSubviews = YES;
        aWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        [aWebView setDelegate:self];
        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        
        NSString *myHTML = [NSString stringWithFormat:@"<html><head><link href=\"Render.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body> <div id=\"WebApp\"><div id=\"iGroup\"><div class=\"iMenu\" style=\"margin-bottom:10px;margin-top:35px;\"><ul class=\"iArrow\" style=\"margin-bottom:10px;\">%@</ul></div></div></div></body></html>", allCalendar];
        [aWebView loadHTMLString:myHTML baseURL:baseURL];
        [appDetailViewController.view addSubview:aWebView];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:appDetailViewController];
        nav.navigationBar.tintColor = UIColorFromRGB(0x0B4E92);
        
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] init];
        closeButton.title = MyLocalizedString(@"_annuler",@"");
        appDetailViewController.navigationItem.rightBarButtonItem = closeButton;
        [closeButton setTarget:self];
        [closeButton setAction:@selector(cancelCalendarChoose:)];
        [closeButton release];
        
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] init];
        saveButton.title = @"Ok";
        appDetailViewController.navigationItem.leftBarButtonItem = saveButton;
        [saveButton setTarget:self];
        [saveButton setAction:@selector(saveCalendarChoose:)];
        [saveButton release];
   
        [self presentViewController:nav animated:YES completion:nil];
        
        allCalendar = nil;
        requete = nil;
        [nav release];
        nav = nil;
        [appDetailViewController release];
        appDetailViewController = nil;
        
    }
    if (buttonIndex == 2) {
		
		NSString *exportContents = @"";
		NSMutableArray *arrayFull = [[NSMutableArray alloc] init];
		
        
        id value;
        if([dicoCalendarFiltered count]){
            value = dicoCalendarFiltered;
        }
        else{
            value = dicoCalendar;
        }
        
		for(id app in value){
			
			NSString *nomApp = [app objectForKey:@"nom"];
			NSString *locationApp = [app objectForKey:@"location"];
			NSString *descriptionApp = [app objectForKey:@"description"];
			NSString *enddateApp = [app objectForKey:@"enddate"];
			NSString *startdateApp = [app objectForKey:@"startdate"];
			
			
			int timestamp = [startdateApp intValue] + 978307200;
			int timestamp2 = [enddateApp intValue] + 978307200;
			NSDate *ladate = [NSDate dateWithTimeIntervalSince1970:timestamp];
			NSDate *ladate2 = [NSDate dateWithTimeIntervalSince1970:timestamp2];
			NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
			[formatter setDateFormat:datetimeFormat];
			//[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
			NSString *stringFromDate = [formatter stringFromDate:ladate];
			NSString *stringFromDate2 = [formatter stringFromDate:ladate2];
			[formatter release];
	
			NSString *exportContentFull = @"";
			
			exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<h3 style=\"margin-bottom:0px;font-size:16px;\">%@</h3>\n",nomApp]];
			
			exportContentFull = [exportContentFull stringByAppendingString:@"<ul style=\"margin-top:0px;font-size:7px;\">\n"];
			
			exportContentFull = [exportContentFull stringByAppendingFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\">%@</li>",stringFromDate];
			exportContentFull = [exportContentFull stringByAppendingFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\">%@</li>",stringFromDate2];
			
			if([locationApp compare:@"0"] != NSOrderedSame){
			exportContentFull = [exportContentFull stringByAppendingFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\">%@</li>",locationApp];
			}
			if([descriptionApp compare:@""] != NSOrderedSame){
			exportContentFull = [exportContentFull stringByAppendingFormat:@"<li style=\"padding-top:10px;padding-bottom:10px;\">%@</li>",descriptionApp];
			}

			exportContentFull = [exportContentFull stringByAppendingString:@"</ul>\n"];
			exportContentFull = [exportContentFull stringByAppendingString:@"<hr />\n"];
					
			[arrayFull addObject:exportContentFull];
			
		}
		
		for(id value in arrayFull){
			exportContents = [exportContents stringByAppendingString:value];
		}
		
		[self  pushEmail:(self.emailUser) andSubject:[NSString stringWithFormat:MyLocalizedString(@"_exportmaildetails",@""),MyLocalizedString(@"_calendrier",@"")] andBody:[NSString stringWithFormat:@"%@", exportContents]];

		[arrayFull release];
		arrayFull = nil;
		exportContents = nil;
	}
}


-(void)cancelCalendarChoose:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    [aWebView release];
    aWebView = nil;
}

-(void)saveCalendarChoose:(id)sender{
    [calendar_id_hidden removeAllObjects];
    for(id cal_id in calendar_id_all){
        NSString *js = [NSString stringWithFormat:@"document.getElementById('cal_%@').checked",cal_id];
        NSString *val = [NSString stringWithString:[aWebView stringByEvaluatingJavaScriptFromString:js]];
        if([val compare:@"false"] == NSOrderedSame){
            [calendar_id_hidden addObject:cal_id];
        }
    }
    [dicoCalendarFiltered removeAllObjects];
    for(id value in dicoCalendar){
        if(![calendar_id_hidden containsObject:[value objectForKey:@"cowid"]]){
            [dicoCalendarFiltered addObject:value];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
    [aWebView release];
    aWebView = nil;
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
    [datetimeFormat release];
    [calendar_id_hidden release];
    [calendar_id_all release];
	[id_calendar_event release];
    [calendarPath release];
    [emailUser release];
	[aWebView release];
    [dicoCalendar release];
    [dicoCalendarFiltered release];
	[calTableView release];
    [super dealloc];
}


@end

