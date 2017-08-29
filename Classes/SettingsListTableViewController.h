//
//  SettingsListTableViewController.h
//  appinfo
//
//  Created by Miles on 06/03/14.
//
//

#import <UIKit/UIKit.h>
#import "SettingsTableViewController.h"

@interface SettingsListTableViewController : UITableViewController <UITableViewDelegate , UITableViewDataSource > {
    NSMutableArray *listValues;
    NSString *selected;
    NSString *iddict;
    SettingsTableViewController *parent;
    NSUInteger parentIndex;
}



@property (nonatomic, retain) NSMutableArray *listValues;
@property (nonatomic, retain) NSString *selected;
@property (nonatomic, retain) NSString *iddict;
@property (nonatomic, retain) SettingsTableViewController *parent;
@property (nonatomic) NSUInteger parentIndex;

@end


