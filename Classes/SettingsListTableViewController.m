//
//  SettingsListTableViewController.m
//  appinfo
//
//  Created by Miles on 06/03/14.
//
//

#import "SettingsListTableViewController.h"
#import "appinfoAppDelegate.h"

@interface SettingsListTableViewController ()

@end

@implementation SettingsListTableViewController

@synthesize listValues;
@synthesize selected;
@synthesize iddict;
@synthesize parent;
@synthesize parentIndex;

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listValues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.backgroundColor = [UIColor whiteColor];
    id value = [self.listValues objectAtIndex:indexPath.row];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if([[NSString stringWithFormat:@"%@",[value objectForKey:@"value"]] compare:self.selected] == NSOrderedSame){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[value objectForKey:@"text"]];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    return cell;
}

#pragma mark -
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id value = [self.listValues objectAtIndex:indexPath.row];
    self.selected = [value objectForKey:@"value"];
    NSMutableDictionary *pref = [[NSMutableDictionary alloc] initWithContentsOfFile:parent.configPath];
    [pref setObject:[value objectForKey:@"value"] forKey:self.iddict];
    [pref writeToFile:parent.configPath atomically:YES];
    appinfoAppDelegate *delegate = (appinfoAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate updateConfig:self.iddict withString:[value objectForKey:@"value"] andVal:[value objectForKey:@"text"]];
    [[self.parent.settingsList objectAtIndex:self.parentIndex] setObject:[value objectForKey:@"text"] forKey:@"default_text"];
    [[self.parent.settingsList objectAtIndex:self.parentIndex] setObject:[value objectForKey:@"value"] forKey:@"default"];
    [tableView reloadData];
    [self.parent.tableView reloadData];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [parent release];
    [iddict release];
    [selected release];
    [listValues release];
    [super dealloc];
}


@end
