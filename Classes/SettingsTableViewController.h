//
//  SettingsTableViewController.h
//  appinfo
//
//  Created by Miles on 06/03/14.
//
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController <UITableViewDelegate , UITableViewDataSource , UITextFieldDelegate > {
    NSMutableArray *settingsList;
    NSString *configPath;
    NSMutableDictionary *plist;
}

@property (nonatomic, retain) NSMutableArray *settingsList;
@property (nonatomic, retain) NSString *configPath;
@property (nonatomic, retain) NSMutableDictionary *plist;

@end
