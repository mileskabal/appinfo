//
//  SmsTableViewController.m
//  appinfo
//
//  Created by Miles on 22/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SmsTableViewController.h"
#import "appinfoAppDelegate.h"
#import "AppDetailViewController.h"
//#import "CustomCell.h"

@implementation SmsTableViewController


@synthesize smsTableView;
@synthesize dicoSms;
@synthesize aWebView;
@synthesize emailUser;
@synthesize dicoChat;
@synthesize smsPath;
@synthesize contactPath;
@synthesize requeteCurrent;
@synthesize datetimeFormat;
@synthesize imageSMS;

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
    
    self.navigationItem.title = MyLocalizedString(@"_messages",@"");

    //[self.tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

	appinfoAppDelegate *delegate = (appinfoAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSString *compareVide = [NSString stringWithFormat:@"%@", delegate.emailConfigF];
	if([compareVide compare:@""] != NSOrderedSame){
		self.emailUser = [NSString stringWithFormat:@"%@", delegate.emailConfigF];
	}
	else {
		self.emailUser = nil;
	}
	
    self.datetimeFormat = [delegate.dateFormatter stringByAppendingString:@" - HH:mm"];
    
    self.smsPath = delegate.pathSms;
    self.contactPath = delegate.pathContacts;
    
    pageCurrent= 0;
    pageTotal = 0;
    pageNbr = [delegate.nbreMessageSMS intValue];
    chatCurrent = 0;
    chatTotal = 0;
    chatNbr = [delegate.chatpage intValue];
    
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/sms.png",path]];
	self.imageSMS = [[[UIImage alloc] initWithData:data] autorelease];
    
    NSString *pagingOk = delegate.chatpaging;
    
    BOOL pagingChat = FALSE;
    if([pagingOk compare:@"1"] == NSOrderedSame){
        pagingChat = TRUE;
    }
    
    if(pagingChat){
        NSString *requete = @"SELECT c.ROWID, c.chat_identifier, c.service_name, h.uncanonicalized_id, m.date, m.text FROM chat c LEFT JOIN chat_handle_join chj ON c.ROWID=chj.chat_id LEFT JOIN handle h ON chj.handle_id=h.ROWID LEFT JOIN message m ON m.handle_id=c.ROWID GROUP BY c.chat_identifier ORDER BY m.date DESC";
        chatTotal = [self getSqliteCount:requete];
        int nbrPageChat = ceil((float)((float)chatTotal/(float)chatNbr));
        
        if(chatNbr < chatTotal){
            UIBarButtonItem *pageButton = [[UIBarButtonItem alloc] init];
            pageButton.title = [NSString stringWithFormat:@"%@ 1/%i",MyLocalizedString(@"_page", @""),nbrPageChat];
            self.navigationItem.rightBarButtonItem = pageButton;
            [pageButton setTarget:self];
            [pageButton setAction:@selector(chatPagingAS:)];
            [pageButton release];
        }
        [self initializeChats:[NSString stringWithFormat:@"LIMIT 0,%i",chatNbr]];
    }
    else{
        [self initializeChats:@""];
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
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.dicoChat count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
    static NSString *CellIdentifier = @"CustomCell";
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //NSLog(@"DEBUG: cell %@",cell);
    //NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
    //NSLog(@"DEBUG: nib %@",nib);
    //cell = [nib objectAtIndex:0];
    //NSLog(@"DEBUG: cell %@",cell);
    if (cell == nil) {
        NSLog(@"DEBUG: cell nil");
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:nil options:nil];
        cell = (CustomCell *) [nib objectAtIndex:0];
		//for(id currentObj in topLevel){
        //    NSLog(@"DEBUG: cell for");
		//	if([currentObj isKindOfClass:[UITableViewCell class]]){
        //       NSLog(@"DEBUG: cell current");
		//		cell = (CustomCell *) currentObj;
		//		break;
		//	}
		//}
    }
    
    
    NSLog(@"DEBUG: cell before value");
    id value = [dicoChat objectAtIndex:indexPath.row];
    
	cell.primaryLabel.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"name"]];
	cell.secondaryLabel.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"textmess"]];
	
	UIImage *image;
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/sms.png",path]];
	image = [[UIImage alloc] initWithData:data];
	cell.myImageView.image = image;	
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	[image release];
	value = nil;
	image = nil;
	
    NSLog(@"DEBUG: end cell");
    
    return cell;
     */
    /*
    id value = [dicoChat objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSLog(@"DEBUG: cell initialize");
    if (cell.backgroundView == nil) { // do one-time configurations
        NSLog(@"DEBUG: cell nil");
        UIView* v = [UIView new];
        v.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = v;
        
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"name"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"textmess"]];
    NSLog(@"DEBUG: end cell");
    return cell;
    
    */

    id value = [self.dicoChat objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if ([cell viewWithTag: 3] == nil) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.contentView.backgroundColor = [UIColor clearColor];
        //  now insert our own views into the contentView
        UIImageView* iv = [UIImageView new];
        iv.tag = 1;
        [cell.contentView addSubview:iv];
        
        UILabel* lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:16];
        lab.backgroundColor = [UIColor clearColor];
        lab.tag = 2;
        [cell.contentView addSubview:lab];
        
        UILabel* labd = [UILabel new];
        labd.font = [UIFont fontWithName:@"Helvetica" size:11];
        labd.textColor = UIColorFromRGB(0x929292);
        labd.backgroundColor = [UIColor clearColor];
        labd.tag = 3;
        [cell.contentView addSubview:labd];
        // we can use autolayout to lay them out
        NSDictionary* d = NSDictionaryOfVariableBindings(iv, lab, labd);
        iv.translatesAutoresizingMaskIntoConstraints = NO;
        lab.translatesAutoresizingMaskIntoConstraints = NO;
        labd.translatesAutoresizingMaskIntoConstraints = NO;
        // image view is vertically centered
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:iv attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        // it's a square (same height as Width)
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:iv attribute:NSLayoutAttributeWidth relatedBy:0 toItem:iv attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        // label has height pinned to superview
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[lab][labd]-5-|" options:0 metrics:nil views:d]];
        // horizontal margins
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[iv(33)]-7-[lab]-5-|" options:0 metrics:nil views:d]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[iv(33)]-7-[labd]-5-|" options:0 metrics:nil views:d]];
   }
    
    UILabel* lab = (UILabel*)[cell viewWithTag: 2];
    lab.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"name"]];

    UILabel* labd = (UILabel*)[cell viewWithTag: 3];
    labd.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"textmess"]];

    UIImageView* iv = (UIImageView*)[cell viewWithTag: 1];
	iv.image = self.imageSMS;
    
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
    
    id value = [self.dicoChat objectAtIndex:indexPath.row];
    
    NSString *nomSms = [NSString stringWithFormat:@"%@", [value objectForKey: @"name"]];
	NSString *conversation = @"";
    
    NSString *requete = @"SELECT ROWID, text, service, date, is_from_me FROM message ";
    if([value objectForKey:@"SMS"]){
        requete = [requete stringByAppendingFormat:@"WHERE handle_id=%@ ",[value objectForKey:@"SMS"]];
    }
    if([value objectForKey:@"iMessage"]){
        if([value objectForKey:@"SMS"]){
            requete = [requete stringByAppendingFormat:@"OR handle_id=%@ ",[value objectForKey:@"iMessage"]];
        }
        else{
            requete = [requete stringByAppendingFormat:@"WHERE handle_id=%@ ",[value objectForKey:@"iMessage"]];
        }
    }
    requete = [requete stringByAppendingString:@"ORDER BY date DESC "];
    
    int nbrDeMess = [self getSqliteCount:requete];
    int nbrDePage = ceil((float)((float)nbrDeMess/(float)pageNbr));
    
    pageCurrent = 0;
    pageTotal = nbrDePage;
    requeteCurrent = [[NSString stringWithFormat:@"%@",requete] retain];
    
    requete = [requete stringByAppendingFormat:@"LIMIT 0,%i",pageNbr];
    
    sqlite3 *database;
    if(sqlite3_open([self.smsPath UTF8String], &database) == SQLITE_OK) {
		
        const char *sqlStatement = [requete cStringUsingEncoding:[NSString defaultCStringEncoding]];
		sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {

			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                /*
                NSString *rowid = @"";
				const char* rowidChar = (const char*)sqlite3_column_text(compiledStatement, 0);
				if(rowidChar != NULL){
					rowid = [NSString stringWithUTF8String:rowidChar];
				}
                 */
                
                NSString *textmess = @"";
				const char* textmessChar = (const char*)sqlite3_column_text(compiledStatement, 1);
				if(textmessChar != NULL){
					textmess = [NSString stringWithUTF8String:textmessChar];
				}

                NSString *service = @"";
				const char* serviceChar = (const char*)sqlite3_column_text(compiledStatement, 2);
				if(serviceChar != NULL){
					service = [NSString stringWithUTF8String:serviceChar];
				}

                NSString *datemess = @"";
				const char* datemessChar = (const char*)sqlite3_column_text(compiledStatement, 3);
				if(datemessChar != NULL){
					datemess = [NSString stringWithUTF8String:datemessChar];
                    int timestamp = [datemess intValue] + 978307200;
                    NSDate *ladate = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:datetimeFormat];
                    datemess = [formatter stringFromDate:ladate];
                    [formatter release];
                    ladate = nil;
				}

                NSString *is_from_me = @"";
				const char* is_from_meChar = (const char*)sqlite3_column_text(compiledStatement, 4);
				if(is_from_meChar != NULL){
					is_from_me = [NSString stringWithUTF8String:is_from_meChar];
				}

                NSString *styleP = @"";
                if([is_from_me compare:@"0"] == NSOrderedSame){
                    styleP = @" style=\"width:75%;background-color:#FFFFFF;float:left;\"";
                }
                else{
                    if([service compare:@"SMS"] == NSOrderedSame){
                        styleP = @" style=\"width:75%;background-color:#92D841;float:right;\"";
                    }
                    else{
                        styleP = @" style=\"width:75%;background-color:#40B0F8;float:right;\"";
                    }
                }
                
                conversation = [conversation stringByAppendingFormat:@"<p%@>%@ <br /><span style=\"font-size:0.7em;color:#444;margin-bottom:0;padding-bottom:0\">%@</span></p>",styleP,textmess,datemess];
                
            }
        }
        sqlite3_finalize(compiledStatement);
        compiledStatement = nil;
    }
    
    sqlite3_close(database);
	database = nil;
	
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    
    NSString *pagination = @"";
    if(nbrDePage > 1){
        pagination = [pagination stringByAppendingFormat:@"<div style=\"background-color:#FFF;opacity:0.9;border-bottom:1px solid #E1E1E1;position:fixed;z-index:100;height:28px;padding-top:10px;width:100%%\">"];
        pagination = [pagination stringByAppendingFormat:@"<div style=\"position:fixed;right:4px;top:4px;z-index:101\"><a href=\"pagenext:\"><img src=\"arrow_next.png\" width=\"30\"/></a></div>"];
        pagination = [pagination stringByAppendingFormat:@"<div style=\"position:fixed;left:4px;top:4px;z-index:101\"></div>"];
        pagination = [pagination stringByAppendingFormat:@"<div style=\"height:100%%;text-align:center;font-size:0.9em\">%@ 1/%i</div>",MyLocalizedString(@"_page", @""),nbrDePage];
        pagination = [pagination stringByAppendingFormat:@"</div><div style=\"height:38px;width:100%%\"></div>"];
    }
	NSString *myHTML = [NSString stringWithFormat:@"<html><head><link href=\"Render.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body><div id=\"WebApp\" style=\"padding-bottom:15px\">%@<div id=\"iGroup\"><div class=\"iBlock\"><h1 id=\"thename\">%@</h1>%@</div></div></div></body></html>",pagination,nomSms,conversation];
    

    AppDetailViewController *appDetailViewController = [[AppDetailViewController alloc] initWithNibName:@"AppDetailViewController" bundle:nil];
    appDetailViewController.title = nomSms;
    aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];//init and create the UIWebView
	aWebView.autoresizesSubviews = YES;
	aWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	[aWebView setDelegate:self];
	[aWebView loadHTMLString:myHTML baseURL:baseURL];
	
	UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] init];
	exportButton.title = MyLocalizedString(@"_export",@"");
	appDetailViewController.navigationItem.rightBarButtonItem = exportButton;
	[exportButton setTarget:self];
	[exportButton setAction:@selector(exportActionApp:)];
	exportButton.tag = indexPath.row;
	[exportButton release];
    
	[appDetailViewController.view addSubview:aWebView];
	[self.navigationController pushViewController:appDetailViewController animated:YES];
    
	value = nil;
    conversation = nil;
    [appDetailViewController release];
	appDetailViewController = nil;
    [aWebView release];
    aWebView = nil;
    
}
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	
    NSURL *URL = [request URL];
	NSString *urlString = [URL absoluteString];
	
	if(navigationType == UIWebViewNavigationTypeLinkClicked) {
		if([urlString hasPrefix:@"pagenext"]){
            pageCurrent++;
            int limit = pageCurrent*pageNbr;
            NSString *requete = [requeteCurrent stringByAppendingFormat:@"LIMIT %i,%i",limit,pageNbr];
            
            NSString *nomSms = [NSString stringWithString:[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('thename').innerHTML"]];
            NSString *conversation = @"";
            sqlite3 *database;
            if(sqlite3_open([self.smsPath UTF8String], &database) == SQLITE_OK) {
                
                const char *sqlStatement = [requete cStringUsingEncoding:[NSString defaultCStringEncoding]];
                sqlite3_stmt *compiledStatement;
                
                if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
                    
                    while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                        /*
                        NSString *rowid = @"";
                        const char* rowidChar = (const char*)sqlite3_column_text(compiledStatement, 0);
                        if(rowidChar != NULL){
                            rowid = [NSString stringWithUTF8String:rowidChar];
                        }
                         */
                        
                        NSString *textmess = @"";
                        const char* textmessChar = (const char*)sqlite3_column_text(compiledStatement, 1);
                        if(textmessChar != NULL){
                            textmess = [NSString stringWithUTF8String:textmessChar];
                        }
                        
                        NSString *service = @"";
                        const char* serviceChar = (const char*)sqlite3_column_text(compiledStatement, 2);
                        if(serviceChar != NULL){
                            service = [NSString stringWithUTF8String:serviceChar];
                        }
                        
                        NSString *datemess = @"";
                        const char* datemessChar = (const char*)sqlite3_column_text(compiledStatement, 3);
                        if(datemessChar != NULL){
                            datemess = [NSString stringWithUTF8String:datemessChar];
                            int timestamp = [datemess intValue] + 978307200;
                            NSDate *ladate = [NSDate dateWithTimeIntervalSince1970:timestamp];
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:datetimeFormat];
                            datemess = [formatter stringFromDate:ladate];
                            [formatter release];
                            ladate = nil;
                        }
                        
                        NSString *is_from_me = @"";
                        const char* is_from_meChar = (const char*)sqlite3_column_text(compiledStatement, 4);
                        if(is_from_meChar != NULL){
                            is_from_me = [NSString stringWithUTF8String:is_from_meChar];
                        }
                        
                        NSString *styleP = @"";
                        if([is_from_me compare:@"0"] == NSOrderedSame){
                            styleP = @" style=\"width:75%;background-color:#FFFFFF;float:left;\"";
                        }
                        else{
                            if([service compare:@"SMS"] == NSOrderedSame){
                                styleP = @" style=\"width:75%;background-color:#92D841;float:right;\"";
                            }
                            else{
                                styleP = @" style=\"width:75%;background-color:#40B0F8;float:right;\"";
                            }
                        }
                        
                        conversation = [conversation stringByAppendingFormat:@"<p%@>%@ <br /><span style=\"font-size:0.7em;color:#444;margin-bottom:0;padding-bottom:0\">%@</span></p>",styleP,textmess,datemess];
                        
                    }
                }
                sqlite3_finalize(compiledStatement);
                compiledStatement = nil;
            }
            
            sqlite3_close(database);
            database = nil;
            
            NSString *path = [[NSBundle mainBundle] bundlePath];
            NSURL *baseURL = [NSURL fileURLWithPath:path];
            
            NSString *flecheDroite = @"";
            if((pageCurrent+1) < pageTotal){
                flecheDroite = @"<a href=\"pagenext:\"><img src=\"arrow_next.png\" width=\"30\"/></a>";
            }
            NSString *flecheGauche = @"<a href=\"pageprev:\"><img src=\"arrow_prev.png\" width=\"30\"/></a>";
            
            NSString *pagination = @"";
            
            pagination = [pagination stringByAppendingFormat:@"<div style=\"background-color:#FFF;opacity:0.9;border-bottom:1px solid #E1E1E1;position:fixed;z-index:100;height:28px;padding-top:10px;width:100%%\">"];
            pagination = [pagination stringByAppendingFormat:@"<div style=\"position:fixed;right:4px;top:4px;z-index:101\">%@</div>",flecheDroite];
            pagination = [pagination stringByAppendingFormat:@"<div style=\"position:fixed;left:4px;top:4px;z-index:101\">%@</div>",flecheGauche];
            pagination = [pagination stringByAppendingFormat:@"<div style=\"height:100%%;text-align:center;font-size:0.9em\">%@ %i/%i</div>",MyLocalizedString(@"_page", @""),(pageCurrent+1),pageTotal];
            pagination = [pagination stringByAppendingFormat:@"</div><div style=\"height:38px;width:100%%\"></div>"];
            
            NSString *myHTML = [NSString stringWithFormat:@"<html><head><link href=\"Render.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body><div id=\"WebApp\" style=\"padding-bottom:15px\">%@<div id=\"iGroup\"><div class=\"iBlock\"><h1 id=\"thename\">%@</h1>%@</div></div></div></body></html>",pagination,nomSms,conversation];
            [webView loadHTMLString:myHTML baseURL:baseURL];
            
        }
        else if([urlString hasPrefix:@"pageprev"]){
            pageCurrent--;
            int limit = pageCurrent*pageNbr;
            NSString *requete = [requeteCurrent stringByAppendingFormat:@"LIMIT %i,%i",limit,pageNbr];
            
            NSString *nomSms = [NSString stringWithString:[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('thename').innerHTML"]];
            NSString *conversation = @"";
            sqlite3 *database;
            if(sqlite3_open([self.smsPath UTF8String], &database) == SQLITE_OK) {
                
                const char *sqlStatement = [requete cStringUsingEncoding:[NSString defaultCStringEncoding]];
                sqlite3_stmt *compiledStatement;
                
                if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
                    
                    while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                        /*
                        NSString *rowid = @"";
                        const char* rowidChar = (const char*)sqlite3_column_text(compiledStatement, 0);
                        if(rowidChar != NULL){
                            rowid = [NSString stringWithUTF8String:rowidChar];
                        }
                         */
                        
                        NSString *textmess = @"";
                        const char* textmessChar = (const char*)sqlite3_column_text(compiledStatement, 1);
                        if(textmessChar != NULL){
                            textmess = [NSString stringWithUTF8String:textmessChar];
                        }
                        
                        NSString *service = @"";
                        const char* serviceChar = (const char*)sqlite3_column_text(compiledStatement, 2);
                        if(serviceChar != NULL){
                            service = [NSString stringWithUTF8String:serviceChar];
                        }
                        
                        NSString *datemess = @"";
                        const char* datemessChar = (const char*)sqlite3_column_text(compiledStatement, 3);
                        if(datemessChar != NULL){
                            datemess = [NSString stringWithUTF8String:datemessChar];
                            int timestamp = [datemess intValue] + 978307200;
                            NSDate *ladate = [NSDate dateWithTimeIntervalSince1970:timestamp];
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateFormat:datetimeFormat];
                            datemess = [formatter stringFromDate:ladate];
                            [formatter release];
                            ladate = nil;
                        }
                        
                        NSString *is_from_me = @"";
                        const char* is_from_meChar = (const char*)sqlite3_column_text(compiledStatement, 4);
                        if(is_from_meChar != NULL){
                            is_from_me = [NSString stringWithUTF8String:is_from_meChar];
                        }
                        
                        NSString *styleP = @"";
                        if([is_from_me compare:@"0"] == NSOrderedSame){
                            styleP = @" style=\"width:75%;background-color:#FFFFFF;float:left;\"";
                        }
                        else{
                            if([service compare:@"SMS"] == NSOrderedSame){
                                styleP = @" style=\"width:75%;background-color:#92D841;float:right;\"";
                            }
                            else{
                                styleP = @" style=\"width:75%;background-color:#40B0F8;float:right;\"";
                            }
                        }
                        
                        conversation = [conversation stringByAppendingFormat:@"<p%@>%@ <br /><span style=\"font-size:0.7em;color:#444;margin-bottom:0;padding-bottom:0\">%@</span></p>",styleP,textmess,datemess];
                        
                    }
                }
                sqlite3_finalize(compiledStatement);
                compiledStatement = nil;
            }
            
            sqlite3_close(database);
            database = nil;
            
            NSString *path = [[NSBundle mainBundle] bundlePath];
            NSURL *baseURL = [NSURL fileURLWithPath:path];
            
            NSString *flecheDroite = @"<a href=\"pagenext:\"><img src=\"arrow_next.png\" width=\"30\"/></a>";
            NSString *flecheGauche = @"";
            if(pageCurrent){
                flecheGauche = @"<a href=\"pageprev:\"><img src=\"arrow_prev.png\" width=\"30\"/></a>";
            }
            
            NSString *pagination = @"";
            pagination = [pagination stringByAppendingFormat:@"<div style=\"background-color:#FFF;opacity:0.9;border-bottom:1px solid #E1E1E1;position:fixed;z-index:100;height:28px;padding-top:10px;width:100%%\">"];
            pagination = [pagination stringByAppendingFormat:@"<div style=\"position:fixed;right:4px;top:4px;z-index:101\">%@</div>",flecheDroite];
            pagination = [pagination stringByAppendingFormat:@"<div style=\"position:fixed;left:4px;top:4px;z-index:101\">%@</div>",flecheGauche];
            pagination = [pagination stringByAppendingFormat:@"<div style=\"height:100%%;text-align:center;font-size:0.9em\">%@ %i/%i</div>",MyLocalizedString(@"_page", @""),(pageCurrent+1),pageTotal];
            pagination = [pagination stringByAppendingFormat:@"</div><div style=\"height:38px;width:100%%\"></div>"];
            
            NSString *myHTML = [NSString stringWithFormat:@"<html><head><link href=\"Render.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body><div id=\"WebApp\" style=\"padding-bottom:15px\">%@<div id=\"iGroup\"><div class=\"iBlock\"><h1 id=\"thename\">%@</h1>%@</div></div></div></body></html>",pagination,nomSms,conversation];
            [webView loadHTMLString:myHTML baseURL:baseURL];
        }
    }
    return TRUE;
}



#pragma mark -
#pragma mark Others Functions
    
- (void)chatPagingAS:(id)sender{
    UIActionSheet *actionSheet;
    actionSheet = [[UIActionSheet alloc] initWithTitle:MyLocalizedString(@"_page", @"") delegate:self cancelButtonTitle:nil destructiveButtonTitle:MyLocalizedString(@"_annuler",@"") otherButtonTitles:nil];
    int nbrPageChat = ceil((float)((float)chatTotal/(float)chatNbr));
    for (int i=0;i<nbrPageChat;i++) {
        [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"%@ %i",MyLocalizedString(@"_page", @""),i+1]];
    }
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.destructiveButtonIndex = 0;
    [actionSheet showInView:self.parentViewController.tabBarController.view];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex){
        int limit = (buttonIndex-1)*chatNbr;
        int nbrPageChat = ceil((float)((float)chatTotal/(float)chatNbr));
        self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"%@ %i/%i",MyLocalizedString(@"_page", @""),buttonIndex,nbrPageChat];
        [self initializeChats:[NSString stringWithFormat:@"LIMIT %i,%i",limit,chatNbr]];
        [self.tableView reloadData];
    }
}


- (void) initializeChats:(NSString *) limit{
    
    self.dicoChat = [[NSMutableArray alloc] init];
    sqlite3 *database;
    
    if(sqlite3_open([self.smsPath UTF8String], &database) == SQLITE_OK) {
        
		NSString *requete = [NSString stringWithFormat:@"SELECT c.ROWID, c.chat_identifier, c.service_name, h.uncanonicalized_id, m.date, m.text, COUNT(DISTINCT c.service_name) FROM chat c LEFT JOIN chat_handle_join chj ON c.ROWID=chj.chat_id LEFT JOIN handle h ON chj.handle_id=h.ROWID LEFT JOIN message m ON m.handle_id=c.ROWID GROUP BY c.chat_identifier ORDER BY m.date DESC %@",limit];
		const char *sqlStatement = [requete cStringUsingEncoding:[NSString defaultCStringEncoding]];
		
		sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {

			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                NSString *chatid = @"";
				const char* chatidChar = (const char*)sqlite3_column_text(compiledStatement, 0);
				if(chatidChar != NULL){
					chatid = [NSString stringWithUTF8String:chatidChar];
				}
                
                NSString *chatidentifier = @"";
				const char* chatidentifierChar = (const char*)sqlite3_column_text(compiledStatement, 1);
				if(chatidentifierChar != NULL){
					chatidentifier = [NSString stringWithUTF8String:chatidentifierChar];
				}
                
                NSString *servicename = @"";
				const char* servicenameChar = (const char*)sqlite3_column_text(compiledStatement, 2);
				if(servicenameChar != NULL){
					servicename = [NSString stringWithUTF8String:servicenameChar];
				}
                
                NSString *ucid = @"";
				const char* ucidChar = (const char*)sqlite3_column_text(compiledStatement, 3);
				if(ucidChar != NULL){
					ucid = [NSString stringWithUTF8String:ucidChar];
				}
                
                NSString *datemess = @"";
                const char* datemessChar = (const char*)sqlite3_column_text(compiledStatement, 4);
                if(datemessChar != NULL){
                    datemess = [NSString stringWithUTF8String:datemessChar];
                }
                NSString *textmess = @"";
                const char* textmessChar = (const char*)sqlite3_column_text(compiledStatement, 5);
                if(textmessChar != NULL){
                    textmess = [NSString stringWithUTF8String:textmessChar];
                }
                NSString *strCount = @"";
                const char* strCountChar = (const char*)sqlite3_column_text(compiledStatement, 6);
                if(strCountChar != NULL){
                    strCount = [NSString stringWithUTF8String:strCountChar];
                }
                
                NSString *nameDisplay = [NSString stringWithFormat:@"%@",chatidentifier];
                sqlite3 *databaseM;
                sqlite3_stmt *compiledStatementM;
                if(sqlite3_open([self.contactPath UTF8String], &databaseM) == SQLITE_OK) {
                    
                    NSString *rqtplus = @"";
                    NSString *tel = [NSString stringWithFormat:@"%@",chatidentifier];
                    
                    /*
                     DEBUT POUR RECONNAITRE NUMERO TEL FRANCAIS
                     NSString *telFormat = @"";
                     NSString *telFormat2 = @"";
                     NSString *telFormat3 = @"";
                     if(tel.length == 12){
                     NSString *p1 = [tel substringWithRange:NSMakeRange(0, 3)];
                     NSString *p2 = [tel substringWithRange:NSMakeRange(3, 1)];
                     NSString *p3 = [tel substringWithRange:NSMakeRange(4, 2)];
                     NSString *p4 = [tel substringWithRange:NSMakeRange(6, 2)];
                     NSString *p5 = [tel substringWithRange:NSMakeRange(8, 2)];
                     NSString *p6 = [tel substringWithRange:NSMakeRange(10, 2)];
                     telFormat = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",p1,p2,p3,p4,p5,p6];
                     
                     NSMutableString *temp = [[NSMutableString alloc] initWithString:telFormat];
                     [temp replaceOccurrencesOfString:@"+33 " withString:@"0" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [temp length])];
                     telFormat2 = [NSString stringWithFormat:@"%@",temp];
                     [temp release];
                     
                     NSMutableString *temp2 = [[NSMutableString alloc] initWithString:telFormat2];
                     [temp2 replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [temp length])];
                     telFormat3 = [NSString stringWithFormat:@"%@",temp2];
                     [temp2 release];
                     
                     rqtplus = [NSString stringWithFormat:@"(abm.value='%@' OR abm.value='%@' OR abm.value='%@' OR abm.value='%@')",chatidentifier, telFormat, telFormat2, telFormat3];
                     }
                     else {
                     rqtplus = [NSString stringWithFormat:@"abm.value='%@'",chatidentifier];
                     }
                     //FIN POUR RECONNAITRE NUMERO TEL FRANCAIS*/
                    
                    tel = [tel stringByReplacingOccurrencesOfString:@"+" withString:@""];
                    NSString *telFormat = @"";
                    NSString *telFormat2 = @"";
                    NSString *telFormat3 = @"";
                    NSString *telFormat4 = @"";
                    for (int i = 0; i < [tel length]; i++) {
                        telFormat = [telFormat stringByAppendingFormat:@"%%%C",[tel characterAtIndex:i]];
                        if(i>0){
                            telFormat2 = [telFormat2 stringByAppendingFormat:@"%%%C",[tel characterAtIndex:i]];
                        }
                        if(i>1){
                            telFormat3 = [telFormat3 stringByAppendingFormat:@"%%%C",[tel characterAtIndex:i]];
                        }
                        if(i>2){
                            telFormat4 = [telFormat4 stringByAppendingFormat:@"%%%C",[tel characterAtIndex:i]];
                        }
                    }
                    
                    rqtplus = [NSString stringWithFormat:@"(abm.value LIKE '%@' ",telFormat];
                    if([telFormat2 compare:@""] != NSOrderedSame){
                        rqtplus = [rqtplus stringByAppendingFormat:@"OR abm.value LIKE '%@' ",telFormat2];
                    }
                    if([telFormat3 compare:@""] != NSOrderedSame){
                        rqtplus = [rqtplus stringByAppendingFormat:@"OR abm.value LIKE '%@' ",telFormat3];
                    }
                    if([telFormat4 compare:@""] != NSOrderedSame){
                        rqtplus = [rqtplus stringByAppendingFormat:@"OR abm.value LIKE '%@' ",telFormat4];
                    }
                    rqtplus = [rqtplus stringByAppendingString:@")"];
                    //NSLog(@"rqtp: %@",rqtplus);
                    
                    NSString *requeteM = [NSString stringWithFormat:@"SELECT abp.First FROM ABPerson abp, ABMultiValue abm WHERE abp.ROWID=abm.record_id AND %@",rqtplus];
                    //NSLog(@"rqtp: %@",requeteM);
                    const char *sqlStatementM = [requeteM cStringUsingEncoding:[NSString defaultCStringEncoding]];
                    if(sqlite3_prepare_v2(databaseM, sqlStatementM, -1, &compiledStatementM, NULL) == SQLITE_OK) {
                        if(sqlite3_step(compiledStatementM) == SQLITE_ROW){
                            const char* firstchar = (const char*)sqlite3_column_text(compiledStatementM, 0);
                            if(firstchar != NULL){
                                nameDisplay = [NSString stringWithUTF8String:firstchar];
                            }
                        }
                    }
                }
                sqlite3_finalize(compiledStatementM);
				compiledStatementM = nil;
                databaseM = nil;

                
                NSMutableDictionary *app = [[NSMutableDictionary alloc] init];
                if([strCount intValue] > 1){
                    NSString *requeteP = [NSString stringWithFormat:@"SELECT c.ROWID, c.service_name FROM chat c WHERE c.chat_identifier='%@' AND c.service_name!='%@' GROUP BY c.service_name",chatidentifier,servicename];
                    const char *sqlStatementP = [requeteP cStringUsingEncoding:[NSString defaultCStringEncoding]];
                    sqlite3_stmt *compiledStatementP;
                    if(sqlite3_prepare_v2(database, sqlStatementP, -1, &compiledStatementP, NULL) == SQLITE_OK) {
                        while(sqlite3_step(compiledStatementP) == SQLITE_ROW){
                            NSString *leid = @"";
                            const char* datemessChar = (const char*)sqlite3_column_text(compiledStatementP, 0);
                            if(datemessChar != NULL){
                                leid = [NSString stringWithUTF8String:datemessChar];
                            }
                            NSString *leservice = @"";
                            const char* textmessChar = (const char*)sqlite3_column_text(compiledStatementP, 1);
                            if(textmessChar != NULL){
                                leservice = [NSString stringWithUTF8String:textmessChar];
                            }
                            if([leid compare:@""] != NSOrderedSame && [leservice compare:@""] != NSOrderedSame){
                                [app setObject:leid forKey:leservice];
                            }
                        }
                    }
                }
                [app setObject:chatid forKey:servicename];
                [app setObject:chatidentifier forKey:@"chatidentifier"];
                [app setObject:ucid forKey:@"ucid"];
                [app setObject:datemess forKey:@"datemess"];
                [app setObject:textmess forKey:@"textmess"];
                [app setObject:nameDisplay forKey:@"name"];
                [self.dicoChat addObject:app];
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
    
- (int) getSqliteCount:(NSString *)requete{
    int count = 0;
    sqlite3 *database;
    if(sqlite3_open([self.smsPath UTF8String], &database) == SQLITE_OK) {
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

- (void)exportActionApp:(id)sender {
		
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	
    id value = [self.dicoChat objectAtIndex:indexPath.row];
    
    NSString *nomSms = [NSString stringWithFormat:@"%@", [value objectForKey: @"name"]];
	NSString *conversation = @"";
    
    int limit = pageCurrent*pageNbr;
    NSString *requete = [requeteCurrent stringByAppendingFormat:@"LIMIT %i,%i",limit,pageNbr];
    
    
    sqlite3 *database;
    if(sqlite3_open([self.smsPath UTF8String], &database) == SQLITE_OK) {
		
        const char *sqlStatement = [requete cStringUsingEncoding:[NSString defaultCStringEncoding]];
		sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                /*
                NSString *rowid = @"";
				const char* rowidChar = (const char*)sqlite3_column_text(compiledStatement, 0);
				if(rowidChar != NULL){
					rowid = [NSString stringWithUTF8String:rowidChar];
				}
                 */
                
                NSString *textmess = @"";
				const char* textmessChar = (const char*)sqlite3_column_text(compiledStatement, 1);
				if(textmessChar != NULL){
					textmess = [NSString stringWithUTF8String:textmessChar];
				}
                
                NSString *service = @"";
				const char* serviceChar = (const char*)sqlite3_column_text(compiledStatement, 2);
				if(serviceChar != NULL){
					service = [NSString stringWithUTF8String:serviceChar];
				}
                
                NSString *datemess = @"";
				const char* datemessChar = (const char*)sqlite3_column_text(compiledStatement, 3);
				if(datemessChar != NULL){
					datemess = [NSString stringWithUTF8String:datemessChar];
                    int timestamp = [datemess intValue] + 978307200;
                    NSDate *ladate = [NSDate dateWithTimeIntervalSince1970:timestamp];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:datetimeFormat];
                    datemess = [formatter stringFromDate:ladate];
                    [formatter release];
                    ladate = nil;
				}
                
                NSString *is_from_me = @"";
				const char* is_from_meChar = (const char*)sqlite3_column_text(compiledStatement, 4);
				if(is_from_meChar != NULL){
					is_from_me = [NSString stringWithUTF8String:is_from_meChar];
				}
                
                NSString *styleP = @"";
                if([is_from_me compare:@"0"] == NSOrderedSame){
                    styleP = @" style=\"width:75%;background-color:#FFFFFF;float:left;font-size:14px;clear:both;border:1px solid #EEEEEE;border-left:none;padding:2px;\"";
                }
                else{
                    if([service compare:@"SMS"] == NSOrderedSame){
                        styleP = @" style=\"width:75%;background-color:#92D841;float:right;font-size:14px;clear:both;border:1px solid #EEEEEE;border-right:none;padding:2px;\"";
                    }
                    else{
                        styleP = @" style=\"width:75%;background-color:#40B0F8;float:right;font-size:14px;clear:both;border:1px solid #EEEEEE;border-right:none;padding:2px;\"";
                    }
                }
                
                conversation = [conversation stringByAppendingFormat:@"<p%@>%@ <br /><span style=\"font-size:0.7em;color:#444;margin-bottom:0;padding-bottom:0\">%@</span></p>",styleP,textmess,datemess];
                
            }
        }
        sqlite3_finalize(compiledStatement);
        compiledStatement = nil;
    }
    
    sqlite3_close(database);
	database = nil;
    
    NSString *exportContents = @"";
	exportContents = [exportContents stringByAppendingString:[NSString stringWithFormat:@"<p style=\"width:100%%;\"><h3 style=\"margin-bottom:0px;font-size:16px;\">%@</h3>\n%@</p><p style=\"clear:both;\"></p>",nomSms,conversation]];
	//exportContents = [exportContents stringByAppendingString:@"<hr />\n"];
    
    [self  pushEmail:(self.emailUser) andSubject:[NSString stringWithFormat:MyLocalizedString(@"_exportmaildetails",@""),MyLocalizedString(@"_messages",@"")] andBody:[NSString stringWithFormat:@"%@", exportContents]];
	
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
    [smsPath release];
	[emailUser release];
    [requeteCurrent release];
	[aWebView release];
	[dicoSms release];
    [dicoChat release];
	[smsTableView release];
    [imageSMS release];
    [super dealloc];
}


@end

