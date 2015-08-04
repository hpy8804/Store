//
//  CartTableViewCell.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/20.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "CartEditTableViewCell.h"

#import <LASIImageView/LASIImageView.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "NSString+imageurl.h"

@interface CartEditTableViewCell ()

@property (weak, nonatomic) IBOutlet LASIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UIButton *increaseButton;
@property (nonatomic, strong) OrderModel *model;
@end

@implementation CartEditTableViewCell

- (void)awakeFromNib {
	@weakify(self);
	[[self.selectedButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    self.selectedButton.selected = !self.selectedButton.selected;
	}];

	[[self.reduceButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    NSInteger buffer = self.number;
	    buffer--;
	    buffer = buffer <= 0 ? 1 : buffer;
	    self.model.quantity = [NSString stringWithFormat:@"%ld", (long)buffer];
	    self.number = buffer;
	    self.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.number];
	}];
	[[self.increaseButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    NSInteger buffer = self.number;
	    buffer++;
	    buffer = buffer >= 99 ? 99 : buffer;
	    self.model.quantity = [NSString stringWithFormat:@"%ld", (long)buffer];
	    self.number = buffer;
	    self.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.number];
	}];
}

- (void)updateWithModel:(OrderModel *)model {
	self.model = model;
//	[self.logoImageView setImageUrl:[model.detail.images fullImageURL]];
	self.nameLabel.text = model.detail.name;
	self.numberLabel.text = model.quantity;
	self.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.detail.saleprice];
	self.number = model.quantity.integerValue;
}

@end
