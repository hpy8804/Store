//
//  CartTableViewCell.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/20.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "CartTableViewCell.h"

#import <LASIImageView/LASIImageView.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "NSString+imageurl.h"

@interface CartTableViewCell ()

@property (weak, nonatomic) IBOutlet LASIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation CartTableViewCell

- (void)awakeFromNib {
	@weakify(self);
	[[self.selectedButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    self.selectedButton.selected = !self.selectedButton.selected;
	}];
}

- (void)updateWithModel:(OrderModel *)model {
//	[self.logoImageView setImageUrl:[model.detail.images fullImageURL]];
	self.nameLabel.text = model.detail.name;
	self.numberLabel.text = model.quantity;
	self.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.detail.saleprice];
}

@end
