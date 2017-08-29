//
//  RemindersViewController.m
//  appinfo
//
//  Created by Miles on 19/02/14.
//
//

#import "RemindersViewController.h"
#import "appinfoAppDelegate.h"
#import "AppDetailViewController.h"
#import "CustomCell.h"

@interface RemindersViewController ()

@end

@implementation RemindersViewController
@synthesize remindersTableView;
@synthesize aWebView;
@synthesize emailUser;
@synthesize id_calendar_event;
@synthesize calendarPath;
@synthesize dicoReminders;
@synthesize dicoRemindersFiltered;
@synthesize reminders_id_hidden;
@synthesize reminders_id_all;
@synthesize datetimeFormat;

/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/
- (void)viewDidLoad
{
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
    
    self.navigationItem.title = MyLocalizedString(@"_rappels",@"");
    
    UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] init];
	exportButton.title = MyLocalizedString(@"_action",@"");
	self.navigationItem.rightBarButtonItem = exportButton;
	[exportButton setTarget:self];
	[exportButton setAction:@selector(exportAction:)];
	[exportButton release];
    
    calendarPath = delegate.pathCalendar;
    id_calendar_event = @"";
    dicoReminders = [[NSMutableArray alloc] init];
    dicoRemindersFiltered = [[NSMutableArray alloc] init];
    
    reminders_id_hidden = [[NSMutableArray alloc] init];
    reminders_id_all = [[NSMutableArray alloc] init];
    completedFilter = FALSE;
    
    sqlite3 *database;
	
	if(sqlite3_open([calendarPath UTF8String], &database) == SQLITE_OK) {
		
        NSString *requeteInit = @"SELECT supported_entity_types FROM Calendar WHERE title='DEFAULT_TASK_CALENDAR_NAME'";
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
        NSString *requete = [NSString stringWithFormat:@"SELECT ci.ROWID, ci.summary, ci.location_id, ci.description, ci.start_date, ci.end_date, l.title, ci.calendar_id, c.title, c.supported_entity_types, ci.creation_date, ci.completion_date, r.frequency, r.interval  FROM CalendarItem ci LEFT JOIN Calendar c ON c.ROWID=ci.calendar_id LEFT JOIN Location l ON l.ROWID=ci.location_id LEFT JOIN Recurrence r ON r.owner_id=ci.ROWID WHERE c.supported_entity_types='%@' ORDER BY ci.creation_date DESC",id_calendar_event];
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
                NSString *calendarTitle = @"";
				const char* calendarTitleChar = (const char*)sqlite3_column_text(compiledStatement, 8);
				if(calendarTitleChar != NULL){
					calendarTitle = [NSString stringWithUTF8String:calendarTitleChar];
				}
                
                NSString *creationdate = @"";
                const char* creationdateChar = (const char*)sqlite3_column_text(compiledStatement, 10);
				if(creationdateChar != NULL){
                    creationdate = [NSString stringWithUTF8String:creationdateChar];
                }
                
                NSString *completiondate = @"";
                const char* completiondateChar = (const char*)sqlite3_column_text(compiledStatement, 11);
				if(completiondateChar != NULL){
                    completiondate = [NSString stringWithUTF8String:completiondateChar];
                }
                
                NSString *frequency = @"";
                const char* frequencyChar = (const char*)sqlite3_column_text(compiledStatement, 12);
				if(frequencyChar != NULL){
                    frequency = [NSString stringWithUTF8String:frequencyChar];
                }
                
                NSString *interval = @"";
                const char* intervalChar = (const char*)sqlite3_column_text(compiledStatement, 13);
				if(intervalChar != NULL){
                    interval = [NSString stringWithUTF8String:intervalChar];
                }
                
                if(![reminders_id_all containsObject: cowid]){
                    [reminders_id_all addObject:cowid];
                }

				NSMutableDictionary *app = [[NSMutableDictionary alloc] init];
				[app setObject:rowid forKey:@"rowid"];
                [app setObject:nom forKey:@"nom"];
				[app setObject:location forKey:@"location"];
				[app setObject:description forKey:@"description"];
				[app setObject:enddate forKey:@"enddate"];
				[app setObject:startdate forKey:@"startdate"];
                [app setObject:cowid forKey:@"cowid"];
                [app setObject:creationdate forKey:@"creationdate"];
                [app setObject:completiondate forKey:@"completiondate"];
                [app setObject:frequency forKey:@"frequency"];
                [app setObject:interval forKey:@"interval"];
                [app setObject:calendarTitle forKey:@"ctitle"];
                [dicoReminders addObject:app];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([dicoRemindersFiltered count]){
        return [dicoRemindersFiltered count];
    }
    else{
        return [dicoReminders count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    if([dicoRemindersFiltered count]){
        value = [dicoRemindersFiltered objectAtIndex:indexPath.row];
    }
    else{
        value = [dicoReminders objectAtIndex:indexPath.row];
    }

    NSString *secondLabel = @"";
    BOOL secondLabelOk = FALSE;
    if([[value objectForKey: @"startdate"]intValue]){
        int timestamp = [[value objectForKey: @"startdate"]intValue] + 978307200;
        NSDate *ladate = [NSDate dateWithTimeIntervalSince1970:timestamp];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:datetimeFormat];
        //[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
        secondLabel = [formatter stringFromDate:ladate];
        [formatter release];
        ladate = nil;
        if([secondLabel compare:@""] != NSOrderedSame) secondLabelOk = TRUE;
    }
    
    
    NSString *frequency = [NSString stringWithFormat:@"%@",[value objectForKey: @"frequency"]];
    NSString *interval = [NSString stringWithFormat:@"%@",[value objectForKey: @"interval"]];
    if([frequency compare:@""] != NSOrderedSame && [interval compare:@""] != NSOrderedSame){
        NSString *prepend = @"";
        if(secondLabelOk) prepend = @" | ";
        if([frequency compare:@"1"] == NSOrderedSame){
            secondLabel = [secondLabel stringByAppendingFormat:@"%@%@",prepend,MyLocalizedString(@"_touslesjours", @"")];
        }
        else if([frequency compare:@"2"] == NSOrderedSame){
            if([interval compare:@"1"] == NSOrderedSame){
                secondLabel = [secondLabel stringByAppendingFormat:@"%@%@",prepend,MyLocalizedString(@"_touteslessemaines", @"")];
            }
            else if([interval compare:@"2"] == NSOrderedSame){
                secondLabel = [secondLabel stringByAppendingFormat:@"%@%@",prepend,MyLocalizedString(@"_toutesles2semaines", @"")];
            }
            
        }
        else if([frequency compare:@"3"] == NSOrderedSame){
            secondLabel = [secondLabel stringByAppendingFormat:@"%@%@",prepend, MyLocalizedString(@"_touslesmois", @"")];
        }
        else if([frequency compare:@"4"] == NSOrderedSame){
            secondLabel = [secondLabel stringByAppendingFormat:@"%@%@",prepend,MyLocalizedString(@"_touslesans", @"")];
        }
    }
    
    BOOL completed = FALSE;
    NSMutableAttributedString *stringSecondLabel;
    if([[value objectForKey: @"completiondate"]intValue]){
        int timestamp = [[value objectForKey: @"completiondate"]intValue] + 978307200;
        NSDate *ladate = [NSDate dateWithTimeIntervalSince1970:timestamp];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:datetimeFormat];
        //[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
        secondLabel = [NSString stringWithFormat:@"%@ : %@",MyLocalizedString(@"_accompli", @""), [formatter stringFromDate:ladate]];
        [formatter release];
        ladate = nil;
        
        stringSecondLabel = [[NSMutableAttributedString alloc] initWithString:secondLabel];
        [stringSecondLabel addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xB22222) range:NSMakeRange(0,[MyLocalizedString(@"_accompli", @"") length])];
        completed = TRUE;
    }
    

	cell.primaryLabel.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"nom"]];
    //cell.secondaryLabel.text = [NSString stringWithFormat:@"%@",string];
    if(!completed) {
        cell.secondaryLabel.text = [NSString stringWithFormat:@"%@",secondLabel];
    }
    else{
        cell.secondaryLabel.attributedText = stringSecondLabel;
        [stringSecondLabel release];
    }
    
	
	UIImage *image;
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/reminders.png",path]];
	image = [[UIImage alloc] initWithData:data];
	cell.myImageView.image = image;
	
    [image release];
	image = nil;
	value = nil;
    stringSecondLabel = nil;
    secondLabel = nil;

    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id value;
    if([dicoRemindersFiltered count]){
        value = [dicoRemindersFiltered objectAtIndex:indexPath.row];
    }
    else{
        value = [dicoReminders objectAtIndex:indexPath.row];
    }
    
    NSString *info = [NSString stringWithFormat:@"%@\n", [value objectForKey: @"ctitle"]];
    
    NSString *secondLabel = @"";
    BOOL secondLabelOk = FALSE;
    if([[value objectForKey: @"startdate"]intValue]){
        int timestamp = [[value objectForKey: @"startdate"]intValue] + 978307200;
        NSDate *ladate = [NSDate dateWithTimeIntervalSince1970:timestamp];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:datetimeFormat];
        //[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
        secondLabel = [formatter stringFromDate:ladate];
        [formatter release];
        ladate = nil;
        if([secondLabel compare:@""] != NSOrderedSame) secondLabelOk = TRUE;
    }
    
    
    NSString *frequency = [NSString stringWithFormat:@"%@",[value objectForKey: @"frequency"]];
    NSString *interval = [NSString stringWithFormat:@"%@",[value objectForKey: @"interval"]];
    if([frequency compare:@""] != NSOrderedSame && [interval compare:@""] != NSOrderedSame){
        NSString *prepend = @"";
        if(secondLabelOk) prepend = @"\n";
        if([frequency compare:@"1"] == NSOrderedSame){
            secondLabel = [secondLabel stringByAppendingFormat:@"%@%@",prepend,MyLocalizedString(@"_touslesjours", @"")];
        }
        else if([frequency compare:@"2"] == NSOrderedSame){
            if([interval compare:@"1"] == NSOrderedSame){
                secondLabel = [secondLabel stringByAppendingFormat:@"%@%@",prepend,MyLocalizedString(@"_touteslessemaines", @"")];
            }
            else if([interval compare:@"2"] == NSOrderedSame){
                secondLabel = [secondLabel stringByAppendingFormat:@"%@%@",prepend,MyLocalizedString(@"_toutesles2semaines", @"")];
            }
            
        }
        else if([frequency compare:@"3"] == NSOrderedSame){
            secondLabel = [secondLabel stringByAppendingFormat:@"%@%@",prepend, MyLocalizedString(@"_touslesmois", @"")];
        }
        else if([frequency compare:@"4"] == NSOrderedSame){
            secondLabel = [secondLabel stringByAppendingFormat:@"%@%@",prepend,MyLocalizedString(@"_touslesans", @"")];
        }
    }
    
    if([[value objectForKey: @"completiondate"]intValue]){
        int timestamp = [[value objectForKey: @"completiondate"]intValue] + 978307200;
        NSDate *ladate = [NSDate dateWithTimeIntervalSince1970:timestamp];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:datetimeFormat];
        //[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
        secondLabel = [NSString stringWithFormat:@"%@ : %@",MyLocalizedString(@"_accompli", @""), [formatter stringFromDate:ladate]];
        [formatter release];
        ladate = nil;
    }
    
	NSString *nom = [NSString stringWithFormat:@"%@", [value objectForKey: @"nom"]];
    info = [info stringByAppendingFormat:@"%@",secondLabel];
    NSString *description = [NSString stringWithFormat:@"%@", [value objectForKey: @"description"]];
    if([description compare:@""] != NSOrderedSame){
        info = [info stringByAppendingFormat:@"\n%@",description];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nom message:info delegate:self cancelButtonTitle:MyLocalizedString(@"_fermer",@"") otherButtonTitles:nil];
	[alert show];
	[alert release];
    
	value = nil;

}
 


#pragma mark -
#pragma mark Others Functions
- (void)exportAction:(id)sender{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:MyLocalizedString(@"_action",@"") delegate:self cancelButtonTitle:nil destructiveButtonTitle:MyLocalizedString(@"_annuler",@"") otherButtonTitles:MyLocalizedString(@"_rappels",@""),MyLocalizedString(@"_exportdetails",@""), nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	actionSheet.destructiveButtonIndex = 0;
	[actionSheet showInView:self.parentViewController.tabBarController.view];
	[actionSheet release];
	
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
	if (buttonIndex == 1) {
        
        AppDetailViewController *appDetailViewController = [[AppDetailViewController alloc] initWithNibName:@"AppDetailViewController" bundle:nil];
        appDetailViewController.title = MyLocalizedString(@"_rappels", @"");
        
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
                    if([reminders_id_hidden containsObject:rowid]){
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
        
        
        NSString *checked = @"checked=\"checked\"";
        if(completedFilter)checked = @"";
        NSString *completedTask = [NSString stringWithFormat:@"<ul class=\"iArrow\" style=\"margin-bottom:10px;\"><li style=\"padding:0px 5px\"><label style=\"width:100%%;padding-top:10px;padding-bottom:10px;display:inline-block;\"><input type=\"checkbox\" id=\"accompli\" %@ /> %@</label></li></ul>", checked, MyLocalizedString(@"_accompli", @"")];
        
        NSString *myHTML = [NSString stringWithFormat:@"<html><head><link href=\"Render.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body> <div id=\"WebApp\"><div id=\"iGroup\"><div class=\"iMenu\" style=\"margin-bottom:10px;margin-top:35px;\">%@<ul class=\"iArrow\" style=\"margin-bottom:10px;\">%@</ul></div></div></div></body></html>", completedTask,allCalendar];
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
		/*
        id value;
        if([dicoRemindersFiltered count]){
            value = [dicoRemindersFiltered objectAtIndex:indexPath.row];
        }
        else{
            value = [dicoReminders objectAtIndex:indexPath.row];
        }
        */
        
        NSString *exportContents = @"";
		NSMutableArray *arrayFull = [[NSMutableArray alloc] init];
		
        
        id reminds;
        if([dicoRemindersFiltered count]){
            reminds = dicoRemindersFiltered;
        }
        else{
            reminds = dicoReminders;
        }
        
		for(id value in reminds){
            NSString *info = [NSString stringWithFormat:@"<p>%@<br />", [value objectForKey: @"ctitle"]];
            
            NSString *secondLabel = @"";
            BOOL secondLabelOk = FALSE;
            if([[value objectForKey: @"startdate"]intValue]){
                int timestamp = [[value objectForKey: @"startdate"]intValue] + 978307200;
                NSDate *ladate = [NSDate dateWithTimeIntervalSince1970:timestamp];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:datetimeFormat];
                //[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
                secondLabel = [formatter stringFromDate:ladate];
                [formatter release];
                ladate = nil;
                if([secondLabel compare:@""] != NSOrderedSame) secondLabelOk = TRUE;
            }
            
            
            NSString *frequency = [NSString stringWithFormat:@"%@",[value objectForKey: @"frequency"]];
            NSString *interval = [NSString stringWithFormat:@"%@",[value objectForKey: @"interval"]];
            if([frequency compare:@""] != NSOrderedSame && [interval compare:@""] != NSOrderedSame){
                NSString *prepend = @"";
                if(secondLabelOk) prepend = @"<br />";
                if([frequency compare:@"1"] == NSOrderedSame){
                    secondLabel = [secondLabel stringByAppendingFormat:@"%@%@",prepend,MyLocalizedString(@"_touslesjours", @"")];
                }
                else if([frequency compare:@"2"] == NSOrderedSame){
                    if([interval compare:@"1"] == NSOrderedSame){
                        secondLabel = [secondLabel stringByAppendingFormat:@"%@%@",prepend,MyLocalizedString(@"_touteslessemaines", @"")];
                    }
                    else if([interval compare:@"2"] == NSOrderedSame){
                        secondLabel = [secondLabel stringByAppendingFormat:@"%@%@",prepend,MyLocalizedString(@"_toutesles2semaines", @"")];
                    }
                    
                }
                else if([frequency compare:@"3"] == NSOrderedSame){
                    secondLabel = [secondLabel stringByAppendingFormat:@"%@%@",prepend, MyLocalizedString(@"_touslesmois", @"")];
                }
                else if([frequency compare:@"4"] == NSOrderedSame){
                    secondLabel = [secondLabel stringByAppendingFormat:@"%@%@",prepend,MyLocalizedString(@"_touslesans", @"")];
                }
            }
            
            if([[value objectForKey: @"completiondate"]intValue]){
                int timestamp = [[value objectForKey: @"completiondate"]intValue] + 978307200;
                NSDate *ladate = [NSDate dateWithTimeIntervalSince1970:timestamp];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:datetimeFormat];
                //[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
                secondLabel = [NSString stringWithFormat:@"%@ : %@",MyLocalizedString(@"_accompli", @""), [formatter stringFromDate:ladate]];
                [formatter release];
                ladate = nil;
            }
            
            NSString *nom = [NSString stringWithFormat:@"%@", [value objectForKey: @"nom"]];
            info = [info stringByAppendingFormat:@"%@",secondLabel];
            NSString *description = [NSString stringWithFormat:@"%@", [value objectForKey: @"description"]];
            if([description compare:@""] != NSOrderedSame){
                info = [info stringByAppendingFormat:@"<br />%@",description];
            }
            
            NSString *exportContentFull = @"";
			exportContentFull = [exportContentFull stringByAppendingString:[NSString stringWithFormat:@"<h3 style=\"margin-bottom:0px;font-size:16px;\">%@</h3>\n",nom]];
            exportContentFull = [exportContentFull stringByAppendingString:info];
            [arrayFull addObject:exportContentFull];
        }
        for(id value in arrayFull){
			exportContents = [exportContents stringByAppendingString:[NSString stringWithFormat:@"%@<hr />",value]];
		}
        
        [self  pushEmail:(self.emailUser) andSubject:[NSString stringWithFormat:MyLocalizedString(@"_exportmaildetails",@""),MyLocalizedString(@"_rappels",@"")] andBody:[NSString stringWithFormat:@"%@", exportContents]];

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
    NSString *accompli = [NSString stringWithString:[aWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('accompli').checked"]];
    if([accompli compare:@"false"] == NSOrderedSame){
        completedFilter = TRUE;
    }
    else{
        completedFilter = FALSE;
    }
    [reminders_id_hidden removeAllObjects];
    for(id cal_id in reminders_id_all){
        NSString *js = [NSString stringWithFormat:@"document.getElementById('cal_%@').checked",cal_id];
        NSString *val = [NSString stringWithString:[aWebView stringByEvaluatingJavaScriptFromString:js]];
        if([val compare:@"false"] == NSOrderedSame){
            [reminders_id_hidden addObject:cal_id];
        }
    }
    [dicoRemindersFiltered removeAllObjects];
    for(id value in dicoReminders){
        if(![reminders_id_hidden containsObject:[value objectForKey:@"cowid"]]){
            if(completedFilter){
                if([[NSString stringWithFormat:@"%@",[value objectForKey:@"completiondate"]] compare:@""] == NSOrderedSame){
                    [dicoRemindersFiltered addObject:value];
                }
            }
            else{
                [dicoRemindersFiltered addObject:value];
            }
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

- (void)dealloc {
    [datetimeFormat release];
    [remindersTableView release];
    [dicoReminders release];
    [dicoRemindersFiltered release];
	[id_calendar_event release];
    [calendarPath release];
    [reminders_id_all release];
    [reminders_id_hidden release];
    [emailUser release];
	[aWebView release];
    [super dealloc];
}


@end
