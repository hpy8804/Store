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

//- (void)setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    [super setEditing:editing animated:animated];
//    if (editing) {
//        self.name.frame = CGRectMake(self.name.frame.origin.x+20, self.name.frame.origin.y, self.name.frame.size.width, self.name.frame.size.height);
//        self.en_name.frame = CGRectMake(self.en_name.frame.origin.x+20, self.en_name.frame.origin.y, self.en_name.frame.size.width, self.en_name.frame.size.height);
//        self.formula.frame = CGRectMake(self.formula.frame.origin.x+20, self.formula.frame.origin.y, self.formula.frame.size.width, self.formula.frame.size.height);
//        self.cas.frame = CGRectMake(self.cas.frame.origin.x+20, self.cas.frame.origin.y, self.cas.frame.size.width, self.cas.frame.size.height);
//    }else {
//        self.name.frame = CGRectMake(self.name.frame.origin.x-20, self.name.frame.origin.y, self.name.frame.size.width, self.name.frame.size.height);
//        self.en_name.frame = CGRectMake(self.en_name.frame.origin.x-20, self.en_name.frame.origin.y, self.en_name.frame.size.width, self.en_name.frame.size.height);
//        self.formula.frame = CGRectMake(self.formula.frame.origin.x-20, self.formula.frame.origin.y, self.formula.frame.size.width, self.formula.frame.size.height);
//        self.cas.frame = CGRectMake(self.cas.frame.origin.x-20, self.cas.frame.origin.y, self.cas.frame.size.width, self.cas.frame.size.height);
//    }
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.name.text = self.productModel.name;
    self.en_name.text = self.productModel.en_name;
    self.formula.text = self.productModel.formula;
    self.cas.text = self.productModel.cas;
}

@end
