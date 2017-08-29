//
//  CustomCell.h
//  BercyBeta
//
//  Created by Miles on 31/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCell : UITableViewCell {
	IBOutlet UILabel *primaryLabel;
	IBOutlet UILabel *secondaryLabel;
	IBOutlet UIImageView *myImageView;
}

@property (nonatomic, retain) IBOutlet UILabel *primaryLabel;
@property (nonatomic, retain) IBOutlet UILabel *secondaryLabel;
@property (nonatomic, retain) IBOutlet UIImageView *myImageView;

@end
