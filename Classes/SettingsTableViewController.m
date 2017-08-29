//
//  SettingsTableViewController.m
//  appinfo
//
//  Created by Miles on 06/03/14.
//
//

#import "SettingsTableViewController.h"
#import "SettingsListTableViewController.h"
#import "appinfoAppDelegate.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

@synthesize settingsList;
@synthesize configPath;
@synthesize plist;

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellBool"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellString"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellList"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellText"];
    
    appinfoAppDelegate *delegate = (appinfoAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.configPath = delegate.pathConfig;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:self.configPath] == YES){
        self.plist = [[NSMutableDictionary alloc] initWithContentsOfFile:self.configPath];
    }
    else{
        self.plist = [[NSMutableDictionary alloc] init];
    }
    
    self.settingsList = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dictLangue = [[[NSMutableDictionary alloc] init] retain];
    [dictLangue setObject:@"Langue" forKey:@"id"];
    [dictLangue setObject:MyLocalizedString(@"_st_language", @"") forKey:@"label"];
    [dictLangue setObject:@"list" forKey:@"celltype"];
    [dictLangue setObject:@"*" forKey:@"required"];
    [dictLangue setObject:@"default,en,fr,de,it,es,pt,hr,sv,cs,tr" forKey:@"values"];
    [dictLangue setObject:@"Default,English,Français,Deutsch,Italiano,Español,Português,Hrvatski,Svenska,Čeština,Türkçe" forKey:@"values_text"];
    [dictLangue setObject:delegate.language forKey:@"default"];
    [dictLangue setObject:delegate.languageVal forKey:@"default_text"];
    [self.settingsList addObject:dictLangue];
    NSMutableDictionary *dictProPack = [[[NSMutableDictionary alloc] init] retain];
    [dictProPack setObject:@"ProPack" forKey:@"id"];
    [dictProPack setObject:MyLocalizedString(@"_st_display", @"") forKey:@"label"];
    [dictProPack setObject:@"bool" forKey:@"celltype"];
    [dictProPack setObject:@"*" forKey:@"required"];
    [dictProPack setObject:delegate.packageConfig forKey:@"default"];
    [self.settingsList addObject:dictProPack];
    NSMutableDictionary *dictMailDef = [[[NSMutableDictionary alloc] init] retain];
    [dictMailDef setObject:@"MailDef" forKey:@"id"];
    [dictMailDef setObject:MyLocalizedString(@"_st_email", @"") forKey:@"label"];
    [dictMailDef setObject:@"string" forKey:@"celltype"];
    [dictMailDef setObject:@"" forKey:@"required"];
    [dictMailDef setObject:delegate.emailConfigF forKey:@"default"];
    [self.settingsList addObject:dictMailDef];
    NSMutableDictionary *dictUnit = [[[NSMutableDictionary alloc] init] retain];
    [dictUnit setObject:@"Unit" forKey:@"id"];
    [dictUnit setObject:MyLocalizedString(@"_st_unit", @"") forKey:@"label"];
    [dictUnit setObject:@"list" forKey:@"celltype"];
    [dictUnit setObject:@"*" forKey:@"required"];
    [dictUnit setObject:@"o,b" forKey:@"values"];
    [dictUnit setObject:@"Octets,Bytes" forKey:@"values_text"];
    [dictUnit setObject:delegate.unitConfig forKey:@"default"];
    [dictUnit setObject:delegate.unitVal forKey:@"default_text"];
    [self.settingsList addObject:dictUnit];
    NSMutableDictionary *dictDate = [[[NSMutableDictionary alloc] init] retain];
    [dictDate setObject:@"dateformat" forKey:@"id"];
    [dictDate setObject:MyLocalizedString(@"_st_date", @"") forKey:@"label"];
    [dictDate setObject:@"list" forKey:@"celltype"];
    [dictDate setObject:@"*" forKey:@"required"];
    [dictDate setObject:@"dd/MM/yyyy,MM/dd/yyyy,yyyy/MM/dd" forKey:@"values"];
    [dictDate setObject:@"day/month/year,month/day/year,year/month/day" forKey:@"values_text"];
    [dictDate setObject:delegate.dateFormatter forKey:@"default"];
    [dictDate setObject:delegate.dateVal forKey:@"default_text"];
    [self.settingsList addObject:dictDate];
    NSMutableDictionary *dictituneshide = [[[NSMutableDictionary alloc] init] retain];
    [dictituneshide setObject:@"ituneshide" forKey:@"id"];
    [dictituneshide setObject:MyLocalizedString(@"_st_hide", @"") forKey:@"label"];
    [dictituneshide setObject:@"bool" forKey:@"celltype"];
    [dictituneshide setObject:@"" forKey:@"required"];
    [dictituneshide setObject:delegate.iIdHidden forKey:@"default"];
    [self.settingsList addObject:dictituneshide];
    NSMutableDictionary *dictChatPaging = [[[NSMutableDictionary alloc] init] retain];
    [dictChatPaging setObject:@"ChatPaging" forKey:@"id"];
    [dictChatPaging setObject:MyLocalizedString(@"_st_paging", @"") forKey:@"label"];
    [dictChatPaging setObject:@"bool" forKey:@"celltype"];
    [dictChatPaging setObject:@"" forKey:@"required"];
    [dictChatPaging setObject:delegate.chatpaging forKey:@"default"];
    [self.settingsList addObject:dictChatPaging];
    NSMutableDictionary *dictChatPage = [[[NSMutableDictionary alloc] init] retain];
    [dictChatPage setObject:@"ChatPage" forKey:@"id"];
    [dictChatPage setObject:MyLocalizedString(@"_st_chats", @"") forKey:@"label"];
    [dictChatPage setObject:@"list" forKey:@"celltype"];
    [dictChatPage setObject:@"" forKey:@"required"];
    [dictChatPage setObject:@"10,20,50,100,200" forKey:@"values"];
    [dictChatPage setObject:@"10,20,50,100,200" forKey:@"values_text"];
    [dictChatPage setObject:delegate.chatpage forKey:@"default"];
    [dictChatPage setObject:delegate.chatpage forKey:@"default_text"];
    [self.settingsList addObject:dictChatPage];
    NSMutableDictionary *dictSMS = [[[NSMutableDictionary alloc] init] retain];
    [dictSMS setObject:@"SMS" forKey:@"id"];
    [dictSMS setObject:MyLocalizedString(@"_st_sms", @"") forKey:@"label"];
    [dictSMS setObject:@"list" forKey:@"celltype"];
    [dictSMS setObject:@"" forKey:@"required"];
    [dictSMS setObject:@"10,20,50,100,200,300,400,500,1000,1500" forKey:@"values"];
    [dictSMS setObject:@"10,20,50,100,200,300,400,500,1000,1500" forKey:@"values_text"];
    [dictSMS setObject:delegate.nbreMessageSMS forKey:@"default"];
    [dictSMS setObject:delegate.nbreMessageSMS forKey:@"default_text"];
    [self.settingsList addObject:dictSMS];
    
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    UILabel* label = [UILabel new];
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor clearColor];
    label.text = MyLocalizedString(@"_st_reboot", @"");
    [footerView addSubview:label];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [footerView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:0 toItem:footerView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [footerView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:footerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    self.tableView.tableFooterView = footerView;
    [footerView release];
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{
    return 2.5;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.settingsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    id value = [self.settingsList objectAtIndex:indexPath.row];
    UITableViewCell *cell;
    
    //BOOLEAN
    if([[NSString stringWithFormat:@"%@",[value objectForKey: @"celltype"]] compare:@"bool"] == NSOrderedSame){
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellBool" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        if ([cell viewWithTag: 1] == nil) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel* label = [UILabel new];
            label.font = [UIFont systemFontOfSize:16];
            label.backgroundColor = [UIColor clearColor];
            label.tag = 1;
            [cell.contentView addSubview:label];
            UISwitch* switchButton = [UISwitch new];
            switchButton.tag = 2;
            [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:switchButton];
            NSDictionary* d = NSDictionaryOfVariableBindings(label,switchButton);
            label.translatesAutoresizingMaskIntoConstraints = NO;
            switchButton.translatesAutoresizingMaskIntoConstraints = NO;
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[label]-10-|" options:0 metrics:nil views:d]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[switchButton]-6-|" options:0 metrics:nil views:d]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[label]-10-[switchButton]-10-|" options:0 metrics:nil views:d]];
        }
        UILabel* label = (UILabel*)[cell viewWithTag: 1];
        label.text = [NSString stringWithFormat:@"%@%@", [value objectForKey: @"label"],[value objectForKey: @"required"]];
        
        UISwitch* switchButton = (UISwitch*)[cell viewWithTag: 2];
        if([[NSString stringWithFormat:@"%@", [value objectForKey: @"default"]] compare:@"1"]== NSOrderedSame){
            [switchButton setOn:YES];
        }
        else{
            [switchButton setOn:NO];
        }
    }
    //STRING
    else if([[NSString stringWithFormat:@"%@",[value objectForKey: @"celltype"]] compare:@"string"] == NSOrderedSame){
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellString" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        if ([cell viewWithTag: 1] == nil) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel* label = [UILabel new];
            label.font = [UIFont systemFontOfSize:16];
            label.backgroundColor = [UIColor clearColor];
            label.tag = 1;
            [cell.contentView addSubview:label];
            UITextField* textfield = [UITextField new];
            textfield.delegate = self;
            if(([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)){
                textfield.textColor = UIColorFromRGB(0x0B4E92);
            }
            else{
                textfield.textColor = [UIColor grayColor];
            }
            textfield.textAlignment = NSTextAlignmentRight;
            textfield.tag = 2;
            [cell.contentView addSubview:textfield];
            NSDictionary* d = NSDictionaryOfVariableBindings(label,textfield);
            label.translatesAutoresizingMaskIntoConstraints = NO;
            textfield.translatesAutoresizingMaskIntoConstraints = NO;
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[label]-10-|" options:0 metrics:nil views:d]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[textfield]-10-|" options:0 metrics:nil views:d]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[label]-10-[textfield(120)]-10-|" options:0 metrics:nil views:d]];
        }
        
        UILabel* label = (UILabel*)[cell viewWithTag: 1];
        label.text = [NSString stringWithFormat:@"%@%@", [value objectForKey: @"label"],[value objectForKey: @"required"]];
        UITextField* textfield = (UITextField*)[cell viewWithTag: 2];
        textfield.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"default"]];
    }
    //LIST
    else if([[NSString stringWithFormat:@"%@",[value objectForKey: @"celltype"]] compare:@"list"] == NSOrderedSame){
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellList" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        if ([cell viewWithTag: 1] == nil) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel* label = [UILabel new];
            label.font = [UIFont systemFontOfSize:16];
            label.backgroundColor = [UIColor clearColor];
            label.tag = 1;
            [cell.contentView addSubview:label];
            UILabel* value = [UILabel new];
            if(([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)){
                value.textColor = UIColorFromRGB(0x0B4E92);
            }
            else{
                value.textColor = [UIColor grayColor];
            }
            value.backgroundColor = [UIColor clearColor];
            value.textAlignment = NSTextAlignmentRight;
            value.tag = 2;
            [cell.contentView addSubview:value];
            NSDictionary* d = NSDictionaryOfVariableBindings(label,value);
            label.translatesAutoresizingMaskIntoConstraints = NO;
            value.translatesAutoresizingMaskIntoConstraints = NO;
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[label]-10-|" options:0 metrics:nil views:d]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[value]-10-|" options:0 metrics:nil views:d]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[label]-10-[value]-10-|" options:0 metrics:nil views:d]];
        }
        
        UILabel* label = (UILabel*)[cell viewWithTag: 1];
        label.text = [NSString stringWithFormat:@"%@%@", [value objectForKey: @"label"],[value objectForKey: @"required"]];
        
        UITextField* textfield = (UITextField*)[cell viewWithTag: 2];
        textfield.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"default_text"]];
    }
    else if([[NSString stringWithFormat:@"%@",[value objectForKey: @"celltype"]] compare:@"text"] == NSOrderedSame){
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellText" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        if ([cell viewWithTag: 1] == nil) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
            cell.backgroundView = [UIView new];
            cell.backgroundView = nil;
            UILabel* label = [UILabel new];
            label.font = [UIFont systemFontOfSize:14];
            label.backgroundColor = [UIColor clearColor];
            label.tag = 1;
            [cell.contentView addSubview:label];
            NSDictionary* d = NSDictionaryOfVariableBindings(label);
            label.translatesAutoresizingMaskIntoConstraints = NO;
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[label]-10-|" options:0 metrics:nil views:d]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[label]-10-|" options:0 metrics:nil views:d]];
        }
        
        UILabel* label = (UILabel*)[cell viewWithTag: 1];
        label.text = [NSString stringWithFormat:@"%@", [value objectForKey: @"label"]];
    }

    return cell;
}

- (void) switchAction:(UISwitch *)sender{
    UITableViewCell *cell;
    if(([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)){
        cell = (UITableViewCell*) sender.superview.superview;
    }
    else{
        cell = (UITableViewCell*) sender.superview.superview.superview;
    }
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    id value = [self.settingsList objectAtIndex:indexPath.row];
    NSString *boolval = @"";
    if([sender isOn]){
        boolval = @"1";
    }
    else{
        boolval = @"0";
    }
    
    NSMutableDictionary *pref = [[NSMutableDictionary alloc] initWithContentsOfFile:self.configPath];
    [pref setObject:boolval forKey:[value objectForKey:@"id"]];
    [pref writeToFile:self.configPath atomically:YES];
    appinfoAppDelegate *delegate = (appinfoAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate updateConfig:[value objectForKey:@"id"] withString:boolval andVal:@""];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    UITableViewCell *cell;
    if(([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)){
        cell = (UITableViewCell*) textField.superview.superview;
    }
    else{
        cell = (UITableViewCell*) textField.superview.superview.superview;
    }
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    id value = [self.settingsList objectAtIndex:indexPath.row];
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSMutableDictionary *pref = [[NSMutableDictionary alloc] initWithContentsOfFile:self.configPath];
    [pref setObject:newString forKey:[value objectForKey:@"id"]];
    [pref writeToFile:self.configPath atomically:YES];
    appinfoAppDelegate *delegate = (appinfoAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate updateConfig:[value objectForKey:@"id"] withString:newString andVal:@""];

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id value = [self.settingsList objectAtIndex:indexPath.row];
    if([[NSString stringWithFormat:@"%@",[value objectForKey: @"celltype"]] compare:@"list"] == NSOrderedSame){
        SettingsListTableViewController *settingsListView = [[SettingsListTableViewController alloc] initWithNibName:@"SettingsListTableViewController" bundle:nil];
        settingsListView.title = [NSString stringWithFormat:@"%@",[value objectForKey: @"label"]];
        
        NSMutableArray *listValues = [[[NSMutableArray alloc] init] autorelease];
        NSArray *arrayval = [[NSString stringWithFormat:@"%@",[value objectForKey: @"values"]] componentsSeparatedByString:@","];
        NSArray *arraytext = [[NSString stringWithFormat:@"%@",[value objectForKey: @"values_text"]] componentsSeparatedByString:@","];
        for(int i=0; i<[arrayval count];i++){
            NSMutableDictionary *listval = [[[NSMutableDictionary alloc] init] autorelease];
            [listval setValue:[arrayval objectAtIndex:i] forKey:@"value"];
            [listval setValue:[arraytext objectAtIndex:i] forKey:@"text"];
            [listValues addObject:listval];
        }
        settingsListView.listValues = listValues;
        settingsListView.selected = [NSString stringWithFormat:@"%@",[value objectForKey: @"default"]];
        settingsListView.iddict = [NSString stringWithFormat:@"%@",[value objectForKey: @"id"]];
        settingsListView.parent = self;
        settingsListView.parentIndex = indexPath.row;
        [self.navigationController pushViewController:settingsListView animated:YES];
    }
}
 

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [plist release];
    [configPath release];
    [settingsList release];
    [super dealloc];
}

@end
