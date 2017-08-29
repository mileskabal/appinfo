//
//  iPodSearchViewController.h
//  appinfo
//
//  Created by Miles on 24/02/14.
//
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class MorceauxTableViewController;

@interface iPodSearchViewController : UIViewController <UITextFieldDelegate>{
    
    IBOutlet UITextField *searchInput;
    IBOutlet UISegmentedControl *segmentControl;
    IBOutlet UIButton *searchButton;
    NSString *databasePath;
	MorceauxTableViewController *morceauxTable;
    IBOutlet NSLayoutConstraint *topConstraint;
    BOOL verifios5;
}

@property (nonatomic, retain) IBOutlet UITextField *searchInput;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentControl;
@property (nonatomic, retain) IBOutlet UIButton *searchButton;
@property (nonatomic, retain) NSString *databasePath;
@property (nonatomic, retain) MorceauxTableViewController *morceauxTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end
