//
//  KANPlaylistTableViewCell.h
//  Kanihi
//
//  Created by Chris Lucas on 8/18/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANTableViewCell.h"

@interface KANPlaylistTableViewCell : KANTableViewCell
// Outlets
@property (weak, nonatomic) IBOutlet UILabel *timecodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemNumberLabel;
@property (weak, nonatomic) IBOutlet KANLabelContainerView *labelContainerView;

@end
