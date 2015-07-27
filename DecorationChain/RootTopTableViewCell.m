//
//  RootTopTableViewCell.m
//  DecorationChain
//
//  Created by sven on 7/24/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "RootTopTableViewCell.h"

@implementation RootTopTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)handleShowCategory:(id)sender {
}

- (IBAction)handleSearchAction:(id)sender {
}

- (IBAction)handleShowMore:(id)sender {
    if (_showMoreProduct) {
        _showMoreProduct();
    }
}

@end
