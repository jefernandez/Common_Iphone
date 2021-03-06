//
//  UICustomizedToolBarCell.h
//  FunSms
//
//  Created by qqn_pipi on 10-7-18.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UICustomizedToolBarCell : UITableViewCell {
	
	// set by external
	NSMutableArray*	buttonList;
	NSString*		backgroundName;
	int				cellCollapseHeight;
	int				cellExpandHeight;
	
	UILabel*		theNewTextLabel;
}

@property (nonatomic, retain) NSMutableArray*	buttonList;
@property (nonatomic, retain) NSString*			backgroundName;
@property (nonatomic, retain) UILabel*			theNewTextLabel;
@property (nonatomic)		  int				cellCollapseHeight;
@property (nonatomic)		  int				cellExpandHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier backgroundImage:(NSString*)backgroundImage buttons:(NSArray*)buttons;
+ (int)getToolbarHeight;
- (void)updateCellRect:(int)heightOfCellWithoutToolbar;

@end
