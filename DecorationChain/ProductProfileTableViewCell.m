//
//  ProductProfileTableViewCell.m
//  DecorationChain
//
//  Created by sven on 7/24/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "ProductProfileTableViewCell.h"

@implementation ProductProfileTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.name.text = self.productModel.name;
    self.en_name.text = self.productModel.en_name;
    self.formula.text = self.productModel.formula;
    self.cas.text = self.productModel.cas;
}

@end
