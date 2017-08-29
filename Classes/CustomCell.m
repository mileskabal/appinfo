//
//  CustomCell.m
//  BercyBeta
//
//  Created by Miles on 31/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomCell.h"


@implementation CustomCell

@synthesize primaryLabel, secondaryLabel, myImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
		// you might want to add the UIView to [self contentView] 
		// so that in edit's the cell's content will be automatically adjusted.
		//ABTableViewCellView *myUIView = [[ABTableViewCellView alloc] initWithFrame:CGRectZero];
		//myUIView.opaque = YES;
		//contentViewForCell = myUIView;
		//[self addSubview:myUIView];
		//[myUIView release];
	}
	
	
	return self;
}



/*
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
	}
    return self;
}
*/

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[primaryLabel release];
	[secondaryLabel release];
	[myImageView release];
    [super dealloc];
}


@end
